codeunit 50010 "Item Borrow Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Souhaitez vous valider l''octroi du l''emprunt ?';
        Text002: Label 'La facture de vente %1 a été créée\La facture d''achat %2 a été créée';
        Text003: Label 'Les quantités cédées doivent etre égales aux quantités reçues.';
        NosSeriesMgt: Codeunit NoSeriesManagement;
        Text004: Label 'Vous ne pouvez pas retourner une quantité supérieure à la quantité empruntée sur la ligne %1';
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text005: Label 'Voulez-vous valider l''emprunt de produits ?';
        Text006: Label 'Voulez-vous créer un nouveau remboursement ?';
        Text007: Label 'Traitement terminé avec succès';
        Text008: Label 'Aucune ligne à traiter !';
        Text009: Label 'Emprunt de produits %1';
        Text010: Label 'Rembouresment Emprunt de produits %1';

    procedure PostOctroiEmprunt(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        LineExits: Boolean;
        ResteARemb: Decimal;
        ItemTransfer: Codeunit "Item Transfer Mgt";
    begin

        if not Confirm(Text005) then exit;

        ItemAdj.TestField("Vendor No.");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Open);

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Partner Location");

        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;



        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Borrow);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");

          AdjustLine.TestField(AdjustLine."Location Code");
          AdjustLine.TestField(AdjustLine."Item No.");
          AdjustLine.TestField(AdjustLine.Quantity);


          LineExits := true;


          ItemTransfer.TransfertItemReclass(ItemJnlPostLine,ItemAdj."No.",ItemAdj."Posting Date",AdjustLine."Item No.",
            AddOnSetup."Partner Location",AdjustLine."Location Code",Abs(AdjustLine.Quantity),AdjustLine."Unit of Measure Code",
            AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",StrSubstNo(Text009,ItemAdj."No."),
            ItemJnlLine."Adjustment Type"::Borrow,AddOnSetup."Cargo Confreres");


        until AdjustLine.Next=0;


        if not LineExits then
          Error(Text008)
        else
          Message(Text007);
    end;

    procedure PostRembEmprunt(var ItemAdj: Record "Adjustment Header")
    var
        ItemTransfer: Codeunit "Item Transfer Mgt";
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        CloseDocument: Boolean;
        LineExistsToReturn: Boolean;
        CodeRemb: Code[20];
        LignePret: Record "Adjustment Line";
    begin


        if not Confirm(Text006) then exit;

        ItemAdj.TestField("Vendor No.");
        ItemAdj.TestField(ItemAdj."Receipt Date");

        CloseDocument := true;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Partner Location");


        LineExistsToReturn:=false;
        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Borrow);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
          if AdjustLine."Returned Qty" + AdjustLine."Qty to return" > AdjustLine.Quantity then
            Error(Text004,AdjustLine."Line No.");
          if AdjustLine."Qty to return"<>0 then LineExistsToReturn:=true;
        until AdjustLine.Next=0;


        if LineExistsToReturn then
          CodeRemb := AddNewRembEmprunt(ItemAdj);


        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Borrow);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");

          LignePret := AdjustLine;


          //AdjustLine."Returned Qty" += AdjustLine."Qty to return";
          //AdjustLine.MODIFY;

          if AdjustLine."Returned Qty" + AdjustLine."Qty to return" <> AdjustLine.Quantity then
            CloseDocument := false;



          if AdjustLine."Qty to return"<>0 then begin
            LineExistsToReturn := true;
            //ItemJnlPostLine.RunWithCheck(ItemJnlLine);

            ItemTransfer.TransfertItemReclass(ItemJnlPostLine,CodeRemb,ItemAdj."Receipt Date",AdjustLine."Item No.",
              AdjustLine."Location Code",AddOnSetup."Partner Location",Abs(AdjustLine."Qty to return"),AdjustLine."Unit of Measure Code",
              AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",StrSubstNo(Text010,ItemAdj."No."),
              ItemJnlLine."Adjustment Type"::"Borrow Return",AddOnSetup."Cargo Confreres");



            LignePret."Returned Qty" += AdjustLine."Qty to return";
            LignePret."Qty to return" := LignePret.Quantity-(LignePret."Returned Qty");
            LignePret.Modify;
          end;

        until AdjustLine.Next=0;


        if LineExistsToReturn then begin
          //Save Remb
          //AddNewRembPret(ItemAdj);

          //Close Doc
          if CloseDocument then
            ArchiveDoc(ItemAdj);

          Message(Text007);
        end else begin
          Message(Text008);
        end;
    end;

    local procedure AddNewRembEmprunt(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        ReturnHeader: Record "Item Return Header";
        ReturnLine: Record "Item Return Line";
        AdjLine: Record "Adjustment Line";
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Item Return Borrow Nos.");

        ReturnHeader.Init;
        ReturnHeader.TransferFields(ItemAdj);
        ReturnHeader."Document Type" := ReturnHeader."Document Type"::Borrow;
        ReturnHeader."No." := NosSeriesMgt.GetNextNo(AddOnSetup."Item Return Borrow Nos.",Today,true);
        ReturnHeader."Original Doc No" := ItemAdj."No.";
        ReturnHeader."Posting Date":=ItemAdj."Receipt Date";
        ReturnHeader."User ID" := UserId;
        ReturnHeader.Insert;

        AdjLine.Reset;
        AdjLine.SetRange("Document Type",AdjLine."Document Type"::Borrow);
        AdjLine.SetRange("Document No.",ItemAdj."No.");
        if AdjLine.FindSet then repeat
          ReturnLine.Init;
          ReturnLine.TransferFields(AdjLine);
          ReturnLine."Document Type" := ReturnLine."Document Type"::Borrow;
          ReturnLine."Document No.":= ReturnHeader."No.";
          ReturnLine."Line No." := AdjLine."Line No.";
          ReturnLine.Quantity := AdjLine."Qty to return";
          if ReturnLine.Quantity>0 then
            ReturnLine.Insert;
        until AdjLine.Next=0;

        exit(ReturnHeader."No.");
    end;

    local procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    begin
        ItemAdjustMgt.ArchiveDoc(ItemAdj);
        ItemAdj.SetIsArchive(true);
        ItemAdj.Delete(true);
    end;
}

