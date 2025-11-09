namespace gdp_bc.gdp_bc;

enum 50025 "Afk Transport Type"
{
    Extensible = true;

    value(0; "Not applied")
    {
        Caption = 'Not applied';
    }
    value(1; City)
    {
        Caption = 'City';
    }
    value(2; "Outside city")
    {
        Caption = 'Outside city';
    }
}
