page 50050 "Profit Centers"
{
    Caption = 'Profit Centers';
    PageType = List;
    SourceTable = "Profit Center";

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

