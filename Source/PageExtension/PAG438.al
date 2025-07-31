pageextension 50039 pageextension70000085 extends "Issued Reminder"
{
    actions
    {
        addafter("&Reminder")
        {
            action(ImprTest)
            {
                Caption = 'ImprTest';
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Header: Record "297";
                begin
                    Header.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(50074, TRUE, FALSE, Header);
                end;
            }
        }
    }
}

