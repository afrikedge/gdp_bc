/// <summary>
/// Report Preparation Order (ID 50196).
/// </summary>
report 50196 "Preparation Order"
{
    Caption = 'Delivery Note';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;
    UsageCategory = Documents;
    ApplicationArea = Warehouse;
    RDLCLayout = './Source/Report/Layout/PreparationOrder.rdl';
    dataset
    {
        dataitem(Header; "Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(DocumentNo; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
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
                // column(OrderNo; "Order No.")
                // {
                // }
                // column(RespCenter; "Responsibility Center")
                // {
                // }
                column(Location_Code; Header."Location Code")
                {
                }
                column(Agency; Agency)
                {
                }
                column(CompanyInfoName; CompanyInfo.Name)
                {
                }
                dataitem(Line; "Warehouse Shipment Line")
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
                    column(Source_No_; "Source No.")
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
                    }
                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");

                        QtyConverted := Quantity * 1000;

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
        Caption = 'Warehouse Shipment';

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
        CompanyInfo: Record "Company Information";
        CompanyInfos: Record "Company Information";
        Lines: Integer;
        QtyConverted: Decimal;
        Agency: Text[100];
        LineNumber: Integer;
        LinesNumb: Integer;
        LineNumberText: Code[2];
        DepotName: Text[100];
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
}