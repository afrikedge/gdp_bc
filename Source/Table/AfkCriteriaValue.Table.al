table 50105 "Afk Criteria Value"
{
    Caption = 'Afk Criteria Value';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Criteria Code"; Enum "Afk Requirement")
        {
            Caption = 'Criteria Code';
        }
        field(2; "Value Type"; Enum "Afk Value Type")
        {
            Caption = 'Value Type';
        }
        field(3; "Value"; Text[20])
        {
            Caption = 'Value';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Point; Integer)
        {
            Caption = 'Point';
        }
    }
    keys
    {
        key(PK; "Criteria Code","Value Type")
        {
            Clustered = true;
        }
    }
}
