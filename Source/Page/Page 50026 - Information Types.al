page 50026 "Information Types"
{
    Caption = 'Information Type PO Tracking';
    PageType = List;
    SourceTable = "PO Tracking Information";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

