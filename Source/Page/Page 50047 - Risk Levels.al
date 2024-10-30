page 50047 "Risk Levels"
{
    Caption = 'Risk Levels';
    PageType = List;
    SourceTable = "Risk Level";
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

