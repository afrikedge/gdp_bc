page 50011 "Delivery Order List"
{
    Caption = 'Delivery Order List';
    CardPageID = "Delivery Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = pro_enteteBL;
    SourceTableView = WHERE(isconfirme = CONST(false),
                            isAnnule = CONST(false),
                            IsBon = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(numBL; Rec.numBL)
                {
                }
                field(datelivraison; Rec.datelivraison)
                {
                    Caption = 'Document Date';
                }
                field(depot; Rec.depot)
                {
                }
                field(idtournee; Rec.idtournee)
                {
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                }
                field(nom; Rec.nom)
                {
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                }
                field(numBE; Rec.numBE)
                {
                }
                field(region; Rec.region)
                {
                }
                field(CreatedFromDocNo; Rec.CreatedFromDocNo)
                {
                }
                field(Source; Rec.Source)
                {
                }
                field(nomresponsable; Rec.nomresponsable)
                {
                }
                field(datecreation; Rec.datecreation)
                {
                }
                field("A Livrer JIRAMA"; Rec."A Livrer JIRAMA")
                {
                    Visible = false;
                }
                field("Livre JIRAMA"; Rec."Livre JIRAMA")
                {
                    Visible = false;
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
    end;
}

