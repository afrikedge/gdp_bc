pageextension 50035 pageextension70000075 extends "Item Reclass. Journal"
{
    layout
    {
        addafter("ShortcutDimCode4")
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field(Observations; Rec.Observations)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Get Bin Content")
        {
            action("Print2")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ItemJnlLine: Record "83";
                begin

                    ItemJnlLine.COPY(Rec);
                    ItemJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    //REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
                    REPORT.RUNMODAL(50052, TRUE, TRUE, ItemJnlLine);
                end;
            }
            action("&Print2")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ItemJnlLine: Record "83";
                begin

                    ItemJnlLine.COPY(Rec);
                    ItemJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    //REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
                    REPORT.RUNMODAL(50084, TRUE, TRUE, ItemJnlLine);
                end;
            }
        }
    }
}

