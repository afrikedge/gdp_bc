page 50276 "Cargo Journal"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Cargo Journal Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Ref Cargo"; Rec."Ref Cargo")
                {
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Entry Type"; Rec."Entry Type")
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
                    Visible = false;
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    Visible = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Cargo Type"; Rec."Cargo Type")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = '&Valider';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                begin
                    PostCargo.PostAjustement;
                end;
            }
            action(Calcul)
            {
                Caption = 'Calcul';

                trigger OnAction()
                begin
                    Message('%1', PostCargo.GetUnitCostCargaison('1611BIS', '42001-0000'));
                end;
            }
        }
    }

    var
        PostCargo: Codeunit "Item Value Cargo Mgt";
}

