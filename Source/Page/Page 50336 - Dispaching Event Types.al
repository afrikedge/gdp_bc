page 50336 "Dispaching Event Types"
{
    Caption = 'Stats Types Dispaching';
    PageType = List;
    SourceTable = "Dispaching Event Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Event Group"; Rec."Event Group")
                {
                }
                field("Event Type"; Rec."Event Type")
                {
                }
                field("Event Code"; Rec."Event Code")
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

