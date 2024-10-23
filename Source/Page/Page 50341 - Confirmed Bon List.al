page 50341 "Confirmed Bon List"
{
    Caption = 'Confirmed Bons Order List';
    CardPageID = "Confirmed Bon Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = pro_enteteBE;
    SourceTableView = SORTING(NumBU)
                      WHERE(BonIsConfirme = CONST(true),
                            isAnnule = CONST(false),
                            IsBon = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(NumBU; Rec.NumBU)
                {
                }
                field(depot; Rec.depot)
                {
                }
                field(idtournee; Rec.idtournee)
                {
                }
                field(dateBE; Rec.dateBE)
                {
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                }
                field(isconfirme; Rec.isconfirme)
                {
                }
                field(NumAfficheBE; Rec.NumAfficheBE)
                {
                }
                field(datevalidite; Rec.datevalidite)
                {
                }
                field(numBSL; Rec.numBSL)
                {
                }
                field(nom; Rec.nom)
                {
                }
                field(CreatedFromDocNo; Rec.CreatedFromDocNo)
                {
                }
                field(Source; Rec.Source)
                {
                }
                field(Imprime; Rec.Imprime)
                {
                }
                field("Customer BE"; Rec."Customer BE")
                {
                }
                field(datecreation; Rec.datecreation)
                {
                }
                field(BonIsConfirme; Rec.BonIsConfirme)
                {
                }
                field(numBE; Rec.numBE)
                {
                    Visible = false;
                }
                field(numBL; Rec.numBL)
                {
                    Visible = false;
                }
                field(datelivraison; Rec.datelivraison)
                {
                    Visible = false;
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                    Visible = false;
                }
                field("Posted Shipment No"; Rec."Posted Shipment No")
                {
                    Visible = false;
                }
                field("Posted Invoice No"; Rec."Posted Invoice No")
                {
                    Visible = false;
                }
                field("Validation Date"; Rec."Validation Date")
                {
                }
                field(nomresponsable; Rec.nomresponsable)
                {
                }
                field(nomchauffeur; Rec.nomchauffeur)
                {
                    Visible = false;
                }
                field("Customer BC"; Rec."Customer BC")
                {
                    Visible = false;
                }
                field(observation; observation)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        ApplyFiltresMagasin;
    end;

    local procedure ApplyFiltresMagasin()
    var
        SecMgt: Codeunit "Security Mgt";
        UserMgt: Codeunit "User Setup Management";
        FiltreMag: Text[500];
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FiltreMag := SecMgt.GetFiltresMagasinsDispaching(UserMgt.GetSalesFilter);
            if FiltreMag <> '' then begin
                Rec.FilterGroup(2);
                Rec.SetFilter(Rec.depot, FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;

        Rec.FilterGroup(2);
        Rec.SetRange(Rec.isAnnule, false);
        Rec.SetRange(Rec.BonIsConfirme, true);
        Rec.FilterGroup(0);
    end;
}

