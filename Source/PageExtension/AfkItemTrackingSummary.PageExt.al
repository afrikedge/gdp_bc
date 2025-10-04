namespace gdp_bc.gdp_bc;

using Microsoft.Inventory.Tracking;

pageextension 50113 "Afk Item Tracking Summary" extends "Item Tracking Summary"
{
    trigger OnOpenPage()
    var
    begin
        Rec.SetCurrentKey("Expiration Date");
        Rec.SetAscending("Expiration Date", false);
    end;
}
