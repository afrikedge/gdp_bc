/// <summary>
/// Report PickUp Order (ID 50190).
/// </summary>
report 50190 "PickUp Order"
{
    Caption = 'PickUp Order';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    EnableHyperlinks = true;
    WordMergeDataItem = Header;
    RDLCLayout = './Source/Report/Layout/PickUpOrder.rdl';

    dataset
    {
        dataitem(Header; pro_enteteBE)
        {
            DataItemTableView = sorting(numBE);
            RequestFilterFields = NumBU, numBE;
            column(numBE; numBE)
            {
            }
            column(numBL; numBL)
            {
            }
            column(NumBU; NumBU)
            {
            }
            column(datevalidite; Format(datevalidite))
            {
            }
            column(region; region)
            {
            }
            column(depot; depot)
            {
            }
            column(dateBE; dateBE)
            {
            }
            column(Destination; Destination)
            {
            }
            column(Cargo_Name; "Cargo Name")
            {
            }
            column(nomchauffeur; nomchauffeur)
            {
            }
            column(nomTransporteur; nomTransporteur)
            {
            }
            column(permis; permis)
            {
            }
            column(codemoyentransport; codemoyentransport)
            {
            }
            column(DepotName; DepotName)
            {
            }
            column(DeliveryMode; DeliveryMode)
            {
            }
            column(Agency; Agency)
            {
            }
            column(observation; observation)
            {
            }
            column(PreparedBy; nom)
            {
            }
            column(AutorisedBy; nomresponsable)
            {
            }


            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(PickUpOrderTitleLbl; PickUpOrderTitleLbl)
            {
            }
            column(SalesAgencyLbl; SalesAgencyLbl)
            {
            }
            column(ActivityLbl; ActivityLbl)
            {
            }
            column(AgencyLbl; AgencyLbl)
            {
            }
            column(DateLbl; DateLbl)
            {
            }
            column(BENumberLbl; BENumberLbl)
            {
            }
            column(DeliveryDepotLbl; DeliveryDepotLbl)
            {
            }
            column(ValidUntilLbl; ValidUntilLbl)
            {
            }
            column(DestinationLbl; DestinationLbl)
            {
            }
            column(NavireNameLbl; NavireNameLbl)
            {
            }
            column(RDLbl; RDLbl)
            {
            }
            column(DeliveryModeLbl; DeliveryModeLbl)
            {
            }
            column(CarrierLbl; CarrierLbl)
            {
            }
            column(DriverNameLbl; DriverNameLbl)
            {
            }
            column(LicenseNumberLbl; LicenseNumberLbl)
            {
            }
            column(TruckNumberLbl; TruckNumberLbl)
            {
            }
            column(DesignationLbl; DesignationLbl)
            {
            }
            column(ProductLbl; ProductLbl)
            {
            }
            column(ProductCodeLbl; ProductCodeLbl)
            {
            }
            column(AmbientVolumeLbl; AmbientVolumeLbl)
            {
            }
            column(CompartmentLbl; CompartmentLbl)
            {
            }
            column(Product2Lbl; Product2Lbl)
            {
            }
            column(NoLbl; NoLbl)
            {
            }
            column(ObservationsLbl; ObservationsLbl)
            {
            }
            column(ForGalanaLbl; ForGalanaLbl)
            {
            }
            column(PreparedByLbl; PreparedByLbl)
            {
            }
            column(Name1Lbl; Name1Lbl)
            {
            }
            column(Date1Lbl; Date1Lbl)
            {
            }
            column(AuthorizedByLbl; AuthorizedByLbl)
            {
            }
            column(Name2Lbl; Name2Lbl)
            {
            }
            column(Date2Lbl; Date2Lbl)
            {
            }
            column(ForLogisticLbl; ForLogisticLbl)
            {
            }
            column(DepotLoaderLbl; DepotLoaderLbl)
            {
            }
            column(Name3Lbl; Name3Lbl)
            {
            }
            column(Date3Lbl; Date3Lbl)
            {
            }
            column(DepotcontrolLbl; DepotcontrolLbl)
            {
            }
            column(Name4Lbl; Name4Lbl)
            {
            }
            column(Date4Lbl; Date4Lbl)
            {
            }
            column(ForCarrierLbl; ForCarrierLbl)
            {
            }
            column(Name5Lbl; Name5Lbl)
            {
            }
            column(Date5Lbl; Date5Lbl)
            {
            }
            column(ArrivalTimeLbl; ArrivalTimeLbl)
            {
            }
            column(StartTimeLbl; StartTimeLbl)
            {
            }
            column(TotalSP95Lbl; TotalSP95Lbl)
            {
            }
            column(TotalPLLbl; TotalPLLbl)
            {
            }
            column(TotalGOLbl; TotalGOLbl)
            {
            }
            column(TotalFOLbl; TotalFOLbl)
            {
            }
            dataitem(Line; pro_detailBE)
            {
                DataItemTableView = sorting(numBE, "Line No.");
                DataItemLinkReference = Header;
                DataItemLink = numBE = field(numBE);

                column(NavItemCode; NavItemCode)
                {
                }
                column(Item_Name; "Item Name")
                {
                }
                column(Unit_Code; "Unit of Measure Code")
                {
                }
                column(volumealivrer; volumealivrer)
                {
                }
                column(volumea15; volumea15)
                {
                }
                column(Shipped_Vol; "Shipped Volume")
                {
                }
                column(Lines; Lines)
                {
                }
                column(LineNumberText; LineNumberText)
                {
                }
                dataitem(BonLoading; BonLoading)
                {
                    DataItemTableView = sorting(numBE, Compartment);
                    DataItemLinkReference = Line;
                    DataItemLink = numBE = field(numBE), "Product Code" = field(codeproduit);

                    column(Compartment; Compartment)
                    {
                    }
                    column(Product; Product)
                    {
                    }
                    column(Shipped_Volume; "Shipped Volume")
                    {
                    }
                    column(TotalSP; TotalSP)
                    {
                    }
                    column(TotalGO; TotalGO)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        If BonLoading.FindSet() then
                            repeat
                                BonLoading.Reset();
                                BonLoading.SetRange(numBE, Line.numBE);
                                BonLoading.SetRange("Product Code", Line.codeproduit);
                            until BonLoading.Next() = 0;

                        Clear(TotalSP);
                        BonLoadRec.Reset();
                        BonLoadRec.SetRange(numBE, Line.numBE);
                        BonLoadRec.SetRange("Product Code", 'SP');
                        if BonLoadRec.FindFirst() then
                            repeat
                                TotalSP := BonLoadRec."Shipped Volume";
                            until BonLoadRec.Next() = 0;

                        Clear(TotalGO);
                        BonLoadRec.Reset();
                        BonLoadRec.SetRange(numBE, Line.numBE);
                        BonLoadRec.SetRange("Product Code", 'GO');
                        if BonLoadRec.FindFirst() then
                            repeat
                                TotalSP := BonLoadRec."Shipped Volume";
                            until BonLoadRec.Next() = 0;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    Lines := 'N°1';
                    LineNumber := LineNumber + 1;
                    if (LineNumber < 11) then
                        LineNumberText := 'N°' + Format(LineNumber)
                    else
                        LineNumberText := Format(LineNumber);
                end;

                trigger OnPreDataItem()
                begin
                    LinesNumb := Count();
                end;
            }
            dataitem(LineFooter; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(LinesFoot; Lines)
                {
                }
                column(LineNumberFoot; LineNumberText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Lines := 'N°1';
                    LineNumber := LineNumber + 1;
                    if (LineNumber < 11) then
                        LineNumberText := 'N°' + Format(LineNumber)
                    else
                        LineNumberText := Format(LineNumber);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 10 - LinesNumb);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                LineNumber := 0;

                if RespCenter.Get(Header.region) then
                    Agency := RespCenter.Name;

                if Location.Get(Header.depot) then
                    DepotName := Location.Name;

                if SalesHeader.Get(Header.NavOrderNo) then
                    DeliveryMode := SalesHeader."Shipment Method Code";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
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
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        LineRec: Record pro_detailBE;
        BonLoadRec: Record BonLoading;
        RespCenter: Record "Responsibility Center";
        // ShipmentMethod: Record "Shipment Method";
        DepotName: Text[100];
        TotalSP: Decimal;
        TotalGO: Decimal;
        Agency: Text[100];
        DeliveryMode: Text[100];
        Lines: Code[4];
        LineNumber: Integer;
        LinesNumb: Integer;
        LineNumberText: Code[4];

        PickUpOrderTitleLbl: Label 'PICK-UP ORDER';
        BENumberLbl: Label 'B/E N°';
        SalesAgencyLbl: Label 'SALES AGENCY';
        ActivityLbl: Label 'ACTIVITY';
        AgencyLbl: Label 'AGENCY';
        DateLbl: Label 'DATE';
        DeliveryDepotLbl: Label 'DELIVERY DEPOT';
        ValidUntilLbl: Label 'Valid until';

        // DuplicataLbl: Label 'DUPLICATA';

        DestinationLbl: Label 'Destination :';
        NavireNameLbl: Label 'Navire name :';
        RDLbl: Label 'R.D :';
        DeliveryModeLbl: Label 'Delivery mode :';
        CarrierLbl: Label 'CARRIER :';
        DriverNameLbl: Label 'DRIVER''S NAME :';
        LicenseNumberLbl: Label 'LICENSE N° :';
        TruckNumberLbl: Label 'TRUCK N° :';
        DesignationLbl: Label 'DESIGNATION';
        ProductLbl: Label 'product';
        ProductCodeLbl: Label 'Code';
        AmbientVolumeLbl: Label 'Ambient VOLUME';
        CompartmentLbl: Label 'COMPARTMENT';
        Product2Lbl: Label 'PRODUCT';
        ObservationsLbl: Label 'OBSERVATIONS';
        NoLbl: Label 'N°';
        ForLogisticLbl: Label 'For LOGISTIC';
        ForCarrierLbl: Label 'For the CARRIER';
        Name1Lbl: Label 'Name :';
        Date1Lbl: Label 'Date :';
        ArrivalTimeLbl: Label 'Arrival time :';
        StartTimeLbl: Label 'Start time :';
        ForGalanaLbl: Label 'FOR GALANA';
        PreparedByLbl: Label 'Prepared by :';
        Name2Lbl: Label 'Name :';
        Date2Lbl: Label 'Date :';
        AuthorizedByLbl: Label 'Authorized by :';
        Name3Lbl: Label 'Name :';
        Date3Lbl: Label 'Date :';
        DepotLoaderLbl: Label 'Depot loader';
        DepotcontrolLbl: Label 'Depot Control';
        Name4Lbl: Label 'Name :';
        Date4Lbl: Label 'Date :';
        Name5Lbl: Label 'Name :';
        Date5Lbl: Label 'Date :';
        TotalSP95Lbl: Label 'TOTAL SUPER SP95';
        TotalPLLbl: Label 'TOTAL LAMP OIL';
        TotalGOLbl: Label 'TOTAL GAS OIL';
        TotalFOLbl: Label 'TOTAL FUEL OIL';

}