codeunit 50011 "Item Shipment Mgt"
{
    // //100617 JN Ajout des champ de dates de preparation, expédition et confirmation de livraion
    // //010618 JN Les écritures lors de la confirmation de livraison sont de type Transfert


    trigger OnRun()
    begin
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Souhaitez-vous créer un document de préparation?';
        Text002: Label 'Vous devez renseigner les quantités à préparer sur le document';
        Text003: Label 'Le document de préparation %1 a été créé';
        Text004: Label '&Terminer la préparation,&Expédier,&Confirmer la livraison';
        Text005: Label '&Confirmer la livraison';
        Text006: Label 'Traitement terminé avec succès';
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        SalesRelease: Codeunit "Release Sales Document";
        UOMgt: Codeunit "Unit of Measure Management";
        Text007: Label 'Aucun article trouvé à livrer sur la commande %1';
        Text008: Label 'Voulez-vous archiver ce document?';
        Selection: Integer;
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text009: Label 'La commande ne peut être livrée dans ce statut';
        Item2: Record Item;
        Text010: Label '&Expédier,&Confirmer la livraison';
        Text011: Label 'Expédition Lubrifiants %1';
        NoConfirmMsg: Boolean;
        SalesProcess: Codeunit "Sales Order Process";
        Text012: Label 'Vous ne pouvez plus préparer une quantité de %1 pour l''article %4. \La quantité commandée est %2. \La quantité en livraison ou déjà livrée est de %3';

    procedure TraiterLivraison(var ShipmentH: Record "Adjustment Header")
    begin

        if ShipmentH."Shipment Status" = ShipmentH."Shipment Status"::" " then begin
            Selection := StrMenu(Text004, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationPreparation(ShipmentH);
            if Selection = 2 then Expedier(ShipmentH);
            if Selection = 3 then ExpedierConfirmer(ShipmentH);
            exit;
        end;

        if ShipmentH."Shipment Status" = ShipmentH."Shipment Status"::Prepared then begin
            Selection := StrMenu(Text010, 1);
            if Selection = 0 then exit;
            if Selection = 1 then Expedier(ShipmentH);
            if Selection = 2 then ExpedierConfirmer(ShipmentH);
            //IF Selection = 2 THEN ConfirmerLivraison(ShipmentH);
            exit;
        end;

        if ShipmentH."Shipment Status" = ShipmentH."Shipment Status"::Shipped then begin
            Selection := StrMenu(Text005, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ConfirmerLivraison(ShipmentH);
            //IF Selection = 2 THEN ConfirmerLivraison(ShipmentH);
            exit;
        end;
    end;

    procedure Expedier(var ShipmentH: Record "Adjustment Header")
    var
        DeliveryLine: Record "Adjustment Line";
        TransferMgt: Codeunit "Item Transfer Mgt";
        ItemJnlLine: Record "Item Journal Line";
        CodeMagasinDest: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."LUB Shipment Location");
        AddOnSetup.TestField(AddOnSetup."Shipment Location GPL");
        AddOnSetup.TestField(AddOnSetup."GPL Item Category");

        DeliveryLine.Reset;
        DeliveryLine.SetRange(DeliveryLine."Document Type", DeliveryLine."Document Type"::Shipment);
        DeliveryLine.SetRange(DeliveryLine."Document No.", ShipmentH."No.");
        if DeliveryLine.FindSet then
            repeat

                DeliveryLine.TestField(DeliveryLine."Location Code");
                DeliveryLine.TestField(DeliveryLine.Quantity);

                CheckShipLine(DeliveryLine);

                if (ShipmentH."Item Category Code" = AddOnSetup."GPL Item Category") then
                    CodeMagasinDest := AddOnSetup."Shipment Location GPL"
                else
                    CodeMagasinDest := AddOnSetup."LUB Shipment Location";

                if (ShipmentH."Item Category Code" = AddOnSetup."GPL Item Category") then//GPL
                    TransferMgt.TransfertItemReclass(ItemJnlPostLine, ShipmentH."No.", ShipmentH."Posting Date", DeliveryLine."Item No.",
                      DeliveryLine."Location Code", CodeMagasinDest, DeliveryLine.Quantity, DeliveryLine."Unit of Measure Code",
                        DeliveryLine."Dimension Set ID", DeliveryLine."Dimension Set ID",
                        StrSubstNo(Text011, ShipmentH."No."), ItemJnlLine."Adjustment Type"::"LUB Ship", '')
                else//LUBS
                    TransferMgt.TransfertItemReclassTransfertLUBS(ItemJnlPostLine, ShipmentH."No.", ShipmentH."Posting Date", DeliveryLine."Item No.",
                      DeliveryLine."Location Code", CodeMagasinDest, DeliveryLine.Quantity, DeliveryLine."Unit of Measure Code",
                        DeliveryLine."Dimension Set ID", DeliveryLine."Dimension Set ID",
                        StrSubstNo(Text011, ShipmentH."No."), ItemJnlLine."Adjustment Type"::"LUB Ship", DeliveryLine);

            until DeliveryLine.Next = 0;

        ShipmentH."Shipment Status" := ShipmentH."Shipment Status"::Shipped;
        ShipmentH.BLub_Expedition := CreateDateTime(Today, Time);
        ShipmentH.Modify;

        if not NoConfirmMsg then
            Message(Text006);
    end;

    local procedure ValidationPreparation(var AdjHeader: Record "Adjustment Header")
    begin
        AdjHeader."Shipment Status" := AdjHeader."Shipment Status"::Prepared;
        AdjHeader.BLub_Preparation := CreateDateTime(Today, Time);
        AdjHeader.Modify;
        Message(Text006);
    end;

    local procedure ConfirmerLivraison(var AdjustH: Record "Adjustment Header")
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record "Adjustment Line";
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
        CodeMagasinDest: Code[20];
    begin

        //AdjustH.TESTFIELD(AdjustH."Location Code");
        AdjustH.TestField(AdjustH."Order No.");

        AdjustH.BLub_Confirmation := CreateDateTime(Today, Time);
        AdjustH.Modify;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."LUB Shipment Location");


        if SalesOrder.Get(SalesOrder."Document Type"::Order, AdjustH."Order No.") then begin

            //SalesOrder.SetHideValidationDialog(TRUE);
            SalesRelease.Reopen(SalesOrder);

            SalesLine.Reset;
            SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
            SalesLine.SetRange(SalesLine."Document No.", SalesOrder."No.");
            if SalesLine.FindSet then
                repeat

                    SalesLine.SetHideValidationDialog(true);
                    //SalesLine.AFK_SetCanSetExpLocation(true);

                    if (SalesLine.Type = SalesLine.Type::Item) then
                        SalesLine.Validate(SalesLine."Qty. to Ship", 0);
                    //ItemExists:=FALSE;

                    DeliveryLine.Reset;
                    DeliveryLine.SetRange(DeliveryLine."Document Type", DeliveryLine."Document Type"::Shipment);
                    DeliveryLine.SetRange(DeliveryLine."Document No.", AdjustH."No.");
                    if DeliveryLine.FindSet then
                        repeat
                            if (SalesLine."No." = DeliveryLine."Item No.") then begin
                                ItemExists := true;

                                //Save Location
                                SalesLine.TestField(SalesLine."Location Code");

                                if SalesLine."Real Location" = '' then
                                    SalesLine."Real Location" := SalesLine."Location Code";


                                if (AdjustH."Item Category Code" = AddOnSetup."GPL Item Category") then
                                    CodeMagasinDest := AddOnSetup."Shipment Location GPL"
                                else
                                    CodeMagasinDest := AddOnSetup."LUB Shipment Location";


                                SalesLine.Validate("Location Code", CodeMagasinDest);

                                CheckShipLine(DeliveryLine);

                                //QteLivreeUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                                //  DeliveryLine."Unit of Measure Code",DeliveryLine.Quantity,DeliveryLine."Item No.",SalesLine."Qty. per Unit of Measure");

                                //SalesLine.VALIDATE(SalesLine."Qty. to Ship",QteLivreeUniteCde);

                                //SalesLine.VALIDATE(SalesLine."Qty. to invoice",0);
                                SalesLine.Modify;
                            end;

                        until DeliveryLine.Next = 0;
                until SalesLine.Next = 0;


            if not ItemExists then Error(Text007, SalesOrder."No.");

            SalesOrder.Validate("Posting Date", AdjustH."Posting Date");
            //SalesOrder.Ship:=TRUE;
            //SalesOrder.Invoice:=FALSE;
            SalesOrder.Modify;
            //CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesOrder);

        end;

        ArchiveDoc(AdjustH);

        if not NoConfirmMsg then
            Message(Text006);
    end;

    local procedure getQtyALivrerUniteCde(CodeUniteCde: Code[10]; CodeUniteDispaching: Code[10]; QteDispaching: Decimal; CodeArticle: Code[20]; QtyPerUnitCde: Decimal): Decimal
    var
        QteBaseDispaching: Decimal;
        QtyPerUnitDispaching: Decimal;
        Item1: Record Item;
        TextErrCde: Label 'Quantity per unit of measure must be defined.';
    begin
        Item1.Get(CodeArticle);
        QtyPerUnitDispaching := UOMgt.GetQtyPerUnitOfMeasure(Item1, CodeUniteDispaching);
        QteBaseDispaching := UOMgt.CalcBaseQty(QteDispaching, QtyPerUnitDispaching);
        if QtyPerUnitCde <> 0 then
            exit(UOMgt.RoundQty(QteBaseDispaching / QtyPerUnitCde))
        else
            Error(TextErrCde);
    end;

    local procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    begin
        ItemAdjustMgt.ArchiveDoc(ItemAdj);
        ItemAdj.SetIsArchive(true);
        ItemAdj.Delete(true);
    end;

    procedure PostArchiveDoc(var ItemAdj: Record "Adjustment Header")
    begin
        if not Confirm(Text008) then exit;
        ArchiveDoc(ItemAdj);
    end;

    procedure CreatePreparationFromSalesOrder(var SalesH: Record "Sales Header"): Code[20]
    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        CreatedLine: Record "Adjustment Line";
        LineNum: Integer;
        LineExistsToReturn: Boolean;
        AdjustLine: Record "Adjustment Line";
        ShipHeader: Record "Adjustment Header";
        ShipLine: Record "Adjustment Line";
        Item1: Record Item;
    begin

        if not Confirm(Text001) then exit;


        SalesProcess.CheckCanPostSalesOrder(SalesH);


        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."LUBS Item Category");
        //CheckExistingInvoice
        /*
        SalesOrderHeader.RESET;
        SalesOrderHeader.SETRANGE(SalesOrderHeader."Document Type",SalesOrderHeader."Document Type"::Invoice);
        SalesOrderHeader.SETRANGE(SalesOrderHeader."Created By Doc Type",SalesOrderHeader."Created By Doc Type"::Consignation);
        SalesOrderHeader.SETRANGE(SalesOrderHeader."Created By Doc No.",ItemAdj."No.");
        IF SalesOrderHeader.FINDFIRST THEN
          ERROR(Text015,SalesOrderHeader."No.");
        */

        SalesH.TestField(SalesH."Posting Date");
        SalesH.TestField(SalesH."Sell-to Customer No.");
        //SalesH.TESTFIELD(SalesH."Delivery Status",SalesH."Delivery Status"::AttenteLivraison);
        if ((SalesH."Delivery Status" <> SalesH."Delivery Status"::AttenteLivraison) and
            (SalesH."Delivery Status" <> SalesH."Delivery Status"::PartiellementLivree) and
             (SalesH."Delivery Status" <> SalesH."Delivery Status"::PartiellementFacturee)) then
            Error(Text009);

        LineExistsToReturn := false;
        SalesOrderLine.Reset;
        SalesOrderLine.SetRange(SalesOrderLine."Document Type", SalesH."Document Type");
        SalesOrderLine.SetRange("Document No.", SalesH."No.");
        if SalesOrderLine.FindSet then
            repeat
                //IF AdjustLine."Returned Qty"
                //  + AdjustLine."Invoiced Qty" + AdjustLine."Qty to invoice" > AdjustLine.Quantity THEN
                //  ERROR(Text005,AdjustLine."Line No.");


                if SalesOrderLine.Type = SalesOrderLine.Type::Item then begin

                    if Item2.Get(SalesOrderLine."No.") then
                        if Item2.Type = Item2.Type::Inventory then
                            SalesOrderLine.TestField(SalesOrderLine."Location Code");

                    CheckShipmentQty(SalesH."No.", SalesOrderLine."Line No.",
                      SalesOrderLine.Quantity, SalesOrderLine."Qty to prepare", SalesOrderLine."No.");

                    if SalesOrderLine."Qty to prepare" <> 0 then
                        LineExistsToReturn := true;
                end;

            until SalesOrderLine.Next = 0;

        if not LineExistsToReturn then
            Error(Text002);




        ShipHeader.Init;
        ShipHeader."Document Type" := ShipHeader."Document Type"::Shipment;
        ShipHeader."No." := '';

        ShipHeader.LockTable;
        ShipHeader.Insert(true);

        ShipHeader.Validate(ShipHeader."Customer No.", SalesH."Sell-to Customer No.");

        if SalesProcess.IsCdeGPL(SalesH) then
            ShipHeader."Item Category Code" := AddOnSetup."GPL Item Category"
        else
            ShipHeader."Item Category Code" := AddOnSetup."LUBS Item Category";
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;

        ShipHeader."Order No." := SalesH."No.";


        ShipHeader.Validate("Posting Date", SalesH."Posting Date");
        ShipHeader."Document Date" := WorkDate;
        //ShipHeader."Shipment Date" := 0D;
        ShipHeader."Shortcut Dimension 1 Code" := SalesH."Shortcut Dimension 1 Code";
        ShipHeader."Shortcut Dimension 2 Code" := SalesH."Shortcut Dimension 2 Code";
        ShipHeader."Dimension Set ID" := SalesH."Dimension Set ID";
        ShipHeader."External Document No." := SalesH."No.";
        ShipHeader."Location Code" := SalesH."Location Code";
        ShipHeader."Responsibility Center" := SalesH."Responsibility Center";
        ShipHeader."Shipment Date" := SalesH."Shipment Date";
        ShipHeader."Shipment Method Code" := SalesH."Shipment Method Code";
        ShipHeader."Ship-to Code" := SalesH."Ship-to Code";

        ShipHeader.Modify;

        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."Consignation Location");



        //Ligne
        LineNum := 0;
        SalesOrderLine.Reset;
        SalesOrderLine.SetRange(SalesOrderLine."Document Type", SalesH."Document Type");
        SalesOrderLine.SetRange("Document No.", SalesH."No.");
        if SalesOrderLine.FindSet then
            repeat

                if ((SalesOrderLine."Qty to prepare" > 0)
                  and (SalesOrderLine.Type = SalesOrderLine.Type::Item)) then begin
                    Item1.Get(SalesOrderLine."No.");
                    if Item1.Type = Item1.Type::Inventory then begin




                        ShipLine.Init;
                        ShipLine."Document Type" := ShipHeader."Document Type"::Shipment;
                        ShipLine."Document No." := ShipHeader."No.";
                        LineNum := LineNum + 10;
                        ShipLine."Line No." := LineNum;
                        ShipLine.Insert(true);




                        ShipLine."Order Line No" := SalesOrderLine."Line No.";

                        ShipLine.Validate(ShipLine."Item No.", SalesOrderLine."No.");
                        //ShipLine.VALIDATE(ShipLine."Location Code",SalesOrderLine."Location Code");
                        ShipLine.Validate("Unit of Measure Code", SalesOrderLine."Unit of Measure Code");
                        ShipLine.Validate(ShipLine.Quantity, SalesOrderLine."Qty to prepare");
                        if SalesOrderLine."Real Location" = '' then
                            ShipLine."Location Code" := SalesOrderLine."Location Code"
                        else
                            ShipLine."Location Code" := SalesOrderLine."Real Location";
                        ShipLine."Shortcut Dimension 1 Code" := SalesOrderLine."Shortcut Dimension 1 Code";
                        ShipLine."Shortcut Dimension 2 Code" := SalesOrderLine."Shortcut Dimension 2 Code";
                        ShipLine."Dimension Set ID" := SalesOrderLine."Dimension Set ID";
                        ShipLine.Modify;

                        SalesOrderLine."Qty to prepare" := 0;
                        SalesOrderLine.Modify;
                    end;

                end;

            until SalesOrderLine.Next = 0;



        Message(Text003, ShipHeader."No.");
        exit(ShipHeader."No.");

    end;

    local procedure ConfirmerLivraison_OLD(var AdjustH: Record "Adjustment Header")
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record "Adjustment Line";
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
    begin

        //AdjustH.TESTFIELD(AdjustH."Location Code");
        AdjustH.TestField(AdjustH."Order No.");

        SalesOrder.Get(SalesOrder."Document Type"::Order, AdjustH."Order No.");
        //SalesOrder.SetHideValidationDialog(TRUE);
        SalesRelease.Reopen(SalesOrder);

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."LUB Shipment Location");


        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(SalesLine."Document No.", SalesOrder."No.");
        if SalesLine.FindSet then
            repeat

                SalesLine.SetHideValidationDialog(true);

                if (SalesLine.Type = SalesLine.Type::Item) then
                    SalesLine.Validate(SalesLine."Qty. to Ship", 0);
                //ItemExists:=FALSE;

                DeliveryLine.Reset;
                DeliveryLine.SetRange(DeliveryLine."Document Type", DeliveryLine."Document Type"::Shipment);
                DeliveryLine.SetRange(DeliveryLine."Document No.", AdjustH."No.");
                if DeliveryLine.FindSet then
                    repeat
                        if (SalesLine."No." = DeliveryLine."Item No.") then begin
                            ItemExists := true;

                            //Save Location
                            SalesLine.TestField(SalesLine."Location Code");

                            if SalesLine."Real Location" = '' then
                                SalesLine."Real Location" := SalesLine."Location Code";

                            SalesLine.Validate("Location Code", AddOnSetup."LUB Shipment Location");

                            QteLivreeUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                              DeliveryLine."Unit of Measure Code", DeliveryLine.Quantity, DeliveryLine."Item No.", SalesLine."Qty. per Unit of Measure");

                            SalesLine.Validate(SalesLine."Qty. to Ship", QteLivreeUniteCde);

                            //SalesLine.VALIDATE(SalesLine."Qty. to invoice",0);
                            SalesLine.Modify;
                        end;

                    until DeliveryLine.Next = 0;
            until SalesLine.Next = 0;


        if not ItemExists then Error(Text007, SalesOrder."No.");

        SalesOrder.Validate("Posting Date", AdjustH."Posting Date");
        SalesOrder.Ship := true;
        SalesOrder.Invoice := false;
        SalesOrder.Modify;
        CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesOrder);

        ArchiveDoc(AdjustH);
        Message(Text006);
    end;

    local procedure ExpedierConfirmer(var AdjHeader: Record "Adjustment Header")
    begin
        NoConfirmMsg := true;
        Expedier(AdjHeader);
        ConfirmerLivraison(AdjHeader);
        Message(Text006);
    end;

    local procedure CanCheckShipmentQty(OrderNo: Code[20]): Boolean
    var
        ShipH: Record "Adjustment Header";
        PostedShipH: Record "Posted Adjustment Header";
        ShipL: Record "Adjustment Line";
        PostedShipL: Record "Posted Adjustment Line";
    begin
        ShipH.Reset;
        ShipH.SetCurrentKey("Order No.");
        ShipH.SetRange("Order No.", OrderNo);
        if ShipH.FindSet then
            repeat

                ShipL.Reset;
                ShipL.SetRange("Document Type", ShipH."Document Type");
                ShipL.SetRange(ShipL."Document No.", ShipH."No.");
                if ShipL.FindSet then
                    repeat
                        if ShipL."Order Line No" = 0 then exit(false);
                    until ShipL.Next = 0;

            until ShipH.Next = 0;

        PostedShipH.Reset;
        PostedShipH.SetCurrentKey("Order No.");
        PostedShipH.SetRange("Order No.", OrderNo);
        if PostedShipH.FindSet then
            repeat

                PostedShipL.Reset;
                PostedShipL.SetRange("Document Type", PostedShipH."Document Type");
                PostedShipL.SetRange("Document No.", PostedShipH."No.");
                if PostedShipL.FindSet then
                    repeat
                        if PostedShipL."Order Line No" = 0 then exit(false);
                    until PostedShipL.Next = 0;

            until PostedShipH.Next = 0;


        exit(true);
    end;

    local procedure CheckShipmentQty(OrderNo: Code[20]; OrderLineNo: Integer; OrderQty: Decimal; NewQtyToShip: Decimal; ItemNo: Code[20])
    var
        QteEnLivraison: Decimal;
        QteConfirmee: Decimal;
        ShipH: Record "Adjustment Header";
        PostedShipH: Record "Posted Adjustment Header";
        ShipL: Record "Adjustment Line";
        PostedShipL: Record "Posted Adjustment Line";
    begin

        if not CanCheckShipmentQty(OrderNo) then exit;


        ShipH.Reset;
        ShipH.SetCurrentKey("Order No.");
        ShipH.SetRange("Order No.", OrderNo);
        if ShipH.FindSet then
            repeat

                ShipL.Reset;
                ShipL.SetRange("Document Type", ShipH."Document Type");
                ShipL.SetRange(ShipL."Document No.", ShipH."No.");
                if ShipL.FindSet then
                    repeat
                        if ShipL."Order Line No" = OrderLineNo then
                            QteEnLivraison := QteEnLivraison + ShipL.Quantity;
                    until ShipL.Next = 0;

            until ShipH.Next = 0;

        PostedShipH.Reset;
        PostedShipH.SetCurrentKey("Order No.");
        PostedShipH.SetRange("Order No.", OrderNo);
        if PostedShipH.FindSet then
            repeat

                PostedShipL.Reset;
                PostedShipL.SetRange("Document Type", PostedShipH."Document Type");
                PostedShipL.SetRange("Document No.", PostedShipH."No.");
                if PostedShipL.FindSet then
                    repeat
                        if PostedShipL."Order Line No" = OrderLineNo then
                            QteConfirmee := QteConfirmee + PostedShipL.Quantity;
                    until PostedShipL.Next = 0;

            until PostedShipH.Next = 0;

        if (QteEnLivraison + QteConfirmee + NewQtyToShip > OrderQty) then
            Error(Text012, NewQtyToShip, OrderQty, QteEnLivraison + QteConfirmee, ItemNo);
    end;

    local procedure CheckShipLine(ShipLine: Record "Adjustment Line")
    var
        Item1: Record Item;
        Loc1: Record Location;
    begin
        Item1.Get(ShipLine."Item No.");
        Loc1.Get(ShipLine."Location Code");
        Item1.TestField(Item1."Item Category Code", Loc1."Item Category Code");
    end;
}

