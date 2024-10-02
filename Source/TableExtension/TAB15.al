tableextension 50003 "A02 G/L Account" extends "G/L Account"
{
    fields
    {
        field(50000; "Purchased Account"; Boolean)
        {
            Caption = 'Purchased Account';

            trigger OnValidate()
            begin
                //***************************************************************
                IF "Purchased Account" THEN BEGIN
                    TESTFIELD("Gen. Prod. Posting Group");
                    TESTFIELD(Rec."Account Type", Rec."Account Type"::Posting);
                END;
                //***************************************************************
            end;
        }
        field(50001; "Migration Account"; Boolean)
        {
        }
    }
}

