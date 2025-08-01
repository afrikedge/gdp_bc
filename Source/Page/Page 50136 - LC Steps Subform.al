page 50136 "LC Steps Subform"
{
    AutoSplitKey = true;
    Caption = 'DeadLines';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    PopulateAllFields = true;
    SourceTable = "Letter of credit Expiry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Value Date"; Rec."Value Date")
                {
                }
                field("Due %"; Rec."Due %")
                {
                }
                field("Due Amount"; Rec."Due Amount")
                {
                }
                field("Total Purchased Due"; Rec."Total Purchased Due")
                {
                }
                field("Total Purchased Due (LCY)"; Rec."Total Purchased Due (LCY)")
                {
                }
                field("Balance To Pay"; Rec."Balance To Pay")
                {
                    Visible = false;
                }
                field("Provisions %"; Rec."Provisions %")
                {
                }
                field("Provisions Amount"; Rec."Provisions Amount")
                {
                }
                field("Provisions Amount Purch (LCY)"; Rec."Provisions Amount Purch (LCY)")
                {
                }
                field("Total Purchased LCY"; Rec."Total Purchased LCY")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GenerateEntries)
            {
                Caption = 'Add new payment';
                Ellipsis = true;
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GLMgt.GenerateEcriturePaiementEcheance(Rec."Document No.", Rec);
                end;
            }
        }
    }

    var
        GLMgt: Codeunit "Treso Mgt";
}

