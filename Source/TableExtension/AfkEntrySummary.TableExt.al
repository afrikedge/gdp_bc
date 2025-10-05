namespace gdp_bc.gdp_bc;

using Microsoft.Inventory.Tracking;

tableextension 50082 "Afk Entry Summary" extends "Entry Summary"
{
    keys
    {
        key(AfkKey1; "Expiration Date") { }
    }
}
