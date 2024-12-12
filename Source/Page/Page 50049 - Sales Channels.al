page 50049 "Sales Channels"
{
    Caption = 'Sales channels';
    PageType = List;
    SourceTable = "Sales Channel";
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
                field("Cargo Priority"; Rec."Cargo Priority")
                {
                }
            }
        }
    }

    actions
    {
    }
}

