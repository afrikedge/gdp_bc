page 50013 "Posted Delivery Order"
{
    Caption = 'Posted delivery order';
    Editable = false;
    PageType = Document;
    SourceTable = pro_enteteBL;
    SourceTableView = WHERE(isconfirme = CONST(true));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(numBL; Rec.numBL)
                {
                }
                field(depot; Rec.depot)
                {
                }
                field(datelivraison; Rec.datelivraison)
                {
                    Caption = 'Delivery Date';
                }
                field(idtournee; Rec.idtournee)
                {
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                }
                field(observationBL; Rec.observationBL)
                {
                }
                field(isconfirme; Rec.isconfirme)
                {
                }
                field(datevalidite; Rec.datevalidite)
                {
                }
                field(nom; Rec.nom)
                {
                }
                field(nomresponsable; Rec.nomresponsable)
                {
                }
                field(datecreation; Rec.datecreation)
                {
                }
                field(NumAfficheBL; Rec.NumAfficheBL)
                {
                }
                field(RegimeDouanier; Rec.RegimeDouanier)
                {
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                }
                field(region; Rec.region)
                {
                }
                field(tarifville; Rec.tarifville)
                {
                }
                field(ville; Rec.ville)
                {
                }
                field(prix_unitaire; Rec.prix_unitaire)
                {
                }
                field(numBE; Rec.numBE)
                {
                }
                field(AdrLivraisonBL; Rec.AdrLivraisonBL)
                {
                }
                field("Delivery Site"; Rec."Delivery Site")
                {
                }
                field("Posted Shipment No"; Rec."Posted Shipment No")
                {
                }
            }
            part(Lines; "Delivery Order Subform")
            {
                Caption = 'Lines';
                SubPageLink = numBL = FIELD(numBL);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(ImprimerBL)
            {
                Caption = 'Imprimer BL';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Dispact: Record pro_enteteBL;
                begin
                    Dispact.SetRange(numBL, Rec.numBL);
                    REPORT.Run(REPORT::"Bon livraison Dispatching", true, false, Dispact);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.Editable := not Rec.isconfirme;
    end;
}

