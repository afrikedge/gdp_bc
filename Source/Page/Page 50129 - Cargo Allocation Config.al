page 50129 "Cargo Allocation Config"
{
    Caption = 'Cargo Allocation Methods';
    PageType = List;
    SourceTable = "Cargo Allocation Config";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Operation Type"; Rec."Operation Type")
                {
                }
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Channel Name"; Rec."Channel Name")
                {
                }
                field("Item Code"; Rec."Item Code")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("First Priority"; Rec."First Priority")
                {
                }
                field("Second Priority"; Rec."Second Priority")
                {
                }
                field("Third Priority"; Rec."Third Priority")
                {
                }
            }
        }
    }

    actions
    {
    }
}

