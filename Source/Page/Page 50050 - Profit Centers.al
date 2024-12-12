page 50050 "Profit Centers"
{
    Caption = 'Profit Centers';
    PageType = List;
    SourceTable = "Profit Center";
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

