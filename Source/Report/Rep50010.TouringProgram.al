report 50010 "Touring Program"
{
    Caption = 'Touring Program';
    RDLCLayout = './Source/Report/Layout/Touring Program.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Touring; Touring)
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(ProgrammeText; ProgrammeText)
            {
            }
            column(TourneeText; TourneeText)
            {
            }
            column(LivraisonText; LivraisonText)
            {
            }

            dataitem(pro_enteteBE; pro_enteteBE)
            {
                DataItemLink = idtournee = field(IdTouring);
                DataItemTableView = SORTING(NumBU) where(IsBon = const(true), isAnnule = const(false));
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
                    column(codeproduit; pro_detailBE.codeproduit)
                    {

                    }
                    column(volumeaenlever; pro_detailBE.volumeaenlever)
                    {

                    }
                }
            }

            trigger OnAfterGetRecord()//Touring
            begin
                ProgrammeText := StrSubstNo(ProgrammeLabel, Format("Touring Date"));
                LivraisonText := StrSubstNo(LivraisonLabel, Format(CalcDate('<1D>', "Touring Date")));
                TourneeText := StrSubstNo(TourneeLabel, Format(IdTouring));
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

    var
        CompanyInfo: Record "Company Information";
        ProgrammeLabel: Label 'PROGRAMME DU %1';
        ProgrammeText: Text;
        TourneeLabel: Label 'TOURNEE N° %1';
        TourneeText: Text;
        LivraisonLabel: Label 'LIVRAISON %1';
        LivraisonText: Text;
}
