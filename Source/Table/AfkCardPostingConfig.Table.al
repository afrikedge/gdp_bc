table 50111 "Afk Card Posting Config"
{
    Caption = 'Afk Card Posting Config';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "File"; Code[30])
        {
            Caption = 'File';
        }
        field(2; "Entry Type"; Enum "Afk Card Posting Account Type")
        {
            Caption = 'Entry Type';
        }
        field(3; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false));
        }
    }
    keys
    {
        key(PK; "File")
        {
            Clustered = true;
        }
    }
}
