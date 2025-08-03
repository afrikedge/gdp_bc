report 50031 "Bon livraison Dispatching"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Bon livraison Dispatching.rdlc';
    PDFFontEmbedding = Yes;
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem(pro_enteteBL; pro_enteteBL)
        {
            RequestFilterFields = numBL;
            column(BLNum; pro_enteteBL.numBL)
            {
            }
            column(BLDepot; pro_enteteBL.depot)
            {
            }
            column(DateLiv; Format(pro_enteteBL.datelivraison))
            {
            }
            column(TranspName; pro_enteteBL."Transporter Name")
            {
            }
            column(DateValid; pro_enteteBL.datevalidite)
            {
            }
            column(NumBE; pro_enteteBL.numBE)
            {
            }
            column(NumCmde; pro_enteteBL.NavOrderNo)
            {
            }
            column(CodeRegion; pro_enteteBL.region)
            {
            }
            column(AdrLiv; pro_enteteBL.AdrLivraisonBL)
            {
            }
            column(CodeCamion; pro_enteteBL.codemoyentransport)
            {
            }
            column(CustNum; Cust."No.")
            {
            }
            column(CustName; Cust."Search Name")
            {
            }
            column(CustAddr; Cust.Address)
            {
            }
            column(CustCity; Cust."Town Code")
            {
            }
            column(CustPhone; Cust."Phone No.")
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
            column(ShipAddrCode; ShipAdrr.Code)
            {
            }
            column(ShipAddrName; ShipAdrr.Name)
            {
            }
            column(ShipAddrAddresse; ShipAdrr.Address)
            {
            }
            column(ShipAddrAddresse2; ShipAdrr."Address 2")
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
            column(Prepareby; pro_enteteBL.nom)
            {
            }
            column(ValidateBy; pro_enteteBL.nomresponsable)
            {
            }
            column(NomChauffeur; pro_enteteBL.nomchauffeur)
            {
            }
            column(Permis; pro_enteteBL.permis)
            {
            }
            dataitem(pro_detailBL; pro_detailBL)
            {
                column(BLNum_Detail; pro_detailBL.numBL)
                {
                }
                column(CodeProduit; pro_detailBL.NavItemCode)
                {
                }
                column(VolumeALivrer; pro_detailBL.volumealivrer)
                {
                }
                column(UnitCode; pro_detailBL."Unit of Measure Code")
                {
                }
                column(ItemName; pro_detailBL."Item Name")
                {
                }
                column(VolumeLivrer; pro_detailBL.volumelivre)
                {
                }
                column(LineNo; pro_detailBL."Line No.")
                {
                }
                column(ConVolume; ConVolume)
                {
                }
                column(QtyLitre; QtyLitre)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if pro_detailBL."Unit of Measure Code" = 'LITRE' then begin
                        ConVolume := pro_detailBL.volumealivrer / 1000;
                        QtyLitre := pro_detailBL.volumealivrer;
                    end else begin
                        ConVolume := pro_detailBL.volumealivrer;
                        QtyLitre := pro_detailBL.volumealivrer * 1000;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    pro_detailBL.SetRange(pro_detailBL.numBL, pro_enteteBL.numBL);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Order.SetRange("No.", pro_enteteBL.NavOrderNo);
                Order.SetRange("Document Type", Order."Document Type"::Order);
                if Location.Get(pro_enteteBL.depot) then
                    if Order.FindFirst then begin
                        Cust.SetRange("No.", Order."Bill-to Customer No.");
                        if Cust.FindFirst then begin
                            ShipAdrr.SetRange("Customer No.", Cust."No.");
                            ShipAdrr.SetRange(Code, Cust."Ship-to Code2");
                            if ShipAdrr.FindFirst then
                                RespCenter.Get(pro_enteteBL.region);
                        end;
                    end;
                RespCenter.Get(pro_enteteBL.region);
                if pro_enteteBL.codemoyentransport <> '' then begin
                    Camion.Get(pro_enteteBL.codemoyentransport);
                    if Camion.codetransporteur <> '' then
                        Vendor.Get(Camion.codetransporteur);
                end;

                //IF Camion.FINDFIRST then
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

    var
        "Order": Record "Sales Header";
        Location: Record Location;
        ShipAdrr: Record "Ship-to Address";
        Cust: Record Customer;
        RespCenter: Record "Responsibility Center";
        Camion: Record pro_moyentransport;
        ConVolume: Decimal;
        Vendor: Record Vendor;
        QtyLitre: Integer;
}

