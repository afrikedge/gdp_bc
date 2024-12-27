page 50342 "Confirmed Bon Order"
{
    // 190118 Add Commit on printing

    Caption = 'Bon (Dispaching)';
    DataCaptionFields = NumBU;
    DeleteAllowed = false;
    Editable = false;
    PageType = Document;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(IsBon = CONST(true));

    layout
    {
        area(content)
        {
            group("Enlèvement")
            {
                field(numBE; Rec.numBE)
                {
                    Visible = false;
                }
                field(NumBU; Rec.NumBU)
                {
                }
                field(depot; Rec.depot)
                {
                    Editable = true;
                }
                field(dateBE; Rec.dateBE)
                {
                    Caption = 'Removal order Date';
                }
                field(idtournee; Rec.idtournee)
                {
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                    Editable = CamionIsEditable;
                }
                field(nomchauffeur; Rec.nomchauffeur)
                {
                }
                field(permis; Rec.permis)
                {
                }
                field(nomTransporteur; Rec.nomTransporteur)
                {
                }
                field(temperature; Rec.temperature)
                {
                    Visible = false;
                }
                field(densite; Rec.densite)
                {
                    Visible = false;
                }
                field(observation; Rec.observation)
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
                field(NumAfficheBE; Rec.NumAfficheBE)
                {
                    Caption = 'BE Number';
                }
                field(RegimeDouanier; Rec.RegimeDouanier)
                {
                }
                field(numBSL; Rec.numBSL)
                {
                }
                field("Customer BE"; Rec."Customer BE")
                {
                    Editable = false;
                }
                field(Destination; Rec.Destination)
                {
                }
                field("Cargo Name"; Rec."Cargo Name")
                {
                }
            }
            group(Livraison)
            {
                field(numBL; Rec.numBL)
                {
                }
                field(region; Rec.region)
                {
                }
                field(datelivraison; Rec.datelivraison)
                {
                }
                field(datevaliditeBL; Rec.datevaliditeBL)
                {
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                }
                field(tarifville; Rec.tarifville)
                {
                }
                field("Customer BC"; Rec."Customer BC")
                {
                }
                field(ville; Rec.ville)
                {
                }
                field(AdrLivraisonBL; Rec.AdrLivraisonBL)
                {
                }
                field("Delivery Site"; Rec."Delivery Site")
                {
                }
                field(prix_unitaire; Rec.prix_unitaire)
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Posted Shipment No"; Rec."Posted Shipment No")
                {
                }
                field("Posted Invoice No"; Rec."Posted Invoice No")
                {
                }
            }
            part(Lines; "Confirmed Bon Order Subform")
            {
                Caption = 'Lines';
                SubPageLink = numBE = FIELD(numBE);
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

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(Loading)
            {
                Caption = 'Chargement';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    //BonLoading: record BonLoading;
                    //BonLoadingList: page "Bon Loading";
                    BonLoading: record "Touring Product Entry";
                    BonLoadingList: page "Compartment Loading";
                begin
                    // BonLoading.Reset();
                    // BonLoading.SetRange(numBE, Rec.numBE);

                    // BonLoadingList.SetTableView(BonLoading);
                    // BonLoadingList.SetRecord(BonLoading);
                    // BonLoadingList.LookupMode(true);
                    // if (BonLoadingList.RunModal() = Action::OK) then begin
                    // end;

                    BonLoading.Reset();
                    //IdTouring,OrderNo,Immatriculation
                    BonLoading.SetRange(BonLoading.IdTouring, Rec.idtournee);
                    BonLoading.SetRange(BonLoading.OrderNo, Rec.NavOrderNo);
                    BonLoading.SetRange(BonLoading.Immatriculation, Rec.codemoyentransport);

                    BonLoadingList.SetTableView(BonLoading);
                    BonLoadingList.SetRecord(BonLoading);
                    BonLoadingList.LookupMode(true);
                    if (BonLoadingList.RunModal() = Action::OK) then;
                end;
            }
        }
        area(navigation)
        {
            action(ListeBL)
            {
                Caption = 'Delivery Order List';
                RunObject = Page "Confirmed Delivery Order List";
                RunPageLink = numBE = FIELD(numBE);
                Visible = false;
            }
            action(ShowPostedShipment)
            {
                Caption = 'Bon de livraison enregistré';
                Image = PostDocument;

                trigger OnAction()
                begin
                    if (RelatedBL.Get(Rec.numBL)) then begin
                        RelatedBL.ShowPostedShipment;
                    end;
                end;
            }
            action(ShowPostedInv)
            {
                Caption = 'Facture enregistrée';
                Image = Invoice;

                trigger OnAction()
                begin
                    if (RelatedBL.Get(Rec.numBL)) then begin
                        RelatedBL.ShowPostedInvoice;
                    end;
                end;
            }
            action(Incidents)
            {
                Caption = 'Incidents';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Bon Incident List";
                RunPageLink = IdRef = FIELD(numBE);
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CamionIsEditable := Rec.Source = Rec.Source::" ";
        DepotIsEditable := Rec.Source = Rec.Source::" ";
        IsNotJirama := not Rec.IsBEJIRAMA;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec.depot := SecMgt.GetDefaultLocationDispaching();
    end;

    trigger OnOpenPage()
    begin
        CurrPage.Editable := not Rec.isconfirme;
        Rec.SetRange(Rec.numBE);
    end;

    var
        StockAdjustMgt: Codeunit "Logistique Mgt";
        SQLMgt: Codeunit "SQL Mgt";
        Text001: Label 'Voulez-vous annuler le Bon %1 ?';
        CamionIsEditable: Boolean;
        SecMgt: Codeunit "Security Mgt";
        DepotIsEditable: Boolean;
        IsNotJirama: Boolean;
        PrintCrystal: Codeunit CRReports;
        RelatedBL: Record pro_enteteBL;
}

