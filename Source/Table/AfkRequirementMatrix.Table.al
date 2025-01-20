table 50106 "Afk Requirement Matrix"
{
    Caption = 'Afk Requirement Matrix';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Legal Status"; Code[20])
        {
            Caption = 'Legal Status';
            TableRelation = "Legal Status";
        }
        field(2; "Sales Category Code"; Code[20])
        {
            Caption = 'Sales Category Code';
            TableRelation = "Sales Category";
        }
        field(3; "Sales Channel"; Code[20])
        {
            Caption = 'Sales Channel';
            TableRelation = "Sales Channel";
        }
        field(4; "Criteria Code"; Code[20])
        {
            Caption = 'Criteria Code';
            TableRelation = "Afk Requirement Criteria";
        }
        field(5; "Requirement Level"; Enum "Afk Requirement")
        {
            Caption = 'Requirement Level';
        }
    }
    keys
    {
        key(PK; "Legal Status", "Sales Category Code", "Sales Channel", "Criteria Code")
        {
            Clustered = true;
        }
    }
}
