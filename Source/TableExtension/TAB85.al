tableextension 50020 "A02 Acc. Schedule Line" extends "Acc. Schedule Line"
{
    fields
    {
        field(50000; "Debitor Balance"; Boolean)
        {
            Caption = 'Debitor Balance';
        }
        field(50001; "Creditor Balance"; Boolean)
        {
            Caption = 'Creditor Balance';
        }
    }
}

