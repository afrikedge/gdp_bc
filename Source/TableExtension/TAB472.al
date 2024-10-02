tableextension 50050 "A02 Job Queue Entry" extends "Job Queue Entry"
{
    fields
    {
        field(50000; "Notify on Error"; Boolean)
        {
            Caption = 'Notify on Error Boolean';
        }
        field(50001; "Notify E-Mail"; Text[100])
        {
            Caption = 'Notify E-Mail';
        }
        field(50002; "Run After Error"; Boolean)
        {
            Caption = 'Run After Error';
        }
    }
}

