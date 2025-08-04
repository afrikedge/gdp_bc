page 50301 "MFiles Invoice Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = tblAxeAnalytique;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TypeLigne; Rec.TypeLigne)
                {
                }
                field(CodeLigne; Rec.CodeLigne)
                {
                }
                field(MontantHTVA; Rec.MontantHTVA)
                {
                    Editable = false;
                }
                field(CodeBudget; Rec.CodeBudget)
                {
                    Editable = false;
                }
                field(CodeCentreCout; Rec.CodeCentreCout)
                {
                    Editable = false;
                }
                field(CodeCentreProfit; Rec.CodeCentreProfit)
                {
                    Editable = false;
                }
                field(CodeProjet; Rec.CodeProjet)
                {
                    Editable = false;
                }
                field(CodeRegion; Rec.CodeRegion)
                {
                    Editable = false;
                }
                field(CodeCentreProfit2; Rec.CodeCentreProfit2)
                {
                }
                field(CodeProduit; Rec.CodeProduit)
                {
                }
            }
        }
    }

    actions
    {
    }
}

