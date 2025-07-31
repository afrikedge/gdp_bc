pageextension 50016 pageextension70000015 extends "G/L Registers"
{
    actions
    {
        addafter(ReverseRegister)
        {
            action(ReverseProvisions)
            {
                Caption = 'Reverse Provisions';
                Image = CancelAllLines;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ReverseProvisions: Report "50165";
                begin
                    CLEAR(ReverseProvisions);
                    ReverseProvisions.SetTransactionNo(Rec."From Entry No.", Rec."To Entry No.");
                    ReverseProvisions.RUN;
                end;
            }

            action(NCGoodies)
            {
                Image = PrintForm;
                ApplicationArea = All;
                ToolTip = 'Imprimer la Note de crédit';
                Caption = 'Imprimer la Note de crédit';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    NCGood: Record "G/L Register";
                begin
                    NCGood.SetRange("No.", Rec."No.");
                    NCGood.SetRange("Journal Templ. Name", Rec."Journal Templ. Name");
                    NCGood.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    Report.Run(50077, true, false, NCGood);
                end;
            }
        }

    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Rec.SETRANGE("User ID", USERID);
        IF Rec.FINDSET THEN;
    end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF FINDSET THEN;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    SETRANGE("User ID",USERID);

    IF FINDSET THEN;
    */
    //end;
}

