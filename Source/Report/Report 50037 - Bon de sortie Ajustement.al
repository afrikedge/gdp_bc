report 50037 "Bon de sortie Ajustement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Bon de sortie Ajustement.rdlc';
    Caption = 'Bon de sortie';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Adjustment Header"; "Adjustment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Customer No.";
            RequestFilterHeading = 'Bon de sortie';
            column(No_AdjustHeader; "No.")
            {
            }
            column(CustomerNo_AdjustHeader; "Customer No.")
            {
            }
            column(CustName_AdjustHeader; "Customer Name")
            {
            }
            column(PostingDate_AdjustHeader; Format("Posting Date"))
            {
            }
            column(CustAddr; Cust.Address)
            {
            }
            column(ShipmentNoCaption; ShipmentNoCaptionLbl)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            dataitem("Adjustment Line"; "Adjustment Line")
            {
                column(DocumentNo_AdjustLine; "Document No.")
                {
                }
                column(DocumentType_AdjustLine; "Document Type")
                {
                }
                column(ItemNo_AdjustLine; "Item No.")
                {
                }
                column(Descript_AdjustLine; Description)
                {
                }
                column(Quantity_AdjustLine; Quantity)
                {
                }
                column(UOM_AdjustLine; "Unit of Measure")
                {
                }
                column(LocationCode_AdjustLine; "Location Code")
                {
                }
                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfoFax; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfoRCS; ' - R.C.S. : ' + CompanyInfo."Trade Register")
                {
                }
                column(CompanyInfoCA; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital")
                {
                }
                column(CompanyInfoNIF; 'NIF : ' + CompanyInfo."Registration No.")
                {
                }
                column(CompanyInfoSTAT; 'STAT : ' + CompanyInfo."Legal Form")
                {
                }
                column(EmailCaption; EmailCaptionLbl)
                {
                }
                column(DocumentDateCaption; DocumentDateCaptionLbl)
                {
                }
                column(FaxCaption; FaxCaptionLbl)
                {
                }
                column(ProductCodeCaption; ProductCodeCaptionLbl)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(UOMCaption; UOMCaptionLbl)
                {
                }
                column(LineNo; "Line No.")
                {
                }
                column(LocationCaption; LocationCaptionLbl)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                /*IF RespCenter.GET("Responsibility Center") THEN BEGIN
                  FormatAddr.RespCenter(CompanyAddr,RespCenter);
                  CompanyInfo."Phone No." := RespCenter."Phone No.";
                  CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE*/

                FormatAddr.Company(CompanyAddr, CompanyInfo);


                //FormatAddr.SalesShptBillTo(CustAddr,"Sales Shipment Header");
                /*ShowCustAddr := "Bill-to Customer No." <> "Sell-to Customer No.";
                FOR i := 1 TO ARRAYLEN(CustAddr) DO
                  IF CustAddr[i] <> ShipToAddr[i] THEN
                    ShowCustAddr := TRUE;*/

                /*IF LogInteraction THEN
                  IF NOT CurrReport.PREVIEW THEN
                    SegManagement.LogDocument(
                      5,"No.",0,0,DATABASE::Customer,"Sell-to Customer No.","Salesperson Code",
                      "Campaign No.","Posting Description",'');*/

                Cust.Get("Adjustment Header"."Customer No.");

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        BonSort = 'BON DE SORTIE';
        PrepareBy = 'Etabli par';
        Client = 'Le Client : (Nom, Signature et Cachet)';
        ApproveBy = 'Approuvé par';
        Text10 = 'Siège Social';
        Text1 = 'Date de sortie :';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
        AsmHeaderExists := false;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'COPY';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        SegManagement: Codeunit SegManagement;
        MoreLines: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        LinNo: Integer;
        ShipmentNoCaptionLbl: Label 'Shipment No.';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        DocumentDateCaptionLbl: Label 'Document Date';
        PageCaptionCap: Label 'Page %1 of %2';
        FaxCaptionLbl: Label 'Fax : ';
        PhoneNoCaptionLbl: Label 'Phone No.';
        Cust: Record Customer;
        ProductCodeCaptionLbl: Label 'Code produit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantité';
        UOMCaptionLbl: Label 'Unité';
        LocationCaptionLbl: Label 'Code Magasin';

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
        ShowLotSN := NewShowLotSN;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;
}

