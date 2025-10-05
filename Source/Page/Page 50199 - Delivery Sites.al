page 50199 "Delivery Sites"
{
    Caption = 'Delivery Sites';
    PageType = List;
    SourceTable = "Delivery Site";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; Rec."Location Code")
                {
                }
                field(Site; Rec.Site)
                {
                }
                field("Location Name"; Rec."Location Name")
                {
                }
                field("Transport Fees"; Rec."Transport Fees")
                {
                }
                field(Desactivated; Rec.Desactivated)
                {
                }
            }
        }
    }

    actions
    {
    }
}

