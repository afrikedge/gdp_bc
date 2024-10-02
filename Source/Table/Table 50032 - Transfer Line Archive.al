table 50032 "Transfer Line Archive"
{
    Caption = 'Transfer Line';
    DrillDownPageID = "Transfer Lines";
    LookupPageID = "Transfer Lines";
    PasteIsValid = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE(Type = CONST(Inventory));

            trigger OnValidate()
            var
                TempTransferLine: Record "Transfer Line" temporary;
            begin
            end;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(6; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(7; "Qty. to Receive"; Decimal)
        {
            Caption = 'Qty. to Receive';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(8; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(9; "Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(10; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(13; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(14; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(15; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(16; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(17; "Outstanding Qty. (Base)"; Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(18; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(19; "Qty. Shipped (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(20; "Qty. to Receive (Base)"; Decimal)
        {
            Caption = 'Qty. to Receive (Base)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(21; "Qty. Received (Base)"; Decimal)
        {
            Caption = 'Qty. Received (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(22; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(23; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
                UOMMgt: Codeunit "Unit of Measure Management";
            begin
            end;
        }
        field(24; "Outstanding Quantity"; Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(25; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(26; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(27; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0 : 5;
        }
        field(30; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                ItemVariant: Record "Item Variant";
            begin
            end;
        }
        field(31; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
        }
        field(32; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(33; "In-Transit Code"; Code[10])
        {
            Caption = 'In-Transit Code';
            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(true));
        }
        field(34; "Qty. in Transit"; Decimal)
        {
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(35; "Qty. in Transit (Base)"; Decimal)
        {
            Caption = 'Qty. in Transit (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(36; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            Editable = false;
            TableRelation = Location;
        }
        field(37; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            Editable = false;
            TableRelation = Location;
        }
        field(38; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(39; "Receipt Date"; Date)
        {
            Caption = 'Receipt Date';
        }
        field(40; "Derived From Line No."; Integer)
        {
            Caption = 'Derived From Line No.';
            TableRelation = "Transfer Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(41; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(42; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
        }
        field(43; "Appl.-to Item Entry"; Integer)
        {
            AccessByPermission = TableData Item = R;
            Caption = 'Appl.-to Item Entry';

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                ItemTrackingLines: Page "Item Tracking Lines";
            begin
            end;
        }
        field(50; "Reserved Quantity Inbnd."; Decimal)
        {
            CalcFormula = Sum("Reservation Entry".Quantity WHERE("Source ID" = FIELD("Document No."),
                                                                  "Source Ref. No." = FIELD("Line No."),
                                                                  "Source Type" = CONST(5741),
                                                                  "Source Subtype" = CONST("1"),
                                                                  "Source Prod. Order Line" = FIELD("Derived From Line No."),
                                                                  "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity Inbnd.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Reserved Quantity Outbnd."; Decimal)
        {
            CalcFormula = - Sum("Reservation Entry".Quantity WHERE("Source ID" = FIELD("Document No."),
                                                                   "Source Ref. No." = FIELD("Line No."),
                                                                   "Source Type" = CONST(5741),
                                                                   "Source Subtype" = CONST("0"),
                                                                   "Source Prod. Order Line" = FIELD("Derived From Line No."),
                                                                   "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity Outbnd.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "Reserved Qty. Inbnd. (Base)"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE("Source ID" = FIELD("Document No."),
                                                                           "Source Ref. No." = FIELD("Line No."),
                                                                           "Source Type" = CONST(5741),
                                                                           "Source Subtype" = CONST("1"),
                                                                           "Source Prod. Order Line" = FIELD("Derived From Line No."),
                                                                           "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. Inbnd. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Reserved Qty. Outbnd. (Base)"; Decimal)
        {
            CalcFormula = - Sum("Reservation Entry"."Quantity (Base)" WHERE("Source ID" = FIELD("Document No."),
                                                                            "Source Ref. No." = FIELD("Line No."),
                                                                            "Source Type" = CONST(5741),
                                                                            "Source Subtype" = CONST("0"),
                                                                            "Source Prod. Order Line" = FIELD("Derived From Line No."),
                                                                            "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. Outbnd. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Time';
        }
        field(55; "Reserved Quantity Shipped"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry".Quantity WHERE("Source ID" = FIELD("Document No."),
                                                                  "Source Ref. No." = FILTER(<> 0),
                                                                  "Source Type" = CONST(5741),
                                                                  "Source Subtype" = CONST("1"),
                                                                  "Source Prod. Order Line" = FIELD("Line No."),
                                                                  "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Quantity Shipped';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(56; "Reserved Qty. Shipped (Base)"; Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE("Source ID" = FIELD("Document No."),
                                                                           "Source Ref. No." = FILTER(<> 0),
                                                                           "Source Type" = CONST(5741),
                                                                           "Source Subtype" = CONST("1"),
                                                                           "Source Prod. Order Line" = FIELD("Line No."),
                                                                           "Reservation Status" = CONST(Reservation)));
            Caption = 'Reserved Qty. Shipped (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(5704; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5707; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            //TableRelation = "Product Group".Code WHERE ("Item Category Code"=FIELD("Item Category Code"));
        }
        field(5750; "Whse. Inbnd. Otsdg. Qty (Base)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" WHERE("Source Type" = CONST(5741),
                                                                                        "Source Subtype" = CONST("1"),
                                                                                        "Source No." = FIELD("Document No."),
                                                                                        "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse. Inbnd. Otsdg. Qty (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5751; "Whse Outbnd. Otsdg. Qty (Base)"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE("Source Type" = CONST(5741),
                                                                                         "Source Subtype" = CONST("0"),
                                                                                         "Source No." = FIELD("Document No."),
                                                                                         "Source Line No." = FIELD("Line No.")));
            Caption = 'Whse Outbnd. Otsdg. Qty (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752; "Completely Shipped"; Boolean)
        {
            Caption = 'Completely Shipped';
            Editable = false;
        }
        field(5753; "Completely Received"; Boolean)
        {
            Caption = 'Completely Received';
            Editable = false;
        }
        field(5793; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(5794; "Inbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Inbound Whse. Handling Time';
        }
        field(7300; "Transfer-from Bin Code"; Code[20])
        {
            Caption = 'Transfer-from Bin Code';
            TableRelation = "Bin Content"."Bin Code" WHERE("Location Code" = FIELD("Transfer-from Code"),
                                                            "Item No." = FIELD("Item No."),
                                                            "Variant Code" = FIELD("Variant Code"));
        }
        field(7301; "Transfer-To Bin Code"; Code[20])
        {
            Caption = 'Transfer-To Bin Code';
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Transfer-to Code"));
        }
        field(50000; "Qty to receive Hypo"; Decimal)
        {
            Caption = 'Quantity to receive';

            trigger OnValidate()
            begin
                //****************************
                "Qty to receive Hypo Adj" := "Qty to receive Hypo";
            end;
        }
        field(50001; "Qty to receive Hypo Adj"; Decimal)
        {
            Caption = 'Quantity to received Adjusted';
        }
        field(50002; "Qty to receive Adj"; Decimal)
        {
            Caption = 'Qty to receive Adjusted';
        }
        field(50003; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(50004; "Qty received Hypo"; Decimal)
        {
            Caption = 'Quantity Received';
            Editable = false;
        }
        field(99000755; "Planning Flexibility"; Option)
        {
            Caption = 'Planning Flexibility';
            OptionCaption = 'Unlimited,None';
            OptionMembers = Unlimited,"None";
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Transfer-to Code", Status, "Derived From Line No.", "Item No.", "Variant Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Receipt Date", "In-Transit Code")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Qty. in Transit (Base)", "Outstanding Qty. (Base)";
        }
        key(Key3; "Transfer-from Code", Status, "Derived From Line No.", "Item No.", "Variant Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Shipment Date", "In-Transit Code")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key4; "Item No.", "Variant Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
    end;

    trigger OnInsert()
    var
        TransLine2: Record "Transfer Line";
    begin
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'must not be less than %1';
        Text003: Label 'Warehouse %1 is required for %2 = %3.';
        Text004: Label '\The entered information may be disregarded by warehouse operations.';
        Text005: Label 'You cannot ship more than %1 units.';
        Text006: Label 'All items have been shipped.';
        Text008: Label 'You cannot receive more than %1 units.';
        Text009: Label 'No items are currently in transit.';
        Text011: Label 'Outbound,Inbound';
        Text012: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text013: Label 'Cancelled.';
        TransferRoute: Record "Transfer Route";
        Item: Record Item;
        TransHeader: Record "Transfer Header";
        Location: Record Location;
        Bin: Record Bin;
        Reservation: Page Reservation;
        DimMgt: Codeunit DimensionManagement;
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
        CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
        WMSManagement: Codeunit "WMS Management";
        TrackingBlocked: Boolean;
        MustUseTrackingErr: Label 'You must use form %1 to enter %2, if item tracking is used.', Comment = '%1 = Form Name, %2 = Value to Enter';
        LedgEntryWillBeOpenedMsg: Label 'When posting the Applied to Ledger Entry %1 will be opened first.', Comment = '%1 = Entry No.';
        ShippingMoreUnitsThanReceivedErr: Label 'You cannot ship more than the %1 units that you have received for document no. %2.', Comment = '%1 = Quantity Value, %2 = Document No.';
}

