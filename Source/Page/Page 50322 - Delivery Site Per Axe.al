page 50322 "Delivery Site Per Axe"
{
    Caption = 'Delivery Site per axe';
    PageType = List;
    SourceTable = "Delivery Constraint";
    SourceTableView = WHERE(Type = CONST(PointLivraisonAxe));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                }
                field("Customer Site"; Rec."Customer Site")
                {
                }
                field(Axe1; Rec.Axe1)
                {
                    Caption = 'Axe ';
                }
                field("Customer Site Name"; Rec."Customer Site Name")
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
        Rec.Type := Rec.Type::PointLivraisonAxe;
    end;

    var
        LocationCode: Code[10];
        Text001: Label 'Veuillez sélectionner un filtre dépot';
}

