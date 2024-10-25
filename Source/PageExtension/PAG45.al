pageextension 50010 pageextension70000087 extends "Sales List"
{
    layout
    {
        addafter("Currency Code")
        {
            field("Reliquat Number"; Rec."Reliquat Number")
            {
            }
            field("Dispatching Status"; Rec."Dispatching Status")
            {
            }
            field("User ID"; Rec."User ID")
            {
            }
        }
    }
}

