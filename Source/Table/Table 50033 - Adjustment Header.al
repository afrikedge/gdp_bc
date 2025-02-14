table 50033 "Adjustment Header"
{
    Caption = 'Adjustment Header';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Exchange,Loan,Borrow,Consignation,Shipment,Invoiced Consumption,FA Conso,Transfer';
            OptionMembers = Exchange,Loan,Borrow,Consignation,Shipment,"Invoiced Consumption","FA Conso",Transfer;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    AddOnSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                if Rec."Document Type" in [Rec."Document Type"::Transfer, Rec."Document Type"::Borrow,
                  Rec."Document Type"::Loan] then
                    TestStatusOpen;
            end;
        }
        field(4; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(7; Comment; Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                            "No." = FIELD("No."),
                                                            "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(9; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(10; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';

            trigger OnValidate()
            begin
                if Rec."Document Type" = Rec."Document Type"::Transfer then
                    TestStatusOpen;
            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Cancelled';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled;
        }
        field(13; "Customer No."; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get("Customer No.") then
                    "Customer Name" := Cust.Name;

                if "Document Type" = Rec."Document Type"::Exchange then begin
                    if Cust.Get("Customer No.") then
                        if Vend.Get(Cust."Related Vendor") then begin
                            "Vendor No." := Vend."No.";
                            "Vendor Name" := Vend.Name;
                        end;
                end;

                if "Document Type" in [Rec."Document Type"::Borrow, Rec."Document Type"::Exchange,
                  Rec."Document Type"::Loan] then
                    if Cust.Get("Customer No.") then
                        Cust.TestField(Cust."GDP Partner");

                CreateDimFromDefaultDim(FieldNo("Customer No."));


                if Rec."Document Type" = Rec."Document Type"::"Invoiced Consumption" then begin
                    SalesOrderHeader.Reset;
                    SalesOrderHeader.SetRange(SalesOrderHeader."Document Type", SalesOrderHeader."Document Type"::Invoice);
                    SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc Type", SalesOrderHeader."Created By Doc Type"::SortieARefacturer);
                    SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc No.", Rec."No.");
                    if SalesOrderHeader.FindFirst then
                        Error(Text011Err, SalesOrderHeader."No.");
                end;
            end;
        }
        field(14; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get(Rec."Vendor No.") then
                    "Vendor Name" := Vend.Name;

                if "Document Type" in [Rec."Document Type"::Borrow, Rec."Document Type"::Exchange,
                  Rec."Document Type"::Loan] then
                    if Vend.Get("Vendor No.") then
                        Vend.TestField("GDP Partner");


                CreateDimFromDefaultDim(FieldNo("Vendor No."));
            end;
        }
        field(15; "Order No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(16; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
        }
        field(17; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(18; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Item Category Code" = FIELD("Item Category Code"),
                                            "Virtual Location" = CONST(false));

            trigger OnValidate()
            begin
                if Rec."Document Type" = Rec."Document Type"::Transfer then
                    TestStatusOpen;

                AFK_SecMgt.CheckWarehouseUser("Location Code");
                CreateDimFromDefaultDim(FieldNo("Location Code"));
            end;
        }
        field(30; "Shipment Status"; Option)
        {
            Caption = 'Shipment Status';
            Editable = false;
            OptionCaption = ' ,Prepared,Shipped,Confirmed';
            OptionMembers = " ",Prepared,Shipped,Confirmed;
        }
        field(31; "Reception Validated"; Boolean)
        {
            Caption = 'Exchange validated';
            Editable = false;
        }
        field(32; "Cession Validated"; Boolean)
        {
            Caption = 'Exchange validated';
            Editable = false;
        }
        field(33; "Cession Date"; Date)
        {
            Caption = 'Cession Date';
        }
        field(34; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';

            trigger OnValidate()
            begin
                UpdateLinesTransfer;
            end;
        }
        field(35; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(36; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Item Category Code" = FIELD("Item Category Code"),
                                            "Virtual Location" = CONST(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
                AFK_SecMgt.CheckWarehouseUser("Transfer-to Code");
                UpdateLinesTransfer;
            end;
        }
        field(37; "In-Transit Code"; Code[10])
        {
            Caption = 'In-Transit Code';
            TableRelation = Location WHERE("Transfer Item Transit" = CONST(true),
                                            "Item Category Code" = FIELD("Item Category Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;
                //UpdateTransLines(FIELDNO("In-Transit Code"));
            end;
        }
        field(38; "BEX Number"; Code[20])
        {
            Caption = 'BEX Number';
        }
        field(39; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            NotBlank = true;
            //TableRelation = "Item Category";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateItemCategory;
            end;
        }
        field(108; "Credit Notes Import Jrnal"; Code[20])
        {
            Caption = 'Credit Notes Validation Journal';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Sales by Cards Import Tmpl"));
        }
        field(109; "Sales by Cards Import Tmpl"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(110; "Debit Notes Import Jrnal"; Code[20])
        {
            Caption = 'Debit Notes Validation Journal';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Sales by Cards Import Tmpl"));
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(50000; "Posted Doc No"; Code[20])
        {
            Caption = 'Posted Doc N°';
            Editable = false;
        }
        field(50004; "Truck Code"; Code[20])
        {
            Caption = 'Truck code';
            TableRelation = pro_moyentransport.immatriculation;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Camion.Get("Truck Code") then begin
                    nomchauffeur := Camion.nomchauffeur;
                    prenomchauffeur := Camion.prenomchauffeur;
                    permis := Camion.permis;
                    CarteGrise := Camion.CarteGrise;
                    if (Camion.codetransporteur <> '') then
                        Validate("Transporter Code", Camion.codetransporteur);
                end
            end;
        }
        field(50005; "Transporter Code"; Code[20])
        {
            Caption = 'Transporter';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get("Transporter Code") then
                    "Transporter Name" := Vend.Name;
            end;
        }
        field(50006; "Transporter Name"; Text[50])
        {
            Caption = 'Transporter Name';
        }
        field(50007; nomchauffeur; Text[50])
        {
            Caption = 'Driver Name';
        }
        field(50008; prenomchauffeur; Text[50])
        {
            Caption = 'Driver First Name';
        }
        field(50009; permis; Text[50])
        {
            Caption = 'Driver licence';
        }
        field(50010; CarteGrise; Text[30])
        {
            Caption = 'Carte grise';
        }
        field(50011; "Cancelled By"; Code[50])
        {
            Caption = 'Cancelled by';
            Description = 'Transfer only';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50012; "Cancellation Date"; Date)
        {
            Caption = 'Cancellation Date';
            Description = 'Transfer only';
            Editable = false;
        }
        field(50013; BLub_Preparation; DateTime)
        {
            Caption = 'Preparation Date';
            Editable = false;
        }
        field(50014; BLub_Expedition; DateTime)
        {
            Caption = 'Expedition Date';
            Editable = false;
        }
        field(50015; BLub_Confirmation; DateTime)
        {
            Caption = 'Confirmation Date';
            Editable = false;
        }
        field(50016; "Customer Search Name"; Text[50])
        {
            CalcFormula = Lookup(Customer."Search Name" WHERE("No." = FIELD("Customer No.")));
            Caption = 'Customer Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "Order No.")
        {
        }
    }

    fieldgroups
    {
        // fieldgroup(Brick;"Posting Date",Field79,Field60,Field84,Field61)
        // {
        // }
    }

    trigger OnDelete()
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
        if not IsArchive then TestStatusOpen;

        AdjLine.Reset;
        AdjLine.SetRange("Document Type", "Document Type");
        AdjLine.SetRange("Document No.", "No.");
        AdjLine.DeleteAll;
    end;

    trigger OnInsert()
    var
        DefaultLoc: Code[10];
        Loc1: Record Location;
    begin
        "Posting Date" := WorkDate;


        AddOnSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            "No. Series" := GetNoSeriesCode();
            if (NoSeriesMgt.AreRelated(GetNoSeriesCode(), xRec."No. Series")) then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series");
            //NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;


        "User ID" := UserId;
        AddOnSetup.TestField(AddOnSetup."Sales by Cards Import Tmpl");
        Rec."Sales by Cards Import Tmpl" := AddOnSetup."Sales by Cards Import Tmpl";

        AddOnSetup.TestField(AddOnSetup."PBL Category Code");
        Rec."Item Category Code" := AddOnSetup."PBL Category Code";

        if ((Rec."Document Type" = Rec."Document Type"::Transfer)) then begin
            DefaultLoc := AFK_SecMgt.GetDefaultOrFirstLocation();
            if (Loc1.Get(DefaultLoc)) then begin
                if ((DefaultLoc <> '') and (Loc1."Item Category Code" = Rec."Item Category Code")) then
                    Validate("Location Code", DefaultLoc);
            end;
        end;

        //IF GetFilterCustNo <> '' THEN
        //  VALIDATE("Sell-to Customer No.",GetFilterCustNo);

        //IF GetFilterContNo <> '' THEN
        //  VALIDATE("Sell-to Contact No.",GetFilterContNo);

        //"Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header","Document Type","No.");
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        Text000: Label 'Do you want to print shipment %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text007: Label '%1 cannot be greater than %2 in the %3 table.';
        Text009: Label 'Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text015: Label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\Do you want to change %1?';
        Text017: Label 'You must delete the existing sales lines before you can change %1.';
        Text018: Label 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\';
        Text019: Label 'You must update the existing sales lines manually.';
        Text020: Label 'The change may affect the exchange rate used in the price calculation of the sales lines.';
        Text021: Label 'Do you want to update the exchange rate?';
        Text022: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text023: Label 'Do you want to print return receipt %1?';
        Text024: Label 'You have modified the %1 field. The recalculation of VAT may cause penny differences, so you must check the amounts afterward. Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: Label 'Your identification is set up to process from %1 %2 only.';
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text030: Label 'Deleting this document will cause a gap in the number series for return receipts. An empty return receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text031: Label 'You have modified %1.\\';
        Text032: Label 'Do you want to update the lines?';
        Text067: Label '%1 %4 with amount of %2 has already been authorized on %3 and is not expired yet. You must void the previous authorization before you can re-authorize this %1.';
        Text068: Label 'There is nothing to void.';
        Text069: Label 'The selected operation cannot complete with the specified %1.';
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        SalesHeader: Record "Adjustment Header";
        AdjLine: Record "Adjustment Line";
        Cust: Record Customer;
        SalesCommentLine: Record "Sales Comment Line";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ArchiveManagement: Codeunit ArchiveManagement;
        HideValidationDialog: Boolean;
        Text035: Label 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: Label 'Contact %1 %2 is not related to a customer.';
        Text040: Label 'A won opportunity is linked to this order.\It has to be changed to status Lost before the Order can be deleted.\Do you want to change the status for this opportunity now?';
        Text043: Label 'Wizard Aborted';
        Text044: Label 'The status of the opportunity has not been changed. The program has aborted deleting the order.';
        Text045: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text048: Label 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?';
        Text049: Label 'The %1 field cannot be blank because this quote is linked to an opportunity.';
        InsertMode: Boolean;
        CompanyInfo: Record "Company Information";
        Text051: Label 'The sales %1 %2 already exists.';
        Text052: Label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text053: Label 'You must cancel the approval process if you wish to change the %1.';
        Text055: Label 'Do you want to print prepayment invoice %1?';
        Text054: Label 'Do you want to print prepayment credit memo %1?';
        Text056: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text057: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text061: Label '%1 is set up to process from %2 %3 only.';
        Text062: Label 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.';
        Text063: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?';
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text066: Label 'You cannot change %1 to %2 because an open inventory pick on the %3.';
        Text070: Label 'You cannot change %1  to %2 because an open warehouse shipment exists for the %3.';
        Text071: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        Text072: Label 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.';
        SynchronizingMsg: Label 'Synchronizing ...\ from: Sales Header with %1\ to: Assembly Header with %2.';
        ShippingAdviceErr: Label 'This order must be a complete shipment.';
        AFK_AllowDeletionVar: Boolean;
        AddOnSetup: Record "AddOn Setup";
        Vend: Record Vendor;
        Camion: Record pro_moyentransport;
        IsArchive: Boolean;
        AFK_SecMgt: Codeunit "Security Mgt";
        SalesOrderHeader: Record "Sales Header";
        Text011Err: Label 'La note de débit %1 existe déjà pour cette sortie';

    procedure AssistEdit(OldSalesHeader: Record "Sales Header"): Boolean
    var
        SalesHeader2: Record "Sales Header";
    begin
        /*
        WITH SalesHeader DO BEGIN
          COPY(Rec);
          SalesSetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldSalesHeader."No. Series","No. Series") THEN BEGIN
            IF ("Sell-to Customer No." = '') AND ("Sell-to Contact No." = '') THEN BEGIN
              HideCreditCheckDialogue := FALSE;
              CheckCreditMaxBeforeInsert;
              HideCreditCheckDialogue := TRUE;
            END;
            NoSeriesMgt.SetSeries("No.");
            IF SalesHeader2.GET("Document Type","No.") THEN
              ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
            Rec := SalesHeader;
            EXIT(TRUE);
          END;
        END;
        */

    end;


    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if SalesLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    // procedure ShowDocDim()
    // var
    //     OldDimSetID: Integer;
    // begin
    //     // OldDimSetID := "Dimension Set ID";
    //     // "Dimension Set ID" :=
    //     //   DimMgt.EditDimensionSet2(
    //     //     "Dimension Set ID",StrSubstNo('%1 %2',"Document Type","Posting Date"),
    //     //     "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    //     // if OldDimSetID <> "Dimension Set ID" then begin
    //     //   Modify;
    //     //   if SalesLinesExist then
    //     //     UpdateAllLineDim("Dimension Set ID",OldDimSetID);
    //     // end;
    // end;
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SalesLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure CreateDimFromDefaultDim(FieldNo: Integer)
    var
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        ShouldCreateDim: Boolean;
    begin
        InitDefaultDimensionSources(DefaultDimSource, FieldNo);
        CreateDim(DefaultDimSource);
    end;

    procedure CreateDim(DefaultDimSource: List of [Dictionary of [Integer, Code[20]]])
    var
        SourceCodeSetup: Record "Source Code Setup";
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        SourceCodeSetup.Get();

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and (OldDimSetID <> 0) and GuiAllowed then
            if CouldDimensionsBeKept() then
                if not ConfirmKeepExistingDimensions(OldDimSetID) then begin
                    "Dimension Set ID" := OldDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(Rec."Dimension Set ID", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");
                end;

        if (OldDimSetID <> "Dimension Set ID") and SalesLinesExist() then begin
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure ConfirmKeepExistingDimensions(OldDimSetID: Integer) Confirmed: Boolean
    var
    begin
        Confirmed := Confirm(DoYouWantToKeepExistingDimensionsQst);
    end;

    local procedure CouldDimensionsBeKept() Result: Boolean;
    var
    begin
        if (xRec."Customer No." <> '') and (xRec."Customer No." <> Rec."Customer No.") then
            exit(false);
        if (xRec."Vendor No." <> '') and (xRec."Vendor No." <> Rec."Vendor No.") then
            exit(false);
        if (xRec."Location Code" <> Rec."Location Code") then
            exit(true);
        if (xRec."Responsibility Center" <> '') and (xRec."Responsibility Center" <> Rec."Responsibility Center") then
            exit(true);
    end;

    procedure InitDefaultDimensionSources(var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    begin
        //DimMgt.AddDimSource(DefaultDimSource, DimMgt.SalesLineTypeToTableID(Type), Rec."No.", FieldNo = Rec.FieldNo("No."));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Responsibility Center", Rec."Responsibility Center", FieldNo = Rec.FieldNo("Responsibility Center"));
        DimMgt.AddDimSource(DefaultDimSource, Database::Location, Rec."Location Code", FieldNo = Rec.FieldNo("Location Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::Customer, Rec."Customer No.", FieldNo = Rec.FieldNo("Customer No."));
        DimMgt.AddDimSource(DefaultDimSource, Database::Vendor, Rec."Vendor No.", FieldNo = Rec.FieldNo("Vendor No."));
    end;


    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not HideValidationDialog and GuiAllowed then
            if not Confirm(Text064) then
                exit;

        AdjLine.Reset;
        AdjLine.SetRange("Document Type", "Document Type");
        AdjLine.SetRange("Document No.", "No.");
        AdjLine.LockTable;
        if AdjLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(AdjLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if AdjLine."Dimension Set ID" <> NewDimSetID then begin
                    AdjLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      AdjLine."Dimension Set ID", AdjLine."Shortcut Dimension 1 Code", AdjLine."Shortcut Dimension 2 Code");
                    AdjLine.Modify;
                    //ATOLink.UpdateAsmDimFromSalesLine(SalesLine);
                end;
            until AdjLine.Next = 0;
    end;

    procedure SalesLinesExist(): Boolean
    begin
        AdjLine.Reset;
        AdjLine.SetRange("Document Type", "Document Type");
        AdjLine.SetRange("Document No.", "No.");
        exit(AdjLine.FindFirst);
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;

    local procedure TestNoSeries(): Boolean
    begin
        AddOnSetup.Get;

        case "Document Type" of
            "Document Type"::Exchange:
                AddOnSetup.TestField("Item Exchange Nos.");
            "Document Type"::Loan:
                begin
                    AddOnSetup.TestField(AddOnSetup."Item Loan Nos.");
                    AddOnSetup.TestField(AddOnSetup."Item Return Loan Nos.");
                end;
            "Document Type"::Borrow:
                begin
                    AddOnSetup.TestField(AddOnSetup."Item Borrow Nos.");
                    AddOnSetup.TestField(AddOnSetup."Item Return Borrow Nos.");
                end;
            "Document Type"::Consignation:
                begin
                    AddOnSetup.TestField(AddOnSetup."Item Consignation Nos.");
                    AddOnSetup.TestField(AddOnSetup."Item Return Consignation Nos.");
                end;
            "Document Type"::Shipment:
                begin
                    AddOnSetup.TestField(AddOnSetup."Item Shipment Nos.");
                    //AddOnSetup.TESTFIELD(AddOnSetup."Item Return Consignation Nos.");
                end;
            "Document Type"::"Invoiced Consumption":
                begin
                    AddOnSetup.TestField(AddOnSetup."Invoiced Consumption Nos.");
                    //AddOnSetup.TESTFIELD(AddOnSetup."Item Return Consignation Nos.");
                end;
            "Document Type"::"FA Conso":
                begin
                    AddOnSetup.TestField(AddOnSetup."FA Conso Nos.");
                    //AddOnSetup.TESTFIELD(AddOnSetup."Item Return Consignation Nos.");
                end;
            "Document Type"::Transfer:
                begin
                    AddOnSetup.TestField(AddOnSetup."Transfer Order Nos.");
                    AddOnSetup.TestField(AddOnSetup."Transfer Receipt Nos.");
                end;
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        case "Document Type" of
            "Document Type"::Exchange:
                exit(AddOnSetup."Item Exchange Nos.");
            "Document Type"::Loan:
                exit(AddOnSetup."Item Loan Nos.");
            "Document Type"::Borrow:
                exit(AddOnSetup."Item Borrow Nos.");
            "Document Type"::Consignation:
                exit(AddOnSetup."Item Consignation Nos.");
            "Document Type"::Shipment:
                exit(AddOnSetup."Item Shipment Nos.");
            "Document Type"::"Invoiced Consumption":
                exit(AddOnSetup."Invoiced Consumption Nos.");
            "Document Type"::"FA Conso":
                exit(AddOnSetup."FA Conso Nos.");
            "Document Type"::Transfer:
                exit(AddOnSetup."Transfer Order Nos.");
        end;
    end;

    local procedure TestStatusOpen()
    begin
        Rec.TestField(Rec.Status, Rec.Status::Open);
        Rec.TestField(Rec."Shipment Status", Rec."Shipment Status"::" ");
    end;

    procedure SetIsArchive(isArch: Boolean)
    begin
        IsArchive := isArch
    end;

    local procedure UpdateItemCategory()
    begin
        // SalesLine.Reset;
        // SalesLine.SetRange("Document Type", "Document Type");
        // SalesLine.SetRange("Document No.", "No.");
        // SalesLine.LockTable;
        // if SalesLine.FindSet then
        //     repeat
        //         if SalesLine."Item Category Code" <> Rec."Item Category Code" then begin
        //             SalesLine."Item Category Code" := Rec."Item Category Code";
        //             SalesLine.Modify;
        //         end;
        //     until SalesLine.Next = 0;
    end;

    local procedure UpdateLinesTransfer()
    var
        TransfertLine: Record "Adjustment Line";
    begin
        if "Document Type" <> Rec."Document Type"::Transfer then exit;

        TransfertLine.Reset;
        TransfertLine.SetRange(TransfertLine."Document Type", Rec."Document Type");
        TransfertLine.SetRange(TransfertLine."Document No.", Rec."No.");
        if TransfertLine.FindSet then
            repeat
                TransfertLine.Validate("Receipt Date", Rec."Receipt Date");
                TransfertLine.Validate("Transfer-to Code", Rec."Transfer-to Code");
                TransfertLine.Modify;
            //TransfertLine.VALIDATE("Receipt Date",Rec."Receipt Date");
            until TransfertLine.Next = 0;
    end;

    var
        DoYouWantToKeepExistingDimensionsQst: Label 'Voulez vous modifier les axes analytiques?';

}

