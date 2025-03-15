page 50332 Drivers
{
    Caption = 'Drivers';
    AutoSplitKey = true;
    PageType = List;
    SourceTable = Driver;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTableView = SORTING(immatriculation, NumOrdre)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Nom; Rec.Nom)
                {
                }
                field(Permis; Rec.Permis)
                {
                }
                field(Categorie; Rec.Categorie)
                {
                }
                field(ValiditePermis; Rec.ValiditePermis)
                {
                }
                field(CartePath; Rec.CartePath)
                {
                }
                field(ValiditeCartePath; Rec.ValiditeCartePath)
                {
                }
                field(MotifRemplacement; Rec.MotifRemplacement)
                {
                }
                field(Formateur; Rec.Formateur)
                {
                }
                field(Telephone; Rec.Telephone)
                {
                }
                field(Titulaire; Rec.Titulaire)
                {
                }
                field(DateDebService; Rec.DateDebService)
                {
                }
                field(CreatedDate; Rec.CreatedDate)
                {
                }
            }
        }
    }

    actions
    {
    }
}

