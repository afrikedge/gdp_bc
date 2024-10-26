page 50177 "AMSA Invoicing Configuration"
{
    Caption = 'AMSA Invoicing Configuration';
    PageType = List;
    SourceTable = "AMSA Invoicing Configuration";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field(Backcharge; Rec.Backcharge)
                {
                }
                field("Cost Code"; Rec."Cost Code")
                {
                }
                field("Per Company"; Rec."Per Company")
                {
                }
                field("Per Process"; Rec."Per Process")
                {
                }
                field("Per Cost Code"; Rec."Per Cost Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

