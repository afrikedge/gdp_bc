page 50303 "MFiles Invoice - integrated"
{
    Caption = 'Facture fournisseur traitée (MFiles)';
    Editable = false;
    PageType = Document;
    SourceTable = tblFacture;
    SourceTableView = WHERE(Statut = CONST(Integrated));

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
                field(NouveauDelaiPaiement; Rec.NouveauDelaiPaiement)
                {
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
            action("Ouvrir la facture")
            {
                Caption = 'Ouvrir la facture';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MfilesMgt.OpenPostedInv(Rec);
                end;
            }
        }
    }

    var
        MfilesMgt: Codeunit "MFiles Mgt";
}

