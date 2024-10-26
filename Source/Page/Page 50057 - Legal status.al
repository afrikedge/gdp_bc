page 50057 "Legal status"
{
    Caption = 'Legal Status';
    PageType = List;
    SourceTable = "Legal Status";

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

