pageextension 50061 pageextension70000123 extends "Revaluation Journal"
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field("Ref Cargo"; Rec."Ref Cargo")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Modification on "Action 75.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF CONFIRM(
             STRSUBSTNO(
               Text001,
        #4..7
          CalcInvtValue.RUNMODAL;
          CLEAR(CalcInvtValue);
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        #1..10
        */
        //end;
    }
}

