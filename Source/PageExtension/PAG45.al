pageextension 50010 pageextension70000087 extends "Sales List"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Reliquat Number"; Rec."Reliquat Number")
            {
                ApplicationArea = All;
            }
            field("Dispatching Status"; Rec."Dispatching Status")
            {
                ApplicationArea = All;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}

