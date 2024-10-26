page 50007 "Removal Order"
{
    // 190118 Add Commit on printing

    Caption = 'Removal Order';
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(isconfirme = CONST(false));

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(numBE; Rec.numBE)
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
            part(Lines; "Removal Order Subform")
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
                Caption = 'P&ost';
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
                    ItemAdjPost.PostOldBE(Rec, false);
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
            }
            action(ImprimerBE)
            {
                Caption = 'Imprimer BE';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    EnteteBE: Record pro_enteteBE;
                begin
                    //EnteteBE.SETRANGE(numBE,Rec.numBE);
                    //REPORT.RUN(REPORT::"Bon Enlevement Dispatching",TRUE, FALSE,EnteteBE);

                    /*
                    
                    PrintCrystal.PrintBE(Rec.numBE);
                    
                    
                    IF NOT Rec.Imprime THEN BEGIN
                      Rec.Imprime:=TRUE;
                      Rec."Nos Printed" := Rec."Nos Printed" + 1;
                      Rec."Last Printed Date" := CREATEDATETIME(TODAY,TIME);
                      Rec.MODIFY;
                      //COMMIT;//********
                    END;
                    */

                end;
            }
            action(CancelBE)
            {
                Caption = 'Cancel BE';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    if Confirm(StrSubstNo(Text001, Rec.numBE)) then begin
                        SecMgt.CheckCanReverseBE_BL;//********************
                                                    //IF Rec.Source = Rec.Source::Dispaching THEN
                                                    //  SQLMgt.AnnulerBE(Rec.numBE)
                                                    //ELSE
                        StockAdjustMgt.CancelOldBE(Rec);
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
        Text001: Label 'Voulez-vous annuler le BE %1 ?\Tous les BL associés seront aussi annulés.';
        CamionIsEditable: Boolean;
        SecMgt: Codeunit "Security Mgt";
        DepotIsEditable: Boolean;
        IsNotJirama: Boolean;
        PrintCrystal: Codeunit CRReports;
}

