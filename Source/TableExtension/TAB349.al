tableextension 50047 "A02 Dimension Value" extends "Dimension Value"
{
    fields
    {
        field(50000; "Old Code"; Code[20])
        {
            Caption = 'Old Code';
            NotBlank = false;
        }
    }
}

