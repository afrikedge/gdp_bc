codeunit 50007 "Item Loan Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Souhaitez vous valider l''octroi du prêt ?';
        Text002: Label 'La facture de vente %1 a été créée\La facture d''achat %2 a été créée';
        Text003: Label 'Les quantités cédées doivent etre égales aux quantités reçues.';
        NosSeriesMgt: Codeunit NoSeriesManagement;
        Text004: Label 'Vous ne pouvez pas retourner une quantité supérieure à la quantité prêtée sur la ligne %1';
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text005: Label 'Voulez-vous valider le prêt de produits ?';
        Text006: Label 'Voulez-vous créer un nouveau remboursement ?';
        Text007: Label 'Traitement terminé avec succès';
        Text008: Label 'Aucune ligne à valider !';
        Text009: Label 'Octroi prêt de produits %1';
        Text010: Label 'Remboursement prêt de produits %1';

    procedure PostOctroiPret(var ItemAdj: Record "Adjustment Header")
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
        descr: Text[50];
    begin

        if not Confirm(Text005) then exit;

        ItemAdj.TestField(ItemAdj."Customer No.");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Open);

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Partner Location");

        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;

        descr := StrSubstNo(Text009,ItemAdj."No.");

        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Loan);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");

          AdjustLine.TestField(AdjustLine."Location Code");
          AdjustLine.TestField(AdjustLine."Item No.");
          AdjustLine.TestField(AdjustLine.Quantity);

          LineExits:=true;
          ItemTransfer.TransfertItemReclass(ItemJnlPostLine,ItemAdj."No.",ItemAdj."Posting Date",AdjustLine."Item No.",
            AdjustLine."Location Code",AddOnSetup."Partner Location",Abs(AdjustLine.Quantity),AdjustLine."Unit of Measure Code",
            AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",descr,ItemJnlLine."Adjustment Type"::Loan,AddOnSetup."Cargo Confreres");


        until AdjustLine.Next=0;


        if not LineExits then
          Error(Text008)
        else
          Message(Text007);
    end;

    procedure PostRembPret(var ItemAdj: Record "Adjustment Header")
    var
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
        ItemTransfer: Codeunit "Item Transfer Mgt";
        descr: Text[50];
    begin


        if not Confirm(Text006) then exit;

        ItemAdj.TestField(ItemAdj."Customer No.");
        ItemAdj.TestField(ItemAdj."Receipt Date");

        CloseDocument := true;

        descr := StrSubstNo(Text010,ItemAdj."No.");

        LineExistsToReturn:=false;
        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Loan);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
          if AdjustLine."Returned Qty" + AdjustLine."Qty to return" > AdjustLine.Quantity then
            Error(Text004,AdjustLine."Line No.");
          if AdjustLine."Qty to return"<>0 then LineExistsToReturn:=true;
        until AdjustLine.Next=0;


        if LineExistsToReturn then
          CodeRemb := AddNewRembPret(ItemAdj);


        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Loan);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");

          LignePret := AdjustLine;

          if AdjustLine."Returned Qty" + AdjustLine."Qty to return" <> AdjustLine.Quantity then
            CloseDocument := false;


          if AdjustLine."Qty to return"<>0 then begin
            LineExistsToReturn := true;

            ItemTransfer.TransfertItemReclass(ItemJnlPostLine,CodeRemb,ItemAdj."Receipt Date",AdjustLine."Item No.",
              AddOnSetup."Partner Location",AdjustLine."Location Code",Abs(AdjustLine."Qty to return"),AdjustLine."Unit of Measure Code",
              AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",descr,ItemJnlLine."Adjustment Type"::"Loan Return",AddOnSetup."Cargo Confreres");


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

    local procedure AddNewRembPret(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        ReturnHeader: Record "Item Return Header";
        ReturnLine: Record "Item Return Line";
        AdjLine: Record "Adjustment Line";
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField("Item Return Loan Nos.");

        ReturnHeader.Init;
        ReturnHeader.TransferFields(ItemAdj);
        ReturnHeader."Document Type" := ReturnHeader."Document Type"::Loan;
        ReturnHeader."No." := NosSeriesMgt.GetNextNo(AddOnSetup."Item Return Loan Nos.",Today,true);
        ReturnHeader."Original Doc No" := ItemAdj."No.";
        ReturnHeader."Posting Date" := ItemAdj."Receipt Date";
        ReturnHeader."User ID" := UserId;
        ReturnHeader.Insert;

        AdjLine.Reset;
        AdjLine.SetRange("Document Type",AdjLine."Document Type"::Loan);
        AdjLine.SetRange("Document No.",ItemAdj."No.");
        if AdjLine.FindSet then repeat
          ReturnLine.Init;
          ReturnLine.TransferFields(AdjLine);
          ReturnLine."Document Type" := ReturnLine."Document Type"::Loan;
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

    procedure PostOctroiPretOld(var ItemAdj: Record "Adjustment Header")
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
    begin

        if not Confirm(Text005) then exit;

        ItemAdj.TestField("Vendor No.");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Open);


        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;


        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");

          AdjustLine.TestField(AdjustLine."Location Code");
          AdjustLine.TestField(AdjustLine."Item No.");
          AdjustLine.TestField(AdjustLine.Quantity);

          //Dépot d'origine - Ajustement négatif
          ItemJnlLine.Init;
          ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::Loan;
          ItemJnlLine."Posting Date" := ItemAdj."Posting Date";
          ItemJnlLine."Document Date" := ItemAdj."Posting Date";
          ItemJnlLine."Document No." := ItemAdj."No.";
          //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
          //ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
          //ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
          //ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
          //ItemJnlLine."Order Line No." := TransLine3."Line No.";
          ItemJnlLine."External Document No." := ItemAdj."External Document No.";

          //IF AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive THEN
          //  ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
          //ELSE
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

          LineExits := true;


          ItemJnlLine.Validate("Item No." , AdjustLine."Item No.");
          ItemJnlLine.Description := ItemAdj."Posting Description";
          ItemJnlLine."Shortcut Dimension 1 Code" := AdjustLine."Shortcut Dimension 1 Code";
          ItemJnlLine."Shortcut Dimension 2 Code" := AdjustLine."Shortcut Dimension 2 Code";
          ItemJnlLine."Dimension Set ID" := AdjustLine."Dimension Set ID";
          ItemJnlLine.Validate("Location Code", AdjustLine."Location Code");
          ItemJnlLine.Validate(Quantity , Abs(AdjustLine.Quantity));

          ItemJnlLine.Validate("Unit of Measure Code" , AdjustLine."Unit of Measure Code");
          ItemJnlLine."Invoiced Quantity" := Abs(AdjustLine.Quantity);
          //ItemJnlLine."Quantity (Base)" := RemovalLine.volumea15;
          //ItemJnlLine."Invoiced Qty. (Base)" := RemovalLine.volumea15;
          ItemJnlLine."Source Code" := SourceCode;
          //ItemJnlLine."Gen. Prod. Posting Group" := TransShptLine2."Gen. Prod. Posting Group";
          //ItemJnlLine."Inventory Posting Group" := TransShptLine2."Inventory Posting Group";

          //ItemJnlLine."Qty. per Unit of Measure" := 1;//TransShptLine2."Qty. per Unit of Measure";
          //ItemJnlLine."Variant Code" := TransShptLine2."Variant Code";
          //ItemJnlLine."Bin Code" := TransLine."Transfer-from Bin Code";
          //ItemJnlLine."Country/Region Code" := TransShptHeader2."Trsf.-from Country/Region Code";
          //ItemJnlLine."Transaction Type" := TransRcptHeader2."Transaction Type";
          //ItemJnlLine."Transport Method" := TransRcptHeader2."Transport Method";
          //ItemJnlLine."Entry/Exit Point" := TransShptHeader2."Entry/Exit Point";
          //ItemJnlLine.Area := TransRcptHeader2.Area;
          //ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
          //ItemJnlLine."Product Group Code" := Item1."Product Group Code";
          //ItemJnlLine."Item Category Code" := Item1."Item Category Code";
          //ItemJnlLine."Applies-to Entry" := TransLine."Appl.-to Item Entry";
          ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
          //ReserveTransLine.TransferTransferToItemJnlLine(TransLine3,
          //  ItemJnlLine,ItemJnlLine."Quantity (Base)",0);

          ItemJnlPostLine.RunWithCheck(ItemJnlLine);





        until AdjustLine.Next=0;


        if not LineExits then
          Error(Text008)
        else
          Message(Text007);
    end;

    procedure PostRembPretOld(var ItemAdj: Record "Adjustment Header")
    var
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
        ItemAdj.TestField("Posting Date");

        CloseDocument := true;


        LineExistsToReturn:=false;
        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
          if AdjustLine."Returned Qty" + AdjustLine."Qty to return" > AdjustLine.Quantity then
            Error(Text004,AdjustLine."Line No.");
          if AdjustLine."Qty to return"<>0 then LineExistsToReturn:=true;
        until AdjustLine.Next=0;


        if LineExistsToReturn then
          CodeRemb := AddNewRembPret(ItemAdj);


        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");

          LignePret := AdjustLine;


          //AdjustLine."Returned Qty" += AdjustLine."Qty to return";
          //AdjustLine.MODIFY;

          if AdjustLine."Returned Qty" + AdjustLine."Qty to return" <> AdjustLine.Quantity then
            CloseDocument := false;

          //Dépot d'origine - Ajustement négatif
          ItemJnlLine.Init;
          ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::"Loan Return";
          ItemJnlLine."Posting Date" := ItemAdj."Posting Date";
          ItemJnlLine."Document Date" := ItemAdj."Posting Date";
          ItemJnlLine."Document No." := CodeRemb;
          //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
          //ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
          //ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
          //ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
          //ItemJnlLine."Order Line No." := TransLine3."Line No.";
          ItemJnlLine."External Document No." := ItemAdj."External Document No.";

          //IF AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive THEN
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
          //ELSE
          //ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";




          ItemJnlLine.Validate("Item No." , AdjustLine."Item No.");
          ItemJnlLine.Description := ItemAdj."Posting Description";
          ItemJnlLine."Shortcut Dimension 1 Code" := AdjustLine."Shortcut Dimension 1 Code";
          ItemJnlLine."Shortcut Dimension 2 Code" := AdjustLine."Shortcut Dimension 2 Code";
          ItemJnlLine."Dimension Set ID" := AdjustLine."Dimension Set ID";
          ItemJnlLine.Validate("Location Code", AdjustLine."Location Code");
          ItemJnlLine.Validate(Quantity , Abs(AdjustLine."Qty to return"));

          ItemJnlLine.Validate("Unit of Measure Code" , AdjustLine."Unit of Measure Code");
          ItemJnlLine."Invoiced Quantity" := Abs(AdjustLine.Quantity);
          //ItemJnlLine."Quantity (Base)" := RemovalLine.volumea15;
          //ItemJnlLine."Invoiced Qty. (Base)" := RemovalLine.volumea15;
          ItemJnlLine."Source Code" := SourceCode;
          //ItemJnlLine."Gen. Prod. Posting Group" := TransShptLine2."Gen. Prod. Posting Group";
          //ItemJnlLine."Inventory Posting Group" := TransShptLine2."Inventory Posting Group";

          //ItemJnlLine."Qty. per Unit of Measure" := 1;//TransShptLine2."Qty. per Unit of Measure";
          //ItemJnlLine."Variant Code" := TransShptLine2."Variant Code";
          //ItemJnlLine."Bin Code" := TransLine."Transfer-from Bin Code";
          //ItemJnlLine."Country/Region Code" := TransShptHeader2."Trsf.-from Country/Region Code";
          //ItemJnlLine."Transaction Type" := TransRcptHeader2."Transaction Type";
          //ItemJnlLine."Transport Method" := TransRcptHeader2."Transport Method";
          //ItemJnlLine."Entry/Exit Point" := TransShptHeader2."Entry/Exit Point";
          //ItemJnlLine.Area := TransRcptHeader2.Area;
          //ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
          //ItemJnlLine."Product Group Code" := Item1."Product Group Code";
          //ItemJnlLine."Item Category Code" := Item1."Item Category Code";
          //ItemJnlLine."Applies-to Entry" := TransLine."Appl.-to Item Entry";
          ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
          //ReserveTransLine.TransferTransferToItemJnlLine(TransLine3,
          //  ItemJnlLine,ItemJnlLine."Quantity (Base)",0);

          if AdjustLine."Qty to return"<>0 then begin
            LineExistsToReturn := true;
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);

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
}

