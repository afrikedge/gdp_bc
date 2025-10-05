namespace gdp_bc.gdp_bc;

using Microsoft.Sales.History;

pageextension 50114 "Afk Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}
