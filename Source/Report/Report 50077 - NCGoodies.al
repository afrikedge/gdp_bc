/// <summary>
/// Report NC Goodies (ID 50077).
/// </summary>
report 50077 "NC Goodies"
{
    DefaultLayout = RDLC;
    Caption = 'NC Goodies';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Source/Report/Layout/NCGoodies.rdl';

    dataset
    {
        dataitem(Header; "G/L Register")
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'NC Goodies';
            column(No_; "No.")
            {
            }
            column(TemplateName_GenJnlBatch; "Journal Templ. Name")
            {
            }
            column(Name_ItemJournalBatch; "Journal Batch Name")
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
            dataitem(Line; "G/L Entry")
            {
                DataItemLink = "Journal Templ. Name" = field("Journal Templ. Name"), "Journal Batch Name" = field("Journal Batch Name"), "Source Code" = field("Source Code");
                DataItemTableView = sorting("Entry No.");
                DataItemLinkReference = Header;
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
                column(RCSLbl; RCSLbl)
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

                column(VAT_Amount; "VAT Amount")
                {
                }
                column(Debit_Amount; "Debit Amount")
                {
                }
                column(Source_Currency_Amount; "Source Currency Amount")
                {
                }
                trigger OnPreDataItem()
                begin
                    Line.SetRange("Entry No.", Header."From Entry No.");
                end;

                trigger OnAfterGetRecord()
                begin
                    Quantity := 1;
                    VATFormatted := Format("VAT Amount", 0, '<Precision,2><Standard Format,0>');
                    AmountFormmatted := Format("Debit Amount", 0, '<Precision,2><Standard Format,0>');
                    TTCAmountFormatted := Format("Source Currency Amount", 0, '<Precision,2><Standard Format,0>');

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
                    RepCheck.FormatNoText(NoText, "Source Currency Amount", LocalCurrency.code);
                    NoText[1] := ReplaceString(NoText[1], '****');
                    NoText[1] := ReplaceString(NoText[1], 'AND 0/100');
                    NoText[2] := ReplaceString(NoText[2], '****');
                    NoText[2] := ReplaceString(NoText[2], 'AND 0/100');
                    Amount_InWords := NoText[1] + ' ' + NoText[2];
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";
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
        CustRec: Record Customer;
        PaymentTerms: Record "Payment Terms";
        RepCheck: Report Check;
        // VAT: Decimal;
        // Qty: Decimal;
        Foot3: Text;
        CurrCode: Code[10];
        CurrencyName: Text;
        LocalCurrencyName: Text;
        CalculatedExchRate: Decimal;
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

        ReportTitle: Label 'NOTE DE CREDIT';
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