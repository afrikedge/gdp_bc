page 50321 "Delivery Site Compatibility"
{
    Caption = 'Delivery Site Compatibility';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Delivery Constraint";
    SourceTableView = WHERE(Type = CONST(PointLivraison));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; Rec."Location Code")
                {
                }
                field(Site1; Rec.Site1)
                {
                }
                field(Site2; Rec.Site2)
                {
                }
                field("Location Name"; Rec."Location Name")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::PointLivraison;
    end;
}

