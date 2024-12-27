page 50340 "Bon Order (Dispaching)"
{
    // 190118 Add Commit on printing

    Caption = 'Bon (Dispaching)';
    DataCaptionFields = NumBU;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(BonIsConfirme = CONST(false),
                            IsBon = CONST(true));

    layout
    {
        area(content)
        {
            group("Enlèvement")
            {
                field(depot; Rec.depot)
                {
                    Editable = BEIsNotConfirme;
                }
                field(dateBE; Rec.dateBE)
                {
                    Caption = 'Removal order Date';
                    Editable = BEIsNotConfirme;
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
                    Editable = CamionIsEditable;
                }
                field(permis; Rec.permis)
                {
                    Editable = CamionIsEditable;
                }
                field(nomTransporteur; Rec.nomTransporteur)
                {
                    Editable = CamionIsEditable;
                }
                field(observation; Rec.observation)
                {
                }
                field(isconfirme; Rec.isconfirme)
                {
                }
                field(datevalidite; Rec.datevalidite)
                {
                    Editable = BEIsNotConfirme;
                }
                field(nom; Rec.nom)
                {
                    Editable = BEIsNotConfirme;
                }
                field(nomresponsable; Rec.nomresponsable)
                {
                    Editable = BEIsNotConfirme;
                }
                field(datecreation; Rec.datecreation)
                {
                }
                field(NumAfficheBE; Rec.NumAfficheBE)
                {
                    Caption = 'BE Number';
                    Editable = BEIsNotConfirme;
                }
                field(RegimeDouanier; Rec.RegimeDouanier)
                {
                    Editable = BEIsNotConfirme;
                }
                field(numBSL; Rec.numBSL)
                {
                    Editable = BEIsNotConfirme;
                }
                field("Customer BE"; Rec."Customer BE")
                {
                    Editable = false;
                }
                field(Destination; Rec.Destination)
                {
                    Editable = BEIsNotConfirme;
                }
                field("Cargo Name"; Rec."Cargo Name")
                {
                    Editable = BEIsNotConfirme;
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
                    Editable = false;
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
            }
            part(Lines; "Bon Order Subform")
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
            action(Post)
            {
                Caption = 'Post';
                Ellipsis = true;
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    ItemAdjPost: Codeunit "Logistique Mgt";
                begin
                    //Post(CODEUNIT::"Sales-Post (Yes/No)");
                    ItemAdjPost.PostBon(Rec);
                    //CODEUNIT.RUN(Co
                    CurrPage.Close;
                end;
            }
            action(Dupliquer)
            {
                Caption = 'Duplicate ';
                Visible = false;


                trigger OnAction()
                begin
                    StockAdjustMgt.CreateBEFromBE(Rec);
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
            action(CreateBL)
            {
                Caption = 'Create Shipment order';
                Visible = false;

                trigger OnAction()
                begin
                    StockAdjustMgt.CreateBLFromBE(Rec);
                end;
            }
        }
        area(navigation)
        {
            action(ListeBL)
            {
                Caption = 'Delivery Order List';
                RunObject = Page "Delivery Order List";
                RunPageLink = numBE = FIELD(numBE);
                Visible = false;
            }
            action(ImprimerBE)
            {
                Caption = 'Imprimer';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EnteteBE: Record pro_enteteBE;
                    PagePrintCard: Page "Print Bon Card";
                begin
                    //EnteteBE.SETRANGE(numBE,Rec.numBE);
                    //REPORT.RUN(REPORT::"Bon Enlevement Dispatching",TRUE, FALSE,EnteteBE);

                    PAGE.RunModal(50352, Rec);

                    /*
                    //BonIsEditable:=FALSE;
                    //CurrPage.ACTIVATE;
                    CurrPage.CLOSE;
                    IF NOT Rec.Imprime THEN BEGIN
                      Rec.Imprime:=TRUE;
                      Rec."Nos Printed" := Rec."Nos Printed" + 1;
                      Rec."Last Printed Date" := CREATEDATETIME(TODAY,TIME);
                      Rec.MODIFY;
                      //COMMIT;//********
                    END;
                    PrintCrystal.PrintBE(Rec.numBE);
                    */

                end;
            }
            action(Imprimer)
            {
                Caption = 'Imprimer BL';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    EnteteBL: Record pro_enteteBL;
                begin
                    //EnteteBL.SETRANGE(numBL,Rec.numBL);
                    //REPORT.RUN(REPORT::"Bon livraison Dispatching",TRUE, FALSE,EnteteBL);

                    PAGE.RunModal(50352, Rec);
                    /*
                    PrintCrystal.PrintBL(numBL);
                    
                    RelatedBL.GET(numBL);
                    IF NOT RelatedBL.Imprime THEN BEGIN
                      RelatedBL.Imprime := TRUE;
                      RelatedBL."Last Printed Date" := CREATEDATETIME(TODAY,TIME);
                      RelatedBL.MODIFY;
                    END;
                    */

                end;
            }
            action(CancelBE)
            {
                Caption = 'Cancel Bon';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(Text001, Rec.numBE)) then begin
                        SecMgt.CheckCanReverseBE_BL;//********************
                                                    //IF Rec.Source = Rec.Source::Dispaching THEN
                                                    //  SQLMgt.AnnulerBE(Rec.numBE)
                                                    //ELSE
                        StockAdjustMgt.CancelBE(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
            action("Signaler un incident")
            {
                Caption = 'Signaler un incident';
                Image = Post;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunPageMode = Create;

                trigger OnAction()
                var
                    FormIncident: Page "Incident Dispaching";
                begin
                    FormIncident.SetIdBE(Rec.numBE);
                    FormIncident.RunModal;
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
        BEIsNotConfirme := not Rec.isconfirme;
        BonIsNotConfirme := not Rec.BonIsConfirme;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        Rec.depot := SecMgt.GetDefaultLocationDispaching();
        Rec.IsBon := true;
    end;

    trigger OnOpenPage()
    begin
        //CurrPage.EDITABLE:=NOT Rec.isconfirme;
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
        BEIsNotConfirme: Boolean;
        BonIsNotConfirme: Boolean;
        BonIsEditable: Boolean;

    procedure ClosePage()
    begin
        CurrPage.Close;
    end;
}

