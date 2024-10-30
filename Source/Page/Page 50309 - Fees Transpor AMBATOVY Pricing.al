page 50309 "Fees Transpor AMBATOVY Pricing"
{
    Caption = 'Item Fees Transport To Ambatovy Pricing';
    PageType = List;
    SourceTable = "Item Charge Pricing";
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTableView = WHERE("Service Type" = CONST(TransportAmbatovy));

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
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field(Price; Rec.Price)
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
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

