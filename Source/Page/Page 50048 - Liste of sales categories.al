page 50048 "Liste of sales categories"
{
    Caption = 'List of sales categories';
    PageType = List;
    SourceTable = "Sales Category";
    ApplicationArea = All;
    UsageCategory = Administration;

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

