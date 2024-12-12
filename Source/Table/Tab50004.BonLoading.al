table 50004 BonLoading
{
    Caption = 'Bon Loading';
    DataClassification = CustomerContent;
    DrillDownPageId = "Bon Loading";

    fields
    {
        field(1; numBE; integer)
        {
            Caption = 'NumBon';
        }
        field(2; Compartment; Enum GD1Compartment)
        {
            Caption = 'Compartment';
        }
        field(3; Product; Enum "GD1 Dispaching Product")
        {
            Caption = 'Product';
            trigger OnValidate()
            var
            begin
                "Product Code" := Format(Product);
            end;
        }
        field(4; "Shipped Volume"; Decimal)
        {
            Caption = 'Shipped Volume';
        }
        field(5; "Product Code"; Code[20])
        {
            Caption = 'Product Code';
            Editable = false;
        }
    }
    keys
    {
        key(PK; numBE, Compartment)
        {
            Clustered = true;
        }

    }

}
