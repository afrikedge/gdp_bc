page 50199 "Delivery Sites"
{
    Caption = 'Delivery Sites';
    PageType = List;
    SourceTable = "Delivery Site";

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
            }
        }
    }

    actions
    {
    }
}

