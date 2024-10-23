page 50014 "Posted Removal Order"
{
    Caption = 'posted removal order';
    Editable = false;
    PageType = Document;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(isconfirme = CONST(true));

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
                }
                field(temperature; Rec.temperature)
                {
                }
                field(densite; Rec.densite)
                {
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
        }
        area(navigation)
        {
            action(ListeBL)
            {
                Caption = 'Delivery Order List';
                RunObject = Page "Confirmed Delivery Order List";
                RunPageLink = numBE = FIELD(numBE);
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable := not Rec.isconfirme;
    end;
}

