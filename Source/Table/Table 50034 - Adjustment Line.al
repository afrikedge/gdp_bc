table 50034 "Adjustment Line"
{
    // IF "Document No."<>'' THEN BEGIN
    //   GetDocumentHeader;
    //   AdjustHeader.TESTFIELD(AdjustHeader."Item Category Code");
    //   Item1.SETRANGE("Item Category Code",AdjustHeader."Item Category Code");
    //   IF PAGE.RUNMODAL(PAGE::"Item List", Item1) = ACTION::LookupOK THEN
    //     VALIDATE(Rec."Item No." , Item1."No.");
    // END;

    Caption = 'Adjustment Line';
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Exchange,Loan,Borrow,Consignation,Shipment,Invoiced Consumption,FA Conso,Transfer';
            OptionMembers = Exchange,Loan,Borrow,Consignation,Shipment,"Invoiced Consumption","FA Conso",Transfer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Item No."; Code[20])
        {
            Caption = 'Item Code';
            TableRelation = Item;//WHERE(Type = CONST(Inventory));

            trigger OnValidate()
            var
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
            begin

                TestStatusOpen;

                //TESTFIELD("Quantity Shipped",0);
                GetDocumentHeader;
                AdjustHeader.TestField("Item Category Code");

                GetItem1();
                Item1.TestField("Item Category Code", AdjustHeader."Item Category Code");
                Item1.TestField(Blocked, false);
                Item1.TestField("Gen. Prod. Posting Group");
                if Item1.Type = Item1.Type::Inventory then begin
                    Item1.TestField("Inventory Posting Group");
                end;
                Description := Item1.Description;
                Validate("Unit of Measure Code", Item1."Base Unit of Measure");
                "ToCharge %" := Item1."ToCharge %";

                "Item Category Code" := Item1."Item Category Code";

                Validate(Quantity);

                //TODO Migration
                // CreateDim(DATABASE::"Fixed Asset",Rec."FA Code",
                //   DimMgt.TypeToTableID3(2),"Item No.",
                //DATABASE::"Responsibility Center","Responsibility Center");
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Item Category Code" = FIELD("Item Category Code"),
                                            "Location Type" = CONST(" "));

            trigger OnValidate()
            begin
                TestStatusOpen;

                //TODO Migration
                //AFK_SecMgt.CheckWarehouseUser("Location Code");

                //IF Rec."Document Type" IN [Rec."Document Type"::Borrow,Rec."Document Type"::Loan,Rec."Document Type"::Exchange] THEN
                if Loc1.Get("Location Code") then
                    Loc1.TestField(Loc1."Item Category Code", Rec."Item Category Code");
            end;
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                TestStatusOpen;

                if Quantity <> 0 then
                    TestField("Item No.");
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(16; "Exchange Type"; Option)
        {
            Caption = 'Transfer Type';
            OptionCaption = 'Ship,Receipt';
            OptionMembers = Ship,Receive;
        }
        field(22; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(23; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                //IF CurrFieldNo <> 0 THEN
                //  TestStatusOpen;
                //TESTFIELD("Qty. per Unit of Measure",1);
                //VALIDATE(Quantity,"Quantity (Base)");
            end;
        }
        field(24; "Returned Qty"; Decimal)
        {
            Caption = 'Returned Quantity';
            Editable = false;
        }
        field(25; "Qty to return"; Decimal)
        {
            Caption = 'Qty to return';

            trigger OnValidate()
            begin
                if "Qty to return" + "Returned Qty" > Quantity then
                    Error(Text002);
            end;
        }
        field(26; "Qty to invoice"; Decimal)
        {
            Caption = 'Qty to invoice';

            trigger OnValidate()
            begin
                if "Qty to return" + "Returned Qty" > Quantity then
                    Error(Text002);
            end;
        }
        field(27; "Invoiced Qty"; Decimal)
        {
            Caption = 'Invoiced quantity';
            Editable = false;
        }
        field(29; "Transfer Fees"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Transfer Fees';
        }
        field(39; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(42; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";
        }
        field(45; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = Job;
        }
        field(46; "Qty Restante Consignation"; Decimal)
        {
            Caption = 'Quantité restante en consignation';
            Editable = false;
        }
        field(61; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(62; "Qty to receive Adj"; Decimal)
        {
            Caption = 'Qty to receive Adj';
            Editable = false;
        }
        field(70; "Customer No."; Code[20])
        {
            Caption = 'Station Code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust1.Get("Customer No.") then "Customer Name" := Cust1.Name;
            end;
        }
        field(71; "Customer Name"; Text[50])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(72; "ToCharge %"; Decimal)
        {
            Caption = 'To be charged %';
            Editable = false;
        }
        field(73; "FA Code"; Code[20])
        {
            Caption = 'FA Code';
            TableRelation = "Fixed Asset";

            trigger OnValidate()
            begin
                //TODO Migration
                // if FA.Get("FA Code") then "FA Name" := FA.Description;
                // CreateDim(
                //   DATABASE::"Responsibility Center","Responsibility Center",
                //   DATABASE::"Fixed Asset","FA Code",DimMgt.TypeToTableID3(2),"Item No.");
            end;
        }
        field(74; "FA Name"; Text[50])
        {
            Caption = 'FA Name';
            Editable = false;
        }
        field(75; AmountToBeInvoice; Decimal)
        {
            Caption = 'Amount to invoice';
            Editable = false;
        }
        field(76; "USD Unit Price"; Decimal)
        {
            Caption = 'USD Unit Price';
        }
        field(77; "USD Rate"; Decimal)
        {
            Caption = 'USD Rate';
        }
        field(78; "GRT Storage Fee"; Boolean)
        {
            Caption = 'GRT Storage Fee';
        }
        field(79; "LPSA Storage Fee"; Boolean)
        {
            Caption = 'LPSA Storage Fee';
        }
        field(80; "Exchange Transit Location"; Code[10])
        {
            Caption = 'Exchange Transit Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Item Category Code" = FIELD("Item Category Code"));
        }
        field(81; "Exch Transit Transfer Fee"; Boolean)
        {
            Caption = 'Transit Transfer Fee';
        }
        field(82; "USD Unit Price 2"; Decimal)
        {
            Caption = 'USD Unit Price 2';
        }
        field(83; "Ambiant Volume"; Decimal)
        {
            Caption = 'Ambiant Volume';
        }
        field(84; "Order Line No"; Integer)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
                UnitOfMeasure: Record "Unit of Measure";
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
                TestStatusOpen;
                if "Unit of Measure Code" = '' then
                    "Unit of Measure" := ''
                else begin
                    if not UnitOfMeasure.Get("Unit of Measure Code") then
                        UnitOfMeasure.Init;
                    "Unit of Measure" := UnitOfMeasure.Description;
                end;

                GetItem1();

                Validate("Qty. per Unit of Measure", UOMMgt.GetQtyPerUnitOfMeasure(Item1, "Unit of Measure Code"));
                Validate(Quantity);
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                //TODO Migration
                // CreateDim(
                //   DATABASE::"Responsibility Center","Responsibility Center",
                //   DimMgt.TypeToTableID3(2),"Item No.",
                //   DATABASE::"Fixed Asset","FA Code");
            end;
        }
        field(50000; "Qty. in Transit"; Decimal)
        {
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                if Quantity <> 0 then
                    TestField("Item No.");
                "Qty. in Transit (Base)" := CalcBaseQty("Qty. in Transit");
            end;
        }
        field(50001; "Qty. in Transit (Base)"; Decimal)
        {
            Caption = 'Qty. in Transit (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50002; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            Editable = false;
            TableRelation = Location;
        }
        field(50003; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            Editable = false;
            TableRelation = Location;
        }
        field(50004; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
            Editable = false;
        }
        field(50005; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Cancelled';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Cancelled;
        }
        field(50030; "Batch Number"; Code[100])
        {
            Caption = 'Batch Number';
        }
        field(50031; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
        }
        key(Key2; "Transfer-to Code", Status, "Item No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Receipt Date")
        {
            SumIndexFields = "Qty. in Transit (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        TestStatusOpen;

        /*
        SalesCommentLine.SETRANGE("Document Type","Document Type");
        SalesCommentLine.SETRANGE("No.","Document No.");
        SalesCommentLine.SETRANGE("Document Line No.","Line No.");
        IF NOT SalesCommentLine.ISEMPTY THEN
          SalesCommentLine.DELETEALL;
        */

    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        AdjustHeader: Record "Adjustment Header";
        AddOnSetup: Record "AddOn Setup";
        DimMgt: Codeunit DimensionManagement;
        UnitOfMeasure: Record "Unit of Measure";
        Item1: Record Item;
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'Vous ne pouvez pas rembourser une quantité supérieure à la quantité prêtée';
        Cust1: Record Customer;
        Text003: Label 'La quantité a déjà été expédiée';
        FA: Record "Fixed Asset";
        Loc1: Record Location;
    //AFK_SecMgt: Codeunit "Security Mgt";

    procedure SetSalesHeader(NewSalesHeader: Record "Sales Header")
    begin
    end;

    local procedure GetDocumentHeader()
    begin
        TestField("Document No.");
        if ("Document Type" <> AdjustHeader."Document Type") or ("Document No." <> AdjustHeader."No.") then begin
            AdjustHeader.Get("Document Type", "Document No.");

        end;
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No.", "Line No."));

        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        //TODO Migration
        // SourceCodeSetup.Get;
        // TableID[1] := Type1;
        // No[1] := No1;
        // TableID[2] := Type2;
        // No[2] := No2;
        // TableID[3] := Type3;
        // No[3] := No3;
        // "Shortcut Dimension 1 Code" := '';
        // "Shortcut Dimension 2 Code" := '';
        // GetDocumentHeader;
        // "Dimension Set ID" :=
        //   DimMgt.GetDefaultDimID(
        //     TableID,No,SourceCodeSetup.Sales,
        //     "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
        //     AdjustHeader."Dimension Set ID",DATABASE::Customer);
        // DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        // //ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure GetSalesSetup()
    begin
        //IF NOT SalesSetupRead THEN
        AddOnSetup.Get;
        //SalesSetupRead := TRUE;
    end;

    local procedure TestStatusOpen()
    begin

        GetDocumentHeader;
        //IF NOT "System-Created Entry" THEN
        //  IF Type <> Type::" " THEN
        AdjustHeader.TestField(Status, AdjustHeader.Status::Open);

        if AdjustHeader."Document Type" = AdjustHeader."Document Type"::Shipment then
            if AdjustHeader."Shipment Status" = AdjustHeader."Shipment Status"::Shipped then
                Error(Text003)
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(Round(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure GetItem1()
    begin
        TestField("Item No.");
        if "Item No." <> Item1."No." then
            Item1.Get("Item No.");
    end;

    procedure AFK_RefreshAdjustQty()
    var
        AdjReason: Record "Transfer Reason Code";
        TotalAdjustQty: Decimal;
    begin
        AdjReason.Reset;
        AdjReason.SetRange(AdjReason."Document Type", AdjReason."Document Type"::Transfer);
        AdjReason.SetRange(AdjReason."Document No.", Rec."Document No.");
        AdjReason.SetRange(AdjReason."Line No.", Rec."Line No.");
        if AdjReason.FindSet then
            repeat
                TotalAdjustQty := TotalAdjustQty + AdjReason."Adjust Qty";
            until AdjReason.Next = 0;

        Rec."Qty to receive Adj" := Rec."Qty to return" + TotalAdjustQty;
    end;

    procedure RefreshItemCategory()
    begin
        if "Document No." <> '' then begin
            GetDocumentHeader;
            AdjustHeader.TestField(AdjustHeader."Item Category Code");
            "Item Category Code" := AdjustHeader."Item Category Code";
        end;
    end;
}

