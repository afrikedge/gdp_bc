page 50003 "Bon Loading"
{
    ApplicationArea = All;
    Caption = 'Bon Loading';
    PageType = List;
    SourceTable = BonLoading;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Compartment; Rec.Compartment)
                {
                }
                field(Product; Rec.Product)
                {
                }
                field("Shipped Volume"; Rec."Shipped Volume")
                {
                }
            }
        }
    }



}
