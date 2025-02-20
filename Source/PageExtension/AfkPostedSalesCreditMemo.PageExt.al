namespace gdp_bc.gdp_bc;

using Microsoft.Sales.History;

pageextension 50108 "Afk Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field(Observations; Rec.Observations)
            {
                MultiLine = true;
                Editable = false;
            }
        }
    }
}
