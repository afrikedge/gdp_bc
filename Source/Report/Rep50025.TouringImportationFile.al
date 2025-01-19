report 50025 "Touring Importation File"
{
    Caption = 'Touring Importation file';
    RDLCLayout = './Source/Report/Layout/Touring Import File.rdl';

    dataset
    {
        dataitem(Touring; Touring)
        {

            dataitem(pro_enteteBE; pro_enteteBE)
            {
                DataItemLink = idtournee = field(IdTouring);
                DataItemTableView = SORTING(NumBU) where(IsBon = const(true));
                column(CustomerNo; "Customer No")
                {
                }
                column(CustomerName; "Customer Name")
                {
                }
                column(NumBU; NumBU)
                {
                }
                column(nomTransporteur; nomTransporteur)
                {
                }
                column(idtournee; idtournee)
                {
                }
                column(depot; depot)
                {
                }
                column(codemoyentransport; codemoyentransport)
                {
                }
                column(NavOrderNo; NavOrderNo)
                {
                }
                column(AdrLivraisonBL; AdrLivraisonBL)
                {
                }
                dataitem(pro_detailBE; pro_detailBE)
                {
                    DataItemTableView = SORTING(NumBE);
                    DataItemLink = NumBE = field(NumBE);
                    column(codeproduit; printedCodeProduit)
                    {

                    }
                    column(volumeaenlever; pro_detailBE.volumeaenlever * 1000)
                    {

                    }
                    column(C1; C1) { }
                    column(C2; C2) { }
                    column(C3; C3) { }
                    column(C4; C4) { }
                    column(C5; C5) { }
                    column(C6; C6) { }
                    column(C7; C7) { }
                    column(C8; C8) { }
                    column(C9; C9) { }
                    column(C10; C10) { }
                    trigger OnAfterGetRecord()//DetailBE
                    begin

                        C1 := FindVolumeCompartiment(1, pro_enteteBE, pro_detailBE);
                        C2 := FindVolumeCompartiment(2, pro_enteteBE, pro_detailBE);
                        C3 := FindVolumeCompartiment(3, pro_enteteBE, pro_detailBE);
                        C4 := FindVolumeCompartiment(4, pro_enteteBE, pro_detailBE);
                        C5 := FindVolumeCompartiment(5, pro_enteteBE, pro_detailBE);
                        C6 := FindVolumeCompartiment(6, pro_enteteBE, pro_detailBE);
                        C7 := FindVolumeCompartiment(7, pro_enteteBE, pro_detailBE);
                        C8 := FindVolumeCompartiment(8, pro_enteteBE, pro_detailBE);
                        C9 := FindVolumeCompartiment(9, pro_enteteBE, pro_detailBE);
                        C10 := FindVolumeCompartiment(10, pro_enteteBE, pro_detailBE);

                        printedCodeProduit := pro_detailBE.codeproduit;
                        if (printedCodeProduit = 'SC') then
                            printedCodeProduit := 'SP95';

                    end;
                }
                trigger OnAfterGetRecord()//EnteteBE
                begin

                end;
            }

            trigger OnAfterGetRecord()//Touring
            begin

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure FindVolumeCompartiment(index: integer; EnteteBE:
    record pro_enteteBE; BELine: record pro_detailBE): decimal
    var
        TouringEntry: record "Touring Product Entry";
    begin
        if (TouringEntry.Get(EnteteBE.idtournee, EnteteBE.NavOrderNo, EnteteBE.codemoyentransport, index)) then
            if (TouringEntry.ItemNo = BELine.codeproduit) then
                exit(TouringEntry.Volume * 1000);
    end;

    var
        CompanyInfo: Record "Company Information";
        printedCodeProduit: Code[10];
        C1: Decimal;
        C2: Decimal;
        C3: Decimal;
        C4: Decimal;
        C5: Decimal;
        C6: Decimal;
        C7: Decimal;
        C8: Decimal;
        C9: Decimal;
        C10: Decimal;
}


