table 50035 "Item Return Header"
{
    Caption = 'Adjustment Header';
    LookupPageID = "Sales List";

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Exchange,Loan,Borrow,Consignation,Transfer';
            OptionMembers = Exchange,Loan,Borrow,Consignation,Transfer;
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  AddOnSetup.Get;
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                end;
            end;
        }
        field(3;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(4;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(5;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(6;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(7;Comment;Boolean)
        {
            CalcFormula = Exist("Sales Comment Line" WHERE ("Document Type"=FIELD("Document Type"),
                                                            "No."=FIELD("No."),
                                                            "Document Line No."=CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"No. Printed";Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(9;"Document Date";Date)
        {
            Caption = 'Document Date';
        }
        field(10;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(11;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(13;"Customer No.";Code[20])
        {
            Caption = 'Partner Code (Customer)';
            TableRelation = Customer;
        }
        field(14;"Vendor No.";Code[20])
        {
            Caption = 'Partner Code (Vendor)';
            TableRelation = Vendor;
        }
        field(35;"User ID";Code[50])
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
        field(36;"Transfer-to Code";Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        field(37;"In-Transit Code";Code[10])
        {
            Caption = 'In-Transit Code';
            TableRelation = Location WHERE ("Use As In-Transit"=CONST(true));

            trigger OnValidate()
            begin
                //TestStatusOpen;
                //UpdateTransLines(FIELDNO("In-Transit Code"));
            end;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(50000;"Original Doc No";Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick;"Posting Date",Field79,Field60,Field84,Field61)
        {
        }
    }

    trigger OnDelete()
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
    end;

    trigger OnInsert()
    begin
        InitInsert;
        InsertMode := true;

        //IF GetFilterCustNo <> '' THEN
        //  VALIDATE("Sell-to Customer No.",GetFilterCustNo);

        //IF GetFilterContNo <> '' THEN
        //  VALIDATE("Sell-to Contact No.",GetFilterContNo);

        //"Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header","Document Type","No.");
    end;

    trigger OnRename()
    begin
        Error(Text003,TableCaption);
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
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Cust: Record Customer;
        SalesCommentLine: Record "Sales Comment Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
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

    procedure InitInsert()
    begin
        if "No." = '' then begin
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
        end;

        InitRecord;
    end;

    procedure InitRecord()
    begin
        AddOnSetup.Get;



        "Posting Date" := WorkDate;
        "Document Date" := WorkDate;



        //"Posting Description" := FORMAT("Document Type") + ' ' + "No.";
    end;

    local procedure InitNoSeries()
    begin
    end;

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

    local procedure TestNoSeries(): Boolean
    begin
        AddOnSetup.Get;

        case "Document Type" of
          "Document Type"::Exchange:
            AddOnSetup.TestField(AddOnSetup."Item Exchange Nos.");
          "Document Type"::Loan:
            AddOnSetup.TestField(AddOnSetup."Item Loan Nos.");
          "Document Type"::Borrow:
            begin
              AddOnSetup.TestField(AddOnSetup."Item Borrow Nos.");
            end;

          "Document Type"::Consignation:
            begin
              AddOnSetup.TestField(AddOnSetup."Item Consignation Nos.");
              //SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
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

        end;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        //IF "Document Type" IN ["Document Type"::"5","Document Type"::Consignation] THEN
        //  EXIT(SalesSetup."Posted Credit Memo Nos.");
        //EXIT(SalesSetup."Posted Invoice Nos.");
    end;

    local procedure TestNoSeriesDate(No: Code[20];NoSeriesCode: Code[10];NoCapt: Text[1024];NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "No. Series";
    begin
        /*
        IF (No <> '') AND (NoSeriesCode <> '') THEN BEGIN
          NoSeries.GET(NoSeriesCode);
          IF NoSeries."Date Order" THEN
            ERROR(
              Text045,
              FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
              NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
              NoCapt,No);
        END;
        */

    end;

    procedure ConfirmDeletion(): Boolean
    begin
        /*
        SalesPost.TestDeleteHeader(
          Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
          SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt);
        IF SalesShptHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text009,TRUE,
               SalesShptHeader."No.")
          THEN
            EXIT;
        IF SalesInvHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text012,TRUE,
               SalesInvHeader."No.")
          THEN
            EXIT;
        IF SalesCrMemoHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text014,TRUE,
               SalesCrMemoHeader."No.")
          THEN
            EXIT;
        IF ReturnRcptHeader."No." <> '' THEN
          IF NOT CONFIRM(
               Text030,TRUE,
               ReturnRcptHeader."No.")
          THEN
            EXIT;
        IF "Prepayment No." <> '' THEN
          IF NOT CONFIRM(
               Text056,TRUE,
               SalesInvHeaderPrepmt."No.")
          THEN
            EXIT;
        IF "Prepmt. Cr. Memo No." <> '' THEN
          IF NOT CONFIRM(
               Text057,TRUE,
               SalesCrMemoHeaderPrepmt."No.")
          THEN
            EXIT;
        EXIT(TRUE);
        */

    end;

    procedure SalesLinesExist(): Boolean
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","No.");
        exit(SalesLine.FindFirst);
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20];Type5: Integer;No5: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,SourceCodeSetup.Sales,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

        if (OldDimSetID <> "Dimension Set ID") and SalesLinesExist then begin
          Modify;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        end;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        if "No."<> '' then
          Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
          Modify;
          if SalesLinesExist then
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",StrSubstNo('%1 %2',"Document Type","Posting Date"),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
          Modify;
          if SalesLinesExist then
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer;OldParentDimSetID: Integer)
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

        SalesLine.Reset;
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","No.");
        SalesLine.LockTable;
        if SalesLine.Find('-') then
          repeat
            NewDimSetID := DimMgt.GetDeltaDimSetID(SalesLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            if SalesLine."Dimension Set ID" <> NewDimSetID then begin
              SalesLine."Dimension Set ID" := NewDimSetID;
              DimMgt.UpdateGlobalDimFromDimSetID(
                SalesLine."Dimension Set ID",SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code");
              SalesLine.Modify;
              ATOLink.UpdateAsmDimFromSalesLine(SalesLine);
            end;
          until SalesLine.Next = 0;
    end;

    procedure InvoicedLineExists(): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type","Document Type");
        SalesLine.SetRange("Document No.","No.");
        SalesLine.SetFilter(Type,'<>%1',SalesLine.Type::" ");
        SalesLine.SetFilter("Quantity Invoiced",'<>%1',0);
        exit(not SalesLine.IsEmpty);
    end;

    procedure GetCardpageID(): Integer
    begin
        /*
        CASE "Document Type" OF
          "Document Type"::Exchange:
            EXIT(PAGE::"Sales Quote");
          "Document Type"::Loan:
            EXIT(PAGE::"Sales Order");
          "Document Type"::Borrow:
            EXIT(PAGE::"Sales Invoice");
          "Document Type"::Consignation:
            EXIT(PAGE::"Sales Credit Memo");
          "Document Type"::"4":
            EXIT(PAGE::"Blanket Sales Order");
          "Document Type"::"5":
            EXIT(PAGE::"Sales Return Order");
        END;
        */

    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date","No.");
        NavigateForm.Run;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",StrSubstNo('%1 %2',TableCaption,"No."));
    end;
}

