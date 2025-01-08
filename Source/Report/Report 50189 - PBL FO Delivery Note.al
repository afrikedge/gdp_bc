/// <summary>
/// Report PBL FO Delivery Note Print (ID 50189).
/// </summary>
report 50189 "PBL FO Delivery Note"
{
    Caption = 'PBL FO Delivery Note';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    EnableHyperlinks = true;
    WordMergeDataItem = Header;
    RDLCLayout = './Source/Report/Layout/PBLFODeliveryNote.rdl';

    dataset
    {
        dataitem(Header; pro_enteteBE)
        {
            DataItemTableView = sorting(numBE);
            RequestFilterFields = NumBU, numBL;

            column(numBE; numBE)
            {
            }
            column(numBL; numBL)
            {
            }
            column(NumBU; NumBU)
            {
            }
            column(NavOrderNo; NavOrderNo)
            {
            }
            column(depot; depot)
            {
            }
            column(region; region)
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
            column(Customer_No; "Customer No")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Agency; Agency)
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            column(CustSearchName; CustSearchName)
            {
            }
            column(DepotName; DepotName)
            {
            }
            column(DeliveryMode; DeliveryMode)
            {
            }
            column(observation; observation)
            {
            }
            column(datelivraison; datelivraison)
            {
            }
            column(PlaceOfDelivery; "Delivery Site")
            {
            }
            column(datevaliditeBL; "datevaliditeBL")
            {
            }
            column(PreparedBy; nom)
            {
            }
            column(AutorisedBy; nomresponsable)
            {
            }
            column(Foot1; 'Siège social ' + CompanyInfo.Address)
            {
            }
            column(Foot2; CompanyInfo."Post Code" + ' - ' + CompanyInfo.City)
            {
            }
            column(Foot3; Foot3)
            {
            }
            column(Foot4; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital" + ' - ' + 'NIF : ' + CompanyInfo."Registration No.")
            {
            }
            column(Foot5; 'R.C.S. : ' + CompanyInfo."Trade Register" + ' - ' + 'STAT : ' + CompanyInfo."Legal Form")
            {
            }
            column(Foot6; 'Email : ' + CompanyInfo."E-Mail")
            {
            }

            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(PBLFODeliveryNoteTitleLbl; PBLFODeliveryNoteTitleLbl)
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
            column(ValidUntilLbl; ValidUntilLbl)
            {
            }
            column(CustomerLbl; CustomerLbl)
            {
            }
            column(BLNumberLbl; BLNumberLbl)
            {
            }
            column(OrderNumberLbl; OrderNumberLbl)
            {
            }
            column(DeliveryDepotLbl; DeliveryDepotLbl)
            {
            }
            column(PlaceOfDeliveryLbl; PlaceOfDeliveryLbl)
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
            column(DeliveryModeLbl; DeliveryModeLbl)
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
            column(QuantityLbl; QuantityLbl)
            {
            }
            column(ConversionInM3Lbl; ConversionInM3Lbl)
            {
            }
            column(ObservationsLbl; ObservationsLbl)
            {
            }
            column(LoadingLbl; LoadingLbl)
            {
            }
            column(CompNumberLbl; CompNumberLbl)
            {
            }
            column(ProdLbl; ProdLbl)
            {
            }
            column(VolAmbientLbl; VolAmbientLbl)
            {
            }
            column(HollowLbl; HollowLbl)
            {
            }
            column(ValveLbl; ValveLbl)
            {
            }
            column(DomeLbl; DomeLbl)
            {
            }
            column(WaterLbl; WaterLbl)
            {
            }
            column(ConformitySealLbl; ConformitySealLbl)
            {
            }
            column(DeliveryLbl; DeliveryLbl)
            {
            }
            column(TempLbl; TempLbl)
            {
            }
            column(DensityLbl; DensityLbl)
            {
            }
            column(HollowObsLbl; HollowObsLbl)
            {
            }
            column(VolDeliveredLbl; VolDeliveredLbl)
            {
            }
            column(DifferenceLbl; DifferenceLbl)
            {
            }
            column(CustomerTankLbl; CustomerTankLbl)
            {
            }
            column(RemarksDeliveryWithSignLbl; RemarksDeliveryWithSignLbl)
            {
            }
            column(CustomerTxtLbl; CustomerTxtLbl)
            {
            }
            column(Name1Lbl; Name1Lbl)
            {
            }
            column(Date1Lbl; Date1Lbl)
            {
            }
            column(ArrivalTimeLbl; ArrivalTimeLbl)
            {
            }
            column(StartTimeLbl; StartTimeLbl)
            {
            }
            column(ForGalanaLbl; ForGalanaLbl)
            {
            }
            column(PreparedByLbl; PreparedByLbl)
            {
            }
            column(Name2Lbl; Name2Lbl)
            {
            }
            column(Date2Lbl; Date2Lbl)
            {
            }
            column(AuthorizedByLbl; AuthorizedByLbl)
            {
            }
            column(Name3Lbl; Name3Lbl)
            {
            }
            column(Date3Lbl; Date3Lbl)
            {
            }
            column(TheCarrierLbl; TheCarrierLbl)
            {
            }
            column(Name4Lbl; Name4Lbl)
            {
            }
            column(Date4Lbl; Date4Lbl)
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
                column(volumeaenlever; volumeaenlever)
                {
                }
                column(Quantity; volumealivrer)
                {
                }
                column(Unit_Code; "Unit of Measure Code")
                {
                }
                column(densite; densite)
                {
                }
                column(volumelivre; volumelivre)
                {
                }
                column(volumea15; volumea15)
                {
                }
                column(ShippedVol; "Shipped Volume")
                {
                }
                column(temperature; temperature)
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

                    trigger OnAfterGetRecord()
                    begin
                        If BonLoading.FindSet() then
                            repeat
                                BonLoading.Reset();
                                BonLoading.SetRange(numBE, Line.numBE);
                                BonLoading.SetRange("Product Code", Line.codeproduit);
                            until BonLoading.Next() = 0;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    Lines := 1;
                    LineNumber := LineNumber + 1;
                    if (LineNumber < 10) then
                        LineNumberText := '0' + Format(LineNumber)
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
                    Lines := 1;
                    LineNumber := LineNumber + 1;
                    if (LineNumber < 10) then
                        LineNumberText := '0' + Format(LineNumber)
                    else
                        LineNumberText := Format(LineNumber);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 5 - LinesNumb);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                LineNumber := 0;

                if Customer.Get(Header."Customer No") then begin
                    CustSearchName := Customer."Search Name";
                    CustAddress := Customer.Address;
                end;

                if RespCenter.Get(Header.region) then
                    Agency := RespCenter.Name;

                if Location.Get(Header.depot) then
                    DepotName := Location.Name;

                if SalesHeader.Get(Header.NavOrderNo) then
                    DeliveryMode := SalesHeader."Shipment Method Code";

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";
            end;

            trigger OnPostDataItem()
            var
                proEnteteBL: record pro_enteteBE;
            begin
                if not CurrReport.Preview then
                    if (proEnteteBL.get(Header.numBL)) then begin
                        proEnteteBL.Imprime := true;
                        proEnteteBL."Last Printed Date" := CreateDateTime(Today(), Time());
                        proEnteteBL."Nos Printed" := proEnteteBL."Nos Printed" + 1;
                        proEnteteBL.Modify();
                        Commit();
                    end;
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
        Customer: Record Customer;
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        RespCenter: Record "Responsibility Center";
        CompanyInfos: Record "Company Information";
        // ShipmentMethod: Record "Shipment Method";
        CustSearchName: Code[100];
        Foot3: Text;
        DepotName: Text[100];
        CustAddress: Text[100];
        Agency: Text[100];
        DeliveryMode: Text[100];
        Lines: Integer;
        LineNumber: Integer;
        LinesNumb: Integer;
        LineNumberText: Code[2];

        PBLFODeliveryNoteTitleLbl: Label 'PBL AND FO DELIVERY NOTE';
        BLNumberLbl: Label 'B/L N°';
        SalesAgencyLbl: Label 'SALES AGENCY';
        ActivityLbl: Label 'ACTIVITY';
        AgencyLbl: Label 'AGENCY';
        DateLbl: Label 'DATE';
        CustomerLbl: Label 'CUSTOMER';
        ValidUntilLbl: Label 'Valid until';

        // DuplicataLbl: Label 'DUPLICATA';

        OrderNumberLbl: Label 'ORDER N° :';
        DeliveryDepotLbl: Label 'DELIVERY DEPOT :';
        PlaceOfDeliveryLbl: Label 'PLACE OF DELIVERY :';

        CarrierLbl: Label 'CARRIER :';
        DriverNameLbl: Label 'DRIVER''S NAME :';
        LicenseNumberLbl: Label 'LICENSE N° :';
        TruckNumberLbl: Label 'TRUCK N° :';
        DeliveryModeLbl: Label 'DELIVERY MODE :';

        DesignationLbl: Label 'DESIGNATION';
        ProductLbl: Label 'product';
        ProductCodeLbl: Label 'Code';
        QuantityLbl: Label 'QUANTITY';
        ConversionInM3Lbl: Label 'CONVERSION IN M3';
        ObservationsLbl: Label 'OBSERVATIONS';
        LoadingLbl: Label 'LOADING';
        CompNumberLbl: Label 'Comp N°';
        ProdLbl: Label 'Product';
        VolAmbientLbl: Label 'Ambient Vol.';
        HollowLbl: Label 'Hollow';
        ConformitySealLbl: Label 'CONFORMITY SEAL';
        ValveLbl: Label 'Valve';
        DomeLbl: Label 'Dome';
        DeliveryLbl: Label 'DELIVERY';
        WaterLbl: Label 'Water';
        TempLbl: Label 'T°';
        DensityLbl: Label 'Density';
        HollowObsLbl: Label 'Hollow Obs.';
        VolDeliveredLbl: Label 'Vol. Delivered';
        DifferenceLbl: Label 'Difference';
        CustomerTankLbl: Label 'Customer tank';
        RemarksDeliveryWithSignLbl: Label 'Remarks on delivery with signatures :';
        CustomerTxtLbl: Label 'THE CUSTOMER';
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
        TheCarrierLbl: Label 'THE CARRIER';
        Name4Lbl: Label 'Name :';
        Date4Lbl: Label 'Date :';

}