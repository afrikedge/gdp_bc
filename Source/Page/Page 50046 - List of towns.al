page 50046 "List of towns"
{
    Caption = 'List of town';
    PageType = List;
    SourceTable = Town;

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
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
            }
        }
    }

    actions
    {
    }
}

