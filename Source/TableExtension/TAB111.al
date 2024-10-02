tableextension 50025 "A02 Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(50000; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(50013; "Sales Category Code"; Code[10])
        {
            Caption = 'Sales Category';
            TableRelation = "Sales Category";
        }
        field(50079; "Real Location"; Code[10])
        {
        }
    }
}

