page 50051 "Moneytech Import"
{
    PageType = Document;
    SourceTable = "MoneyTech Import";
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
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Import date';
                }
                field("Tranche Horaire"; Rec."Tranche Horaire")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Posting Description"; Rec."Posting Description")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Credit Notes Import Jrnal"; Rec."Credit Notes Import Jrnal")
                {
                }
                field("Debit Notes Import Jrnal"; Rec."Debit Notes Import Jrnal")
                {
                }
                field("Total Charge"; Rec."Total Charge")
                {
                }
                field("Total Decharge"; Rec."Total Decharge")
                {
                }
            }
            part(Lines; "MoneyTech Import Line subform")
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
                    SQLMgt.ImportMoneyTechEntries(Rec, Rec."Tranche Horaire");
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
                    MoneyTechMgt.CreateJournalEntries(Rec);
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
                    MoneyTechMgt.DeleteAllEntries(Rec);
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
            action("<Report Import MoneyTech>")
            {
                Caption = 'Recap Import MoneyTech';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MoneyTech.SetFilter("No.", Rec."No.");
                    REPORT.Run(REPORT::"Recap Import MoneyTech", true, false, MoneyTech);
                end;
            }
            action("<Report NC/ND>")
            {
                Caption = 'Imprimer NC/ND';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // MoneyTech.SetFilter("No.", Rec."No.");
                    // REPORT.Run(REPORT::"ND/NC MT Before Post", true, false, MoneyTech);
                end;
            }
        }
    }

    var
        MoneyTechMgt: Codeunit "Conso by Cards Mgt";
        SQLMgt: Codeunit "SQL Mgt";
        MoneyTech: Record "MoneyTech Import";
}

