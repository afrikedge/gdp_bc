page 50260 "Cancelled Removal Order List"
{
    Caption = 'Cancelled Removal Order List';
    CardPageID = "Cancelled Removal Order";
    Editable = false;
    PageType = List;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(isAnnule = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(numBE; Rec.numBE)
                {
                }
                field(depot; Rec.depot)
                {
                }
                field(dateBE; Rec.dateBE)
                {
                }
                field(idtournee; Rec.idtournee)
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
                field(numBSL; Rec.numBSL)
                {
                }
                field(datecreation; Rec.datecreation)
                {
                }
                field(nom; Rec.nom)
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
                FilterGroup(2);
                SetFilter(Rec.depot, FiltreMag);
                FilterGroup(0);
            end;
        end;
    end;
}

