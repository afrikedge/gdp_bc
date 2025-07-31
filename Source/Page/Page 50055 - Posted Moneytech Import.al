page 50055 "Posted Moneytech Import"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Posted Moneytech Import";
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
            }
            part(Lines; "Posted Mny Import Line subform")
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
            action(GLEntries)
            {
                Caption = 'G/L Entries';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "General Ledger Entries";
                RunPageLink = "External Document No." = FIELD("No.");
            }
            action("<Report Posted Import MoneyTech>")
            {
                Caption = 'Recap Import MoneyTech';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MoneyTech.SetFilter("No.", Rec."No.");
                    REPORT.Run(REPORT::"Recap Posted Import MoneyTech", true, false, MoneyTech);
                end;
            }
            action("<Report NC/ND>")
            {
                Caption = 'Imprimer NC/ND';
                Image = "report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // MoneyTech.SetFilter("No.", Rec."No.");
                    // REPORT.Run(REPORT::"ND/NC MT After Post", true, false, MoneyTech);
                end;
            }
        }
    }

    var
        MoneyTech: Record "Posted Moneytech Import";
}

