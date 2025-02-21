table 50098 "Afk Reference"
{
    Caption = 'Afk Reference';
    DataClassification = CustomerContent;

    fields
    {

        field(1; TableType; enum "Afk Table Type")
        {
            Caption = 'TableType';
            Editable = false;
        }
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(4; Active; Boolean)
        {
            Caption = 'Active';
        }
    }
    keys
    {
        key(PK; TableType, "Code")
        {
            Clustered = true;
        }
    }
}
