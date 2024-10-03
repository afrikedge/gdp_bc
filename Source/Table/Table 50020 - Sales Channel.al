table 50020 "Sales Channel"
{
    Caption = 'Sales Channel';
    // LookupPageID = "Sales Channels";

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Code[50])
        {
        }
        field(3; "Cargo Priority"; Integer)
        {
            Caption = 'Cargo allocation Priority';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Cargo Priority")
        {
        }
    }

    fieldgroups
    {
    }
}

