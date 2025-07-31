page 50302 "MFiles Invoice - In Progress"
{
    Caption = 'Facture fournisseur à traiter (MFiles)';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = tblFacture;
    SourceTableView = WHERE(Statut = CONST(Created));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(ID; Rec.ID)
                {
                    Editable = false;
                }
                field(DateMFiles; Rec.DateMFiles)
                {
                    Editable = false;
                }
                field(NumeroFacture; Rec.NumeroFacture)
                {
                    Editable = false;
                }
                field(DateFacture; Rec.DateFacture)
                {
                    Editable = false;
                }
                field(FactureDirecte; Rec.FactureDirecte)
                {
                    Editable = false;
                }
                field(NumeroBDC; Rec.NumeroBDC)
                {
                    Editable = false;
                }
                field(MontantHTVA; Rec.MontantHTVA)
                {
                    Editable = false;
                }
                field(NumeroFournisseur; Rec.NumeroFournisseur)
                {
                    Editable = false;
                }
                field(MFilesURL; Rec.MFilesURL)
                {
                    Editable = false;
                }
                field(NouveauDelaiPaiement; Rec.NouveauDelaiPaiement)
                {
                }
                field(DateNav; Rec.DateNav)
                {
                }
                field(Statut; Rec.Statut)
                {
                    Editable = false;
                }
            }
            part(Lines; "MFiles Invoice Subform")
            {
                SubPageLink = IDFacture = FIELD(ID);
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Créer la facture")
            {
                Caption = 'Créer la facture';
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MfilesMgt.CreatePurchInvoice(Rec);
                end;
            }
            action("Ouvrir la facture")
            {
                Caption = 'Ouvrir la facture';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MfilesMgt.OpenCreatedInv(Rec);
                end;
            }
        }
    }

    var
        MfilesMgt: Codeunit "MFiles Mgt";
}

