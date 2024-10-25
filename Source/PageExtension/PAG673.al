pageextension 50045 pageextension70000130 extends "Job Queue Entry Card"
{
    layout
    {
        addafter("Description")
        {
            field("Notify on Error"; Rec."Notify on Error")
            {
            }
            field("Notify E-Mail"; Rec."Notify E-Mail")
            {
            }
            field("Run After Error"; Rec."Run After Error")
            {
            }
        }
    }
}

