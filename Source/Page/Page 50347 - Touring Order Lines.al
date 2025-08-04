page 50347 "Touring Order Lines"
{
    Caption = 'Touring Order Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Touring Sales Order";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IdTouring; Rec.IdTouring)
                {
                }
                field("Order No"; Rec."Order No")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Pompe; Rec.Pompe)
                {
                }
            }
        }
    }

    actions
    {
    }
}

