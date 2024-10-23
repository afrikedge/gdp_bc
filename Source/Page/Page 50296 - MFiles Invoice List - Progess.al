page 50296 "MFiles Invoice List - Progess"
{
    Caption = 'Liste des factures fournisseurs non traitées (MFiles)';
    Editable = false;
    PageType = List;
    SourceTable = tblFacture;
    SourceTableView = WHERE(Statut = CONST(Created));

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
                    Visible = false;
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
                    Visible = false;
                }
                field(MontantHTVA; Rec.MontantHTVA)
                {
                }
                field(NumeroFournisseur; Rec.NumeroFournisseur)
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(DateNav; Rec.DateNav)
                {
                }
                field(Statut; Rec.Statut)
                {
                }
                field(MFilesURL; Rec.MFilesURL)
                {
                }
            }
        }
    }

    actions
    {
    }
}

