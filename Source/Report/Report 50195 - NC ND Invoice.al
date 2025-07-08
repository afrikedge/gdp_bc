/// <summary>
/// Report NC ND Invoice (ID 50195).
/// </summary>
report 50195 "NC ND Invoice"
{
    DefaultLayout = RDLC;
    Caption = 'NC/ND Invoice';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Source/Report/Layout/NCNDInvoice.rdl';

    dataset
    {
        dataitem(Line; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Document No.";
            RequestFilterHeading = 'Invoice NC/ND';
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

            column(InvoicetitleLbl; InvoicetitleLbl)
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
            column(CustomerLbl; CustomerLbl)
            {
            }
            column(DeliveryDepotLbl; DeliveryDepotLbl)
            {
            }
            column(BLNumberLbl; BLNumberLbl)
            {
            }
            column(InvoiceNumberLbl; InvoiceNumberLbl)
            {
            }
            column(OrderNumberLbl; OrderNumberLbl)
            {
            }
            column(CustomerBCLbl; CustomerBCLbl)
            {
            }
            column(NIFLbl; NIFLbl)
            {
            }
            column(STATLbl; STATLbl)
            {
            }
            column(CIFCISLbl; CIFCISLbl)
            {
            }
            column(ObservationsLbl; ObservationsLbl)
            {
            }
            column(PaymentTermsLbl; PaymentTermsLbl)
            {
            }
            column(DueDateLbl; DueDateLbl)
            {
            }
            column(DesignationLbl; DesignationLbl)
            {
            }
            column(ProductLbl; ProductLbl)
            {
            }
            column(ProdRefLbl; ProdRefLbl)
            {
            }
            column(ProductCodeLbl; ProductCodeLbl)
            {
            }
            column(ProductUnitLbl; ProductUnitLbl)
            {
            }
            column(QtyOrNbLbl; QtyOrNbLbl)
            {
            }
            column(UnitPriceLbl; UnitPriceLbl)
            {
            }
            column(VATLbl; VATLbl)
            {
            }
            column(AmountHTLbl; AmountHTLbl)
            {
            }
            column(CustomerGeneralTermsLbl; CustomerGeneralTermsLbl)
            {
            }
            column(NetPayableLbl; NetPayableLbl)
            {
            }
            column(InvoiceArrestedLbl; InvoiceArrestedLbl)
            {
            }
            column(ForGalanaLbl; ForGalanaLbl)
            {
            }
            column(NameLbl; NameLbl)
            {
            }
            column(Date1Lbl; Date1Lbl)
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Qty; Qty)
            {
            }
            column(VATFormatted; VATFormatted)
            {
            }
            column(DepotName; DepotName)
            {
            }
            // column(Resp_Center; "Responsibility Center")
            // {
            // }
            // column(Observations; Observations)
            // {
            // }
            column(BCClt; "External Document No.")
            {
            }
            column(NIF; NIF)
            {
            }
            column(STAT; STAT)
            {
            }
            column(CIF; CIF)
            {
            }
            column(PaymentTerm; PaymentTerm)
            {
            }
            column(Amount_InWords; Amount_InWords)
            {
            }

            column(DocumentNo; "Document No.")
            {
            }
            column(Due_Date; Format("Due Date"))
            {
            }
            column(Date; Format("Posting Date"))
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(Customer_Name; Customer_Name)
            {
            }
            column(Customer_Name_2; Customer_Name_2)
            {
            }
            column(Sell_to_Address; Sell_to_Address)
            {
            }
            column(Description; Description)
            {
            }
            column(Amount__LCY_; "Amount (LCY)")
            {
            }
            column(AmountFormmatted; AmountFormmatted)
            {
            }
            column(Agency; "Shortcut Dimension 4 Code")
            {
            }
            column(ChannelCode; "Shortcut Dimension 3 Code")
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(RCS; RCS)
            {
            }
            column(RCSLbl; RCSLbl)
            {
            }
            trigger OnAfterGetRecord()
            begin

                VAT := 0;
                Qty := 1;
                VATFormatted := Format(VAT, 0, '<Precision,2><Standard Format,0>');
                AmountFormmatted := Format("Amount (LCY)", 0, '<Precision,2><Standard Format,0>');

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";

                if Cust.Get(Line."Customer No.") then begin
                    Customer_Name := Cust."Name 2";
                    Customer_Name_2 := Cust."Search Name";
                    Sell_to_Address := Cust.Address;
                    NIF := Cust."VAT Registration No.";
                    STAT := Cust."STAT Code";
                    CIF := Cust."CIF/CIS";
                    RCS := Cust."Trade Number";
                end;

                GLSetup.Get();
                GLSetup.TestField("LCY Code");
                CurrCode := Line."Currency Code";
                if (CurrCode = '') then
                    CurrCode := GLSetup."LCY Code";

                CurrencyName := CurrCode;
                if Currency.Get(CurrCode) then
                    CurrencyName := Currency.Description;

                if (LocalCurrency.Get(GLSetup."LCY Code") and (CurrCode <> GLSetup."LCY Code")) then
                    LocalCurrencyName := LocalCurrency.Description;

                if "Currency Code" <> '' then begin
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Currency Code", 1);
                    CalculatedExchRate :=
                      Round(1 / "Original Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                end;

                if (Line."Amount (LCY)" > 0) then
                    ReportTitle := NDLabel
                else
                    ReportTitle := NCLabel;

                RepCheck.InitTextVariable();
                RepCheck.FormatNoText(NoText, ABS("Amount (LCY)"), LocalCurrency.code);
                NoText[1] := ReplaceString(NoText[1], '****');
                NoText[1] := ReplaceString(NoText[1], 'AND 0/100');
                NoText[2] := ReplaceString(NoText[2], '****');
                NoText[2] := ReplaceString(NoText[2], 'AND 0/100');
                Amount_InWords := NoText[1] + ' ' + NoText[2];
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {

            }
        }

        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyInfos: Record "Company Information";
        LocalCurrency: Record Currency;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        RepCheck: Report Check;
        CurrCode: Code[10];
        CurrencyName: Text;
        LocalCurrencyName: Text;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;

        // Lines: Integer;
        // LineNumber: Integer;
        // LinesNumb: Integer;
        // LineNumberText: Code[2];
        DepotName: Text[100];
        Customer_Name: Text[100];
        Customer_Name_2: Text[100];
        Sell_to_Address: Text[100];
        NIF: Text[20];
        Foot3: Text;
        STAT: Code[50];
        CIF: Code[50];
        RCS: Code[50];
        PaymentTerm: Text[100];
        VAT: Decimal;
        VATFormatted: Text;
        Qty: Decimal;
        Amount_InWords: Text;
        AmountFormmatted: Text;
        // LocalCurrencyText: Text[100];
        // CurrencyName: Text;
        // LocalCurrencyName: Text;
        NoText: array[2] of Text;

        InvoicetitleLbl: Label 'NC/ND INVOICE';
        ActivityLbl: Label 'ACTIVITY';
        AgencyLbl: Label 'AGENCY';
        DateLbl: Label 'DATE';
        CustomerLbl: Label 'CUSTOMER';
        DeliveryDepotLbl: Label 'DELIVERY DEPOT';
        BLNumberLbl: Label 'BL N°';
        InvoiceNumberLbl: Label 'Invoice N°';
        OrderNumberLbl: Label 'Order N°';
        CustomerBCLbl: Label 'Customer BC';
        NIFLbl: Label 'NIF :';
        STATLbl: Label 'STAT :';
        CIFCISLbl: Label 'CIF/CIS :';
        RCSLbl: Label 'RCS :';
        ObservationsLbl: Label 'OBSERVATIONS';
        PaymentTermsLbl: Label 'Payment terms :';
        DueDateLbl: Label 'Due date :';
        DesignationLbl: Label 'DESIGNATION';
        ProductLbl: Label 'product';
        ProductCodeLbl: Label 'Code';
        ProdRefLbl: Label 'PRODUCTS REFERENCE';
        ProductUnitLbl: Label 'Unit';
        QtyOrNbLbl: Label 'QUANTITY or NUMBER';
        UnitPriceLbl: Label 'UNIT PRICE';
        AmountHTLbl: Label 'AMOUNT (HT)';
        VATLbl: Label 'VAT';
        NetPayableLbl: Label 'NET PAYABLE (TTC)';
        ExchangeRateTxt: Label 'Exchange rate: %1/%2';
        CustomerGeneralTermsLbl: Label 'The customer accepts the general terms and conditions of sale described overleaf';
        InvoiceArrestedLbl: Label 'Invoice arrested at the sum of :';
        ForGalanaLbl: Label 'FOR GALANA';

        NDLabel: Label 'NOTE DE DEBIT';
        NClabel: Label 'NOTE DE CREDIT';
        ReportTitle: Text;
        NameLbl: Label 'Name :';
        Date1Lbl: Label 'Date :';

    local procedure ReplaceString(OriginString: Text; ReplaceStr: Text): Text
    var
        Rep: Text;
        pos: Integer;
    begin
        Rep := OriginString;
        pos := StrPos(OriginString, ReplaceStr);
        if (pos >= 1) then
            Rep := DelStr(OriginString, pos, StrLen(ReplaceStr));
        exit(Rep);
    end;
}
