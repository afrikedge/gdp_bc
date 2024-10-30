page 50344 "Cancelled Bon List"
{
    Caption = 'Cancelled Bons Order List';
    CardPageID = "Confirmed Bon Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    RefreshOnActivate = true;
    SourceTable = pro_enteteBE;
    SourceTableView = SORTING(NumBU)
                      WHERE(isconfirme = CONST(false),
                            isAnnule = CONST(true),
                            IsBon = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(NumBU; Rec.NumBU)
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
                field("Cancelled By"; Rec."Cancelled By")
                {
                }
                field("Cancelled Date"; Rec."Cancelled Date")
                {
                }
                field("Cancelled Incident Type"; Rec."Cancelled Incident Type")
                {
                }
                field("Canceleld Comments"; Rec."Canceleld Comments")
                {
                }
                field("Cancelled Reason"; Rec."Cancelled Reason")
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
                Rec.filterGroup(2);
                Rec.SetFilter(Rec.depot, FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;

        Rec.FilterGroup(2);
        Rec.SetRange(Rec.isAnnule, true);
        //SETRANGE(Rec.isconfirme,FALSE);
        Rec.FilterGroup(0);
    end;
}

