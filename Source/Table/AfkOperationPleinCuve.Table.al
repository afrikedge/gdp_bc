table 50112 "Afk Operation Plein Cuve"
{
    Caption = 'Operation Plein Cuve';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(3; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(4; Inactif; Boolean)
        {
            Caption = 'Inactif';
        }
    }
    keys
    {
        key(PK; "Customer No.", "Starting Date", "Ending Date")
        {
            Clustered = true;
        }
    }
}
