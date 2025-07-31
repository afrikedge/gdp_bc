pageextension 50105 "Afk Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        addafter("Assigned User ID")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}
