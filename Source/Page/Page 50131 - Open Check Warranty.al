page 50131 "Open Check Warranty"
{
    Caption = 'Open Check Warranty';
    PageType = List;
    SourceTable = "Check Warranty";
    SourceTableView = WHERE(Status = CONST(Open));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Check No."; Rec."Check No.")
                {
                }
                field("Check Date"; Rec."Check Date")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                    Visible = false;
                }
                field("CCL Jrnal"; Rec."CCL Jrnal")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Return)
            {
                Caption = 'Return check';
                Image = ReturnOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ComptaMgt.CloseCheckWarranty(Rec);
                end;
            }
            action(Confirmer)
            {
                Caption = 'Confirm Check';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ComptaMgt.ConfirmCheckCaution(Rec);
                end;
            }
        }
    }

    var
        ComptaMgt: Codeunit "Treso Mgt";
}

