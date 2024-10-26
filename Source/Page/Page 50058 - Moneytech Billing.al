page 50058 "Moneytech Billing"
{
    PageType = Document;
    SourceTable = "MoneyTech Billing";

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Total Decharge"; Rec."Total Decharge")
                {
                }
            }
            part(Lines; "MoneyTech Billing Line subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CreateLines)
            {
                Caption = 'Create lines';
                Ellipsis = true;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MoneyTechMgt.ProcessBilling(Rec);
                end;
            }
            action(CreateInvoices)
            {
                Caption = 'Create invoices';
                Ellipsis = true;
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MoneyTechMgt.CreateCardsInvoices(Rec);
                end;
            }
        }
    }

    var
        MoneyTechMgt: Codeunit "Conso by Cards Mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

