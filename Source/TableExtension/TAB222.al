tableextension 50036 "A02 Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50000; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
    }
}

