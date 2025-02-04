tableextension 50011 "A02 Sales Header" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            Caption = 'Sell-to Customer No.';
        }
        modify("Ship-to Code")
        {
            Caption = 'Ship-to Code';
        }

        //Unsupported feature: Property Insertion (Editable) on ""Due Date"(Field 24)".

        modify("Location Code")
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Transfer Item Transit" = CONST(false),
                                            "Virtual Location" = CONST(false));
        }
        modify("Sell-to Customer Name")
        {
            Caption = 'Sell-to Customer Name';
        }

        //Unsupported feature: Property Insertion (Editable) on ""VAT Bus. Posting Group"(Field 116)".

        modify("Responsibility Center")
        {
            Caption = 'Responsibility Center';
        }

        //Unsupported feature: Code Modification on ""Sell-to Customer No."(Field 2).OnValidate".

        //trigger "(Field 2)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckCreditLimitIfLineNotInsertedYet;
        IF "No." = '' THEN
          InitRecord;
        #4..60

        Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,FALSE);
        Cust.TESTFIELD("Gen. Bus. Posting Group");
        CopySellToCustomerAddressFieldsFromCustomer(Cust);

        IF "Sell-to Customer No." = xRec."Sell-to Customer No." THEN
          IF ShippedSalesLinesExist OR ReturnReceiptExist THEN BEGIN
        #68..79
          VALIDATE("Bill-to Customer No.","Sell-to Customer No.");
          SkipBillToContact := FALSE;
        END;
        VALIDATE("Ship-to Code",Cust."Ship-to Code");

        GetShippingTime(FIELDNO("Sell-to Customer No."));

        #87..98

        IF (xRec."Sell-to Customer No." <> '') AND (xRec."Sell-to Customer No." <> "Sell-to Customer No.") THEN
          RecallModifyAddressNotification(GetModifyCustomerAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..63
        //*********************************************
        Cust.TESTFIELD("Responsibility Center");
        //*********************************************

        CopySellToCustomerAddressFieldsFromCustomer(Cust);

        #65..82

        //VALIDATE("Ship-to Code",'');//*********************************************JN001*Commented
        VALIDATE("Ship-to Code",Cust."Ship-to Code2");//Added*************************JN001*****************Added
        VALIDATE("Shipment Method Code",Cust."Shipment Method Code");//**************JN001*****************
        //VALIDATE("Ship-to Code",Cust."Ship-to Code");

        #84..101
        */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." <> xRec."No." THEN BEGIN
          SalesSetup.GET;
          NoSeriesMgt.TestManual(GetNoSeriesCode);
          "No. Series" := '';
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5


        //JN Controle des code facture et commandes
        //*****************************************
        IF "Document Type"=Rec."Document Type"::Order THEN BEGIN
          SalesHeaderArchive.RESET;
          SalesHeaderArchive.SETRANGE("Document Type",SalesHeaderArchive."Document Type"::Order);
          SalesHeaderArchive.SETRANGE("No.",Rec."No.");
          IF SalesHeaderArchive.FINDFIRST THEN ERROR(AFK_ERR001);
        END;

        IF "Document Type"=Rec."Document Type"::Invoice THEN BEGIN
          SalesInvHeader2.RESET;
          SalesInvHeader2.SETRANGE("Pre-Assigned No.",Rec."No.");
          IF SalesInvHeader2.FINDFIRST THEN ERROR(AFK_ERR002);
        END;
        //*****************************************
        */
        //end;


        //Unsupported feature: Code Modification on ""Bill-to Customer No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
        IF BilltoCustomerNoChanged THEN
          IF xRec."Bill-to Customer No." = '' THEN
            InitRecord
          ELSE BEGIN
            IF GetHideValidationDialog OR NOT GUIALLOWED THEN
              Confirmed := TRUE
            ELSE
              Confirmed := CONFIRM(ConfirmChangeQst,FALSE,BillToCustomerTxt);
            IF Confirmed THEN BEGIN
              SalesLine.SETRANGE("Document Type","Document Type");
              SalesLine.SETRANGE("Document No.","No.");
        #14..58
        "Bill-to IC Partner Code" := Cust."IC Partner Code";
        "Send IC Document" := ("Bill-to IC Partner Code" <> '') AND ("IC Direction" = "IC Direction"::Outgoing);

        IF (xRec."Bill-to Customer No." <> '') AND (xRec."Bill-to Customer No." <> "Bill-to Customer No.") THEN
          RecallModifyAddressNotification(GetModifyBillToCustomerAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..6

            //VALIDATE("Credit Card No.",'');
            //Confirmed := CONFIRM(ConfirmChangeQst,FALSE,BillToCustomerTxt);********************************************
            Confirmed := TRUE;//ADDED ************************************



        #11..61

        //******************************************************
        //******************************************************
        IF (Rec."Document Type" = Rec."Document Type"::Invoice) THEN BEGIN
          IF (Rec."Created By Doc Type" = Rec."Created By Doc Type"::SortieARefacturer) THEN
            IF Rec."Created By Doc No." <> '' THEN
              ERROR(AFK_Text004,Rec."Created By Doc No.");
        END;
        //******************************************************
        //******************************************************


        IF (xRec."Bill-to Customer No." <> '') AND (xRec."Bill-to Customer No." <> "Bill-to Customer No.") THEN
          RecallModifyAddressNotification(GetModifyBillToCustomerAddressNotificationId);
        */
        //end;


        //Unsupported feature: Code Modification on ""Ship-to Code"(Field 12).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ("Document Type" = "Document Type"::Order) AND
           (xRec."Ship-to Code" <> "Ship-to Code")
        THEN BEGIN
        #4..20
              "Tax Area Code" := Cust."Tax Area Code";
            END;
            ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
            CopyShipToCustomerAddressFieldsFromShipToAddr(ShipToAddr);
          END ELSE
            IF "Sell-to Customer No." <> '' THEN BEGIN
              GetCust("Sell-to Customer No.");
        #28..44
            IF xRec."Tax Liable" <> "Tax Liable" THEN
              VALIDATE("Tax Liable");
          END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..23

            CopyShipToCustomerAddressFieldsFromShipToAddr(ShipToAddr);

        #25..47
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Location Code"(Field 28).OnValidate".

        //trigger (Variable: Loc)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 28).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        TestStatusOpen;
        IF ("Location Code" <> xRec."Location Code") AND
           (xRec."Sell-to Customer No." = "Sell-to Customer No.")
        THEN
          MessageIfSalesLinesExist(FIELDCAPTION("Location Code"));

        UpdateShipToAddress;
        UpdateOutboundWhseHandlingTime;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7



        //***********************************************************
        //***********************************************************
        IF Loc.GET("Location Code") THEN
          IF ((Loc."Location Type"=Loc."Location Type"::Expedition) OR
              (Loc."Location Type"=Loc."Location Type"::TransferTransit)) THEN
              ERROR(AFK_ERR003);

        //IF Loc.GET("Location Code") THEN Loc.TESTFIELD("Responsibility Center","Responsibility Center");
        //AFK_SecMgt.CheckWarehouseUser("Location Code");
        //***********************************************************
        //***********************************************************

        UpdateOutboundWhseHandlingTime;
        */
        //end;
        field(50000; "Delivery Status"; Option)
        {
            Caption = 'Processing Status';
            Editable = false;
            OptionCaption = 'Draft,Pending Prices validation,Blocked,Pending Delivery Order,Pending Delivery,Partially Shipped,Shipped,Partially invoiced,Invoiced,Closed,Cancelled,Rupture';
            OptionMembers = Saisie,ValidationTarifs,Bloquee,AttenteOrdreLiv,AttenteLivraison,PartiellementLivree,Livree,PartiellementFacturee,Facturee,Soldee,Annulee,Rupture;
        }
        field(50001; "Created By Doc No."; Code[20])
        {
            Caption = 'Created By Doc No.';
            Editable = false;
        }
        field(50002; "Created By Doc Type"; Option)
        {
            Caption = 'Created By Doc Type';
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation,AMSA,Sortie';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation,AMSA,SortieARefacturer;
        }
        field(50003; "Return Reason"; Text[200])
        {
            Caption = 'Return Reason';
        }
        field(50010; "JIRAMA Order Ref."; Code[30])
        {
            Caption = 'JIRAMA Order Ref.';
        }
        field(50011; "JIRAMA Invoice No."; Code[30])
        {
            Caption = 'JIRAMA Invoice No.';
        }
        field(50012; Observations; Text[250])
        {
        }
        field(50013; "Type Ecr Cargo"; Option)
        {
            Caption = 'Type écriture cargo';
            OptionCaption = ' ,Normale,Fictive';
            OptionMembers = " ",Normale,Fictive;
        }
        field(50060; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "418";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50061; "Shipment Val UserID"; Code[50])
        {
            Caption = 'Shipment Validated By';
        }
        field(50062; "Shipment Val Date"; DateTime)
        {
            Caption = 'Shipment Validation Date';
        }
        field(50063; "Prices Status"; Option)
        {
            Caption = 'Prices status';
            OptionCaption = 'Conformes,Prix non conformes';
            OptionMembers = Conformes,"Prix non conformes";
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
        field(50069; "Ref Dossier Cargo"; Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
        field(50075; "Dispatching Status"; Option)
        {
            Caption = 'Dispatching Status';
            Editable = false;
            OptionCaption = ' ,Non traitée,Reliquat,Traitée';
            OptionMembers = "None",NonTraite,Reliquat,Processed;
        }
        field(50076; "Reliquat Number"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("Touring Sales Order" WHERE("Order No" = FIELD("No."),
                                                             "Touring Status" = CONST(Posted)));
            Caption = 'Reliquat Number';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50077; "GDP Deletion"; Boolean)
        {
        }
        field(50078; "GD1 Credit Notes Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Order Pay Doc"."Paid Amount" WHERE("Customer No." = FIELD("Sell-to Customer No."),
                                                           "Document No." = FIELD("No.")));
            Caption = 'Credit notes / payment';
            Editable = false;
        }
    }
    keys
    {
        // key(Key1;"Document Type","Delivery Status")
        // {
        // }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT UserSetupMgt.CheckRespCenter(0,"Responsibility Center") THEN
      ERROR(
        Text022,
        RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter);

    ArchiveManagement.AutoArchiveSalesDocument(Rec);
    PostSalesDelete.DeleteHeader(
      Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
      SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt);
    UpdateOpportunity;

    VALIDATE("Applies-to ID",'');
    VALIDATE("Incoming Document Entry No.",0);

    #15..44

    IF IdentityManagement.IsInvAppId AND CustInvoiceDisc.GET(SalesHeader."Invoice Disc. Code") THEN
      CustInvoiceDisc.DELETE; // Cleanup of autogenerated cust. invoice discounts
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //******************************************
    //******************************************
    IF NOT AFK_AllowDeletionVar THEN
      IF "Document Type"=Rec."Document Type"::Order THEN
        TESTFIELD("Delivery Status","Delivery Status"::Saisie);
    //******************************************
    //******************************************

    #1..6
    IF NOT AFK_AllowDeletionVar THEN//**************************************************************
    #7..11


    #12..47
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InitInsert;
    InsertMode := TRUE;

    SetSellToCustomerFromFilter;

    IF GetFilterContNo <> '' THEN
      VALIDATE("Sell-to Contact No.",GetFilterContNo);

    VALIDATE("Payment Instructions Id",O365SalesInvoiceMgmt.GetDefaultPaymentInstructionsId);

    IF "Salesperson Code" = '' THEN
    #12..15

    // Remove view filters so that the cards does not show filtered view notification
    SETVIEW('');
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8


    //***********************************
    //"Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header","Document Type","No.");

    Rec."User ID" := USERID;
    SOProcess.InsertNewStep("No.",0,FORMAT(Rec."Delivery Status"),'');
    Rec."Dispatching Status" := Rec."Dispatching Status"::NonTraite;
    //***********************************

    #9..18
    */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 43)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := FALSE;
    OnBeforeSetSecurityFilterOnRespCenter(Rec,IsHandled);
    IF (NOT IsHandled) AND (UserSetupMgt.GetSalesFilter <> '') THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;

    SETRANGE("Date Filter",0D,WORKDATE - 1);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    //*********************************************
    SETRANGE("User ID",USERID);
    //*********************************************

    SETRANGE("Date Filter",0D,WORKDATE - 1);
    */
    //end;


    //Unsupported feature: Code Modification on "CopyShipToCustomerAddressFieldsFromShipToAddr(PROCEDURE 165)".

    //procedure CopyShipToCustomerAddressFieldsFromShipToAddr();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Ship-to Name" := ShipToAddr.Name;
    "Ship-to Name 2" := ShipToAddr."Name 2";
    "Ship-to Address" := ShipToAddr.Address;
    #4..6
    "Ship-to County" := ShipToAddr.County;
    VALIDATE("Ship-to Country/Region Code",ShipToAddr."Country/Region Code");
    "Ship-to Contact" := ShipToAddr.Contact;
    IF ShipToAddr."Shipment Method Code" <> '' THEN
      VALIDATE("Shipment Method Code",ShipToAddr."Shipment Method Code");
    IF ShipToAddr."Location Code" <> '' THEN
      VALIDATE("Location Code",ShipToAddr."Location Code");
    "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
    #15..17
    "Tax Liable" := ShipToAddr."Tax Liable";

    OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(Rec,ShipToAddr);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
    //*******************************************************************
    //IF ShipToAddr."Shipment Method Code" <> '' THEN
    //  VALIDATE("Shipment Method Code",ShipToAddr."Shipment Method Code");
    //*******************************************************************
    #12..20
    */
    //end;

    procedure AFK_AllowDeletion(CanDelete: Boolean)
    var
        SingleCU: Codeunit SingleInstance;
    begin
        SingleCU.Set_AllowDeletionSalesHeader(true);
        AFK_AllowDeletionVar := CanDelete;
    end;

    procedure Clear_AllowDeletion()
    var
        SingleCU: Codeunit SingleInstance;
    begin
        SingleCU.Set_AllowDeletionSalesHeader(false);
    end;


    //TODO Migration
    // procedure AFK_RefreshSalesLinePrices()
    // var
    //     SalesLine1: Record "37";
    //     PricesDate: Date;
    //     BLHeader: Record "50005";
    //     DocPrepa: Record "50037";
    //     JiramaSitePrice: Decimal;
    // begin
    //     AddOnSetup2.GET;
    //     IF Rec."Document Type" <> Rec."Document Type"::Order THEN EXIT;

    //     PricesDate := 0D;

    //     BLHeader.RESET;
    //     BLHeader.SETRANGE(BLHeader.NavOrderNo, Rec."No.");
    //     BLHeader.SETRANGE(isconfirme, TRUE);
    //     IF BLHeader.FINDLAST THEN
    //         PricesDate := BLHeader.datelivraison;

    //     IF PricesDate = 0D THEN BEGIN
    //         DocPrepa.RESET;
    //         DocPrepa.SETRANGE(DocPrepa."Document Type", DocPrepa."Document Type"::Shipment);
    //         DocPrepa.SETRANGE(DocPrepa."Order No.", Rec."No.");
    //         IF DocPrepa.FINDLAST THEN
    //             PricesDate := DocPrepa."Posting Date";
    //     END;

    //     IF PricesDate = 0D THEN ERROR(AFK_Text003);

    //     //PricesDate := Rec."Requested Delivery Date";
    //     IF NOT CONFIRM(STRSUBSTNO(AFK_Text002, PricesDate)) THEN EXIT;

    //     SalesLine1.RESET;
    //     SalesLine1.SETRANGE("Document Type", SalesLine1."Document Type"::Order);
    //     SalesLine1.SETRANGE("Document No.", Rec."No.");
    //     IF SalesLine1.FINDSET THEN
    //         REPEAT
    //             IF ((SalesLine1.Type = SalesLine1.Type::Item) OR
    //               (SalesLine1.Type = SalesLine1.Type::Resource)) THEN BEGIN

    //                 SalesLine1.TESTFIELD("Qty. per Unit of Measure");

    //                 CASE SalesLine1.Type OF
    //                     SalesLine1.Type::Item, SalesLine1.Type::Resource:
    //                         BEGIN
    //                             PriceCalcMgt.SetSalesPriceDate(PricesDate);
    //                             PriceCalcMgt.FindSalesLineLineDisc(Rec, SalesLine1);
    //                             PriceCalcMgt.FindSalesLinePrice(Rec, SalesLine1, SalesLine1.FIELDNO("No."));
    //                         END;
    //                 END;

    //                 //*****************Prix par site Jirama
    //                 //TODO Migration
    //                 /*
    //                   IF AddOnSetup2."Activate Jirama Site UP" THEN BEGIN
    //                   JiramaSitePrice := JiramaSitePricing.GetJiramaSiteUnitPrice("Sell-to Customer No.","Ship-to Code",PricesDate,SalesLine1."No.");
    //                   IF(JiramaSitePrice > 0) THEN
    //                     SalesLine1."Unit Price" := JiramaSitePrice;
    //                 END;
    //                 */
    //                 //*****************Prix par site Jirama

    //                 SalesLine1.VALIDATE("Unit Price");
    //                 SalesLine1.MODIFY;

    //             END;
    //         UNTIL SalesLine1.NEXT = 0;
    //     MESSAGE(AFK_Text001);
    // end;



    var
        Loc: Record "14";

    var
        AFK_AllowDeletionVar: Boolean;
        //AFK_SecMgt: Codeunit "50016";
        SalesHeaderArchive: Record "5107";
        SalesInvHeader2: Record "112";
        AFK_ERR001: Label 'Ce numéro a déjà été utilisé pour une commande';
        AFK_ERR002: Label 'Ce numéro a déjà été utilisé pour une facture';
        AFK_ERR003: Label 'Vous ne devez pas seléctionner un magasin de ce type';
        //SOProcess: Codeunit "50001";
        PriceCalcMgt: Codeunit "7000";
        AFK_Text001: Label 'Mise à jour des prix terminée !';
        AFK_Text002: Label 'Les prix de vente seront mis à jour pour considérer les prix du %1. Voulez-vous continuer ?';
        AFK_Text003: Label 'Aucune document de livraison n''a été trouvé pour cette commande';
        AFK_Text004: Label 'Le document provient d''une sortie à refacturer %1, le code client ne doit pas être changé sur la facture';
        //JiramaSitePricing: Codeunit "50023";
        AddOnSetup2: Record "50001";
}

