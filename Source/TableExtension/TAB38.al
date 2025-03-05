tableextension 50013 "A02 Purchase Header" extends "Purchase Header"
{
    // //Archiver si suppression manuelle (Cas de commande facturées a partir de la création d'une facture directe)
    // 121017  MFiles Interface Mgt
    fields
    {

        //Unsupported feature: Property Insertion (Editable) on ""Due Date"(Field 24)".

        modify("Vendor Order No.")
        {
            Caption = 'Vendor Order No.';
        }

        //Unsupported feature: Property Insertion (Editable) on ""VAT Bus. Posting Group"(Field 116)".


        //Unsupported feature: Property Insertion (Editable) on ""Prepmt. Payment Terms Code"(Field 143)".

        modify("Assigned User ID")
        {
            Caption = 'Assigned User ID';
        }


        //Unsupported feature: Code Modification on ""Buy-from Vendor No."(Field 2).OnValidate".

        //trigger "(Field 2)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." = '' THEN
          InitRecord;
        TestStatusOpen;
        IF ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND
           (xRec."Buy-from Vendor No." <> '')
        THEN BEGIN
        #7..44
        ValidateEmptySellToCustomerAndLocation;
        OnAfterCopyBuyFromVendorFieldsFromVendor(Rec,Vend,xRec);

        IF "Buy-from Vendor No." = xRec."Pay-to Vendor No." THEN
          IF ReceivedPurchLinesExist OR ReturnShipmentExist THEN BEGIN
            TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
        #51..86
        IF NOT SkipBuyFromContact THEN
          UpdateBuyFromCont("Buy-from Vendor No.");

        IF "No." <> '' THEN
          StandardCodesMgt.CheckShowPurchRecurringLinesNotification(Rec);

        IF (xRec."Buy-from Vendor No." <> '') AND (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") THEN
          RecallModifyAddressNotification(GetModifyVendorAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        #1..3

        //******************121017
        AFK_TestMFilesInvoice;
        //************************

        #4..47
        //***********************************************************************
        "Vendor Retention Posting Group" := Vend."Vendor Retention Posting Group";
        IF Vend.Statut=Vend.Statut::BlackListe THEN
          ERROR(TextErr01);
        //***********************************************************************

        #48..89
        //********************************************************
        //JN001 Remplir les lignes de la SR le cas echéant
        //********************************************************
        ServRequisitionMgt.CreateLinesOffer(Rec);
        //********************************************************

        #90..94
        */
        //end;


        //Unsupported feature: Code Modification on ""Pay-to Vendor No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        IF (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") AND
           (xRec."Pay-to Vendor No." <> '')
        THEN BEGIN
          IF GetHideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
          ELSE
            Confirmed := CONFIRM(ConfirmChangeQst,FALSE,PayToVendorTxt);
          IF Confirmed THEN BEGIN
            PurchLine.SETRANGE("Document Type","Document Type");
            PurchLine.SETRANGE("Document No.","No.");
        #12..23
        Vend.TESTFIELD("Vendor Posting Group");
        PostingSetupMgt.CheckVendPostingGroupPayablesAccount("Vendor Posting Group");

        "Pay-to Name" := Vend.Name;
        "Pay-to Name 2" := Vend."Name 2";
        CopyPayToVendorAddressFieldsFromVendor(Vend,FALSE);
        IF NOT SkipPayToContact THEN
          "Pay-to Contact" := Vend.Contact;
        "Payment Terms Code" := Vend."Payment Terms Code";
        "Prepmt. Payment Terms Code" := Vend."Payment Terms Code";

        IF IsCreditDocType THEN BEGIN
          "Payment Method Code" := '';
        #37..90

        IF (xRec."Pay-to Vendor No." <> '') AND (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") THEN
          RecallModifyAddressNotification(GetModifyPayToVendorAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*


        //******************121017
        AFK_TestMFilesInvoice;
        //************************
        TestStatusOpen;

        #2..4

          Confirmed := TRUE;//ADDED***************************************************
          //Confirmed := CONFIRM(ConfirmChangeQst,FALSE,PayToVendorTxt);**************

        #9..26
        //******************
        Vend.TESTFIELD(Vend."Validation Status",Vend."Validation Status"::Validated);
        //******************

        #27..32

        //"Prepmt. Payment Terms Code" := Vend."Payment Terms Code"; //Removed
        //Afk**********Start
        AFK_Setup.GET;
        IF(AFK_Setup."Def Prepmt. Payment Terms Code" <> '') THEN
          "Prepmt. Payment Terms Code" := AFK_Setup."Def Prepmt. Payment Terms Code"
        ELSE
          "Prepmt. Payment Terms Code" := Vend."Payment Terms Code";
        //Afk**********End
        #34..93
        */
        //end;


        //Unsupported feature: Code Modification on ""Payment Terms Code"(Field 23).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
          PaymentTerms.GET("Payment Terms Code");
          IF IsCreditDocType AND NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
        #4..16
            VALIDATE("Payment Discount %",0);
          END;
        END;
        IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
          VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..19
        //Afk**********Start
        //IF xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" THEN
        //  VALIDATE("Prepmt. Payment Terms Code","Payment Terms Code");
        //Afk**********End
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Location Code"(Field 28).OnValidate".

        //trigger (Variable: Loc)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Vendor Invoice No."(Field 68).OnValidate".

        //trigger "(Field 68)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Vendor Invoice No." <> '' THEN
          IF FindPostedDocumentWithSameExternalDocNo(VendorLedgerEntry,"Vendor Invoice No.") THEN
            ShowExternalDocAlreadyExistNotification(VendorLedgerEntry)
          ELSE
            RecallExternalDocAlreadyExistsNotification;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //******************121017
        AFK_TestMFilesInvoice;
        //************************
        #1..5
        */
        //end;
        field(50001; "Created By Doc No."; Code[20])
        {
            Caption = 'Created By Doc No.';
            Editable = false;
        }
        field(50002; "Created By Doc Type"; Option)
        {
            Caption = 'Created By Doc Type';
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation,ProvisionsFA';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation,ProvisionsFA;
        }
        field(50010; DelaiDeLivraison; Text[50])
        {
            Caption = 'Delivery Terms';
        }
        field(50020; "Code Demande"; Code[20])
        {
            Caption = 'Purchase Requiqition Code';
            Editable = false;
        }
        field(50021; "Code Budget"; Code[10])
        {
            Editable = false;
            TableRelation = "G/L Budget Name";
        }
        field(50022; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            Editable = false;
            ExtendedDatatype = Masked;
            OptionCaption = 'Purchase of goods,Others purchases';
            OptionMembers = AchatMarchandise,AchatAutre;
        }
        field(50023; "Validity Offer"; Text[30])
        {
            Caption = 'Validity of Offer';
        }
        field(50024; "PR Type"; Option)
        {
            Caption = 'Purch Req Type';
            OptionCaption = ' ,DOP Travaux,DOP Maintenance,DOP Supply,DOP Logistique,HSE,DCM,IT,SGX,SGX Service,RH,DG,Reseau,Energie,Travaux&Maintenance,Comptabilite,Agence,B2B,DSP,CAP,RSE';
            OptionMembers = " ","DOP Travaux","DOP Maintenance","DOP Supply","DOP Logistique",HSE,DCM,IT,SGX,"SGX Service",RH,DG,Reseau,Energie,"Travaux&Maintenance",Comptabilite,Agence,B2B,DSP,CAP,RSE;
        }
        field(50025; "PO Type"; Option)
        {
            Caption = 'Purch Order Type';
            OptionCaption = ' ,Achats,SGX Services,RH,DG';
            OptionMembers = " ",Achats,"SGX Services",RH,DG;
        }
        field(50050; ProvisionValide; Boolean)
        {
            Caption = 'Provision charge item generated';
            Editable = false;
        }
        field(50055; "Ref Cargo"; Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo WHERE(Closed = CONST(false));

            trigger OnValidate()
            var
                Cargo1: Record "50045";
            begin
                IF (Cargo1.GET(Rec."Ref Cargo")) THEN
                    Cargo1.TESTFIELD(Cargo1.Closed, FALSE);
            end;
        }
        field(50056; "Vendor Retention Posting Group"; Code[10])
        {
            Caption = 'Source retention Group';
            TableRelation = "Vendor Posting Group";

            trigger OnLookup()
            var
                VendPostingGroup: Record "Vendor Posting Group";
            begin
                IF PAGE.RUNMODAL(50139, VendPostingGroup) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("Vendor Retention Posting Group", VendPostingGroup.Code);
                END;
            end;
        }
        field(50060; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;


        }
        field(50061; "Processing Status"; Option)
        {
            Caption = 'Processing Status';
            OptionCaption = ' ,Soldee';
            OptionMembers = " ",Soldee;
        }
        field(50062; "Offer Prepayment %"; Decimal)
        {
            Caption = 'Offer Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF xRec."Prepayment %" <> "Prepayment %" THEN
                    UpdatePurchLines(FIELDCAPTION("Prepayment %"), CurrFieldNo <> 0);
            end;
        }
        field(50063; Observations; Text[150])
        {
            Caption = 'Description';
        }
        field(50064; ProvisionValideVarStock; Boolean)
        {
            Caption = 'Provision inventory generated';
            Editable = false;
        }
        field(50065; Anticipated; Boolean)
        {
            Caption = 'Anticipated';
        }
        field(50066; Printed; Boolean)
        {
            Caption = 'Printed';
            Editable = false;
        }
        field(50067; "Printed Date"; Date)
        {
            Caption = 'Printed Date';
            Editable = false;
        }
        field(50068; "Printed By"; Code[50])
        {
            Caption = 'Printed By';
            Editable = false;
        }
        field(50069; "Ref Dossier Cargo"; Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
        field(50070; "MFiles Invoice"; Boolean)
        {
        }
        field(50071; MFilesURL; Text[100])
        {
            Caption = 'URL';
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(50072; "Skip Invoice Control"; Boolean)
        {
            Caption = 'No Invoice linked';

            trigger OnValidate()
            begin
                //********************************************************
                IF "Skip Invoice Control" THEN "On Hold" := '';
                //********************************************************
            end;
        }
        field(50073; "Invoice Doc Ref"; Code[20])
        {
            Caption = 'Invoice document';
            TableRelation = "Vendor Invoice Doc"."Reference Number" WHERE("Vendor No" = FIELD("Buy-from Vendor No."),
                                                                           Status = CONST(Receptionee));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                InvoiceDoc: Record "Vendor Invoice Doc";
            begin
                //****************************************************080222
                IF ("Invoice Doc Ref" <> '') THEN BEGIN
                    InvoiceDoc.SETCURRENTKEY("Reference Number");
                    InvoiceDoc.SETRANGE(InvoiceDoc."Reference Number", "Invoice Doc Ref");
                    IF InvoiceDoc.FINDFIRST THEN BEGIN
                        VALIDATE("Document Date", InvoiceDoc."Arrival Date");
                        VALIDATE("Vendor Invoice No.", InvoiceDoc."Vendor Invoice No.");
                    END;
                END;
                //****************************************************
            end;
        }
        field(50074; "GDP Deletion"; Boolean)
        {
        }
        field(50075; Derogation; Boolean)
        {
        }
        field(60000; "Partially Received"; Boolean)
        {
            CalcFormula = Max("Purchase Line"."Partially Received" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("No."),
                                                                          Type = FILTER(<> ' '),
                                                                          "Location Code" = FIELD("Location Filter")));
            Caption = 'Partially Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60002; "Outstanding Amount (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amt. Ex. VAT (LCY)" WHERE("Document Type" = FIELD("Document Type"),
                                                                                      "Document No." = FIELD("No.")));
            Caption = 'Outstanding Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: BudgetLineP)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
      ERROR(
        Text023,
    #4..9
    VALIDATE("Applies-to ID",'');
    VALIDATE("Incoming Document Entry No.",0);

    ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);
    PurchLine.LOCKTABLE;

    WhseRequest.SETRANGE("Source Type",DATABASE::"Purchase Line");
    WhseRequest.SETRANGE("Source Subtype","Document Type");
    WhseRequest.SETRANGE("Source No.","No.");
    WhseRequest.DELETEALL(TRUE);

    PurchLine.SETRANGE("Document Type","Document Type");
    PurchLine.SETRANGE("Document No.","No.");
    PurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
    DeletePurchaseLines;
    PurchLine.SETRANGE(Type);
    DeletePurchaseLines;

    PurchCommentLine.SETRANGE("Document Type","Document Type");
    PurchCommentLine.SETRANGE("No.","No.");
    PurchCommentLine.DELETEALL;
    #31..36
       (PurchCrMemoHeaderPrepmt."No." <> '')
    THEN
      MESSAGE(PostedDocsToPrintCreatedMsg);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12

    //*****************************************************
    //*****************************************************
    AddOnSetup.GET;
    //IF NOT AddOnSetup."Preserve Purch Approval Entry" THEN
    //  ApprovalsMgmt.DeleteApprovalEntry(DATABASE::"Purchase Header","Document Type","No.");

    //ApprovalsMgmt.DeleteApprovalEntry(DATABASE::"Purchase Header","Document Type","No.");
    //*****************************************************
    //*****************************************************

    ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);

    #14..20

    //*****************************************
    //JN Delete Budget Lines 310314
    //*****************************************
    //*****************************************
    BudgetLineP.RESET;
    BudgetLineP.SETRANGE("Document Type","Document Type");
    BudgetLineP.SETRANGE("Document No.","No.");
    BudgetLineP.DELETEALL;

    IF "Code Demande"<>'' THEN
      ServRequisitionMgt.RefreshRemainingQtyReqByCode("Code Demande");

    ArchiveManagement.ArchPurchDocumentNoConfirm(Rec);
    //*****************************************
    //*****************************************


    PurchLine.AFK_SetIsSolderCommande(AFK_IsSolderCommande);//*******************

    #21..27







    #28..39
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InitInsert;

    IF GETFILTER("Buy-from Vendor No.") <> '' THEN
      IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
        VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));

    IF "Purchaser Code" = '' THEN
      SetDefaultPurchaser;

    IF "Buy-from Vendor No." <> '' THEN
      StandardCodesMgt.CheckShowPurchRecurringLinesNotification(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6


    //**********************************************
    Rec."User ID" := USERID;

    {
    AFK_Setup.GET;
    IF (("Document Type" = Rec."Document Type"::Invoice) OR
          ("Document Type" = Rec."Document Type"::Order)) THEN BEGIN
      IF AFK_Setup."Activate Vend Payments Process" THEN
        "On Hold" := 'GDP';
    END;
    }
    //**********************************************

    #7..11
    */
    //end;


    //Unsupported feature: Code Modification on "GetPstdDocLinesToRevere(PROCEDURE 47)".

    //procedure GetPstdDocLinesToRevere();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetVend("Buy-from Vendor No.");
    PurchPostedDocLines.SetToPurchHeader(Rec);
    PurchPostedDocLines.SETRECORD(Vend);
    PurchPostedDocLines.LOOKUPMODE := TRUE;
    IF PurchPostedDocLines.RUNMODAL = ACTION::LookupOK THEN
      PurchPostedDocLines.CopyLineToDoc;

    CLEAR(PurchPostedDocLines);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    GetVend("Buy-from Vendor No.");
    //PurchPostedDocLines.SetAFKToPurchHeader(Rec);//**************************
    #2..8
    */
    //end;

    local procedure AFK_TestMFilesInvoice()
    begin
        //*******************************121017
        AddOnSetup.GET;
        IF NOT AddOnSetup."MFiles Mgt" THEN EXIT;

        IF Rec."MFiles Invoice" THEN
            ERROR(AFK_Text0001);
    end;

    procedure AFK_SetIsSolderCommande(val: Boolean)
    begin
        AFK_IsSolderCommande := val;
    end;

    var
        Loc: Record "14";

    var
        BudgetLineP: Record "50052";

    var
        //ServRequisitionMgt: Codeunit "50020";
        TextErr01: Label 'Ce fournisseur a été blacklisté';
        AddOnSetup: Record "50000";
        AFK_Text0001: Label 'Cette facture ne peut pas être modifiée car elle provient d''un document MFiles';
        AFK_Setup: Record "50001";
        AFK_IsSolderCommande: Boolean;
}

