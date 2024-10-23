page 50338 "Bon Dispaching List"
{
    Caption = 'Bons Order List';
    CardPageID = "Bon Order (Dispaching)";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = pro_enteteBE;
    SourceTableView = SORTING(NumBU)
                      WHERE(IsBon = CONST(true));

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
                field(BonIsConfirme; Rec.BonIsConfirme)
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
                field(observation; Rec.observation)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Importer les informations enlevement")
            {
                Caption = 'Importer les informations enlevement';
                Image = ImportChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ImportInfosBE.SelectAndImportBEData();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

        ApplyFiltresMagasin;
    end;

    var
        ImportInfosBE: Codeunit ImportInfosBE;

    local procedure ApplyFiltresMagasin()
    var
        SecMgt: Codeunit "Security Mgt";
        UserMgt: Codeunit "User Setup Management";
        FiltreMag: Text[500];
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FiltreMag := SecMgt.GetFiltresMagasinsDispaching(UserMgt.GetSalesFilter);
            if FiltreMag <> '' then begin
                FilterGroup(2);
                SetFilter(Rec.depot, FiltreMag);
                FilterGroup(0);
            end;
        end;

        FilterGroup(2);
        SetRange(Rec.isAnnule, false);
        SetRange(Rec.BonIsConfirme, false);
        FilterGroup(0);
    end;
}

