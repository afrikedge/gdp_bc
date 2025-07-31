page 50189 "Posted AMSA Invoice"
{
    Caption = 'Posted AMSA Invoice';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Posted Fuel Statement";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Customer No"; Rec."Customer No")
                {
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field("Total Counter"; Rec."Total Counter")
                {
                    Visible = false;
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field(Backcharge; Rec.Backcharge)
                {
                }
                field("Cost Code"; Rec."Cost Code")
                {
                }
                field("Company Code"; Rec."Company Code")
                {
                }
                field(Process; Rec.Process)
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
            }
            part(Lines; "Posted AMSA Invoice Subform")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PrintInvoice)
            {
                Caption = 'Print Invoice';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdjH: Record "Posted Fuel Statement";
                begin
                    //*******************************
                    AdjH.SetRange(AdjH."Document Type", AdjH."Document Type"::Invoice);
                    AdjH.SetRange(AdjH."No.", Rec."No.");
                    REPORT.RunModal(50046, true, false, AdjH);
                end;
            }
        }
    }

    var
        AMSAMgt: Codeunit "AMSA Sales mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

