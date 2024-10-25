report 50050 "Recu Encaissement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Recu Encaissement.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Posting Date", "Journal Template Name", "Journal Batch Name", "Document No.";
            column(JnlTmplName_GenJnlBatch; "Journal Template Name")
            {
            }
            column(Name_GenJnlBatch; "Journal Batch Name")
            {
            }
            column(UserID; User."User Name")
            {
            }
            column(UserName; User."Full Name")
            {
            }
            column(Devise1; Devise1)
            {
            }
            column(Devise2; Devise2)
            {
            }
            column(PostingDate_GenJnlLine; Format("Posting Date", 0, 4))
            {
            }
            column(DocType_GenJnlLine; "Document Type")
            {
            }
            column(DocNo_GenJnlLine; "Document No.")
            {
            }
            column(AccountType_GenJnlLine; "Account Type")
            {
            }
            column(AccountNo_GenJnlLine; "Account No.")
            {
            }
            column(ModeRG; ModeRG)
            {
            }
            column(Description_GenJnlLine; Description)
            {
            }
            column(Amount_GenJnlLine; Amount)
            {
            }
            column(CurrencyCode_GenJnlLine; "Currency Code")
            {
            }
            column(BalAccNo_GenJnlLine; "Bal. Account No.")
            {
            }
            column(BalanceLCY_GenJnlLine; "Balance (LCY)")
            {
            }
            column(AmountLCY_GenJnlLine; "Amount (LCY)")
            {
            }
            column(JnlTmplName_GenJnlLine; "Journal Template Name")
            {
            }
            column(JnlBatchName_GenJnlLine; "Journal Batch Name")
            {
            }
            column(LineNo_GenJnlLine; "Line No.")
            {
            }
            column(Cust_Name; Cust.Name)
            {
            }
            column(TotalAmountLetter; TotalAmountLetter[1])
            {
            }
            column(NoTitre; "Check No.")
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
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
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
            column(TelCaption; TelCaption)
            {
            }
            column(BPCaption; BPCaption)
            {
            }
            column(EmailCaption; EmailCaption)
            {
            }
            dataitem(Facture; "Integer")
            {
                column(DocumentNo; DocumentNo)
                {
                }
                column(DocDate; Format(DocDate))
                {
                }
                column(DocDescrip; DocDescrip)
                {
                }
                column(AmountLCY; AmountToApply)
                {
                }
                column(RefCust; RefCust)
                {
                }
                column(CustNo; CustNo)
                {
                }
                column(OrderNo; OrderNo)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    OrderNo := '';
                    DocumentNo := CustLedgEntry."Document No.";
                    RefCust := CustLedgEntry."External Document No.";
                    DocDate := CustLedgEntry."Document Date";
                    DocDescrip := CustLedgEntry.Description;
                    CustNo := CustLedgEntry."Customer No.";
                    CustLedgEntry.CalcFields("Amount (LCY)");
                    AmountLCY := (CustLedgEntry."Amount (LCY)");
                    AmountToApply := (CustLedgEntry."Amount to Apply");

                    if SalesInv.Get(DocumentNo) then
                        OrderNo := SalesInv."Order No.";
                    if CustLedgEntry.Next <> 0 then;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, Counter);
                    //IF CustLedgEntry.FINDFIRST THEN;
                    DocumentNo := '';
                    RefCust := '';
                    DocDate := 0D;
                    AmountLCY := 0;
                    CustNo := '';
                    OrderNo := '';
                    DocDescrip := '';
                    AmountLCY := 0;
                    AmountToApply := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                PaymentTerms: Record "Payment Terms";
                DimMgt: Codeunit DimensionManagement;
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin

                FormatAddr.Company(CompanyAddr, CompanyInfo);

                User.SetRange(User."User Name", UserId);
                if User.FindFirst then;
                //IF UserSetup.GET(USERID) THEN
                //  UserSetup.CALCFIELDS("User Full Name");

                if ("Currency Code" = '') or ("Currency Code" = 'MGA') then begin
                    Devise1 := 'MGA';
                    Devise2 := 'Ar';
                    DevTrans := 'Ar'
                end else begin
                    Devise1 := "Currency Code";
                    Devise2 := "Currency Code";
                    DevTrans := "Currency Code";
                end;
                Cust.Get("Gen. Journal Line"."Account No.");
                CustLedgEntry.SetRange(CustLedgEntry."Customer No.", "Gen. Journal Line"."Account No.");
                CustLedgEntry.SetRange(CustLedgEntry."Applies-to ID", "Gen. Journal Line"."Document No.");
                Counter := CustLedgEntry.Count;

                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::ChequeNormal) or
                  ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::ChequeCaution) or
                  ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::ChequeGarantie) then
                    ModeRG := 'CHEQUE';
                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::Especes) then
                    ModeRG := 'ESPECE';
                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::Traite) then
                    ModeRG := 'TRAITE';
                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::Virement) then
                    ModeRG := 'VIREMENT';
                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::MobileMoney) then
                    ModeRG := 'ORANGE MONEY';

                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::MobileMoney2) then
                    ModeRG := 'AIRTEL MONEY';

                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::MobileMoney3) then
                    ModeRG := AfKText001;

                if ("Gen. Journal Line"."CC Document Type" = "Gen. Journal Line"."CC Document Type"::MobileMoney4) then
                    ModeRG := AfKText002;

                if CustLedgEntry.FindFirst then;
                NbTLet.InitTextVariable;
                //TODO Montants
                // NbTLet.FormatNoTextFR(TotalAmountLetter, Abs("Gen. Journal Line".Amount), "Gen. Journal Line"."Currency Code");
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        Text001 = 'Reçu Encaissement';
        Text002 = 'N° Encaiss.';
        Text004 = 'Référence :';
        Text005 = 'Date';
        Text006 = 'Récu la somme de :';
        Text008 = 'Code client :';
        Text009 = 'Nom client :';
        Text010 = 'Mode règlt :';
        Text011 = 'N° Chèque';
        Text012 = 'Le Client';
        Text013 = 'Nom et signature';
        // The label 'Text014' could not be exported.
        Text015 = 'Réf Commande';
        Text016 = 'N°';
        Text017 = 'Montant';
        Text018 = 'Total (Ar)';
        Text019 = 'Date/Heure saisie :';
        Text10 = 'Siège Social';
        Text020 = 'Reçu par :';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        "Gen. Journal Line".CopyFilter("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
        "Gen. Journal Line".CopyFilter("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
        GenJnlLineFilter := "Gen. Journal Line".GetFilters;
    end;

    var
        Devise1: Text[30];
        Devise2: Text[30];
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        GenJnlLineFilter: Text;
        ComBank: Record "Bank Account";
        DevBank: Text[30];
        DevTrans: Text[30];
        BankMess: Text[50];
        Cust: Record Customer;
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[150];
        ComBankCode: Text[30];
        Reference: Text[30];
        CustLedgEntry: Record "Cust. Ledger Entry";
        Counter: Integer;
        DocumentNo: Code[30];
        DocDescrip: Text[60];
        DocDate: Date;
        AmountLCY: Decimal;
        RefCust: Text[30];
        CustNo: Code[20];
        AmountToApply: Decimal;
        SalesInv: Record "Sales Invoice Header";
        OrderNo: Text[30];
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        PhoneNoCaptionLbl: Label 'Phone No.';
        EMailCaptionLbl: Label 'E-Mail';
        FaxCaptionLbl: Label 'Fax : ';
        // Text007: ;
        FormatAddr: Codeunit "Format Address";
        TelCaption: Label 'Tél/Fax : ';
        BPCaption: Label 'BP : ';
        EmailCaption: Label 'Email : ';
        ModeRG: Text[30];
        AfKText001: Label 'M''VOLA MONEY';
        User: Record User;
        AfKText002: Label 'ORANGE MONEY MARCHAND';
}

