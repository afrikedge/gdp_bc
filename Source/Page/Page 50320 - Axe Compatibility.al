page 50320 "Axe Compatibility"
{
    Caption = 'Axes Compatibility';
    PageType = List;
    SourceTable = "Delivery Constraint";
    SourceTableView = WHERE(Type = CONST(Axe));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Axe1; Rec.Axe1)
                {
                }
                field(Axe2; Rec.Axe2)
                {
                    Caption = 'Axe 2';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Axe;
    end;
}

