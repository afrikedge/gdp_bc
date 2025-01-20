table 50101 "Afk FrontDeskProfilePermission"
{
    Caption = 'Permission par Profil FrontDesk';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "FrontDesk Profile"; Code[20])
        {
            Caption = 'FrontDesk Profile';
        }
        field(2; "FrontDesk Features"; Code[20])
        {
            Caption = 'FrontDesk Features';
        }
        field(3; Insertion; Boolean)
        {
            Caption = 'Insertion';
        }
        field(4; Modification; Boolean)
        {
            Caption = 'Modification';
        }
        field(5; Deletion; Boolean)
        {
            Caption = 'Deletion';
        }
        field(6; Read; Boolean)
        {
            Caption = 'Read';
        }
        field(7; Execution; Boolean)
        {
            Caption = 'Execution';
        }
    }
    keys
    {
        key(PK; "FrontDesk Profile", "FrontDesk Features")
        {
            Clustered = true;
        }
    }
}
