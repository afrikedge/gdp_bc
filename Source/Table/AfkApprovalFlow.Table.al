table 50108 "Afk Approval Flow"
{
    Caption = 'Afk Approval Flow';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Record Type"; enum "Afk Record Type")
        {
            Caption = 'Record Type';
        }
        field(2; "Record No."; Code[20])
        {
            Caption = 'Record No.';
        }
        field(3; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
        }
        field(4; "Approval Mode"; Enum "Afk Application Mode")
        {
            Caption = 'Approval Mode';
        }
        field(5; "Approved On"; Date)
        {
            Caption = 'Approved On';
        }
        field(6; "Approved by"; Code[50])
        {
            Caption = 'Approved by';
            TableRelation = "Afk FrontDesk User";
        }
        field(7; "Approved as"; Code[50])
        {
            Caption = 'Approved as';
            TableRelation = "Afk FrontDesk User";
        }
        field(8; "Actual Status"; Enum "Afk CRM Approval Status")
        {
            Caption = 'Actual Status';
        }
        field(9; "Next Status"; Enum "Afk CRM Approval Status")
        {
            Caption = 'Next Status';
        }
        field(10; Comments; Text[300])
        {
            Caption = 'Comments';
        }
    }
    keys
    {
        key(PK; "Record Type", "Record No.", "Sequence No.")
        {
            Clustered = true;
        }
    }
}
