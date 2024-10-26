page 50263 "Region Users"
{
    Caption = 'Region Users';
    PageType = List;
    SourceTable = "Security Item";
    SourceTableView = WHERE(SecurityType = CONST(Region));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("Item Code"; Rec."Item Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

