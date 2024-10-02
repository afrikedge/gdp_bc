tableextension 50048 "A02 SMTP Mail Setup" extends "SMTP Mail Setup"
{
    fields
    {
        field(50000; "From Adress"; Text[80])
        {
            Caption = 'From Adress';
        }
        field(50001; "From Name"; Text[80])
        {
            Caption = 'From Name';
        }
    }
}

