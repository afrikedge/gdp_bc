page 50004 "Compartment Loading"
{
    ApplicationArea = All;
    Caption = 'Compartment Loading';
    PageType = List;
    SourceTable = "Touring Product Entry";
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Immatriculation; Compartment)
                {
                    Editable = false;
                    Enabled = false;
                }
                field(ItemNo; Rec.ItemNo)
                {
                    Caption = 'Item No.';
                    Editable = false;
                }
                field(Volume; Rec.Volume)
                {
                    Caption = 'Volume to ship';
                    Editable = false;
                }
                field("Real Shipped Volume"; Rec."Real Shipped Volume")
                {
                    Caption = 'Volume shipped';
                    Editable = (Rec.TouringStatus <> Rec.TouringStatus::Confirmed);
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        Compartment := 'C' + format(Rec.IdCompartment);
    end;

    var
        Compartment: Code[2];
}
