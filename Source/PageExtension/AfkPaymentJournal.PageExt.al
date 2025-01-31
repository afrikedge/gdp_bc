pageextension 50106 "Afk Payment Journal" extends "Payment Journal"
{
    layout
    {
        addafter("External Document No.")
        {
        }
        addafter(Correction)
        {
            field(Destinataire; Rec.Destinataire)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the recipient information';
            }
        }
    }
    actions
    {
        addafter("P&osting")
        {
            action(PostAndEmail)
            {
                ApplicationArea = All;
                Caption = 'Post and email to vendor';
                Image = PostSendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortcutKey = 'Shift+F9';
                Visible = false;

                trigger OnAction()
                var
                    GenJrnPost: Codeunit "Gen. Jnl.-Post";
                    singleCU: Codeunit SingleInstance;
                begin
                    singleCU.Set_SendVendorEmails_AFK(true);
                    GenJrnPost.Run(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        addafter(PrintCheck)
        {
            action(Virement)
            {
                ApplicationArea = All;
                Caption = 'Imprimer OV';
                Image = TransferFunds;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("Payment Method Code");

                    GenJnlLine.Reset();
                    GenJnlLine.Copy(Rec);
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Posting Date", Rec."Posting Date");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    Report.Run(Report::"Virement Fournisseur", true, false, GenJnlLine);
                end;
            }

            action(Traite)
            {
                ApplicationArea = All;
                Caption = 'Imprimer Traite';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("Payment Method Code");

                    GenJnlLine.Reset();
                    GenJnlLine.Copy(Rec);
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Posting Date", Rec."Posting Date");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    Report.Run(Report::"Traite Fournisseur", true, false, GenJnlLine);
                end;
            }

            action(Factures)
            {
                ApplicationArea = All;
                Caption = 'Imprimer Factures du paiement';
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.Copy(Rec);
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Posting Date", Rec."Posting Date");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    Report.Run(Report::"FacturePaiement", true, false, GenJnlLine);
                end;
            }

            action(AnnexeOV)
            {
                ApplicationArea = All;
                Caption = 'Imprimer Récapitulatif des OV';
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.Copy(Rec);
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Posting Date", Rec."Posting Date");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    Report.Run(Report::"AnnexeOV", true, false, GenJnlLine);
                end;
            }
            action("Avis Paiement Factures frs")
            {
                ApplicationArea = All;
                Caption = 'Imprimer Avis Factures du paiement';
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GenJnlLine.RESET;
                    GenJnlLine.COPY(Rec);
                    GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SETRANGE("Posting Date", Rec."Posting Date");
                    GenJnlLine.SETRANGE("Document No.", Rec."Document No.");//**************************************added
                    REPORT.RUN(REPORT::"Avis Paiement Fournisseur", TRUE, FALSE, GenJnlLine);
                end;
            }
        }
    }
    var
        GenJnlLine: Record "Gen. Journal Line";
}
