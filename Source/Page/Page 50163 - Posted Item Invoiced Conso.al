page 50163 "Posted Item Invoiced Conso"
{
    Caption = 'Posted Item Invoiced Conso';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST("Invoiced Consumption"));

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
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
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Station Code';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Station Name';
                }
                field("Posted Doc No"; Rec."Posted Doc No")
                {
                }
            }
            part(Lines; "Posted Item Inv. Conso Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1000000012; Links)
            {
                Visible = false;
            }
            systempart(Control1000000011; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(ListeND)
            {
                Caption = 'Debit Notes';
                Ellipsis = true;
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navigate2;
                end;
            }
            action(PrintND)
            {
                Caption = 'Imprimer Note de Débitt';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdjH: Record "Posted Adjustment Header";
                begin
                    AdjH.Reset;
                    AdjH.SetRange(AdjH."Document Type", AdjH."Document Type"::"Invoiced Consumption");
                    AdjH.SetRange(AdjH."No.", Rec."No.");
                    REPORT.Run(50047, true, false, AdjH);
                end;
            }
        }
    }

    var
        ItemLoanMgt: Codeunit "Item Loan Mgt";

    procedure Navigate2()
    var
        NavigateForm: Page Navigate;
        CustLedgEntries: Page "Customer Ledger Entries";
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        Clear(CustLedgEntries);
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentKey("External Document No.");
        CustLedgEntry.SetRange("External Document No.", Rec."No.");
        CustLedgEntries.SetTableView(CustLedgEntry);
        CustLedgEntries.Run;
        // NavigateForm.SetDoc("Posting Date",");
        // NavigateForm.RUN;
    end;
}

