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

                trigger OnAction()
                var
                    ReverseProvisions: Report "50165";
                begin
                    CLEAR(ReverseProvisions);
                    ReverseProvisions.SetTransactionNo(Rec."From Entry No.", Rec."To Entry No.");
                    ReverseProvisions.RUN;
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

