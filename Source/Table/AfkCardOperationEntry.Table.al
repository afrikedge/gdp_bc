table 50110 "Afk Card Operation Entry"
{
    Caption = 'Afk Card Operation Entry';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "File"; Code[30])
        {
            Caption = 'File';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Posted In GL"; Boolean)
        {
            Caption = 'Posted In GL';
        }
    }
    keys
    {
        key(PK; "File","Posting Date","Customer No.")
        {
            Clustered = true;
        }
    }
}
