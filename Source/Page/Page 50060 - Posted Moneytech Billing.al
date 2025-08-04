page 50060 "Posted Moneytech Billing"
{
    Editable = false;
    PageType = Document;
    SourceTable = "Posted MoneyTech Billing";
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
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Import date';
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
            part(Lines; "Posted Mny Billing subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportTrans)
            {
                Caption = 'Import transactions from database';
                Ellipsis = true;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //SQLMgt.ImportMoneyTechEntries(Rec);
                end;
            }
            action(CreateEntries)
            {
                Caption = 'Create entries';
                Ellipsis = true;
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //MoneyTechMgt.CreateJournalEntries(Rec);
                end;
            }
            action(DeleteEntries)
            {
                Caption = 'Delete unposted entries in Journal';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //MoneyTechMgt.DeleteAllEntries(Rec);
                end;
            }
            action("Sales Journal")
            {
                Caption = 'Sales Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Journal";
            }
        }
    }

    var
        MoneyTechMgt: Codeunit "Conso by Cards Mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

