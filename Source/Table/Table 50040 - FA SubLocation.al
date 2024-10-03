table 50040 "FA SubLocation"
{
    Caption = 'FA Sub Location';
    // LookupPageID = "FA Sub Locations";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Location Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Location Code", "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

