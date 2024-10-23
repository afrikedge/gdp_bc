page 50277 "Item Cargo Entries"
{
    Caption = 'Item Cargo Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Item Cargo Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Ref Cargo"; Rec."Ref Cargo")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                }
                field(Positive; Rec.Positive)
                {
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    Visible = false;
                }
                field("Cargo Type"; Rec."Cargo Type")
                {
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Journal; Rec.Journal)
                {
                }
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Sales Channel Name"; Rec."Sales Channel Name")
                {
                }
                field("System Entry"; Rec."System Entry")
                {
                    Visible = false;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
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
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            action(ItemEntries)
            {
                Caption = 'Item ledger entry';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Entry No." = FIELD("Item Ledger Entry No.");
            }
            action(ValueEntries)
            {
                Caption = 'Value entries';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Value Entries";
                RunPageLink = "Item Ledger Entry No." = FIELD("Item Ledger Entry No.");
            }
        }
    }

    var
        Navigate: Page Navigate;
    //ReverseCargoEntry: Report "Reverse Cargo Entry";
}

