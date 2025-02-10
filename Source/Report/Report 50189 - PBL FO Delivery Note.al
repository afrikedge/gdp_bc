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
            DataItemTableView = sorting(numBE) where(IsBon = const(true));
            RequestFilterFields = NumBU, idtournee;

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
            column(Duplicata; Duplicata)
            {
            }
            column(Comp1; Comp1)
            {
            }
            column(Comp2; Comp2)
            {
            }
            column(Comp3; Comp3)
            {
            }
            column(Comp4; Comp4)
            {
            }
            column(Comp5; Comp5)
            {
            }
            column(Comp6; Comp6)
            {
            }
            column(Comp7; Comp7)
            {
            }
            column(Comp8; Comp8)
            {
            }
            column(Comp9; Comp9)
            {
            }
            column(Comp10; Comp10)
            {
            }


            column(Prod1; Prod1)
            {
            }
            column(Prod2; Prod2)
            {
            }
            column(Prod3; Prod3)
            {
            }
            column(Prod4; Prod4)
            {
            }
            column(Prod5; Prod5)
            {
            }
            column(Prod6; Prod6)
            {
            }
            column(Prod7; Prod7)
            {
            }
            column(Prod8; Prod8)
            {
            }
            column(Prod9; Prod9)
            {
            }
            column(Prod10; Prod10)
            {
            }

            column(Vol1; Vol1)
            {
            }
            column(Vol2; Vol2)
            {
            }
            column(Vol3; Vol3)
            {
            }
            column(Vol4; Vol4)
            {
            }
            column(Vol5; Vol5)
            {
            }
            column(Vol6; Vol6)
            {
            }
            column(Vol7; Vol7)
            {
            }
            column(Vol8; Vol8)
            {
            }
            column(Vol9; Vol9)
            {
            }
            column(Vol10; Vol10)
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
                column(ConvertedVolume; ConvertedVolume)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    ConvertedVolume := Line.volumeaenlever * 1000;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if Customer.Get(Header."Customer No") then begin
                    CustSearchName := Customer."Search Name";
                    CustAddress := Customer.Address;
                end;

                if RespCenter.Get(Header.region) then
                    Agency := RespCenter.Name;

                if Location.Get(Header.depot) then
                    DepotName := Location.Name;

                if SalesHeader.Get(SalesHeader."Document Type"::Order, Header.NavOrderNo) then
                    DeliveryMode := SalesHeader."Shipment Method Code";

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";


                proEnteteBL.Reset;
                proEnteteBL.SetRange(numBE, Header.numBE);
                if proEnteteBL.FindFirst() then
                    if proEnteteBL.Imprime then
                        Duplicata := 'DUPLICATA' + ' ' + Format(proEnteteBL."Nos Printed");

                FindTouringProduct(Header);


                proEnteteBL.Reset;
                proEnteteBL.SetRange(numBE, Header.numBE);
                if proEnteteBL.FindFirst() then
                    IF not CurrReport.Preview then begin
                        proEnteteBL.Imprime := true;
                        proEnteteBL."Nos Printed" := proEnteteBL."Nos Printed" + 1;
                        proEnteteBL."Last Printed Date" := CreateDateTime(today, time);
                        proEnteteBL.Modify();
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
        proEnteteBL: Record pro_enteteBL;
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        RespCenter: Record "Responsibility Center";
        CompanyInfos: Record "Company Information";
        // ShipmentMethod: Record "Shipment Method";
        ConvertedVolume: Decimal;
        Comp1: Code[20];
        Comp2: Code[20];
        Comp3: Code[20];
        Comp4: Code[20];
        Comp5: Code[20];
        Comp6: Code[20];
        Comp7: Code[20];
        Comp8: Code[20];
        Comp9: Code[20];
        Comp10: Code[20];

        Prod1: Text[50];
        Prod2: Text[50];
        Prod3: Text[50];
        Prod4: Text[50];
        Prod5: Text[50];
        Prod6: Text[50];
        Prod7: Text[50];
        Prod8: Text[50];
        Prod9: Text[50];
        Prod10: Text[50];

        Vol1: Decimal;
        Vol2: Decimal;
        Vol3: Decimal;
        Vol4: Decimal;
        Vol5: Decimal;
        Vol6: Decimal;
        Vol7: Decimal;
        Vol8: Decimal;
        Vol9: Decimal;
        Vol10: Decimal;

        CustSearchName: Code[100];
        Foot3: Text;
        DepotName: Text[100];
        CustAddress: Text[100];
        Agency: Text[100];
        DeliveryMode: Text[100];
        Duplicata: Text;

        PBLFODeliveryNoteTitleLbl: Label 'PBL AND FO DELIVERY NOTE';
        BLNumberLbl: Label 'B/L N°';
        SalesAgencyLbl: Label 'SALES AGENCY';
        ActivityLbl: Label 'ACTIVITY';
        AgencyLbl: Label 'AGENCY';
        DateLbl: Label 'DATE';
        CustomerLbl: Label 'CUSTOMER';
        ValidUntilLbl: Label 'Valid until';

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

    local procedure FindTouringProduct(EnteteBE: record pro_enteteBE)
    var
        TouringEntry: Record "Touring Product Entry";
    begin
        Comp1 := '';
        Comp2 := '';
        Comp3 := '';
        Comp4 := '';
        Comp5 := '';
        Comp6 := '';
        Comp7 := '';
        Comp8 := '';
        Comp9 := '';
        Comp10 := '';

        Prod1 := '';
        Prod2 := '';
        Prod3 := '';
        Prod4 := '';
        Prod5 := '';
        Prod6 := '';
        Prod7 := '';
        Prod8 := '';
        Prod9 := '';
        Prod10 := '';

        Vol1 := 0;
        Vol2 := 0;
        Vol3 := 0;
        Vol4 := 0;
        Vol5 := 0;
        Vol6 := 0;
        Vol7 := 0;
        Vol8 := 0;
        Vol9 := 0;
        Vol10 := 0;

        TouringEntry.SetRange(IdTouring, EnteteBE.idtournee);
        TouringEntry.SetRange(OrderNo, EnteteBE.NavOrderNo);
        TouringEntry.SetRange(Immatriculation, EnteteBE.codemoyentransport);
        if TouringEntry.FindSet() then
            repeat
                if TouringEntry.IdCompartment = 1 then begin
                    Comp1 := 'C1';
                    Prod1 := TouringEntry.ItemNo;
                    Vol1 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 2 then begin
                    Comp2 := 'C2';
                    Prod2 := TouringEntry.ItemNo;
                    Vol2 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 3 then begin
                    Comp3 := 'C3';
                    Prod3 := TouringEntry.ItemNo;
                    Vol3 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 4 then begin
                    Comp4 := 'C4';
                    Prod4 := TouringEntry.ItemNo;
                    Vol4 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 5 then begin
                    Comp5 := 'C5';
                    Prod5 := TouringEntry.ItemNo;
                    Vol5 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 6 then begin
                    Comp6 := 'C6';
                    Prod6 := TouringEntry.ItemNo;
                    Vol6 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 7 then begin
                    Comp7 := 'C7';
                    Prod7 := TouringEntry.ItemNo;
                    Vol7 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 8 then begin
                    Comp8 := 'C8';
                    Prod8 := TouringEntry.ItemNo;
                    Vol8 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 9 then begin
                    Comp9 := 'C9';
                    Prod9 := TouringEntry.ItemNo;
                    Vol9 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 10 then begin
                    Comp10 := 'C10';
                    Prod10 := TouringEntry.ItemNo;
                    Vol10 := TouringEntry.Volume * 1000;
                end;
            until TouringEntry.Next() = 0;
    end;
}


