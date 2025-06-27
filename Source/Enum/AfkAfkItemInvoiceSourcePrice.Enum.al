namespace gdp_bc.gdp_bc;

enum 50024 AfkItemInvoiceSourcePrice
{
    Extensible = true;
    
    value(0; PriceList)
    {
        Caption = 'Groupe de prix client';
    }
    value(1; UnitCost)
    {
        Caption = 'Cout unitaire';
    }
}
