page 50127 "Item Fees Storage Pricing"
{
    Caption = 'Item Fees Storage Pricing';
    PageType = List;
    SourceTable = "Item Charge Pricing";
    SourceTableView = WHERE("Service Type" = CONST(Storage));

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
                field("Item No."; Rec."Item No.")
                {
                }
                field(Price; Rec.Price)
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field(Discount; Rec.Discount)
                {
                }
                field("Origin Location Name"; Rec."Origin Location Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

