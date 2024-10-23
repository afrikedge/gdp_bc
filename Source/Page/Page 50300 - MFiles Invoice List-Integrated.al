page 50300 "MFiles Invoice List-Integrated"
{
    Caption = 'Liste des factures fournisseurs traitées (MFiles)';
    CardPageID = "MFiles Invoice - integrated";
    Editable = false;
    PageType = List;
    SourceTable = tblFacture;
    SourceTableView = WHERE(Statut = CONST(Integrated));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                }
                field(DateMFiles; Rec.DateMFiles)
                {
                }
                field(NumeroFacture; Rec.NumeroFacture)
                {
                }
                field(DateFacture; Rec.DateFacture)
                {
                }
                field(FactureDirecte; Rec.FactureDirecte)
                {
                }
                field(NumeroBDC; Rec.NumeroBDC)
                {
                }
                field(NouveauDelaiPaiement; Rec.NouveauDelaiPaiement)
                {
                }
                field(MontantHTVA; Rec.MontantHTVA)
                {
                }
                field(NumeroFournisseur; Rec.NumeroFournisseur)
                {
                }
                field(MFilesURL; Rec.MFilesURL)
                {
                }
                field(DateNav; Rec.DateNav)
                {
                }
                field(Statut; Rec.Statut)
                {
                }
            }
        }
    }

    actions
    {
    }
}

