page 50005 "Delivery Order"
{
    Caption = 'Delivery Order';
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = pro_enteteBL;
    SourceTableView = WHERE(isconfirme = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(numBL; Rec.numBL)
                {
                    Visible = false;
                }
                field(depot; Rec.depot)
                {
                    Editable = DepotIsEditable;
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
                    Visible = false;
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
                    Editable = NumBEIsEditable;
                }
                field(AdrLivraisonBL; Rec.AdrLivraisonBL)
                {
                }
                field("Delivery Site"; Rec."Delivery Site")
                {
                }
                field("Posted Shipment No"; Rec."Posted Shipment No")
                {
                    Visible = false;
                }
            }
            part(Lines; "Delivery Order Subform")
            {
                Caption = 'Lines';
                SubPageLink = numBL = FIELD(numBL);
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
                    ItemAdjPost.PostBL_Old2(Rec);
                    //CODEUNIT.RUN(Co
                    CurrPage.Close;
                end;
            }
            action(Imprimer)
            {
                Caption = 'Imprimer BL';
                Image = "Report";
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



                    /*
                    ReportsCR.PrintBL(numBL);
                    
                    IF NOT Rec.Imprime THEN BEGIN
                      Rec.Imprime := TRUE;
                      Rec."Last Printed Date" := CREATEDATETIME(TODAY,TIME);
                      Rec.MODIFY;
                    END;
                    */

                end;
            }
            action(CancelBL)
            {
                Caption = 'Cancel BL';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(Text001, Rec.numBL)) then begin
                        SecMgt.CheckCanReverseBE_BL;//********************
                                                    //IF Rec.Source = Rec.Source::Dispaching THEN
                                                    //  SqlMgt.AnnulerBL(Rec.numBL)
                                                    //ELSE
                        LogistiqueMgt.CancelOldBL(Rec);
                        CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CamionIsEditable := Rec.Source = Rec.Source::" ";
        DepotIsEditable := Rec.Source = Rec.Source::" ";
        NumBEIsEditable := Rec.Source = Rec.Source::" ";
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage.Editable := not Rec.isconfirme;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.depot := SecMgt.GetDefaultLocationDispaching;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Rec.numBL);
    end;

    var
        SqlMgt: Codeunit "SQL Mgt";
        Text001: Label 'Voulez-vous annuler le bon de livraison %1 ?';
        LogistiqueMgt: Codeunit "Logistique Mgt";
        CamionIsEditable: Boolean;
        DepotIsEditable: Boolean;
        NumBEIsEditable: Boolean;
        SecMgt: Codeunit "Security Mgt";
        ReportsCR: Codeunit CRReports;
}

