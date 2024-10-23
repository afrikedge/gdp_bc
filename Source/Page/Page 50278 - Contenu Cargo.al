page 50278 "Contenu Cargo"
{
    Editable = false;
    PageType = List;
    SourceTable = "Contenu Cargo";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Ref Cargo"; Rec."Ref Cargo")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Purchased Quantity"; Rec."Purchased Quantity")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Cost Updated"; Rec."Cost Updated")
                {
                }
                field("Last Unit Cost"; Rec."Last Unit Cost")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(CargoEntries)
            {
                Caption = 'Cargo entries';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Cargo Entries";
                RunPageLink = "Ref Cargo" = FIELD("Ref Cargo"),
                              "Item No." = FIELD("Item No.");
            }
        }
    }
}

