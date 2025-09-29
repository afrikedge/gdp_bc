/// <summary>
/// Report Preparation Order Lub (ID 50197).
/// </summary>
report 50197 "PreparationOrder Lub"
{
    Caption = 'Delivery Note';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;
    UsageCategory = Documents;
    ApplicationArea = All;
    RDLCLayout = './Source/Report/Layout/PreparationOrderLub.rdl';
    dataset
    {
        dataitem(Header; "Adjustment Header")
        {
            DataItemTableView = sorting("No.") WHERE("Document Type" = CONST(Shipment));
            RequestFilterFields = "No.";
            column(DocumentNo; "No.")
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
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
            column(TitleCaptionLbl; TitleCaptionLbl)
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
            column(LieuDeLivraisonLbl; LieuDeLivraisonLbl)
            {
            }
            column(AddresLivr1; AddresLivr1)
            {
            }
            column(AddressLivr2; AddressLivr2)
            {
            }
            // column(AddresLivr1; ShipToAddress.Address)
            // {
            // }
            // column(AddressLivr2; ShipToAddress."Address 2")
            // {
            // }
            column(Location_Code; Header."Location Code")
            {
            }
            column(Agency; RespCenter.Name)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Customer_Name_2; "Customer Search Name")
            {
            }
            column(Sell_to_Address; Cust.Address)
            {
            }
            column(OrderNo; "Order No.")
            {
            }
            column(RespCent; RespCenter.Code)
            {
            }
            column(Camion; "Truck Code")
            {
            }
            column(permis; permis)
            {
            }
            column(nomchauffeur; nomchauffeur)
            {
            }
            column(Transporter_Name; "Transporter Name")
            {
            }
            dataitem(Line; "Adjustment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(Lines; Lines)
                {
                }
                column(No_; "Item No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Batch_Number; "Batch Number")
                {
                }
                column(Expiration_Date; Format("Expiration Date"))
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(Location_Code_; "Location Code")
                {
                }
                column(LineNumberText; LineNumberText)
                {
                }
                column(TonneConversion; TonneConversion)
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

                    Item.Get(Line."Item No.");
                    if Item."Sales Category Code" = 'LUB' then
                        TonneConversion := Item."Gross Weight" * Line.Quantity
                    else
                        if ItemUnitMeasure.Get(Line."Item No.", Line."Unit of Measure Code") then
                            if ItemUnitMeasure.Get(Line."Item No.", 'KG') then
                                TonneConversion := Line.Quantity / ItemUnitMeasure."Qty. per Unit of Measure";
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

            trigger OnAfterGetRecord()
            begin
                LineNumber := 0;

                if Location.Get(Header."Location Code") then
                    DepotName := Location.Name;

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";

                if Header."Customer No." <> '' then
                    Cust.Get(Header."Customer No.");
                if Cust."Responsibility Center" <> '' then
                    RespCenter.Get(Cust."Responsibility Center");

                if ShipToAddress.Get(Header."Customer No.", Header."Ship-to Code") then begin
                    AddresLivr1 := ShipToAddress.Address;
                    AddressLivr2 := ShipToAddress."Address 2";
                end;
            end;
        }
    }
    requestpage
    {
        Caption = 'Delivery Note';

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
    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Location: Record Location;
        Cust: Record Customer;
        Item: Record Item;
        ShipToAddress: Record "Ship-to Address";
        RespCenter: Record "Responsibility Center";
        CompanyInfo: Record "Company Information";
        CompanyInfos: Record "Company Information";
        ItemUnitMeasure: Record "Item Unit of Measure";
        TonneConversion: Decimal;
        Lines: Integer;
        // Agency: Text[100];
        LineNumber: Integer;
        LinesNumb: Integer;
        LineNumberText: Code[2];
        DepotName: Text[100];
        Foot3: Text;
        AddresLivr1: Text[100];
        AddressLivr2: Text[50];
        // PAGENOCaptionLbl: Label 'Page';
        LieuDeLivraisonLbl: Label 'LIEU DE LIVRAISON :';
        TitleCaptionLbl: Label 'DELIVERY NOTE';
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
}