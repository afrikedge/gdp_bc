pageextension 50072 pageextension70000141 extends "Sales Return Order List"
{
    layout
    {
        addafter("Due Date")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}

