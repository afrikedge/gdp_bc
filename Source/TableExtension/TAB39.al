tableextension 50014 "A01 Purchase Line" extends "Purchase Line"
{
    // 121017  MFiles Interface Mgt
    fields
    {
        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Item Category Code" = FIELD("Item Category Code"));
        }

        //Unsupported feature: Property Insertion (Editable) on ""Line Amount"(Field 103)".



        //Unsupported feature: Code Modification on "Type(Field 5).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetPurchHeader;
        TestStatusOpen;

        TESTFIELD("Qty. Rcd. Not Invoiced",0);
        TESTFIELD("Quantity Received",0);
        #6..58
          "Allow Item Charge Assignment" := TRUE
        ELSE
          "Allow Item Charge Assignment" := FALSE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        GetPurchHeader;
        TestStatusOpen;
        //121017******
        AFK_TestMFilesInvoice;
        #3..61
        */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 6).OnValidate".

        //trigger "(Field 6)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetPurchSetup;
        IF PurchSetup."Create Item from Item No." THEN
          "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

        TestStatusOpen;
        TESTFIELD("Qty. Rcd. Not Invoiced",0);
        TESTFIELD("Quantity Received",0);
        TESTFIELD("Receipt No.",'');
        #9..130

        PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*


        #1..5
        //121017**************
        AFK_TestMFilesInvoice;
        //********************
        #6..133

        //The code has been merged but contained errors that could prevent import
        //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
        //GetPurchSetup;
        //IF PurchSetup."Create Item from Item No." THEN
        //  "No." := FindRecordMgt.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");
        //
        //TestStatusOpen;
        //TESTFIELD("Qty. Rcd. Not Invoiced",0);
        //TESTFIELD("Quantity Received",0);
        //TESTFIELD("Receipt No.",'');
        ////121017******
        //AFK_TestMFilesInvoice;
        //
        //TESTFIELD("Prepmt. Amt. Inv.",0);
        //
        //TestReturnFieldsZero;
        //
        //IF "Drop Shipment" THEN
        //  ERROR(
        //    Text001,
        //    FIELDCAPTION("No."),"Sales Order No.");
        //
        //IF "Special Order" THEN
        //  ERROR(
        //    Text001,
        //    FIELDCAPTION("No."),"Special Order Sales No.");
        //
        //IF "Prod. Order No." <> '' THEN
        //  ERROR(
        //    Text044,
        //    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");
        //
        //OnValidateNoOnAfterChecks(Rec,xRec,CurrFieldNo);
        //
        //IF "No." <> xRec."No." THEN BEGIN
        //  IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
        //    ReservePurchLine.VerifyChange(Rec,xRec);
        //    CALCFIELDS("Reserved Qty. (Base)");
        //    TESTFIELD("Reserved Qty. (Base)",0);
        //    IF Type = Type::Item THEN
        //      WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
        //    OnValidateNoOnAfterVerifyChange(Rec,xRec);
        //  END;
        //  IF Type = Type::Item THEN
        //    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
        //  IF Type = Type::"Charge (Item)" THEN
        //    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
        //END;
        //
        //OnValidateNoOnBeforeInitRec(Rec,xRec,CurrFieldNo);
        //TempPurchLine := Rec;
        //INIT;
        //IF xRec."Line Amount" <> 0 THEN
        //  "Recalculate Invoice Disc." := TRUE;
        //Type := TempPurchLine.Type;
        //"No." := TempPurchLine."No.";
        //OnValidateNoOnCopyFromTempPurchLine(Rec,TempPurchLine);
        //IF "No." = '' THEN
        //  EXIT;
        //
        //IF HasTypeToFillMandatoryFields THEN BEGIN
        //  Quantity := TempPurchLine.Quantity;
        //  "Outstanding Qty. (Base)" := TempPurchLine."Outstanding Qty. (Base)";
        //END;
        //
        //"System-Created Entry" := TempPurchLine."System-Created Entry";
        //GetPurchHeader;
        //InitHeaderDefaults(PurchHeader);
        //UpdateLeadTimeFields;
        //UpdateDates;
        //
        //OnAfterAssignHeaderValues(Rec,PurchHeader);
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
        //      //***********************************************************
        //      IF "Document Type" = Rec."Document Type"::Order THEN BEGIN
        //        UserSetupCheck.GET(USERID);
        //        IF NOT UserSetupCheck."GLAccount on Purchase Order" THEN ERROR(AFK_Text0002);
        //      END;
        //
        //      IF NOT "System-Created Entry" THEN
        //        GLAcc.TESTFIELD(GLAcc."Purchased Account",TRUE);
        //      //***********************************************************
        //    END;
        //{=======} TARGET
        //    CopyFromGLAccount;
        //{<<<<<<<}
        //  Type::Item:
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      GetItem;
        //      GetGLSetup;
        //      Item.TESTFIELD(Blocked,FALSE);
        //      Item.TESTFIELD("Gen. Prod. Posting Group");
        //      IF Item.Type = Item.Type::Inventory THEN BEGIN
        //        Item.TESTFIELD("Inventory Posting Group");
        //        "Posting Group" := Item."Inventory Posting Group";
        //      END;
        //      Description := Item.Description;
        //      "Description 2" := Item."Description 2";
        //      "Unit Price (LCY)" := Item."Unit Price";
        //      "Units per Parcel" := Item."Units per Parcel";
        //      "Indirect Cost %" := Item."Indirect Cost %";
        //      "Overhead Rate" := Item."Overhead Rate";
        //      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
        //      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
        //      "Tax Group Code" := Item."Tax Group Code";
        //      Nonstock := Item."Created From Nonstock Item";
        //      "Item Category Code" := Item."Item Category Code";
        //      "Product Group Code" := Item."Product Group Code";
        //      "Allow Item Charge Assignment" := TRUE;
        //      PrepmtMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");
        //
        //      IF Item."Price Includes VAT" THEN BEGIN
        //        IF NOT VATPostingSetup.GET(
        //             Item."VAT Bus. Posting Gr. (Price)",Item."VAT Prod. Posting Group")
        //        THEN
        //          VATPostingSetup.INIT;
        //        CASE VATPostingSetup."VAT Calculation Type" OF
        //          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
        //            VATPostingSetup."VAT %" := 0;
        //          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
        //            ERROR(
        //              Text002,
        //              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
        //              VATPostingSetup."VAT Calculation Type");
        //        END;
        //        "Unit Price (LCY)" :=
        //          ROUND("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
        //            GLSetup."Unit-Amount Rounding Precision");
        //      END;
        //
        //      IF PurchHeader."Language Code" <> '' THEN
        //        GetItemTranslation;
        //
        //      "Unit of Measure Code" := Item."Purch. Unit of Measure";
        //      InitDeferralCode;
        //    END;
        //  Type::"3":
        //{=======} MODIFIED
        //    BEGIN
        //      GetItem;
        //      GetGLSetup;
        //      Item.TESTFIELD(Blocked,FALSE);
        //      //*******************************
        //      Item.TESTFIELD(Item."Validation Status",Item."Validation Status"::Validated);
        //      //*******************************
        //      Item.TESTFIELD("Gen. Prod. Posting Group");
        //      IF Item.Type = Item.Type::Inventory THEN BEGIN
        //        Item.TESTFIELD("Inventory Posting Group");
        //        "Posting Group" := Item."Inventory Posting Group";
        //      END;
        //      Description := Item.Description;
        //      "Description 2" := Item."Description 2";
        //      "Unit Price (LCY)" := Item."Unit Price";
        //      "Units per Parcel" := Item."Units per Parcel";
        //      "Indirect Cost %" := Item."Indirect Cost %";
        //      "Overhead Rate" := Item."Overhead Rate";
        //      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
        //      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        //      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
        //      "Tax Group Code" := Item."Tax Group Code";
        //      Nonstock := Item."Created From Nonstock Item";
        //      "Item Category Code" := Item."Item Category Code";
        //      "Product Group Code" := Item."Product Group Code";
        //      "Allow Item Charge Assignment" := TRUE;
        //      PrepmtMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");
        //
        //      IF Item."Price Includes VAT" THEN BEGIN
        //        IF NOT VATPostingSetup.GET(
        //             Item."VAT Bus. Posting Gr. (Price)",Item."VAT Prod. Posting Group")
        //        THEN
        //          VATPostingSetup.INIT;
        //        CASE VATPostingSetup."VAT Calculation Type" OF
        //          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
        //            VATPostingSetup."VAT %" := 0;
        //          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
        //            ERROR(
        //              Text002,
        //              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
        //              VATPostingSetup."VAT Calculation Type");
        //        END;
        //        "Unit Price (LCY)" :=
        //          ROUND("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
        //            GLSetup."Unit-Amount Rounding Precision");
        //      END;
        //
        //      IF PurchHeader."Language Code" <> '' THEN
        //        GetItemTranslation;
        //
        //      "Unit of Measure Code" := Item."Purch. Unit of Measure";
        //      InitDeferralCode;
        //    END;
        //  Type::"3":
        //{=======} TARGET
        //    CopyFromItem;
        //  3:
        //{<<<<<<<}
        //    ERROR(Text003);
        //  Type::"Fixed Asset":
        //    CopyFromFixedAsset;
        //  Type::"Charge (Item)":
        //    CopyFromItemCharge;
        //END;
        //
        //OnAfterAssignFieldsForNo(Rec,xRec,PurchHeader);
        //
        //IF HasTypeToFillMandatoryFields AND NOT (Type = Type::"Fixed Asset") THEN
        //  VALIDATE("VAT Prod. Posting Group");
        //
        //UpdatePrepmtSetupFields;
        //
        //IF HasTypeToFillMandatoryFields THEN BEGIN
        //  Quantity := xRec.Quantity;
        //  OnValidateNoOnAfterAssignQtyFromXRec(Rec,TempPurchLine);
        //  VALIDATE("Unit of Measure Code");
        //  IF Quantity <> 0 THEN BEGIN
        //    InitOutstanding;
        //    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
        //      InitQtyToShip
        //    ELSE
        //      InitQtyToReceive;
        //  END;
        //  UpdateWithWarehouseReceive;
        //  UpdateDirectUnitCost(FIELDNO("No."));
        //  IF xRec."Job No." <> '' THEN
        //    VALIDATE("Job No.",xRec."Job No.");
        //  "Job Line Type" := xRec."Job Line Type";
        //  IF xRec."Job Task No." <> '' THEN BEGIN
        //    VALIDATE("Job Task No.",xRec."Job Task No.");
        //    IF "No." = xRec."No." THEN
        //      VALIDATE("Job Planning Line No.",xRec."Job Planning Line No.");
        //  END;
        //END;
        //
        //CreateDim(
        //  DimMgt.TypeToTableID3(Type),"No.",
        //  DATABASE::Job,"Job No.",
        //  DATABASE::"Responsibility Center","Responsibility Center",
        //  DATABASE::"Work Center","Work Center No.");
        //
        //PurchHeader.GET("Document Type","Document No.");
        //UpdateItemReference;
        //
        //GetDefaultBin;
        //
        //IF JobTaskIsSet THEN BEGIN
        //  CreateTempJobJnlLine(TRUE);
        //  UpdateJobPrices;
        //{>>>>>>>} ORIGINAL
        //END
        //{=======} MODIFIED
        //END;
        //
        //
        //
        //
        ////*************************************************
        ////Budget Mgt***************************************
        //"Purchase Account":=BudgetMgt.GetPurchAcc(Rec);
        ////*************************************************Jn0001
        //{=======} TARGET
        //  UpdateDimensionsFromJobTask;
        //END;
        //
        //PostingSetupMgt.CheckGenPostingSetupPurchAccount("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
        //PostingSetupMgt.CheckVATPostingSetupPurchAccount("VAT Bus. Posting Group","VAT Prod. Posting Group");
        //{<<<<<<<}
        */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Field 15).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        IsHandled := FALSE;
        OnValidateQuantityOnBeforeDropShptCheck(Rec,xRec,CurrFieldNo,IsHandled);
        IF NOT IsHandled THEN
          IF "Drop Shipment" AND ("Document Type" <> "Document Type"::Invoice) THEN
            ERROR(
              Text001,FIELDCAPTION(Quantity),"Sales Order No.");
        "Quantity (Base)" := CalcBaseQty(Quantity);
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          IF (Quantity * "Return Qty. Shipped" < 0) OR
        #11..85
        END;

        CheckWMS;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        TestStatusOpen;

        //121017******
        AFK_TestMFilesInvoice;
        //************

        #2..7

        #8..88
        */
        //end;


        //Unsupported feature: Code Modification on ""Line Discount %"(Field 27).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateLineDiscountPercent(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //121017******
        AFK_TestMFilesInvoice;
        //************

        ValidateLineDiscountPercent(TRUE);
        */
        //end;


        //Unsupported feature: Code Modification on ""Line Discount Amount"(Field 28).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetPurchHeader;
        "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
        TestStatusOpen;
        #4..7
        "Inv. Disc. Amount to Invoice" := 0;
        UpdateAmounts;
        UpdateUnitCost;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..10

        //121017******
        AFK_TestMFilesInvoice;
        //************
        */
        //end;
        field(50010; "Purchase Account"; Code[20])
        {
            Caption = 'Charge Account';
            Editable = false;
        }
        field(50015; "Purch Req Line No."; Integer)
        {
        }
        field(50016; "Purch Req No."; Code[20])
        {
        }
        field(50024; Disponibility; Option)
        {
            Caption = 'Disponibility';
            OptionCaption = 'Available,Non available';
            OptionMembers = Dispo,Indisponible;
        }
        field(50025; "Starting Warranty"; Option)
        {
            Caption = 'Starting Garanty';
            OptionCaption = 'On receipt, On starting,No Warranty';
            OptionMembers = Receipt,Starting,"No Warranty";
        }
        field(50026; "Warranty (Months)"; Integer)
        {
            Caption = 'Warranty (Months)';
        }
        field(50027; Insurance; Boolean)
        {
            Caption = 'Insurance';
        }
        field(50028; "Disponibility 2"; Text[30])
        {
            Caption = 'Disponibility';
        }
        field(50029; "Provision Var Stock Qty"; Decimal)
        {
        }
        field(50030; "Batch Number"; Code[100])
        {
            Caption = 'Batch Number';
        }
        field(50031; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50050; "Provision Qty"; Decimal)
        {
            Editable = false;
        }
        field(50051; "Partially Received"; Boolean)
        {
            Caption = 'Partially Received';
            Editable = false;
        }
        field(60000; "MFiles ID"; BigInteger)
        {
        }
    }
    keys
    {
        // key(A01Key1; "Purchase Account", "Shortcut Dimension 1 Code")
        // {
        // }
        key(Key2; "Purch Req No.", "Purch Req Line No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TestStatusOpen;
    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
      ReservePurchLine.DeleteLine(Rec);
    #4..10
      WhseValidateSourceLine.PurchaseLineDelete(Rec);
    END;

    IF ("Document Type" = "Document Type"::Order) AND (Quantity <> "Quantity Invoiced") THEN
      TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

    IF "Sales Order Line No." <> 0 THEN BEGIN
      LOCKTABLE;
    #19..76
      DeferralUtilities.DeferralCodeOnDelete(
        DeferralUtilities.GetPurchDeferralDocType,'','',
        "Document Type","Document No.","Line No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..13
    IF NOT AFK_IsSolderCommande THEN//*****************************************************************
      IF ("Document Type" = "Document Type"::Order) AND (Quantity <> "Quantity Invoiced") THEN
        TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");
    #16..79
    */
    //end;


    //Unsupported feature: Code Modification on "InitOutstanding(PROCEDURE 16)".

    //procedure InitOutstanding();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
      "Outstanding Quantity" := Quantity - "Return Qty. Shipped";
      "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Shipped (Base)";
    #4..11

    OnAfterInitOutstandingQty(Rec);
    "Completely Received" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
    InitOutstandingAmount;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    //JN241117**************************
    //**********************************
    "Partially Received" := (Quantity <> 0) AND ("Outstanding Quantity" <> 0) AND ("Quantity Received" <> 0);
    //**********************************
    //**********************************
    InitOutstandingAmount;
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: UserSetupCheck) (VariableCollection) on "CopyFromGLAccount(PROCEDURE 96)".



    //Unsupported feature: Code Modification on "CopyFromGLAccount(PROCEDURE 96)".

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

    #1..12

    //***********************************************************
    IF "Document Type" = Rec."Document Type"::Order THEN BEGIN
      UserSetupCheck.GET(USERID);
      IF NOT UserSetupCheck."GLAccount on Purchase Order" THEN ERROR(AFK_Text0002);
    END;

    IF NOT "System-Created Entry" THEN
      GLAcc.TESTFIELD(GLAcc."Purchased Account",TRUE);
    //***********************************************************
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromItem(PROCEDURE 100)".

    //procedure CopyFromItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetItem(Item);
    GetGLSetup;
    OnBeforeCopyFromItem(Rec,Item);
    Item.TESTFIELD(Blocked,FALSE);
    Item.TESTFIELD("Gen. Prod. Posting Group");
    #6..48
    "Unit of Measure Code" := Item."Purch. Unit of Measure";
    InitDeferralCode;
    OnAfterAssignItemValues(Rec,Item);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    GetItem(Item);
    GetGLSetup;

    //*******************************
    Item.TESTFIELD(Item."Validation Status",Item."Validation Status"::Validated);
    //*******************************

    #3..51
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateAmounts(PROCEDURE 3)".

    //procedure UpdateAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Type = Type::" " THEN
      EXIT;
    GetPurchHeader;
    #4..15
      LineAmountChanged := TRUE;
    END;

    IF NOT "Prepayment Line" THEN BEGIN
      IF "Prepayment %" <> 0 THEN BEGIN
        IF Quantity < 0 THEN
    #22..47
          FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
        END;
    END;

    OnAfterUpdateAmounts(Rec,xRec,CurrFieldNo);

    #54..67
    CalcPrepaymentToDeduct;

    OnAfterUpdateAmountsDone(Rec,xRec,CurrFieldNo);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..18
    IF NOT AFK_IsSolderCommande THEN BEGIN //**************************************************************
    #19..50
    END;//*****************************************************************************************

    #51..70
    //The code has been merged but contained errors that could prevent import
    //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
    //IF Type = Type::" " THEN
    //  EXIT;
    //GetPurchHeader;
    //
    //VATBaseAmount := "VAT Base Amount";
    //"Recalculate Invoice Disc." := TRUE;
    //
    //IF "Line Amount" <> xRec."Line Amount" THEN BEGIN
    //  "VAT Difference" := 0;
    //  LineAmountChanged := TRUE;
    //END;
    //IF "Line Amount" <> ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
    //  "Line Amount" :=
    //    ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount";
    //  "VAT Difference" := 0;
    //  LineAmountChanged := TRUE;
    //END;
    //
    //IF NOT AFK_IsSolderCommande THEN BEGIN //**************************************************************
    //  IF NOT "Prepayment Line" THEN BEGIN
    //    IF "Prepayment %" <> 0 THEN BEGIN
    //      IF Quantity < 0 THEN
    //        FIELDERROR(Quantity,STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
    //      IF "Direct Unit Cost" < 0 THEN
    //        FIELDERROR("Direct Unit Cost",STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
    //    END;
    //    IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
    //      "Prepayment VAT Difference" := 0;
    //      IF NOT PrePaymentLineAmountEntered THEN
    //        "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
    //      IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
    //        FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text037,"Prepmt. Amt. Inv."));
    //      PrePaymentLineAmountEntered := FALSE;
    //      IF "Prepmt. Line Amount" <> 0 THEN BEGIN
    //        RemLineAmountToInvoice :=
    //          ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
    //        IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
    //          FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
    //      END;
    //    END ELSE
    //      IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
    //         ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
    //      THEN BEGIN
    //        IF "Line Amount" < xRec."Line Amount" THEN
    //          FIELDERROR("Line Amount",STRSUBSTNO(Text038,xRec."Line Amount"));
    //        FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
    //      END;
    //  END;
    //{>>>>>>>} ORIGINAL
    //  IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
    //    "Prepayment VAT Difference" := 0;
    //    IF NOT PrePaymentLineAmountEntered THEN
    //      "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
    //    IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
    //      FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text037,"Prepmt. Amt. Inv."));
    //    PrePaymentLineAmountEntered := FALSE;
    //    IF "Prepmt. Line Amount" <> 0 THEN BEGIN
    //      RemLineAmountToInvoice :=
    //        ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
    //      IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
    //        FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
    //    END;
    //  END ELSE
    //    IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
    //       ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
    //    THEN BEGIN
    //      IF "Line Amount" < xRec."Line Amount" THEN
    //        FIELDERROR("Line Amount",STRSUBSTNO(Text038,xRec."Line Amount"));
    //      FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
    //    END;
    //END;
    //{=======} MODIFIED
    //END;//*****************************************************************************************
    //
    //{=======} TARGET
    //  IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
    //    "Prepayment VAT Difference" := 0;
    //    IF NOT PrePaymentLineAmountEntered THEN
    //      "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
    //    IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN BEGIN
    //      IF IsServiceCharge THEN
    //        ERROR(CannotChangePrepaidServiceChargeErr);
    //      FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text037,"Prepmt. Amt. Inv."));
    //    END;
    //    PrePaymentLineAmountEntered := FALSE;
    //    IF "Prepmt. Line Amount" <> 0 THEN BEGIN
    //      RemLineAmountToInvoice :=
    //        ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
    //      IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
    //        FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
    //    END;
    //  END ELSE
    //    IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
    //       ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
    //    THEN BEGIN
    //      IF "Line Amount" < xRec."Line Amount" THEN
    //        FIELDERROR("Line Amount",STRSUBSTNO(Text038,xRec."Line Amount"));
    //      FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
    //    END;
    //END;
    //
    //OnAfterUpdateAmounts(Rec,xRec,CurrFieldNo);
    //
    //{<<<<<<<}
    //UpdateVATAmounts;
    //IF VATBaseAmount <> "VAT Base Amount" THEN
    //  LineAmountChanged := TRUE;
    //
    //IF LineAmountChanged THEN BEGIN
    //  UpdateDeferralAmounts;
    //  LineAmountChanged := FALSE;
    //END;
    //
    //InitOutstandingAmount;
    //
    //IF Type = Type::"Charge (Item)" THEN
    //  UpdateItemChargeAssgnt;
    //
    //CalcPrepaymentToDeduct;
    //
    //OnAfterUpdateAmountsDone(Rec,xRec,CurrFieldNo);
    */
    //end;

    local procedure AFK_TestMFilesInvoice()
    var
        PurchHeader: Record "Purchase Header";
    begin
        //121017
        AddOnSetup.GET();
        IF NOT AddOnSetup."MFiles Mgt" THEN EXIT;

        PurchHeader.Get(Rec."Document Type", Rec."Document No.");

        GetPurchHeader();
        IF NOT "System-Created Entry" THEN
            IF Type <> Type::" " THEN
                IF PurchHeader."MFiles Invoice" THEN
                    ERROR(AFK_Text0001);
    end;

    procedure AFK_SetIsSolderCommande(val: Boolean)
    begin
        AFK_IsSolderCommande := val;
    end;

    var
        UserSetupCheck: Record "User Setup";

    var
        //BudgetMgt: Codeunit "50020";
        AFK_Text0001: Label 'Cette facture ne peut pas être modifiée car elle provient d''un document MFiles';
        AddOnSetup: Record "AddOn Setup";
        AFK_IsSolderCommande: Boolean;
        AFK_Text0002: Label 'Vous n''êtes pas autorisé à utilisé un compte général sur les commandes';
}

