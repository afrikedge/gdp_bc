page 50254 "Item Fees Transport Pricing"
{
    Caption = 'Item Fees Transport Pricing';
    PageType = List;
    SourceTable = "Item Charge Pricing";
    SourceTableView = WHERE("Service Type" = CONST(Transport));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field("Origin Location"; Rec."Origin Location")
                {
                }
                field("Arrival Location"; Rec."Arrival Location")
                {
                }
                field(Price; Rec.Price)
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Origin Location Name"; Rec."Origin Location Name")
                {
                }
                field("Arrival Location Name"; Rec."Arrival Location Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

