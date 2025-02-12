table 50109 "Afk Web Link Document"
{
    Caption = 'Web Link Document';
    DataClassification = CustomerContent;

    fields
    {
        // field(1; "Record Id"; Guid)
        // {
        //     Caption = 'Record Id';
        // }
        field(1; "Function Code"; Code[20])
        {
            Caption = 'Function Code';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Document Name"; Text[100])
        {
            Caption = 'Document Name';
        }
        field(4; Link; Text[250])
        {
            Caption = 'Link';
        }
        field(5; "Created By"; Code[50])
        {
            Caption = 'Created By';
            TableRelation = "Afk FrontDesk User";
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Function Code", "Document No.", "Document Name")
        {
            Clustered = true;
        }
    }
}
