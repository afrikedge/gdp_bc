report 50007 "Note de Debit/Note de Credit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Note de DebitNote de Credit.rdlc';
    Caption = 'Debit-Credit Note';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Document No.");
            RequestFilterFields = "External Document No.", "Customer No.";
            RequestFilterHeading = 'Cust. Entry Note';
            column(CustomerNo; "Customer No.")
            {
            }
            column(EMailCaption; EMailCaptionLbl)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
            {
            }
            column(MontLetter; MontLetter)
            {
            }
            column(CondTerm; CondTerm)
            {
            }
            column(SalesCatCode; Cust."Sales Channel Code")
            {
            }
            column(StatCode; 'STAT : ' + Cust."STAT Code")
            {
            }
            column(CIFCIS; 'CIS/CIS : ' + Cust."CIF/CIS")
            {
            }
            column(PaymentCond; CondPaieName)
            {
            }
            column(NIF; 'NIF : ' + Cust."VAT Registration No.")
            {
            }
            column(PostDate; Format("Posting Date"))
            {
            }
            column(Description; Descript)
            {
            }
            column(Amount; Amount)
            {
            }
            column(TotalText; TotalText)
            {
            }
            column(UnitPriceCaption; UnitPriceCaptionLbl)
            {
            }
            column(AmtCaption; AmtCaptionLbl)
            {
            }
            column(Desc_Caption; Desc_Caption)
            {
            }
            column(NoCaption; NoCaptionLbl)
            {
            }
            column(No_LineCaption; No_LineCaption)
            {
            }
            column(Quantity_Caption; Quantity_Caption)
            {
            }
            column(UnitofMeasure_Caption; UnitofMeasure_Caption)
            {
            }
            column(EntryNo; Num)
            {
            }
            column(Fact; Fact)
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CustAddr1; CustAddr[1])
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CustAddr2; CustAddr[2])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CustAddr3; CustAddr[3])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CustAddr4; CustAddr[4])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CustAddr5; CustAddr[5])
            {
            }
            column(CustAddr6; CustAddr[6])
            {
            }
            column(VATNoText; VATNoText)
            {
            }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
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
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
            {
            }
            column(RespCent; Cust."Responsibility Center")
            {
            }
            column(ReferenceText; ReferenceText)
            {
            }
            column(CustAddr7; CustAddr[7])
            {
            }
            column(CustAddr8; CustAddr[8])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(OutputNo; OutputNo)
            {
            }
            column(TotalAmountLetter; Amount_InWords)
            {
            }

            trigger OnAfterGetRecord()
            var
                SalesInvLineLocation: Record "Sales Invoice Line";
                CondPaiem: Record "Payment Terms";
            begin

                FormatAddr.Company(CompanyAddr, CompanyInfo);
                Num := "Cust. Ledger Entry"."Document No.";
                Descript := "Cust. Ledger Entry".Description;
                if "Cust. Ledger Entry"."Document Type" = "Document Type"::Invoice then
                    Fact := 'Note de Débit'
                else if "Document Type" = "Document Type"::"Credit Memo" then
                    Fact := 'Note de Crédit';

                /*IF "Salesperson Code" = '' THEN BEGIN
                  SalesPurchPerson.INIT;
                  SalesPersonText := '';
                END ELSE BEGIN
                  SalesPurchPerson.GET("Salesperson Code");
                  SalesPersonText := Text000;
                END;*/

                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                end;
                Cust.Get("Cust. Ledger Entry"."Customer No.");

                FormatAddr.Customer(CustAddr, Cust);

                if CondPaiem.Get(Cust."Payment Terms Code") then
                    CondPaieName := CondPaiem.Description;

                NbTLet.InitTextVariable;
                //TODO
                if ("Cust. Ledger Entry"."Currency Code" <> '') then
                    NbTLet.FormatNoText(TotalAmountLetter, Abs(Amount), "Cust. Ledger Entry"."Currency Code")
                else
                    NbTLet.FormatNoText(TotalAmountLetter, Abs(Amount), GLSetup."LCY Code");

                Amount_InWords := TotalAmountLetter[1] + ' ' + TotalAmountLetter[2];
            end;

            trigger OnPreDataItem()
            begin

                /*"Cust. Ledger Entry".SETCURRENTKEY("External Document No.");
                "Cust. Ledger Entry".SETRANGE("Document No.","G/"Document No.");
                "Cust. Ledger Entry".FINDFIRST;
                */

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
        Text3 = 'ACTIVITE';
        Text4 = 'AGENCE';
        Text5 = 'DATE';
        Text6 = 'CLIENT';
        PrepareBy = 'Préparée par';
        AutoriseBy = 'Autorisée par';
        CondPaie = 'Conditions de paiement';
        Text7 = 'POUR GALANA';
        Text8 = 'nom :';
        Text9 = 'date :';
        Text10 = 'Siège Social';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;
        //CompanyInfo.VerifyAndSetPaymentInfo;

        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin

        if not CurrReport.UseRequestPage then
            InitLogInteraction;

        //IF "Cust. Ledger Entry".GETFILTER("External Document No.") = '' THEN
        //  ERROR(Text005);
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label 'Sales - Invoice %1';
        PageCaptionCap: Label 'Page %1 of %2';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        MoreLines: Boolean;
        CopyText: Text[30];
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        VALExchRate: Text[50];
        Text009: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: Label 'Sales - Prepayment Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        ShipmentInvoiced: Record "Shipment Invoiced";
        NoShipmentNumLoop: Integer;
        NoShipmentDatas: array[3] of Text[20];
        NoShipmentText: Text[30];
        IncludeShptNo: Boolean;
        GetTotalLineAmount: Decimal;
        GetTotalInvDiscAmount: Decimal;
        GetTotalAmount: Decimal;
        GetTotalAmountIncVAT: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        NoCaptionLbl: Label 'Invoice No.';
        UnitPriceCaptionLbl: Label 'Unit Price';
        AmtCaptionLbl: Label 'Amount';
        PostedShpDateCaptionLbl: Label 'Posted Shipment Date';
        InvDiscAmtCaptionLbl: Label 'Inv. Discount Amount';
        TotalCaptionLbl: Label 'Total';
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        DisplayAdditionalFeeNote: Boolean;
        CondTerm: Label 'Subtotal';
        MontLetter: Label 'Arrêté le présent document à la somme de :   ';
        OrderNoCaptionLbl: Label 'Order No.';
        Location: Record Location;
        LocationName: Text[100];
        Desc_Caption: Label 'DESIGNATION';
        No_LineCaption: Label 'REFERENCE';
        UnitofMeasure_Caption: Label 'UNITE';
        Quantity_Caption: Label 'QUANTITE';
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[150];
        PhoneNoCaptionLbl: Label 'Phone No.';
        EMailCaptionLbl: Label 'E-Mail';
        FaxCaptionLbl: Label 'Fax : ';
        CondPaieName: Text[50];
        Fact: Text[30];
        Descript: Text[50];
        Text005: Label 'Vous devez renseigner le numéro de document externe';
        Num: Text[20];
        Amount_InWords: Text;

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; IncludeShptNo: Boolean; DisplAsmInfo: Boolean)
    begin
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        IncludeShptNo := IncludeShptNo;
        DisplayAssemblyInformation := DisplAsmInfo;
    end;
}

