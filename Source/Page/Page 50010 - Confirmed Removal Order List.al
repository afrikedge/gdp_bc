page 50010 "Confirmed Removal Order List"
{
    Caption = 'Confirmed Removal Order List';
    CardPageID = "Posted Removal Order";
    Editable = false;
    PageType = List;
    SaveValues = true;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(isconfirme = CONST(true),
                            IsBon = CONST(false));

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
                field(datevalidite; Rec.datevalidite)
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
                Rec.FilterGroup(2);
                Rec.SetFilter(Rec.depot, FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;
    end;
}

