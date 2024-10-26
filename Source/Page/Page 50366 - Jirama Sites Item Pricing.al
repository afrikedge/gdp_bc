page 50366 "Jirama Sites Item Pricing"
{
    Caption = 'Prix de vente sites JIRAMA';
    PageType = List;
    SourceTable = "Item Charge Pricing";
    SourceTableView = WHERE("Service Type" = CONST(JiramaSite));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Price; Rec.Price)
                {
                    Caption = 'Price';
                }
            }
        }
    }

    actions
    {
    }
}

