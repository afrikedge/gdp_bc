page 50259 "Cancelled Delivery Order List"
{
    Caption = 'Cancelled Delivery Order List';
    CardPageID = "Cancelled Delivery Order";
    Editable = false;
    PageType = List;
    SourceTable = pro_enteteBL;
    SourceTableView = WHERE(isAnnule = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(numBL; Rec.numBL)
                {
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
                field(NavOrderNo; Rec.NavOrderNo)
                {
                }
                field(numBE; Rec.numBE)
                {
                }
                field(region; Rec.region)
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
    end;
}

