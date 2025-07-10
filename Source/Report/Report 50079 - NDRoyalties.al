/// <summary>
/// Report NC Royalties (ID 50079).
/// </summary>
report 50079 "ND Royalties"
{
    DefaultLayout = RDLC;
    Caption = 'ND/Nc Royalties..Goodies';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Source/Report/Layout/NDNCRoyalties.rdl';

    dataset
    {
        dataitem(Line; "G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Entry No.";
            RequestFilterHeading = 'ND/NC Royalties..Goodies';

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
            column(ReportTitle; ReportTitle)
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
            column(RCSLbl; RCSLbl)
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
            column(Amount_InWords; Amount_InWords)
            {
            }

            column(DocumentNo; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Agency; "Shortcut Dimension 4 Code")
            {
            }
            column(ChannelCode; "Shortcut Dimension 3 Code")
            {
            }
            column(Date; Format("Posting Date"))
            {
            }
            column(Due_Date; Format("Posting Date"))
            {
            }
            column(BCClt; "External Document No.")
            {
            }
            column(Customer_No_; "Source No.")
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
            column(DepotName; DepotName)
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
            column(RCS; RCS)
            {
            }
            column(PaymentTerm; PaymentTerm)
            {
            }
            column(Qty; Quantity)
            {
            }
            column(VATFormatted; VATFormatted)
            {
            }
            column(AmountFormmatted; AmountFormmatted)
            {
            }
            column(TTCAmountFormatted; TTCAmountFormatted)
            {
            }
            column(TTCAmount; TTCAmount)
            {
            }
            // column(VAT_Amount; "VAT Amount")
            // {
            // }
            // column(Debit_Amount; "Debit Amount")
            // {
            // }
            // column(Source_Currency_Amount; "Source Currency Amount")
            // {
            // }

            trigger OnAfterGetRecord()
            begin
                Quantity := 1;
                VATFormatted := Format("VAT Amount", 0, '<Precision,2><Standard Format,0>');
                AmountFormmatted := Format("Debit Amount", 0, '<Precision,2><Standard Format,0>');
                TTCAmountFormatted := Format("Source Currency Amount", 0, '<Precision,2><Standard Format,0>');

                if Line.Amount > 0 then begin
                    ReportTitle := 'NOTE DE CREDIT';
                    VATFormatted := Format("VAT Amount", 0, '<Precision,2><Standard Format,0>');
                    AmountFormmatted := Format("Debit Amount", 0, '<Precision,2><Standard Format,0>');
                    TTCAmount := "Source Currency Amount";
                    TTCAmountFormatted := Format(TTCAmount, 0, '<Precision,2><Standard Format,0>');
                end;

                if Line.Amount < 0 then begin
                    ReportTitle := 'NOTE DE DEBIT';
                    VATFormatted := Format(Abs("VAT Amount"), 0, '<Precision,2><Standard Format,0>');
                    AmountFormmatted := Format("Credit Amount", 0, '<Precision,2><Standard Format,0>');
                    TTCAmount := GetTotalTTC(Line."Document No.", Line."Journal Templ. Name", Line."Journal Batch Name");
                    TTCAmountFormatted := Format(TTCAmount, 0, '<Precision,2><Standard Format,0>');
                end;

                if Cust.Get(Line."Source No.") then begin
                    Customer_Name := Cust."Name 2";
                    Customer_Name_2 := Cust."Search Name";
                    Sell_to_Address := Cust.Address;
                    NIF := Cust."VAT Registration No.";
                    STAT := Cust."STAT Code";
                    CIF := Cust."CIF/CIS";
                    RCS := Cust."Trade Number";

                    if PaymentTerms.Get(Cust."Payment Terms Code") then
                        PaymentTerm := PaymentTerms.Description;
                end;

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";

                GLSetup.Get();
                GLSetup.TestField("LCY Code");
                CurrCode := Line."Source Currency Code";
                if (CurrCode = '') then
                    CurrCode := GLSetup."LCY Code";

                CurrencyName := CurrCode;
                if Currency.Get(CurrCode) then
                    CurrencyName := Currency.Description;

                if (LocalCurrency.Get(GLSetup."LCY Code") and (CurrCode <> GLSetup."LCY Code")) then
                    LocalCurrencyName := LocalCurrency.Description;

                if "Source Currency Code" <> '' then begin
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Source Currency Code", 1);
                    CalculatedExchRate :=
                      Round(1 / 1 * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                end;

                RepCheck.InitTextVariable();
                RepCheck.FormatNoText(NoText, TTCAmount, LocalCurrency.code);
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
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LocalCurrency: Record Currency;
        Currency: Record Currency;
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        RepCheck: Report Check;
        // VAT: Decimal;
        // Qty: Decimal;
        Foot3: Text;
        CurrCode: Code[10];
        CurrencyName: Text;
        LocalCurrencyName: Text;
        CalculatedExchRate: Decimal;
        TTCAmount: Decimal;
        ExchangeRateText: Text;
        DepotName: Text[100];
        Customer_Name: Text[100];
        Customer_Name_2: Text[100];
        Sell_to_Address: Text[100];
        NIF: Text[20];
        STAT: Code[50];
        CIF: Code[50];
        RCS: Code[50];
        PaymentTerm: Text[100];
        VATFormatted: Text;
        AmountFormmatted: Text;
        TTCAmountFormatted: Text;
        NoText: array[2] of Text;
        Amount_InWords: Text;

        ReportTitle: Text;
        ActivityLbl: Label 'ACTIVITE';
        AgencyLbl: Label 'AGENCE';
        DateLbl: Label 'DATE';
        CustomerLbl: Label 'CLIENT';
        DeliveryDepotLbl: Label 'DEPOT LIVRANCIER';
        BLNumberLbl: Label 'BL N°';
        InvoiceNumberLbl: Label 'Facture N°';
        OrderNumberLbl: Label 'Cmde N°';
        CustomerBCLbl: Label 'BC Client';
        NIFLbl: Label 'NIF :';
        STATLbl: Label 'STAT :';
        CIFCISLbl: Label 'CIF/CIS :';
        RCSLbl: Label 'RCS :';
        ObservationsLbl: Label 'OBSERVATIONS';
        PaymentTermsLbl: Label 'Conditions de paiement :';
        DueDateLbl: Label 'Date d''écheance :';
        DesignationLbl: Label 'DESIGNATION';
        ProductLbl: Label 'Produit';
        ProductCodeLbl: Label 'Code';
        ProdRefLbl: Label 'REFERENCE PRODUITS';
        ProductUnitLbl: Label 'Unité';
        QtyOrNbLbl: Label 'QUANTITE ou NOMBRE';
        UnitPriceLbl: Label 'PRIX UNITAIRE';
        AmountHTLbl: Label 'MONTANT (HT)';
        VATLbl: Label 'TVA';
        NetPayableLbl: Label 'NET A PAYER (TTC)';
        ExchangeRateTxt: Label 'Taux d''echange: %1/%2';
        CustomerGeneralTermsLbl: Label 'Le client accepte les conditions générales de vente décrites au verso';
        InvoiceArrestedLbl: Label 'Facture arrêtée à la somme de :';
        ForGalanaLbl: Label 'POUR GALANA';
        NameLbl: Label 'Nom :';
        Date1Lbl: Label 'Date :';

    local procedure GetTotalTTC(CodeDoc: Code[20]; JournalTmp: Code[20]; JournalCode: Code[20]) Rep: Decimal
    var
        GenJrnLine: Record "G/L Entry";
    begin
        GenJrnLine.Reset();
        GenJrnLine.SetRange("Journal Templ. Name", JournalTmp);
        GenJrnLine.SetRange("Journal Batch Name", JournalCode);
        GenJrnLine.SetRange("Document No.", CodeDoc);
        if GenJrnLine.FindSet() then
            repeat
                Rep := Rep + GenJrnLine."Credit Amount";
            until GenJrnLine.Next() = 0;
    end;

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