page 50319 "Last Delivery Compatibility"
{
    Caption = 'Last Delivery InCompatibility';
    PageType = List;
    SourceTable = "Delivery Constraint";
    SourceTableView = WHERE(Type = CONST(Livraison));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Item1; Rec.Item1)
                {
                    Caption = 'Last Item ';
                }
                field(Item2; Rec.Item2)
                {
                    Caption = 'Non compatible Item ';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::Livraison;
    end;
}

