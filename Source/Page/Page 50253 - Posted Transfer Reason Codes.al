page 50253 "Posted Transfer Reason Codes"
{
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Posted Transfer Reason Code";

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

