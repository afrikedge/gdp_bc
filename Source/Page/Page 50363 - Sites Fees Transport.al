page 50363 "Sites Fees Transport"
{
    Caption = 'Prix de transport sur logistique (Sites Dispaching)';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Item Charge Pricing";
    SourceTableView = WHERE("Service Type" = CONST(LivraisonSite));

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
                    Caption = 'Location';
                }
                field(codetransporteur; Rec.codetransporteur)
                {
                }
                field(Site; Rec.Site)
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
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

