table 50104 "Afk Requirement Criteria"
{
    Caption = 'Afk Requirement Criteria';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Requirement; Enum "Afk Requirement")
        {
            Caption = 'Requirement';
        }
        field(4; Validity; Enum "Afk Validity Type")
        {
            Caption = 'Validity';
        }
        field(5; Coefficient; Decimal)
        {
            Caption = 'Coefficient';
        }
        field(6; "Point Maximal"; Decimal)
        {
            Caption = 'Point Maximal';
        }
        field(7; "Document required"; Boolean)
        {
            Caption = 'Document required';
        }
        field(8; "Value Type"; Enum "Afk Value Type")
        {
            Caption = 'Value Type';
        }
        field(9; "Value Size"; Integer)
        {
            Caption = 'Value Size';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
