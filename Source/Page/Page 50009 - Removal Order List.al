page 50009 "Removal Order List"
{
    Caption = 'Removal Order List';
    CardPageID = "Removal Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(isconfirme = CONST(false),
                            isAnnule = CONST(false),
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
                field(idtournee; Rec.idtournee)
                {
                }
                field(dateBE; Rec.dateBE)
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
                field(datevalidite; Rec.datevalidite)
                {
                }
                field(numBSL; Rec.numBSL)
                {
                }
                field(nom; Rec.nom)
                {
                }
                field(CreatedFromDocNo; Rec.CreatedFromDocNo)
                {
                }
                field(Source; Rec.Source)
                {
                }
                field(Imprime; Rec.Imprime)
                {
                }
                field("Customer BE"; Rec."Customer BE")
                {
                }
                field(datecreation; Rec.datecreation)
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

        Rec.FilterGroup(2);
        Rec.SetRange(Rec.isAnnule, false);
        Rec.SetRange(Rec.isconfirme, false);
        Rec.FilterGroup(0);
    end;
}

