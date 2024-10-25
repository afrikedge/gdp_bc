report 50020 "ND / NC Before"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ND  NC Before.rdlc';
    Caption = 'Debit-Credit Note';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Document No.");
            RequestFilterFields = "Document No.";
            RequestFilterHeading = 'Gen Ledger Entry';
            column(CustomerNo; "Account No.")
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
            column(StatCode; 'STAT : ' + STATCode)
            {
            }
            column(CIFCIS; 'CIS/CIS : ' + CISCode)
            {
            }
            column(PaymentCond; CondPaieName + ' ' + TexteChequeFsseur)
            {
            }
            column(NIF; 'NIF : ' + NIFCode)
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
            column(BalVATBaseAmount_GenJournalLine; "Gen. Journal Line"."Bal. VAT Base Amount")
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
            column(TotalAmountLetter; TotalAmountLetter[1])
            {
            }
            column(BalVATAmount_GenJournalLine; "Gen. Journal Line"."Bal. VAT Amount")
            {
            }
            column(TextTiers; TextTiers)
            {
            }
            column(CondTermes; CondTermes)
            {
            }
            column(espece; Cust."Cash payment")
            {
            }
            column(cheque; Cust."Check Set")
            {
            }
            column(Virement; Cust."Bank Transfer Bank Stamp")
            {
            }
            column(traite; Cust.Traite)
            {
            }
            column(cheque2; Cust."Received Check")
            {
            }
            column(espece2; Cust."Credit Note")
            {
            }

            trigger OnAfterGetRecord()
            var
                SalesInvLineLocation: Record "Sales Invoice Line";
                CondPaiem: Record "Payment Terms";
                MontantTTC: Decimal;
            begin

                FormatAddr.Company(CompanyAddr, CompanyInfo);
                Num := "Gen. Journal Line"."Document No.";
                Descript := "Gen. Journal Line".Description;
                /*
                IF "Document Type"="Document Type"::Invoice THEN
                  Fact:='Note de Débit'
                ELSE IF "Document Type"="Document Type"::"Credit Memo" THEN
                  Fact:='Note de Crédit';
                  */
                //IF "Gen. Journal Line"."Account Type"="Gen. Journal Line"."Account Type"::Customer THEN
                if "Gen. Journal Line".Amount > 0 then
                    Fact := TextND
                else
                    Fact := TextNC;

                /*
                IF "Gen. Journal Line"."Account Type"="Gen. Journal Line"."Account Type"::Vendor THEN
                  IF  "Gen. Journal Line".Amount>0 THEN
                    Fact := TextND
                  ELSE
                    Fact := TextNC;*/


                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Customer then begin
                    TextTiers := TextClient;
                    CondTermes := CondTerm;
                end else begin
                    TextTiers := TextFsseur;
                    //CondTermes := CondTermFsseur;
                    Fact := TextNDC
                end;
                TextTiers := TextCliFssTiers;

                /*IF "Salesperson Code" = '' THEN BEGIN
                  SalesPurchPerson.INIT;
                  SalesPersonText := '';
                END ELSE BEGIN
                  SalesPurchPerson.GET("Salesperson Code");
                  SalesPersonText := Text000;
                END;
                */

                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                end;

                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Customer then begin
                    Cust.Get("Gen. Journal Line"."Account No.");
                    NIFCode := Cust."VAT Registration No.";
                    STATCode := Cust."STAT Code";
                    CISCode := Cust."CIF/CIS";
                    FormatAddr.Customer(CustAddr, Cust);
                    if CondPaiem.Get(Cust."Payment Terms Code") then
                        CondPaieName := CondPaiem.Description;
                end;

                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor then begin
                    Vend.Get("Gen. Journal Line"."Account No.");
                    NIFCode := Vend."VAT Registration No.";
                    STATCode := Vend."STAT Code";
                    CISCode := Vend."CIF/CIS";
                    FormatAddr.Vendor(CustAddr, Vend);
                    TexteChequeFsseur := TextePaymentFsseur;
                    if CondPaiem.Get(Vend."Payment Terms Code") then
                        CondPaieName := CondPaiem.Description;
                end;

                MontantTTC := GetTotalTTCDoc("Gen. Journal Line"."Document No.",
                    "Gen. Journal Line"."Journal Template Name", "Gen. Journal Line"."Journal Batch Name");



                NbTLet.InitTextVariable;
                //TODO
                //NbTLet.FormatNoTextFR(TotalAmountLetter,(MontantTTC),"Currency Code");

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
        TxtMontantHT = 'Total HT';
        TxtMontantTVA = 'Montant TVA';
        TxtMontantTTC = 'Montant TTC';
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
        LocationName: Text[60];
        Desc_Caption: Label 'Désignation';
        No_LineCaption: Label 'Référence';
        UnitofMeasure_Caption: Label 'Unité';
        Quantity_Caption: Label 'Quantité';
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
        TextND: Label 'Note de Débit';
        TextNC: Label 'Note de Crédit';
        Vend: Record Vendor;
        TextClient: Label 'CLIENT';
        TextFsseur: Label 'FOURNISSEUR';
        TextTiers: Text[50];
        CondTermFsseur: Label 'Subtotal';
        CondTermes: Text[100];
        TextNDC: Label 'Note de Débit / Crédit';
        NIFCode: Text[50];
        STATCode: Text[50];
        CISCode: Text[50];
        TextePaymentFsseur: Label 'payé par Chèque à l''ordre de GALANA DISTRIBUTION PETROLIERE SA';
        TexteChequeFsseur: Text[100];
        TextCliFssTiers: Label 'TIERS';

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

    local procedure GetTotalTTCDoc(CodeDoc: Code[20]; JournalTmp: Code[20]; JournalCode: Code[20]) Rep: Decimal
    var
        GenJrnLine3: Record "Gen. Journal Line";
    begin
        GenJrnLine3.Reset;
        GenJrnLine3.SetRange("Journal Template Name", JournalTmp);
        GenJrnLine3.SetRange("Journal Batch Name", JournalCode);
        GenJrnLine3.SetRange("Document No.", CodeDoc);
        if GenJrnLine3.FindSet then
            repeat
                Rep := Rep + Abs(GenJrnLine3.Amount);
            until GenJrnLine3.Next = 0;
    end;
}

