page 50312 "Customer Receipts Docs"
{
    Caption = 'Customer receipts documents';
    Editable = false;
    PageType = List;
    SourceTable = "G/L Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'Customer N°';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    Visible = false;
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print Receipt")
            {
                Caption = 'Print Receipt';
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    GLEntry3: Record "G/L Entry";
                begin
                    GLEntry3.SetRange("Entry No.", Rec."Entry No.");
                    REPORT.Run(50082, true, false, GLEntry3);
                end;
            }
            action("Invoices to reconciliate")
            {
                Caption = 'Invoices to reconciliate';
                Image = ReceiptLines;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ReconInfo: Record "Reconciliation Info";
                    ReconInfoForm: Page "Reconciliation Infos Posted";
                begin
                    ReconInfo.FilterGroup(2);
                    ReconInfo.SetRange("Customer No.", Rec."External Document No.");
                    ReconInfo.SetRange(ReconInfo."G/L Entry No", Rec."Entry No.");
                    ReconInfo.FilterGroup(0);
                    ReconInfoForm.SetTableView(ReconInfo);
                    ReconInfoForm.Editable := false;
                    ReconInfoForm.RunModal;
                    //PAGE.RUNMODAL(50310,ReconInfo);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        AddOnSetup.Get;
        Rec.FilterGroup(2);
        Rec.SetCurrentKey("G/L Account No.");
        Rec.SetFilter(Rec."G/L Account No.", '%1|%2', AddOnSetup."Traite Acc To Cach", AddOnSetup."Check Acc To Cach");
        Rec.FilterGroup(0);
    end;

    var
        AddOnSetup: Record "AddOn Setup";
}

