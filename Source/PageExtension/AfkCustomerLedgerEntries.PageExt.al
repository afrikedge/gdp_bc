pageextension 50095 "Afk Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Customer Name2"; Rec."Customer Name2")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addbefore("Show Document")
        {
            action("Receipt")
            {
                ToolTip = 'Print receipt';
                Image = PrintForm;
                Caption = 'Print receipt';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Recpt: Record "Cust. Ledger Entry";
                begin
                    Recpt.SetRange("Entry No.", Rec."Entry No.");
                    Recpt.SetRange("Customer No.", Rec."Customer No.");
                    Recpt.SetRange("Posting Date", Rec."Posting Date");
                    Recpt.SetRange("Document Type", Rec."Document Type");
                    Report.Run(50051, true, false, Recpt);
                end;
            }
            action("Zero Lettering")
            {
                ToolTip = 'Print zero lettering';
                Image = PrintForm;
                Caption = 'Print zero lettering';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Recpt: Record "Cust. Ledger Entry";
                begin
                    Recpt.SetRange("Entry No.", Rec."Entry No.");
                    Report.Run(50053, true, false, Recpt);
                end;
            }
            action("Invoice NC/ND")
            {
                ToolTip = 'Print Invoice NC/ND';
                Image = PrintForm;
                Caption = 'Print Invoice NC/ND';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Inv: Record "Cust. Ledger Entry";
                begin
                    Inv.SetRange("Entry No.", Rec."Entry No.");
                    Inv.SetRange("Document No.", Rec."Document No.");
                    Report.Run(50195, true, false, Inv);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        Rec.SetRange("User ID", UserId);
    end;
}
