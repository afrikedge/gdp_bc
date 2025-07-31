pageextension 50092 "Afk Purchase Order" extends "Purchase Order"
{
    layout
    {
        modify("Assigned User ID")
        {
            Caption = 'Propriétaire du projet';
        }
        addlast(General)
        {
            field("Vendor Retention Posting Group"; Rec."Vendor Retention Posting Group")
            {
                ApplicationArea = all;
            }
            field("PR Type"; Rec."PR Type")
            {
                ApplicationArea = all;
                Editable = TypeDemandeIsEditable;
            }
            field(Observations; Rec.Observations)
            {
                ApplicationArea = all;
            }
            field(Derogation; Rec.Derogation)
            {
                ApplicationArea = all;
            }
            field("Invoice Doc Ref"; Rec."Invoice Doc Ref")
            {
                ApplicationArea = all;
            }
            field(Anticipated; Rec.Anticipated)
            {
                ApplicationArea = all;
            }
        }
        addafter(PurchLines)
        {
            group("DetailOffre")
            {
                Caption = 'Détail de l''offre';
                field(DelaiDeLivraison; Rec.DelaiDeLivraison)
                {
                    ApplicationArea = all;
                }
                field("Validity Offer"; Rec."Validity Offer")
                {
                    ApplicationArea = all;
                }
                field("Vendor Order No.1"; Rec."Vendor Order No.")
                {
                    ApplicationArea = all;
                }
                field("Code Demande"; Rec."Code Demande")
                {
                    ApplicationArea = all;
                }
            }
            part(SyntheseBudget; "Budget Document Lines")
            {
                Caption = 'Synthèse budgétaire';
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                //UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            Enabled = CanPrintDoc;
        }
        addlast("P&osting")
        {
            action(CalculateBudget)
            {
                ApplicationArea = All;
                Caption = 'Calculer le budget';
                Ellipsis = true;
                Image = Calculate;
                trigger OnAction()
                var
                    BudgetMgt: Codeunit "Purchase Requisition Mgt";
                begin
                    BudgetMgt.CreatePurchaseBudgetLines(Rec);
                    ;
                end;
            }
            action(Solder)
            {
                ApplicationArea = All;
                Caption = 'Solder la commande';
                Ellipsis = true;
                Image = Close;
                trigger OnAction()
                var
                    BudgetMgt: Codeunit "Purchase Requisition Mgt";
                begin
                    BudgetMgt.SolderCdeAchat(Rec);
                end;
            }
            action(ProvisionsEntries)
            {
                ApplicationArea = All;
                Caption = 'Ecritures provisions';
                Ellipsis = true;
                Image = Entries;
                RunObject = Page "General Ledger Entries";
                RunPageLink = "External Document No." = FIELD("No.");
            }

        }

    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserSetup: Record "User Setup";
        TextErr001: Label 'Vous ne disposez pas d''autorisations pour créer des demandes d''achat';
    begin
        Rec."Purchase Type" := Rec."Purchase Type"::AchatAutre;

        IF UserSetup.GET(USERID) THEN BEGIN

            IF UserSetup."PO Type" = UserSetup."PO Type"::" " THEN ERROR(TextErr001);
            Rec."PO Type" := UserSetup."PO Type";
            Rec."PR Type" := UserSetup."PR Type";

        END ELSE BEGIN
            ERROR(TextErr001);
        END;
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        TypeDemandeIsEditable := (Rec."Code Demande" = '');
        CanPrintDoc := ((Rec.Status = Rec.Status::Released) OR (Rec."Prepayment %" > 0));//******************
    end;

    var
        CanPrintDoc: Boolean;
        TypeDemandeIsEditable: Boolean;
}
