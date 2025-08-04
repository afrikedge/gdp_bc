pageextension 50012 pageextension70000105 extends "Purchase List"
{
    layout
    {
        addafter("Currency Code")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}

