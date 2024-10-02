table 50080 "Item Journal Buffer BCK"
{
    Caption = 'Item Journal Buffer';

    fields
    {
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(8;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(12;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(5402;"Variant Code";Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE ("Item No."=FIELD("Item No."));
        }
        field(5802;"Inventory Value (Calculated)";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Inventory Value (Calculated)';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Line No.")
        {
        }
        key(Key2;"Item No.","Location Code","Variant Code")
        {
        }
        key(Key3;"Item No.","Variant Code")
        {
        }
    }

    fieldgroups
    {
    }
}

