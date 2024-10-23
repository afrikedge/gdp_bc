page 50192 "Transfer Reason Codes"
{
    PageType = List;
    SourceTable = "Transfer Reason Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Reason Description"; Rec."Reason Description")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

