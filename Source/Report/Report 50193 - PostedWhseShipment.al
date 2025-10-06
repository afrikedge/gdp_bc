/// <summary>
/// Report Posted Whse Shipment (ID 50193).
/// </summary>
report 50193 "Posted Whse Shipment"
{
    Caption = 'Delivery Note';
    DefaultLayout = RDLC;
    UsageCategory = Documents;
    ApplicationArea = All;
    WordMergeDataItem = Header;
    RDLCLayout = './Source/Report/Layout/PostedWhseShipment.rdl';

    dataset
    {
        dataitem(Header; "Posted Whse. Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(DocumentNo; Header."No.")
                {
                }
                column(CompanyPicture; CompanyInfo.Picture)
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
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(Date; Format(Header."Posting Date"))
                {
                }
                column(LocationCode; Format(Header."Location Code"))
                {
                }
                column(DepotName; DepotName)
                {
                }
                column(WhsePostedShipmentCaptionLbl; WhsePostedShipmentCaptionLbl)
                {
                }
                column(BLNumberCaptionLbl; BLNumberCaptionLbl)
                {
                }
                column(SalesAgencyCaptionLbl; SalesAgencyCaptionLbl)
                {
                }
                column(ActivityCaptionLbl; ActivityCaptionLbl)
                {
                }
                column(AgencyCaptionLbl; AgencyCaptionLbl)
                {
                }
                column(DateCaptionLbl; DateCaptionLbl)
                {
                }
                column(CustomerCaptionLbl; CustomerCaptionLbl)
                {
                }
                column(OrderNumberCaptionLbl; OrderNumberCaptionLbl)
                {
                }
                column(DeliveryDepotCaptionLbl; DeliveryDepotCaptionLbl)
                {
                }
                column(DeliveryPlaceCaptionLbl; DeliveryPlaceCaptionLbl)
                {
                }
                column(DesignationCaptionLbl; DesignationCaptionLbl)
                {
                }
                column(ProductCaptionLbl; ProductCaptionLbl)
                {
                }
                column(ProductCodeCaptionLbl; ProductCodeCaptionLbl)
                {
                }
                column(QtyOrNbCaptionLbl; QtyOrNbCaptionLbl)
                {
                }
                column(BacthCaptionLbl; BacthCaptionLbl)
                {
                }
                column(PLVCaptionLbl; PLVCaptionLbl)
                {
                }
                column(PCBCaptionLbl; PCBCaptionLbl)
                {
                }
                column(ConversionInCM3CaptionLbl; ConversionInCM3CaptionLbl)
                {
                }
                column(CarrierCaptionLbl; CarrierCaptionLbl)
                {
                }
                column(DriverNameCaptionLbl; DriverNameCaptionLbl)
                {
                }
                column(LicenseNumberCaptionLbl; LicenseNumberCaptionLbl)
                {
                }
                column(TruckNumberCaptionLbl; TruckNumberCaptionLbl)
                {
                }
                column(TheCustomerCaptionLbl; TheCustomerCaptionLbl)
                {
                }
                column(Name1CaptionLbl; Name1CaptionLbl)
                {
                }
                column(Date1CaptionLbl; Date1CaptionLbl)
                {
                }
                column(ArrivalTimeCaptionLbl; ArrivalTimeCaptionLbl)
                {
                }
                column(StartTimeCaptionLbl; StartTimeCaptionLbl)
                {
                }
                column(ForGalanaCaptionLbl; ForGalanaCaptionLbl)
                {
                }
                column(AuthorizedByCaptionLbl; AuthorizedByCaptionLbl)
                {
                }
                column(Name2CaptionLbl; Name2CaptionLbl)
                {
                }
                column(Date2CaptionLbl; Date2CaptionLbl)
                {
                }
                column(TheWhseMgrCaptionLbl; TheWhseMgrCaptionLbl)
                {
                }
                column(Name3CaptionLbl; Name3CaptionLbl)
                {
                }
                column(Date3CaptionLbl; Date3CaptionLbl)
                {
                }
                column(TheSecurityCaptionLbl; TheSecurityCaptionLbl)
                {
                }
                column(Name4CaptionLbl; Name4CaptionLbl)
                {
                }
                column(Date4CaptionLbl; Date4CaptionLbl)
                {
                }
                column(TheCarrierCaptionLbl; TheCarrierCaptionLbl)
                {
                }
                column(Name5CaptionLbl; Name5CaptionLbl)
                {
                }
                column(Date5CaptionLbl; Date5CaptionLbl)
                {
                }
                column(ObservationsCaptionLbl; ObservationsCaptionLbl)
                {
                }
                column(Location_Code; Header."Location Code")
                {
                }
                column(UserCode; Header."Assigned User ID")
                {
                }
                column(Camion; Header."Afk Truck Code")
                {
                }
                column(Transporteur; Header."Afk Transporter Name")
                {
                }
                column(NomChauffeur; Header.AfkNomchauffeur)
                {
                }
                column(NoPermis; Header.AfkPermis)
                {
                }
                column(CompanyInfoName; CompanyInfo.Name)
                {
                }
                column(CompanyStamp; CompanyInfo."Company Stamp")
                {
                }
                dataitem(Line; "Posted Whse. Shipment Line")
                {
                    DataItemLink = "No." = field("No.");
                    DataItemLinkReference = Header;
                    DataItemTableView = sorting("No.", "Line No.");
                    column(Lines; Lines)
                    {
                    }
                    column(No_; "Item No.")
                    {
                    }
                    column(OrderNo; "Source No.")
                    {
                    }
                    column(Description; Description)
                    {
                    }
                    column(Quantity; Quantity)
                    {
                    }
                    column(LineNumberText; LineNumberText)
                    {
                    }
                    column(ShelfNo_PostedWhseShptLine; "Shelf No.")
                    {
                    }
                    column(QtyConverted; QtyConverted)
                    {
                    }
                    column(TonneConversion; TonneConversion)
                    {
                    }
                    column(Address; Address)
                    {
                    }
                    column(Agency; Agency)
                    {
                    }
                    column(Batch; Batch)
                    {
                    }
                    column(ExpDate; ExpDate)
                    {
                    }
                    dataitem(Customer; Customer)
                    {
                        DataItemLink = "No." = field("Destination No.");
                        DataItemLinkReference = Line;
                        DataItemTableView = sorting("No.");
                        column(Customer_No_; "No.")
                        {
                        }
                        column(Customer_Name; Name)
                        {
                        }
                        column(Customer_Name_2; "Search Name")
                        {
                        }
                        column(Sell_to_Address; Address)
                        {
                        }
                        column(RespCent; "Responsibility Center")
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");

                        Lines := 1;
                        LineNumber := LineNumber + 1;
                        if (LineNumber < 10) then
                            LineNumberText := '0' + Format(LineNumber)
                        else
                            LineNumberText := Format(LineNumber);

                        QtyConverted := Quantity * 1000;
                        Item.Get(Line."Item No.");
                        if Item."Sales Category Code" = 'LUB' then
                            TonneConversion := Item."Gross Weight" * Line.Quantity
                        else
                            if ItemUnitMeasure.Get(Line."Item No.", Line."Unit of Measure Code") then
                                if ItemUnitMeasure.Get(Line."Item No.", 'KG') then
                                    TonneConversion := Line.Quantity / ItemUnitMeasure."Qty. per Unit of Measure";

                        Address := GetShipToAddress(Line);
                        Agency := GetRespCenter(Line);
                        Batch := GetBatchNumber(Line);
                        ExpDate := GetExpirationDate(Line);
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
                        SetRange(Number, 1, 12 - LinesNumb);
                    end;
                }
            }
            trigger OnAfterGetRecord()
            begin
                LineNumber := 0;
                GetLocation("Location Code");

                if Location.Get(Header."Location Code") then
                    DepotName := Location.Name;

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";
            end;
        }
    }

    requestpage
    {
        Caption = 'Warehouse Posted Shipment';

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.CalcFields("Company Stamp");
    end;

    var
        Location: Record Location;
        Item: Record Item;
        ItemUnitMeasure: Record "Item Unit of Measure";
        CompanyInfo: Record "Company Information";
        CompanyInfos: Record "Company Information";
        QtyConverted: Decimal;
        TonneConversion: Decimal;
        Lines: Integer;
        LineNumber: Integer;
        LinesNumb: Integer;
        LineNumberText: Code[2];
        DepotName: Text[100];
        Address: Text;
        Agency: Text;
        Batch: Text;
        ExpDate: Text;
        Foot3: Text;
        // PAGENOCaptionLbl: Label 'Page';
        WhsePostedShipmentCaptionLbl: Label 'DELIVERY NOTE';
        BLNumberCaptionLbl: Label 'B/L N°';
        SalesAgencyCaptionLbl: Label 'SALES AGENCY';
        ActivityCaptionLbl: Label 'ACTIVITY';
        AgencyCaptionLbl: Label 'AGENCY';
        DateCaptionLbl: Label 'DATE';
        CustomerCaptionLbl: Label 'CUSTOMER';
        OrderNumberCaptionLbl: Label 'Order N° :';
        DeliveryDepotCaptionLbl: Label 'DELIVERY DEPOT :';
        DeliveryPlaceCaptionLbl: Label 'DELIVERY PLACE :';
        DesignationCaptionLbl: Label 'DESIGNATION';
        ProductCaptionLbl: Label 'product';
        ProductCodeCaptionLbl: Label 'Code';
        QtyOrNbCaptionLbl: Label 'QUANTITY or NUMBER';
        BacthCaptionLbl: Label 'BATCH';
        PLVCaptionLbl: Label 'PLV';
        PCBCaptionLbl: Label 'PCB';
        ConversionInCM3CaptionLbl: Label 'CONVERSION in M3 or T';
        CarrierCaptionLbl: Label 'CARRIER :';
        DriverNameCaptionLbl: Label 'DRIVER''S NAME :';
        LicenseNumberCaptionLbl: Label 'LICENSE N° :';
        TruckNumberCaptionLbl: Label 'TRUCK N° :';
        TheCustomerCaptionLbl: Label 'THE CUSTOMER';
        Name1CaptionLbl: Label 'Name :';
        Date1CaptionLbl: Label 'Date :';
        ArrivalTimeCaptionLbl: Label 'Arrival time :';
        StartTimeCaptionLbl: Label 'Start time :';
        ForGalanaCaptionLbl: Label 'FOR GALANA';
        AuthorizedByCaptionLbl: Label 'Authorized by :';
        Name2CaptionLbl: Label 'Name :';
        Date2CaptionLbl: Label 'Date :';
        TheWhseMgrCaptionLbl: Label 'THE WAREHOUSE MANAGER';
        Name3CaptionLbl: Label 'Name :';
        Date3CaptionLbl: Label 'Date :';
        TheSecurityCaptionLbl: Label 'THE SECURITY';
        Name4CaptionLbl: Label 'Name :';
        Date4CaptionLbl: Label 'Date :';
        TheCarrierCaptionLbl: Label 'THE CARRIER';
        Name5CaptionLbl: Label 'Name :';
        Date5CaptionLbl: Label 'Date :';
        ObservationsCaptionLbl: Label 'OBSERVATIONS';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init()
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    procedure GetShipToAddress(WhseShipLine: Record "Posted Whse. Shipment Line"): Text
    var
        SHeader: Record "Sales Header";
        ShipToAddress: Record "Ship-to Address";
        AddressText: Text;
    begin
        if WhseShipLine."Source Document" = WhseShipLine."Source Document"::"Sales Order" then
            if SHeader.Get(WhseShipLine."Source Subtype", WhseShipLine."Source No.") then
                if SHeader."Ship-to Code" <> '' then begin
                    ShipToAddress.SetRange("Customer No.", SHeader."Sell-to Customer No.");
                    ShipToAddress.SetRange(Code, SHeader."Ship-to Code");
                    if ShipToAddress.FindFirst() then
                        AddressText := ShipToAddress.Address + ' ' + ShipToAddress."Address 2";
                end else
                    AddressText := SHeader."Ship-to Address" + ' ' + SHeader."Ship-to Address 2";
        exit(AddressText);
    end;

    procedure GetRespCenter(WhseShipLine: Record "Posted Whse. Shipment Line"): Text
    var
        SHeader: Record "Sales Header";
        RespC: Record "Responsibility Center";
        RespName: Text;
    begin
        if WhseShipLine."Source Document" = WhseShipLine."Source Document"::"Sales Order" then
            if SHeader.Get(WhseShipLine."Source Subtype", WhseShipLine."Source No.") then
                if SHeader."Responsibility Center" <> '' then
                    // RespC.SetRange(Code, SHeader."Responsibility Center");
                    if RespC.Get(SHeader."Responsibility Center") then
                        RespName := RespC.Name;
        exit(RespName);
    end;

    procedure GetBatchNumber(WhseShipLine: Record "Posted Whse. Shipment Line"): Text
    var
        ILE: Record "Item Ledger Entry";
        BatchText: Text;
    begin
        // if WhseShipLine."Posted Source Document" = WhseShipLine."Posted Source Document"::"Posted Shipment" then
        //     if SShipL.Get(WhseShipLine."Posted Source No.", WhseShipLine."Line No.") then
        //     if ILE.Get(SShipL."Document No.") then

        ILE.SetRange("Document No.", WhseShipLine."Posted Source No.");
        ILE.SetRange("Item No.", WhseShipLine."Item No.");
        ILE.SetRange("Document Line No.", WhseShipLine."Line No.");

        if ILE.FindSet() then
            repeat
                if ILE."Lot No." <> '' then begin
                    BatchText += ILE."Lot No.";
                    BatchText += '\n';
                end;
            until ILE.Next() = 0;

        exit(BatchText);
    end;

    procedure GetExpirationDate(WhseShipLine: Record "Posted Whse. Shipment Line"): Text
    var
        ILE: Record "Item Ledger Entry";
        DateText: Text;
    begin
        ILE.SetRange("Document No.", WhseShipLine."Posted Source No.");
        ILE.SetRange("Item No.", WhseShipLine."Item No.");
        ILE.SetRange("Document Line No.", WhseShipLine."Line No.");

        if ILE.FindSet() then
            repeat
                if ILE."Expiration Date" <> 0D then begin
                    DateText += Format(ILE."Expiration Date");
                    DateText += '\n';
                end;
            until ILE.Next() = 0;

        exit(DateText);
    end;
}