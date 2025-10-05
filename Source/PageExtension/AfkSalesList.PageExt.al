namespace gdp_bc.gdp_bc;

using Microsoft.Sales.Document;

pageextension 50115 "Afk Sales List" extends "Sales List"
{
    layout
    {
        addafter("Location Code")
        {
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {

            }
        }
        addafter(Status)
        {
            field("Order Date"; Rec."Order Date")
            {

            }
        }
    }
}
