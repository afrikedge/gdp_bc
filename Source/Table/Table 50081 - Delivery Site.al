table 50081 "Delivery Site"
{
    Caption = 'Delivery Site';

    fields
    {
        field(1;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(2;Site;Code[30])
        {
        }
        field(3;"Location Name";Text[50])
        {
            CalcFormula = Lookup(Location.Name WHERE (Code=FIELD("Location Code")));
            Caption = 'Nom du dépôt';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Transport Fees";Decimal)
        {
            Caption = 'Transport fees';
        }
    }

    keys
    {
        key(Key1;"Location Code",Site)
        {
        }
    }

    fieldgroups
    {
    }
}

