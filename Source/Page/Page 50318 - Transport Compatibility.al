page 50318 "Transport Compatibility"
{
    Caption = 'Transport Compatibility';
    PageType = List;
    SourceTable = "Delivery Constraint";
    SourceTableView = WHERE(Type = CONST(Transport));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Item1; Rec.Item1)
                {
                }
                field(Item2; Rec.Item2)
                {
                    Caption = 'Item 2';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Transport;
    end;
}

