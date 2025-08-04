pageextension 50045 pageextension70000130 extends "Job Queue Entry Card"
{
    layout
    {
        addafter("Description")
        {
            field("Notify on Error"; Rec."Notify on Error")
            {
                ApplicationArea = All;
            }
            field("Notify E-Mail"; Rec."Notify E-Mail")
            {
                ApplicationArea = All;
            }
            field("Run After Error"; Rec."Run After Error")
            {
                ApplicationArea = All;
            }
        }
    }
}

