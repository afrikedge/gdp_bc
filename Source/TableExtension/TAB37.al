tableextension 50012 "A02 Sales Line" extends "Sales Line"
{
    // //170216 Redevence Fees Mgt
    fields
    {
        // modify("Location Code")
        // {
        //     TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
        //                                     "Item Category Code" = FIELD("Item Category Code"));
        // }

        //Unsupported feature: Property Insertion (Editable) on ""Line Amount"(Field 103)".



        //Unsupported feature: Code Modification on ""No."(Field 6).OnValidate".

        //trigger "(Field 6)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetSalesSetup;
        IF SalesSetup."Create Item from Item No." THEN
          "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");
        #4..119
        PostingSetupMgt.CheckGenPostingSetupSalesAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        PostingSetupMgt.CheckGenPostingSetupCOGSAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        PostingSetupMgt.CheckVATPostingSetupSalesAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..122






        //The code has been merged but contained errors that could prevent import
        //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
        //GetSalesSetup;
        //IF SalesSetup."Create Item from Item No." THEN
        //  "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");
        //
        //TestJobPlanningLine;
        //TestStatusOpen;
        //CheckItemAvailable(FIELDNO("No."));
        //
        //IF (xRec."No." <> "No.") AND (Quantity <> 0) THEN BEGIN
        //  TESTFIELD("Qty. to Asm. to Order (Base)",0);
        //  CALCFIELDS("Reserved Qty. (Base)");
        //  TESTFIELD("Reserved Qty. (Base)",0);
        //  IF Type = Type::Item THEN
        //    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
        //  OnValidateNoOnAfterVerifyChange(Rec,xRec);
        //END;
        //
        //TESTFIELD("Qty. Shipped Not Invoiced",0);
        //TESTFIELD("Quantity Shipped",0);
        //TESTFIELD("Shipment No.",'');
        //
        //TESTFIELD("Prepmt. Amt. Inv.",0);
        //
        //TESTFIELD("Return Qty. Rcd. Not Invd.",0);
        //TESTFIELD("Return Qty. Received",0);
        //TESTFIELD("Return Receipt No.",'');
        //
        //IF "No." = '' THEN
        //  ATOLink.DeleteAsmFromSalesLine(Rec);
        //CheckAssocPurchOrder(FIELDCAPTION("No."));
        //AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
        //
        //OnValidateNoOnBeforeInitRec(Rec,xRec,CurrFieldNo);
        //TempSalesLine := Rec;
        //INIT;
        //IF xRec."Line Amount" <> 0 THEN
        //  "Recalculate Invoice Disc." := TRUE;
        //Type := TempSalesLine.Type;
        //"No." := TempSalesLine."No.";
        //OnValidateNoOnCopyFromTempSalesLine(Rec,TempSalesLine);
        //IF "No." = '' THEN
        //  EXIT;
        //
        //IF HasTypeToFillMandatoryFields THEN
        //  Quantity := TempSalesLine.Quantity;
        //
        //"System-Created Entry" := TempSalesLine."System-Created Entry";
        //GetSalesHeader;
        //InitHeaderDefaults(SalesHeader);
        //CALCFIELDS("Substitution Available");
        //
        //"Promised Delivery Date" := SalesHeader."Promised Delivery Date";
        //"Requested Delivery Date" := SalesHeader."Requested Delivery Date";
        //"Shipment Date" :=
        //  CalendarMgmt.CalcDateBOC(
        //    '',SalesHeader."Shipment Date",CalChange."Source Type"::Location,"Location Code",'',
        //    CalChange."Source Type"::"Shipping Agent","Shipping Agent Code","Shipping Agent Service Code",FALSE);
        //
        //OnValidateNoOnBeforeUpdateDates(Rec,xRec,SalesHeader,CurrFieldNo);
        //UpdateDates;
        //
        //OnAfterAssignHeaderValues(Rec,SalesHeader);
        //
        //CASE Type OF
        //  Type::" ":
        //    CopyFromStandardText;
        //  Type::"G/L Account":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      GLAcc.GET("No.");
        //      GLAcc.CheckGLAcc;
        //      IF NOT "System-Created Entry" THEN
        //        GLAcc.TESTFIELD("Direct Posting",TRUE);
        //      Description := GLAcc.Name;
        //      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        //      "Tax Group Code" := GLAcc."Tax Group Code";
        //      "Allow Invoice Disc." := FALSE;
        //      "Allow Item Charge Assignment" := FALSE;
        //      InitDeferralCode;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      //*****************************************************
        //      ERROR(AFK_Text004);
        //      //*****************************************************
        //      GLAcc.GET("No.");
        //      GLAcc.CheckGLAcc;
        //      IF NOT "System-Created Entry" THEN
        //        GLAcc.TESTFIELD("Direct Posting",TRUE);
        //      Description := GLAcc.Name;
        //      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        //      "Tax Group Code" := GLAcc."Tax Group Code";
        //      "Allow Invoice Disc." := FALSE;
        //      "Allow Item Charge Assignment" := FALSE;
        //      InitDeferralCode;
        //    END;
        //{=======} TARGET
        //    CopyFromGLAccount;
        //{<<<<<<<}
        //  Type::Item:
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      GetItem;
        //      Item.TESTFIELD(Blocked,FALSE);
        //      Item.TESTFIELD("Gen. Prod. Posting Group");
        //      IF Item.Type = Item.Type::Inventory THEN BEGIN
        //        Item.TESTFIELD("Inventory Posting Group");
        //        "Posting Group" := Item."Inventory Posting Group";
        //      END;
        //      Description := Item.Description;
        //      "Description 2" := Item."Description 2";
        //      GetUnitCost;
        //      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
        //      "Units per Parcel" := Item."Units per Parcel";
        //      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
        //      "Tax Group Code" := Item."Tax Group Code";
        //      "Item Category Code" := Item."Item Category Code";
        //      "Product Group Code" := Item."Product Group Code";
        //      Nonstock := Item."Created From Nonstock Item";
        //      "Profit %" := Item."Profit %";
        //      "Allow Item Charge Assignment" := TRUE;
        //      PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");
        //
        //      IF SalesHeader."Language Code" <> '' THEN
        //        GetItemTranslation;
        //
        //      IF Item.Reserve = Item.Reserve::Optional THEN
        //        Reserve := SalesHeader.Reserve
        //      ELSE
        //        Reserve := Item.Reserve;
        //
        //      "Unit of Measure Code" := Item."Sales Unit of Measure";
        //      InitDeferralCode;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      GetItem;
        //      Item.TESTFIELD(Blocked,FALSE);
        //      Item.TESTFIELD("Gen. Prod. Posting Group");
        //      IF Item.Type = Item.Type::Inventory THEN BEGIN
        //        Item.TESTFIELD("Inventory Posting Group");
        //        "Posting Group" := Item."Inventory Posting Group";
        //      END;
        //      Description := Item.Description;
        //      "Description 2" := Item."Description 2";
        //      GetUnitCost;
        //      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
        //      "Units per Parcel" := Item."Units per Parcel";
        //      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
        //      "Tax Group Code" := Item."Tax Group Code";
        //      "Item Category Code" := Item."Item Category Code";
        //      "Product Group Code" := Item."Product Group Code";
        //      Nonstock := Item."Created From Nonstock Item";
        //      "Profit %" := Item."Profit %";
        //      "Allow Item Charge Assignment" := TRUE;
        //      PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");
        //
        //      //***********************************************************
        //      //***********************************************************
        //
        //      Cust2.GET(SalesHeader."Sell-to Customer No.");
        //      Cust2.TESTFIELD(Cust2."Sales Category Code");
        //
        //      AFK_AddOnSetup.GET;
        //      IF Item.Type = Item.Type::Inventory THEN BEGIN
        //        IF NOT AFK_SecMgt.CanAddItemOnSalesInv THEN BEGIN
        //          IF ((SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::"Credit Memo"]) AND
        //               (SalesHeader."Created By Doc Type"<>SalesHeader."Created By Doc Type"::Consignation)) THEN
        //            IF Cust2."Sales Channel Code"<> AFK_AddOnSetup."AMSA Sales Channel" THEN
        //              ERROR(AFK_Text002);
        //        END;
        //      END;
        //
        //      IF SalesHeader."Document Type"=SalesHeader."Document Type"::Order THEN
        //        Item.TESTFIELD("Sales Category Code",Cust2."Sales Category Code");
        //
        //
        //      IF AfkLoc.GET(Rec."Location Code") THEN
        //        Item.TESTFIELD("Item Category Code",AfkLoc."Item Category Code");
        //
        //      "FER Fees Price" := Item."FER Fees Price";
        //      "OMH Fees Price" := Item."OMH Fees Price";
        //      "ENV Fees Price" := Item."ENV Fees Price";
        //      "RDS Fees Price" := Item."RDS Fees Price";
        //
        //      "Shipment Group" := Item."Shipment Group";
        //
        //      //***********************************************************
        //      //***********************************************************
        //
        //      IF SalesHeader."Language Code" <> '' THEN
        //        GetItemTranslation;
        //
        //      IF Item.Reserve = Item.Reserve::Optional THEN
        //        Reserve := SalesHeader.Reserve
        //      ELSE
        //        Reserve := Item.Reserve;
        //
        //      "Unit of Measure Code" := Item."Sales Unit of Measure";
        //      InitDeferralCode;
        //    END;
        //{=======} TARGET
        //    CopyFromItem;
        //{<<<<<<<}
        //  Type::Resource:
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      Res.GET("No.");
        //      Res.TESTFIELD(Blocked,FALSE);
        //      Res.TESTFIELD("Gen. Prod. Posting Group");
        //      Description := Res.Name;
        //      "Description 2" := Res."Name 2";
        //      "Unit of Measure Code" := Res."Base Unit of Measure";
        //      "Unit Cost (LCY)" := Res."Unit Cost";
        //      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
        //      "Tax Group Code" := Res."Tax Group Code";
        //      "Allow Item Charge Assignment" := FALSE;
        //      FindResUnitCost;
        //      InitDeferralCode;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      //*****************************************************
        //      ERROR(AFK_Text004);
        //      //*****************************************************
        //      Res.GET("No.");
        //      Res.TESTFIELD(Blocked,FALSE);
        //      Res.TESTFIELD("Gen. Prod. Posting Group");
        //      Description := Res.Name;
        //      "Description 2" := Res."Name 2";
        //      "Unit of Measure Code" := Res."Base Unit of Measure";
        //      "Unit Cost (LCY)" := Res."Unit Cost";
        //      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
        //      "Tax Group Code" := Res."Tax Group Code";
        //      "Allow Item Charge Assignment" := FALSE;
        //      FindResUnitCost;
        //      InitDeferralCode;
        //    END;
        //{=======} TARGET
        //    CopyFromResource;
        //{<<<<<<<}
        //  Type::"Fixed Asset":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      FA.GET("No.");
        //      FA.TESTFIELD(Inactive,FALSE);
        //      FA.TESTFIELD(Blocked,FALSE);
        //      GetFAPostingGroup;
        //      Description := FA.Description;
        //      "Description 2" := FA."Description 2";
        //      "Allow Invoice Disc." := FALSE;
        //      "Allow Item Charge Assignment" := FALSE;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      //*****************************************************
        //      IF "Document Type"=Rec."Document Type"::Order THEN ERROR(AFK_Text004);
        //      //*****************************************************
        //      FA.GET("No.");
        //      FA.TESTFIELD(Inactive,FALSE);
        //      FA.TESTFIELD(Blocked,FALSE);
        //      GetFAPostingGroup;
        //      Description := FA.Description;
        //      "Description 2" := FA."Description 2";
        //      "Allow Invoice Disc." := FALSE;
        //      "Allow Item Charge Assignment" := FALSE;
        //    END;
        //{=======} TARGET
        //    CopyFromFixedAsset;
        //{<<<<<<<}
        //  Type::"Charge (Item)":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      ItemCharge.GET("No.");
        //      Description := ItemCharge.Description;
        //      "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
        //      "Tax Group Code" := ItemCharge."Tax Group Code";
        //      "Allow Invoice Disc." := FALSE;
        //      "Allow Item Charge Assignment" := FALSE;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      //*****************************************************
        //      ERROR(AFK_Text004);
        //      //*****************************************************
        //      ItemCharge.GET("No.");
        //      Description := ItemCharge.Description;
        //      "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
        //      "Tax Group Code" := ItemCharge."Tax Group Code";
        //      "Allow Invoice Disc." := FALSE;
        //      "Allow Item Charge Assignment" := FALSE;
        //    END;
        //{=======} TARGET
        //    CopyFromItemCharge;
        //{<<<<<<<}
        //END;
        //
        //OnAfterAssignFieldsForNo(Rec,xRec,SalesHeader);
        //
        //IF HasTypeToFillMandatoryFields AND (Type <> Type::"Fixed Asset") THEN
        //  VALIDATE("VAT Prod. Posting Group");
        //
        //UpdatePrepmtSetupFields;
        //
        //IF HasTypeToFillMandatoryFields THEN BEGIN
        //  VALIDATE("Unit of Measure Code");
        //  IF Quantity <> 0 THEN BEGIN
        //    InitOutstanding;
        //    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        //      InitQtyToReceive
        //    ELSE
        //      InitQtyToShip;
        //    InitQtyToAsm;
        //    UpdateWithWarehouseShip;
        //  END;
        //  UpdateUnitPrice(FIELDNO("No."));
        //END;
        //
        //CreateDim(
        //  DimMgt.TypeToTableID3(Type),"No.",
        //  DATABASE::Job,"Job No.",
        //  DATABASE::"Responsibility Center","Responsibility Center");
        //
        //IF "No." <> xRec."No." THEN BEGIN
        //  IF Type = Type::Item THEN
        //    IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
        //      ReserveSalesLine.VerifyChange(Rec,xRec);
        //      WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
        //    END;
        //  GetDefaultBin;
        //  AutoAsmToOrder;
        //  DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
        //  IF Type = Type::"Charge (Item)" THEN
        //    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
        //END;
        //
        //UpdateItemCrossRef;
        //
        //PostingSetupMgt.CheckGenPostingSetupSalesAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        //PostingSetupMgt.CheckGenPostingSetupCOGSAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        //PostingSetupMgt.CheckVATPostingSetupSalesAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Location Code"(Field 7).OnValidate".

        //trigger (Variable: Loc)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 7).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestJobPlanningLine;
        TestStatusOpen;
        CheckAssocPurchOrder(FIELDCAPTION("Location Code"));
        #4..17
        END;

        GetSalesHeader;
        IsHandled := FALSE;
        OnValidateLocationCodeOnBeforeSetShipmentDate(Rec,IsHandled);
        IF NOT IsHandled THEN
        #24..26
              '',CalChange."Source Type"::"Shipping Agent","Shipping Agent Code","Shipping Agent Service Code",
              FALSE);

        CheckItemAvailable(FIELDNO("Location Code"));

        IF NOT "Drop Shipment" THEN BEGIN
        #33..62

        IF "Document Type" = "Document Type"::"Return Order" THEN
          ValidateReturnReasonCode(FIELDNO("Location Code"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..20

        //********************************************************
        //********************************************************
        //IF Loc.GET("Location Code") THEN Loc.TESTFIELD("Responsibility Center",SalesHeader."Responsibility Center");
        //Reserver les magasin spécifiques pour les commandes
        IF Loc.GET("Location Code") THEN
          IF Rec."Document Type"<>Rec."Document Type"::Order THEN
            IF Loc."Location Type"<>Loc."Location Type"::" " THEN
              ERROR(AFK_Text003);

        IF Loc.GET("Location Code") THEN BEGIN
          EnteteBL.RESET;
          EnteteBL.SETRANGE(EnteteBL.NavOrderNo,Rec."No.");
          EnteteBL.SETRANGE(EnteteBL.isconfirme,TRUE);
          IF EnteteBL.FINDFIRST THEN
            IF Loc."Location Type"<>Loc."Location Type"::Expedition THEN
              ERROR(AFK_Text005,EnteteBL.numBL);

          //IF SalesHeader."Document Type"=SalesHeader."Document Type"::Order THEN
          IF AfkItem.GET(Rec."No.") THEN
            AfkItem.TESTFIELD("Item Category Code",Loc."Item Category Code");
        END;

        //AFK_SecMgt.CheckWarehouseUser("Location Code");
        //********************************************************
        //********************************************************


        #21..29

        #30..65
        */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Field 15).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestJobPlanningLine;
        TestStatusOpen;

        #4..19
             ((ABS("Quantity (Base)") < ABS("Return Qty. Received (Base)")) AND ("Return Receipt No." = ''))
          THEN
            FIELDERROR("Quantity (Base)",STRSUBSTNO(Text003,FIELDCAPTION("Return Qty. Received (Base)")));
        END ELSE BEGIN
          IF (Quantity * "Quantity Shipped" < 0) OR
             ((ABS(Quantity) < ABS("Quantity Shipped")) AND ("Shipment No." = ''))
          THEN
        #27..89
        UpdatePlanned;
        IF "Document Type" = "Document Type"::"Return Order" THEN
          ValidateReturnReasonCode(FIELDNO(Quantity));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..22

        END ELSE BEGIN

          //*************************************************************start
          //*************************************************************
          IF "Document Type" = Rec."Document Type"::Order THEN BEGIN
            QtyInDispaching := DispachingMgt.GetQtyEnTourneeCde(Rec."Document No.",Rec."No.",Rec."Unit of Measure Code",
              Rec."Qty. per Unit of Measure");
            IF
              (ABS(Quantity) < ABS("Quantity Shipped")+QtyInDispaching) AND ("Shipment No." = '')
            THEN
              ERROR(AFK_Text006,ABS("Quantity Shipped"),QtyInDispaching);
          END;

          IF (("Document Type" = Rec."Document Type"::Invoice) AND (AFKSOMgt.IsCdeJIRAMA(SalesHeader))
            AND ("Shipment No."<>'') AND (xRec.Quantity<>0)) THEN BEGIN
              IF NOT AFK_SecMgt.CanUpdateSOAfterValidation THEN
                ERROR(AFK_Text007);
            END;
          //*************************************************************
          //*************************************************************end

        #24..92
        */
        //end;


        //Unsupported feature: Code Modification on ""Unit Price"(Field 22).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        VALIDATE("Line Discount %");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        VALIDATE("Line Discount %");

        //********************************************
        //********************************************
        IF SalesHeader."Quote No."<>'' THEN ERROR(AFK_Text001);
        //********************************************
        //********************************************
        */
        //end;
        field(50000; "Card Number"; Code[10])
        {
            Caption = 'Card Number';
        }
        field(50001; "Consignation Line No."; Integer)
        {
            Editable = false;
        }
        field(50002; "Qty to remove"; Decimal)
        {
            Caption = 'Qty to remove';
        }
        field(50003; "Qty to prepare"; Decimal)
        {
            Caption = 'Qty to prepare';
        }
        field(50010; "OMH Fees Price"; Decimal)
        {
        }
        field(50011; "FER Fees Price"; Decimal)
        {
        }
        field(50012; "ENV Fees Price"; Decimal)
        {
        }
        field(50013; "Sales Category Code"; Code[10])
        {
            Caption = 'Sales Category';
            TableRelation = "Sales Category";
        }
        field(50014; "RDS Fees Price"; Decimal)
        {
        }
        field(50023; "Shipment Group"; Option)
        {
            Caption = 'Shipment Group';
            OptionCaption = ' ,GO,SC,PL,FO';
            OptionMembers = " ",GO,SC,PL,FO;
        }
        field(50030; "Initial Qty"; Decimal)
        {
            Caption = 'Initial Qty';
            Editable = false;
        }
        field(50050; "Provision Qty"; Decimal)
        {
            Editable = false;
        }
        field(50051; "Provision Var Stock Qty"; Decimal)
        {
            Editable = false;
        }
        field(50070; "AMSA Source Type"; Option)
        {
            Caption = 'AMSA Source Type';
            Editable = false;
            OptionCaption = 'Station,Tanker';
            OptionMembers = Station,Tanker;
        }
        field(50071; IsAMSA; Boolean)
        {
            Editable = false;
        }
        field(50072; "AMSA Cost Code"; Code[20])
        {
            Editable = false;
        }
        field(50073; "AMSA BackCharge"; Option)
        {
            Caption = 'Backcharge';
            Editable = false;
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50074; "AMSA Equipment Type"; Option)
        {
            Caption = 'Equipment Type';
            Editable = false;
            OptionCaption = 'Mobile,Fixed';
            OptionMembers = Mobile,"Fixed";
        }
        field(50075; "AMSA Company Code"; Code[30])
        {
            Editable = false;
        }
        field(50076; "AMSA Process"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50077; "AMSA Invoice No."; Code[20])
        {
            Editable = false;
        }
        field(50078; "AMSA Order No."; Code[20])
        {
        }
        field(50079; "Real Location"; Code[10])
        {
        }
        field(50080; VAT20Amount; Decimal)
        {
        }
        field(50081; VAT15Amount; Decimal)
        {
        }
    }

    procedure GetParentCategory(): Code[20]
    var
        ItemCat: Record "Item Category";
    begin
        if (ItemCat.Get(Rec."Item Category Code")) then
            exit(ItemCat."Parent Category");
    end;

    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestStatusOpen;

    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
    #4..64
      DeferralUtilities.DeferralCodeOnDelete(
        DeferralUtilities.GetSalesDeferralDocType,'','',
        "Document Type","Document No.","Line No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..67


    //***************************************************
    //Prevent Deletion by CCL
    IF NOT AFKSOMgt.CanUpdateOrderLineAfterValidation(SalesHeader) THEN
      ERROR(AFK_Text008);
    //***************************************************
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: Cust2)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "InitQtyToShip(PROCEDURE 15)".

    //procedure InitQtyToShip();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetSalesSetup;
    IF (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) OR
       ("Document Type" = "Document Type"::Invoice)
    THEN BEGIN
      "Qty. to Ship" := "Outstanding Quantity";
      "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
    END ELSE
      IF "Qty. to Ship" <> 0 THEN
        "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
    #10..12
    OnAfterInitQtyToShip(Rec,CurrFieldNo);

    InitQtyToInvoice;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6

      //*******************************************************************
      //*******************************************************************
      Rec."Qty to prepare" := "Qty. to Ship";
      //*******************************************************************
      //*******************************************************************
    #7..15
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromGLAccount(PROCEDURE 142)".

    //procedure CopyFromGLAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GLAcc.GET("No.");
    GLAcc.CheckGLAcc;
    IF NOT "System-Created Entry" THEN
    #4..9
    "Allow Item Charge Assignment" := FALSE;
    InitDeferralCode;
    OnAfterAssignGLAccountValues(Rec,GLAcc);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //*****************************************************
    ERROR(AFK_Text004);
    //*****************************************************
    #1..12
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: Cust2) (VariableCollection) on "CopyFromItem(PROCEDURE 144)".


    //Unsupported feature: Variable Insertion (Variable: AfkLoc) (VariableCollection) on "CopyFromItem(PROCEDURE 144)".



    //Unsupported feature: Code Modification on "CopyFromItem(PROCEDURE 144)".

    //procedure CopyFromItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetItem(Item);
    OnBeforeCopyFromItem(Rec,Item);
    Item.TESTFIELD(Blocked,FALSE);
    #4..32
      Reserve := Item.Reserve;

    "Unit of Measure Code" := Item."Sales Unit of Measure";
    OnAfterCopyFromItem(Rec,Item);

    InitDeferralCode;
    SetDefaultItemQuantity;
    OnAfterAssignItemValues(Rec,Item);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..35

      //***********************************************************
      //***********************************************************

      Cust2.GET(SalesHeader."Sell-to Customer No.");
      Cust2.TESTFIELD(Cust2."Sales Category Code");

      AFK_AddOnSetup.GET;
      IF Item.Type = Item.Type::Inventory THEN BEGIN
        IF NOT AFK_SecMgt.CanAddItemOnSalesInv THEN BEGIN
          IF ((SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::"Credit Memo"]) AND
                (SalesHeader."Created By Doc Type"<>SalesHeader."Created By Doc Type"::Consignation)) THEN
            IF Cust2."Sales Channel Code"<> AFK_AddOnSetup."AMSA Sales Channel" THEN
              ERROR(AFK_Text002);
        END;
      END;

      IF SalesHeader."Document Type"=SalesHeader."Document Type"::Order THEN
        Item.TESTFIELD("Sales Category Code",Cust2."Sales Category Code");


      IF AfkLoc.GET(Rec."Location Code") THEN
        Item.TESTFIELD("Item Category Code",AfkLoc."Item Category Code");

      "FER Fees Price" := Item."FER Fees Price";
      "OMH Fees Price" := Item."OMH Fees Price";
      "ENV Fees Price" := Item."ENV Fees Price";
      "RDS Fees Price" := Item."RDS Fees Price";

      "Shipment Group" := Item."Shipment Group";

      //***********************************************************
      //***********************************************************

    #36..40
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: AFKItem1) (VariableCollection) on "CalcVATAmountLines(PROCEDURE 35)".



    //Unsupported feature: Code Modification on "CalcVATAmountLines(PROCEDURE 35)".

    //procedure CalcVATAmountLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF IsCalcVATAmountLinesHandled(SalesHeader,SalesLine,VATAmountLine) THEN
      EXIT;

    #4..9
      SETRANGE("Document No.",SalesHeader."No.");
      IF FINDSET THEN
        REPEAT
          IF NOT ZeroAmountLine(QtyType) THEN BEGIN
            IF (Type = Type::"G/L Account") AND NOT "Prepayment Line" THEN
              RoundingLineInserted := ("No." = GetCPGInvRoundAcc(SalesHeader)) OR RoundingLineInserted;
            IF "VAT Calculation Type" IN
    #17..100
      END;

    OnAfterCalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,QtyType);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12


         IF NOT ZeroAmountLine(QtyType) THEN BEGIN
    #14..103
    */
    //end;

    // local procedure AFK_InitRemiseLUBS()
    // var
    //     SalesLine1: Record "Sales Line";
    //     Item1: Record "Item";
    //     Item2: Record "Item";
    // begin
    //     IF SalesHeader.GET("Document Type", "Document No.") THEN;
    //     MESSAGE('%1 %2', Rec."Document No.", Rec."Line No.");
    //     IF AFKSOMgt.IsCdeLUBS(SalesHeader) THEN BEGIN
    //         SalesLine1.RESET;
    //         SalesLine1.SETRANGE(SalesLine1."Document Type", SalesLine1."Document Type"::Order);
    //         SalesLine1.SETRANGE(SalesLine1."Document No.", Rec."Document No.");
    //         SalesLine1.SETFILTER(SalesLine1."Line No.", '<%1', Rec."Line No.");
    //         IF SalesLine1.FINDLAST THEN
    //             IF SalesLine1.Type = SalesLine1.Type::Item THEN
    //                 IF Item1.GET(SalesLine1."No.") THEN
    //                     IF Item1.Type = Item1.Type::Inventory THEN BEGIN
    //                         IF Rec.Quantity = 0 THEN
    //                             Rec.VALIDATE(Rec.Quantity, SalesLine1.Amount);
    //                     END;
    //     END;
    // end;
    //TODO Migration
    // procedure AFK_SetCanSetExpLocation(CanSet: Boolean)
    // begin
    //     CanSetExpLocation := CanSet;
    // end;

    // var
    //     Cust2: Record "18";
    //     Item3: Record "27";
    //     AfkLoc: Record "14";

    // var
    //     Loc: Record "14";
    //     EnteteBL: Record "50005";
    //     AfkItem: Record "27";

    // var
    //     QtyInDispaching: Decimal;

    // var
    //     Cust2: Record "18";

    var
    // AFK_Text001: Label 'You cannot set the unit price because this order is from a validated Quote';
    // AFK_SecMgt: Codeunit "50016";
    // AFK_AddOnSetup: Record "AddOn Setup";
    // AFK_Text002: Label 'Impossible de facturer directement des articles, vous devez passer par une commande';
    // AFKSOMgt: Codeunit "50001";
    // AFK_Text003: Label 'Le magasin de ce type ne doit pas être utilisé sur ce document !';
    // CanSetExpLocation: Boolean;
    // AFK_Text004: Label 'Le type doit être "Article"';
    // AFK_Text005: Label 'Le numéro BL %1 a été confirmé pour cette commande, le code magasin ne doit plus être modifié.';
    // DispachingMgt: Codeunit "50000";
    // AFK_Text006: Label 'Vous ne pouvez pas rentrer cette quantité. \La quantité déjà livrée est %1. \La quantité en cours de livraison (Dispaching) est %2';
    // AFK_Text007: Label 'Impossible de mettre à jour cette quantité lors de la facturation JIRAMA car la ligne provient d''une expédition enregistrée.';
    // AFK_Text008: Label 'Vous n''etes pas autorisé à supprimer cette ligne.';
    // AfkReleaseSales: Codeunit "414";

    procedure IsServiceItem(): Boolean
    var
        Item: record Item;
    begin
        IF Type <> Type::Item THEN
            EXIT(FALSE);
        IF "No." = '' THEN
            EXIT(FALSE);
        Item.Get("No.");
        EXIT(Item.Type = Item.Type::Service);
    end;
}

