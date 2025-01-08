/// <summary>
/// PageExtension Posted Sales Invoice (ID 50089) extends Posted Sales Invoice.
/// </summary>
pageextension 50089 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Print)
        {
            action("Sales Invoice Soutage")
            {
                ToolTip = 'Sales Invoice Soutage';
                Image = PrintForm;
                Caption = 'Print - Sales Invoice Soutage';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvRec: Record "Sales Invoice Header";
                begin
                    SalesInvRec.SetRange("No.", Rec."No.");
                    SalesInvRec.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    Report.Run(50192, true, false, SalesInvRec);
                end;
            }
            action("JIRAMA Sales Invoice")
            {
                ToolTip = 'JIRAMA Sales Invoice';
                Image = PrintForm;
                Caption = 'Print - JIRAMA Sales Invoice';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesInvRec: Record "Sales Invoice Header";
                begin
                    SalesInvRec.SetRange("No.", Rec."No.");
                    SalesInvRec.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                    Report.Run(50005, true, false, SalesInvRec);
                end;
            }
        }
    }
}