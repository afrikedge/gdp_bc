report 50032 "Bon Enlevement Dispatching"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Bon Enlevement Dispatching.rdlc';
    PDFFontEmbedding = Yes;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(pro_enteteBE; pro_enteteBE)
        {
            RequestFilterFields = numBE;
            column(BENum; numBE)
            {
            }
            column(BEDepot; depot)
            {
            }
            column(DateBE; Format(dateBE))
            {
            }
            column(TranspName; nomTransporteur)
            {
            }
            column(DateValid; datevalidite)
            {
            }
            column(CodeCamion; codemoyentransport)
            {
            }
            column(LocationCode; Location.Code)
            {
            }
            column(LocationName; Location.Name)
            {
            }
            column(LocationAddr; Location.Address)
            {
            }
            column(RespCenterCode; RespCenter.Code)
            {
            }
            column(RespCenterName; RespCenter.Name)
            {
            }
            column(DatePrint; Format(Today))
            {
            }
            column(Prepareby; pro_enteteBE.nom)
            {
            }
            column(ValidateBy; pro_enteteBE.nomresponsable)
            {
            }
            column(NomChauffeur; nomchauffeur)
            {
            }
            column(Permis; permis)
            {
            }
            column(duplicata; Duplicata)
            {
            }
            column(BSLNo; numBSL)
            {
            }
            dataitem(DetailBE; "Integer")
            {
                dataitem(LigneBL; "Integer")
                {
                    column(CodeArt; CodeArt)
                    {
                    }
                    column(Descript; Descript)
                    {
                    }
                    column(NumCmd; NumCmd)
                    {
                    }
                    column(QtyLitre; QtyLitre)
                    {
                    }
                    column(LineNo; LineNo)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CodeArt := DetailBL.NavItemCode;
                        DetailBL.CalcFields("Item Name");
                        Descript := DetailBL."Item Name";
                        NumCmd := 'No cmd : ' + EnteteBL.NavOrderNo;
                        if DetailBL."Unit of Measure Code" = 'LITRE' then begin
                            QtyLitre := DetailBL.volumealivrer;
                        end else begin
                            QtyLitre := DetailBL.volumealivrer * 1000;
                        end;

                        LineNo := LineNo + 1;
                        if DetailBL.Next <> 0 then;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if EnteteBL.Next <> 0 then;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, Counter2);
                        DetailBL.FindFirst;
                        CodeArt := '';
                        Descript := '';
                        QtyLitre := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    DetailBL.SetRange(DetailBL.numBL, EnteteBL.numBL);
                    if DetailBL.FindFirst then
                        Counter2 := DetailBL.Count;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, Counter);
                    EnteteBL.FindFirst;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Location.Get(depot);
                Duplicata := '';
                //RespCenter.GET();
                if pro_enteteBE.codemoyentransport <> '' then
                    Camion.Get(pro_enteteBE.codemoyentransport);

                EnteteBL.SetRange(numBE, pro_enteteBE.numBE);
                if EnteteBL.FindFirst then
                    Counter := EnteteBL.Count;
                if pro_enteteBE.Imprime then
                    Duplicata := 'DUPLICATA';
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        LineNo := 0;
        Counter := 0;
        Counter2 := 0;
    end;

    var
        Location: Record Location;
        RespCenter: Record "Responsibility Center";
        Camion: Record pro_moyentransport;
        Vendor: Record Vendor;
        EnteteBL: Record pro_enteteBL;
        DetailBL: Record pro_detailBL;
        Counter: Integer;
        QtyLitre: Integer;
        CodeArt: Code[20];
        Descript: Text[80];
        NumCmd: Text[30];
        LineNo: Integer;
        Counter2: Integer;
        Duplicata: Text;
}

