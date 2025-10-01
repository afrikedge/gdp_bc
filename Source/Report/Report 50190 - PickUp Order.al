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
            column(RegimeDouanier; RegimeDouanier)
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
            column(TotalGO; TotalGO)
            {
            }
            column(TotalSP; TotalSP)
            {
            }
            column(Duplicata; Duplicata)
            {
            }
            column(TotalPL; TotalPL)
            {
            }
            column(TotalFO; TotalFO)
            {
            }
            column(UnitLbl; UnitLbl)
            {
            }

            column(ItName1; ItName1)
            {
            }
            column(ItName2; ItName2)
            {
            }
            column(ItName3; ItName3)
            {
            }
            column(ItName4; ItName4)
            {
            }
            column(ItName5; ItName5)
            {
            }

            column(ItCode1; ItCode1)
            {
            }
            column(ItCode2; ItCode2)
            {
            }
            column(ItCode3; ItCode3)
            {
            }
            column(ItCode4; ItCode4)
            {
            }
            column(ItCode5; ItCode5)
            {
            }

            column(ItVol1; ItVol1)
            {
            }
            column(ItVol2; ItVol2)
            {
            }
            column(ItVol3; ItVol3)
            {
            }
            column(ItVol4; ItVol4)
            {
            }
            column(ItVol5; ItVol5)
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
            column(Compteur; Compteur)
            {
            }
            column(SignSignature; UserSetup."Afk Signature")
            {
            }
            column(SignSignature2; UserSetup2."Afk Signature")
            {
            }
            column(SignatureDate; Format(Today))
            {
            }
            column(CompanyStamp; CompanyInfo."Company Stamp")
            {
            }
            trigger OnAfterGetRecord()
            begin
                if RespCenter.Get(Header.region) then
                    Agency := RespCenter.Name;

                if Location.Get(Header.depot) then
                    DepotName := Location.Name;

                if SalesHeader.Get(SalesHeader."Document Type"::Order, Header.NavOrderNo) then
                    DeliveryMode := SalesHeader."Shipment Method Code";

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";

                if Imprime then
                    Duplicata := 'DUPLICATA' + ' ' + Format("Nos Printed");

                Clear(TotalGO);
                Clear(TotalSP);
                Clear(TotalPL);
                Clear(TotalFO);
                LineRec.SetRange(numBE, Header.numBE);
                if LineRec.Findset() then
                    repeat
                        if LineRec.codeproduit = 'GO' then
                            TotalGO := TotalGO + LineRec.volumealivrer * 1000;
                    until LineRec.Next() = 0;

                if LineRec.Findset() then
                    repeat
                        if LineRec.codeproduit = 'SC' then
                            TotalSP := TotalSP + LineRec.volumealivrer * 1000;
                    until LineRec.Next() = 0;

                if LineRec.Findset() then
                    repeat
                        if LineRec.codeproduit = 'PL' then
                            TotalPL := TotalPL + LineRec.volumealivrer * 1000;
                    until LineRec.Next() = 0;

                if LineRec.Findset() then
                    repeat
                        if LineRec.codeproduit = 'FO' then
                            TotalFO := TotalFO + LineRec.volumealivrer;
                    until LineRec.Next() = 0;

                FindLineProduct(Header);
                FindTouringProduct(Header);

                IF not CurrReport.Preview then begin
                    Header.Imprime := true;
                    Header."Nos Printed" := Header."Nos Printed" + 1;
                    Header."Last Printed Date" := CreateDateTime(today, time);
                    Header.Modify();
                end;

                // -----------*--------- Signature Dispatcheur ---------*----------//
                GetUserSignature(UserSetup, UserSetup2, Header);
                // -----------*--------- Signature Dispatcheur ---------*----------//
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
        CompanyInfo.CalcFields("Company Stamp");
    end;

    var
        CompanyInfo: Record "Company Information";
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        LineRec: Record pro_detailBE;
        RespCenter: Record "Responsibility Center";
        CompanyInfos: Record "Company Information";
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        // ShipmentMethod: Record "Shipment Method";
        ItName1: Text[50];
        ItName2: Text[50];
        ItName3: Text[50];
        ItName4: Text[50];
        ItName5: Text[50];

        ItCode1: Code[20];
        ItCode2: Code[20];
        ItCode3: Code[20];
        ItCode4: Code[20];
        ItCode5: Code[20];

        ItVol1: Decimal;
        ItVol2: Decimal;
        ItVol3: Decimal;
        ItVol4: Decimal;
        ItVol5: Decimal;

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

        Compteur: Integer;

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

        DepotName: Text[100];
        Foot3: Text;
        TotalSP: Decimal;
        TotalGO: Decimal;
        TotalFO: Decimal;
        TotalPL: Decimal;
        Agency: Text[100];
        DeliveryMode: Text[100];
        Duplicata: Text;
        PickUpOrderTitleLbl: Label 'PICK-UP ORDER';
        BENumberLbl: Label 'B/E N°';
        SalesAgencyLbl: Label 'SALES AGENCY';
        ActivityLbl: Label 'ACTIVITY';
        AgencyLbl: Label 'AGENCY';
        DateLbl: Label 'DATE';
        DeliveryDepotLbl: Label 'DELIVERY DEPOT';
        ValidUntilLbl: Label 'Valid until';
        DestinationLbl: Label 'Destination :';
        NavireNameLbl: Label 'Navire name :';
        RDLbl: Label 'R.D :';
        UnitLbl: Label 'L';
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

    local procedure FindLineProduct(EnteteBE: record pro_enteteBE)
    var
        LineDetailBE: Record pro_detailBE;
        LineNo: Integer;
    begin
        ItCode1 := '';
        ItCode2 := '';
        ItCode3 := '';
        ItCode4 := '';
        ItCode5 := '';

        ItName1 := '';
        ItName2 := '';
        ItName3 := '';
        ItName4 := '';
        ItName5 := '';

        ItVol1 := 0;
        ItVol2 := 0;
        ItVol3 := 0;
        ItVol4 := 0;
        ItVol5 := 0;

        LineDetailBE.SetRange(numBE, EnteteBE.numBE);
        if LineDetailBE.FindSet() then
            repeat
                LineNo += 1;

                LineDetailBE.CalcFields("Item Name");
                if LineNo = 1 then begin
                    ItCode1 := LineDetailBE.NavItemCode;
                    ItName1 := LineDetailBE."Item Name";

                    if LineDetailBE."Unit of Measure Code" = 'M3' then
                        ItVol1 := LineDetailBE.volumeaenlever * 1000
                    else
                        ItVol1 := LineDetailBE.volumeaenlever;
                end;

                if LineNo = 2 then begin
                    ItCode2 := LineDetailBE.NavItemCode;
                    ItName2 := LineDetailBE."Item Name";

                    if LineDetailBE."Unit of Measure Code" = 'M3' then
                        ItVol2 := LineDetailBE.volumeaenlever * 1000
                    else
                        ItVol2 := LineDetailBE.volumeaenlever;
                end;

                if LineNo = 3 then begin
                    ItCode3 := LineDetailBE.NavItemCode;
                    ItName3 := LineDetailBE."Item Name";

                    if LineDetailBE."Unit of Measure Code" = 'M3' then
                        ItVol3 := LineDetailBE.volumeaenlever * 1000
                    else
                        ItVol3 := LineDetailBE.volumeaenlever;
                end;

                if LineNo = 4 then begin
                    ItCode4 := LineDetailBE.NavItemCode;
                    ItName4 := LineDetailBE."Item Name";

                    if LineDetailBE."Unit of Measure Code" = 'M3' then
                        ItVol4 := LineDetailBE.volumeaenlever * 1000
                    else
                        ItVol4 := LineDetailBE.volumeaenlever;
                end;

                if LineNo = 5 then begin
                    ItCode5 := LineDetailBE.NavItemCode;
                    ItName5 := LineDetailBE."Item Name";

                    if LineDetailBE."Unit of Measure Code" = 'M3' then
                        ItVol5 := LineDetailBE.volumeaenlever * 1000
                    else
                        ItVol5 := LineDetailBE.volumeaenlever;
                end;
            until LineDetailBE.Next() = 0;
    end;

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
                Compteur := TouringEntry.IdCompartment;

                if TouringEntry.IdCompartment = 1 then begin
                    Comp1 := 'N°1';
                    Prod1 := TouringEntry.ItemNo;
                    Vol1 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 2 then begin
                    Comp2 := 'N°2';
                    Prod2 := TouringEntry.ItemNo;
                    Vol2 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 3 then begin
                    Comp3 := 'N°3';
                    Prod3 := TouringEntry.ItemNo;
                    Vol3 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 4 then begin
                    Comp4 := 'N°4';
                    Prod4 := TouringEntry.ItemNo;
                    Vol4 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 5 then begin
                    Comp5 := 'N°5';
                    Prod5 := TouringEntry.ItemNo;
                    Vol5 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 6 then begin
                    Comp6 := 'N°6';
                    Prod6 := TouringEntry.ItemNo;
                    Vol6 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 7 then begin
                    Comp7 := 'N°7';
                    Prod7 := TouringEntry.ItemNo;
                    Vol7 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 8 then begin
                    Comp8 := 'N°8';
                    Prod8 := TouringEntry.ItemNo;
                    Vol8 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 9 then begin
                    Comp9 := 'N°9';
                    Prod9 := TouringEntry.ItemNo;
                    Vol9 := TouringEntry.Volume * 1000;
                end;
                if TouringEntry.IdCompartment = 10 then begin
                    Comp10 := 'N°10';
                    Prod10 := TouringEntry.ItemNo;
                    Vol10 := TouringEntry.Volume * 1000;
                end;
            until TouringEntry.Next() = 0;
    end;

    procedure GetUserSignature(var USetup1: record "User Setup"; var USetup2: record "User Setup"; Dispach: Record pro_enteteBE)
    Var
        UserT: Record "User Setup";
    begin
        Clear(UserT);
        Clear(USetup1);
        Clear(USetup2);

        Usetup1.SetRange("Afk Dispatch User", Dispach.nom);
        if USetup1.FindFirst() then
            USetup1.CalcFields("Afk Signature");

        Usetup2.SetRange("Afk Dispatch User", Dispach.nomresponsable);
        if USetup2.FindFirst() then
            USetup2.CalcFields("Afk Signature");
    end;
}