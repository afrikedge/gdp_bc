pageextension 50100 "Afk Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field(Observations; Rec.Observations)
            {

            }
        }
    }
}
