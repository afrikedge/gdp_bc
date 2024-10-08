codeunit 50008 "Item Consignation Mgt"
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
        Text004: Label 'Traitement terminé avec succès';
        Text005: Label 'La quantité à retourner est supérieure à la quantité restante sur la ligne %1';
        Text006: Label 'Le document ne peut pas être clôturé car la ligne %1 a une quantité restante';
        ItemAdjMgt: Codeunit "Item Adjustment Mgt";
        Text007: Label 'Consignation de produits %1';
        Text008: Label 'Voulez-vous valider la consignation de produits ?';
        Text009: Label 'Voulez-vous créer une nouvelle facture de vente ?';
        Text010: Label 'Voulez-vous clôturer ce document ?';
        Text011: Label 'Voulez-vous créer un retour de consignation ?';
        Text012: Label 'Traitement terminé avec succès';
        Text013: Label 'Aucune ligne à valider !';
        Text014: Label 'La facture de vente %1 a été créée';
        Text015: Label 'Une facture non validée existe pour ce document, Validez la facture %1 avant de créer une nouvelle';
        Text016: Label 'Retour de consignation de produits %1';

    procedure PostConsignation(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        SalesOrderHeader: Record "Sales Header";
        ItemTransfer: Codeunit "Item Transfer Mgt";
    begin

        if not Confirm(Text008) then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Consignation Location");

        ItemAdj.TestField("Customer No.");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Open);

        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;

        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Consignation);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat

          Item1.Get(AdjustLine."Item No.");
          AdjustLine.TestField(AdjustLine."Location Code");
          AdjustLine.TestField(AdjustLine.Quantity);

          ItemTransfer.TransfertItemReclass(ItemJnlPostLine,ItemAdj."No.",ItemAdj."Posting Date",AdjustLine."Item No.",
            AdjustLine."Location Code",AddOnSetup."Consignation Location",Abs(AdjustLine.Quantity),AdjustLine."Unit of Measure Code",
            AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",StrSubstNo(Text007,ItemAdj."No."),ItemJnlLine."Adjustment Type"::Consignation,'');


        until AdjustLine.Next=0;

        Message(Text004);
    end;

    procedure PostRetourConsignation(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        CodeRemb: Code[20];
        LineExistsToReturn: Boolean;
        LigneCons: Record "Adjustment Line";
        SalesOrderHeader: Record "Sales Header";
        ItemTransfer: Codeunit "Item Transfer Mgt";
    begin


        if not Confirm(Text011) then exit;



        //CheckExistingInvoice
        SalesOrderHeader.Reset;
        SalesOrderHeader.SetRange(SalesOrderHeader."Document Type",SalesOrderHeader."Document Type"::Invoice);
        SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc Type",SalesOrderHeader."Created By Doc Type"::Consignation);
        SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc No.",ItemAdj."No.");
        if SalesOrderHeader.FindFirst then
          Error(Text015,SalesOrderHeader."No.");


        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Released);
        ItemAdj.TestField("Customer No.");
        ItemAdj.TestField("Receipt Date");


        LineExistsToReturn:=false;
        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Consignation);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
          if AdjustLine."Returned Qty"
            + AdjustLine."Invoiced Qty" + AdjustLine."Qty to return" > AdjustLine.Quantity then
            Error(Text005,AdjustLine."Line No.");
          if AdjustLine."Qty to return"<>0 then LineExistsToReturn:=true;
        until AdjustLine.Next=0;

        if LineExistsToReturn then
          CodeRemb := AddNewRetourConsignation(ItemAdj);


        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Consignation);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet(true,true) then repeat

          Item1.Get(AdjustLine."Item No.");


          LigneCons := AdjustLine;

          //AdjustLine."Returned Qty" := AdjustLine."Returned Qty"+AdjustLine."Qty to return";
          //AdjustLine.MODIFY;




        if AdjustLine."Qty to return"<>0 then
          ItemTransfer.TransfertItemReclass(ItemJnlPostLine,CodeRemb,ItemAdj."Receipt Date",AdjustLine."Item No.",
            AddOnSetup."Consignation Location",AdjustLine."Location Code",Abs(AdjustLine."Qty to return"),AdjustLine."Unit of Measure Code",
            AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",StrSubstNo(Text016,ItemAdj."No."),
            ItemJnlLine."Adjustment Type"::"Consignation Return",'');


         if AdjustLine."Qty to return"<>0 then begin
            LigneCons."Returned Qty" += AdjustLine."Qty to return";
            //LigneCons."Qty to return" := LigneCons.Quantity-(LigneCons."Returned Qty"+LigneCons."Invoiced Qty");
            LigneCons."Qty to return" :=0;
            LigneCons."Qty Restante Consignation" := LigneCons.Quantity-(LigneCons."Invoiced Qty"+LigneCons."Returned Qty");
            LigneCons.Modify;
          end;

        until AdjustLine.Next=0;



        if LineExistsToReturn then begin
          //Close Doc
          //IF CloseDocument THEN
          //  ArchiveDoc(ItemAdj);
          CheckArchiveDoc(ItemAdj);

          Message(Text012);
        end else begin
          Message(Text013);
        end;
    end;

    local procedure AddNewRetourConsignation(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        ReturnHeader: Record "Item Return Header";
        ReturnLine: Record "Item Return Line";
        AdjLine: Record "Adjustment Line";
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Item Return Consignation Nos.");


        ReturnHeader.Init;
        ReturnHeader.TransferFields(ItemAdj);
        ReturnHeader."Document Type" := ReturnHeader."Document Type"::Consignation;
        ReturnHeader."No." := NosSeriesMgt.GetNextNo(AddOnSetup."Item Return Consignation Nos.",Today,true);
        ReturnHeader."Original Doc No" := ItemAdj."No.";
        ReturnHeader."Posting Date" := ItemAdj."Receipt Date";
        ReturnHeader."User ID" := UserId;
        ReturnHeader.Insert;

        AdjLine.Reset;
        AdjLine.SetRange("Document Type",AdjLine."Document Type"::Consignation);
        AdjLine.SetRange("Document No.",ItemAdj."No.");
        if AdjLine.FindSet then repeat
          ReturnLine.Init;
          ReturnLine.TransferFields(AdjLine);
          ReturnLine."Document Type" := ReturnLine."Document Type"::Consignation;
          ReturnLine."Document No.":= ReturnHeader."No.";
          ReturnLine."Line No." := AdjLine."Line No.";
          ReturnLine.Quantity := AdjLine."Qty to return";
          if ReturnLine.Quantity>0 then
            ReturnLine.Insert;
        until AdjLine.Next=0;

        exit(ReturnHeader."No.");
    end;

    procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    var
        PostedRec: Record "Posted Adjustment Header";
        PostedLine: Record "Posted Adjustment Line";
        AdjustLine: Record "Adjustment Line";
    begin

        //Controle quantité
        AdjustLine.Reset;
        AdjustLine.SetRange("Document Type",ItemAdj."Document Type");
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat

          if AdjustLine."Returned Qty" + AdjustLine."Invoiced Qty"  <> AdjustLine.Quantity then
            Error(Text006,AdjustLine."Line No.");

        until AdjustLine.Next=0;

        ItemAdjMgt.ArchiveDoc(ItemAdj);
    end;

    procedure AddNewSalesConsignationInvoice(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        CreatedLine: Record "Adjustment Line";
        LineNum: Integer;
        LineExistsToReturn: Boolean;
        AdjustLine: Record "Adjustment Line";
    begin

        if not Confirm(Text009) then exit;



        //CheckExistingInvoice
        SalesOrderHeader.Reset;
        SalesOrderHeader.SetRange(SalesOrderHeader."Document Type",SalesOrderHeader."Document Type"::Invoice);
        SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc Type",SalesOrderHeader."Created By Doc Type"::Consignation);
        SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc No.",ItemAdj."No.");
        if SalesOrderHeader.FindFirst then
          Error(Text015,SalesOrderHeader."No.");

        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Released);
        ItemAdj.TestField("Customer No.");
        ItemAdj.TestField(ItemAdj."Shipment Date");


        LineExistsToReturn:=false;
        AdjustLine.Reset;
        AdjustLine.SetRange("Document Type",AdjustLine."Document Type"::Consignation);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
          if AdjustLine."Returned Qty"
            + AdjustLine."Invoiced Qty" + AdjustLine."Qty to invoice" > AdjustLine.Quantity then
            Error(Text005,AdjustLine."Line No.");
          if AdjustLine."Qty to invoice"<>0 then LineExistsToReturn:=true;
        until AdjustLine.Next=0;

        if not LineExistsToReturn then
          Error(Text013);




        SalesOrderHeader.Init;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Invoice;
        SalesOrderHeader."No." := '';

        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        SalesOrderHeader.Validate(SalesOrderHeader."Sell-to Customer No.",ItemAdj."Customer No.");
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;

        SalesOrderHeader."Created By Doc No." := ItemAdj."No.";
        SalesOrderHeader."Created By Doc Type" := SalesOrderHeader."Created By Doc Type"::Consignation;


        SalesOrderHeader.Validate("Posting Date" , ItemAdj."Shipment Date");
        SalesOrderHeader."Document Date" := WorkDate;
        //SalesOrderHeader."Shipment Date" := 0D;
        SalesOrderHeader."Shortcut Dimension 1 Code" := ItemAdj."Shortcut Dimension 1 Code";
        SalesOrderHeader."Shortcut Dimension 2 Code" := ItemAdj."Shortcut Dimension 2 Code";
        SalesOrderHeader."Dimension Set ID" := ItemAdj."Dimension Set ID";

        SalesOrderHeader.Modify;



        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Consignation Location");



        //Ligne
        LineNum:=0;
        CreatedLine.Reset;
        CreatedLine.SetRange("Document Type",CreatedLine."Document Type"::Consignation);
        CreatedLine.SetRange("Document No.",ItemAdj."No.");
        if CreatedLine.FindSet then repeat


          SalesOrderLine.Init;
          SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Invoice;
          SalesOrderLine."Document No." := SalesOrderHeader."No.";
          LineNum := LineNum + 10;
          SalesOrderLine."Line No." := LineNum;
          SalesOrderLine.Insert(true);

          SalesOrderLine.Type := SalesOrderLine.Type::Item;
          SalesOrderLine.Validate(SalesOrderLine."No.",CreatedLine."Item No.");
          SalesOrderLine.Validate(SalesOrderLine."Location Code",AddOnSetup."Consignation Location");
          SalesOrderLine.Validate(SalesOrderLine.Quantity,CreatedLine."Qty to invoice");
          //SalesOrderLine.VALIDATE(SalesOrderLine."Unit Price",CreatedLine."Transfer Fees");
          //SalesOrderLine."Card Number" := CreatedLine."Card Number";
          SalesOrderLine."Shortcut Dimension 1 Code" := CreatedLine."Shortcut Dimension 1 Code";
          SalesOrderLine."Shortcut Dimension 2 Code" := CreatedLine."Shortcut Dimension 2 Code";
          SalesOrderLine."Dimension Set ID" := CreatedLine."Dimension Set ID";
          SalesOrderLine."Consignation Line No." := CreatedLine."Line No.";
          SalesOrderLine.Modify;

          CreatedLine."Qty to invoice" := 0;
          CreatedLine.Modify;

        until CreatedLine.Next=0;



        Message(Text014,SalesOrderHeader."No.");
        exit(SalesOrderHeader."No.");
    end;

    procedure ConfirmConsignationSalesQty(var SalesHeader: Record "Sales Invoice Header")
    var
        ReturnHeader: Record "Item Return Header";
        ReturnLine: Record "Item Return Line";
        AdjLine: Record "Adjustment Line";
        ItemAdj: Record "Adjustment Header";
        SalesLine: Record "Sales Invoice Line";
    begin

        if SalesHeader."Created By Doc Type"<>SalesHeader."Created By Doc Type"::Consignation then exit;

        SalesLine.Reset;
        //SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::in);
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        if SalesLine.FindSet then repeat

          if AdjLine.Get(AdjLine."Document Type"::Consignation,SalesHeader."Created By Doc No.",SalesLine."Consignation Line No.")
             then begin

             if AdjLine."Returned Qty"
                + AdjLine."Invoiced Qty" + SalesLine.Quantity > AdjLine.Quantity then
                  Error(Text005,AdjLine."Line No.");

             AdjLine."Invoiced Qty" += SalesLine.Quantity;
             AdjLine."Qty Restante Consignation" := AdjLine.Quantity-(AdjLine."Invoiced Qty"+AdjLine."Returned Qty");
             AdjLine.Modify;
          end;

        until SalesLine.Next=0;

        if ItemAdj.Get(ItemAdj."Document Type"::Consignation,SalesHeader."Created By Doc No.") then
          CheckArchiveDoc(ItemAdj);
    end;

    procedure CheckArchiveDoc(var ItemAdj: Record "Adjustment Header")
    var
        PostedRec: Record "Posted Adjustment Header";
        PostedLine: Record "Posted Adjustment Line";
        AdjustLine: Record "Adjustment Line";
        DoNotClose: Boolean;
    begin

        DoNotClose := false;

        //Controle quantité
        AdjustLine.Reset;
        AdjustLine.SetRange("Document Type",ItemAdj."Document Type");
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat

          if AdjustLine."Returned Qty" + AdjustLine."Invoiced Qty"  <> AdjustLine.Quantity then
            DoNotClose := true;

        until AdjustLine.Next=0;

        if not DoNotClose then begin
          ItemAdjMgt.ArchiveDoc(ItemAdj);
          ItemAdj.SetIsArchive(true);
          ItemAdj.Delete(true);
        end;
    end;
}

