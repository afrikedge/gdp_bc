report 50023 "Virement Fournisseur"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Virement Fournisseur.rdlc';
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
            column(Text007; Text007)
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
            column(ComBank_Name; ComBank.Name)
            {
            }
            column(ComBank_Adress; ComBank.Address)
            {
            }
            column(ComBank_City; ComBank.City)
            {
            }
            column(RefDoc; Reference)
            {
            }
            column(ComBank_Num; ComBankCode)
            {
            }
            column(Vend_Name; NomDestinataire)
            {
            }
            column(TotalAmountLetter; Amount_InWords)
            {
            }
            column(VendBank_Name; NomBanqueDestinataire)
            {
            }
            column(Beneficiaire; NomBeneficiaire)
            {
            }
            column(VendBank_Num; VendBankCode)
            {
            }
            column(ComBank_Contact; ComBank.Contact)
            {
            }
            column(CodeSwift; CodeSwiftDest)
            {
            }

            trigger OnAfterGetRecord()
            var
                PaymentTerms: Record "Payment Terms";
                DimMgt: Codeunit DimensionManagement;
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin
                if ("Currency Code" = '') or ("Currency Code" = 'MGA') then begin
                    Devise1 := 'MGA';
                    Devise2 := 'Ar';
                    DevTrans := 'MGA'
                end else begin
                    Devise1 := "Currency Code";
                    Devise2 := "Currency Code";
                    DevTrans := "Currency Code";
                end;

                if (("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor) and
                  ("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::"Bank Account")) then
                    Error(Text018);
                if "Gen. Journal Line"."Account No." = '' then
                    Error(Text019);
                if "Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor then
                    if "Gen. Journal Line"."Recipient Bank Account" = '' then
                        Error(Text020, "Gen. Journal Line"."Account No.");
                if "Gen. Journal Line"."Payment Method Code" <> 'VIREMENT' then
                    Error(Text022);
                if "Gen. Journal Line".Amount = 0 then
                    Error(Text023);
                if "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."Bal. Account Type"::"Bank Account" then
                    Error(Text024);
                if "Gen. Journal Line"."Bal. Account No." = '' then
                    Error(Text025);


                if ("Gen. Journal Line"."Account Type" = "Gen. Journal Line"."Account Type"::Vendor) then begin
                    Vend.Get("Gen. Journal Line"."Account No.");

                    VendBank.SetCurrentKey(VendBank."Vendor No.", VendBank.Code);
                    VendBank.SetRange("Vendor No.", "Gen. Journal Line"."Account No.");
                    VendBank.SetRange(Code, "Gen. Journal Line"."Recipient Bank Account");
                    if VendBank.FindFirst then begin

                        IF COPYSTR("Gen. Journal Line"."Document No.", 1, 3) <> 'ETR' THEN BEGIN
                            IF (VendBank."Bank Account No." = '') THEN
                                ERROR(Text026, "Gen. Journal Line"."Recipient Bank Account")
                            ELSE
                                VendBankCode := VendBank."Bank Branch No." + '.' + VendBank."Agency Code" + '.' + VendBank."Bank Account No." + '.' + FORMAT(VendBank."RIB Key Text");
                        END ELSE BEGIN
                            IF VendBank.IBAN = '' THEN
                                ERROR(Text028, "Gen. Journal Line"."Recipient Bank Account")
                            ELSE
                                VendBankCode := VendBank.IBAN;
                        END;

                        //VendBankCode := VendBank."Bank Account No.";//***
                        NomDestinataire := Vend.Name;
                        NomBeneficiaire := VendBank."Name 2";
                        NomBanqueDestinataire := VendBank.Name;
                        CodeSwiftDest := VendBank."SWIFT Code";
                    end;

                end else begin
                    DestBank.Get("Gen. Journal Line"."Account No.");
                    VendBankCode := DestBank."Bank Branch No." + '.' + DestBank."Agency Code" + '.' + DestBank."Bank Account No." + '.' + Format(DestBank."RIB Key Text");
                    NomDestinataire := DestBank.Name;
                    NomBeneficiaire := DestBank.Name;
                    NomBanqueDestinataire := DestBank.Name;
                    CodeSwiftDest := DestBank."SWIFT Code";
                end;

                ComBank.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                if ComBank.FindFirst then begin
                    if (ComBank."Currency Code" = 'MGA') or (ComBank."Currency Code" = '') then
                        DevBank := 'MGA'
                    else
                        DevBank := ComBank."Currency Code";
                    if ComBank."Bank Account No." = '' then
                        Error(Text026, "Gen. Journal Line"."Bal. Account No.");

                    if ComBank."Currency Code" <> '' then begin
                        if DevBank <> DevTrans then
                            Error(Text027);
                    end;

                    ComBankCode := ComBank."Bank Branch No." + '.' + ComBank."Agency Code" + '.' + ComBank."Bank Account No." + '.' + Format(ComBank."RIB Key Text");
                    Reference := Format("Gen. Journal Line"."Document No.");//+' GAL '+FORMAT(DATE2DMY(TODAY,3));
                end;


                NbTLet.InitTextVariable;
                NbTLet.FormatNoText(TotalAmountLetter, "Gen. Journal Line".Amount, "Gen. Journal Line"."Currency Code");
                Amount_InWords := TotalAmountLetter[1] + ' ' + TotalAmountLetter[2];

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
        Text001 = 'Nos Réf :';
        Text002 = 'Objet :';
        Text004 = 'Demande de transfert de :';
        Text005 = 'A l''attention de :';
        Text006 = 'Madame / Monsieur';
        Text008 = 'Veuillez effectuer le transfert ci-après  :';
        Text009 = 'Bénéficiaire';
        Text010 = 'Montant';
        Text011 = '(en lettre)';
        Text012 = 'Domicilation';
        Text013 = 'N° de compte';
        Text014 = 'Motif';
        Text015 = 'La prise en charge des frais sera partagée.';
        Text016 = 'Nous vous en remercions et vous prions d''agréer, nos salutations distinguées.';
        Text017 = 'POUR LA GALANA';
        Text018 = 'AGENCE';
        Text019 = 'Swift Code';
    }

    trigger OnPreReport()
    begin
        "Gen. Journal Line".CopyFilter("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
        "Gen. Journal Line".CopyFilter("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
        GenJnlLineFilter := "Gen. Journal Line".GetFilters;
    end;

    var
        Text007: Label 'Par le débit de notre compte ****';
        Devise1: Text[20];
        Devise2: Text[20];
        Text018: Label '%1 or %2 must be specified.';
        Text019: Label 'Vous devez spécifier le compte fournisseur';
        Text020: Label 'Vous devez spécfier le compte bancaire du fournisseur %1';
        Text021: Label 'Vous devez spécifier une reférence';
        Text022: Label 'Mode de règlement doit être virement';
        Text023: Label 'Montant non spécifié';
        Text024: Label 'Le compte de contrepartie doit être Banque';
        Text025: Label 'Vous devez renseigner la banque';
        Text026: Label '%1 ne dispose pas de compte bancaire défini';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        GenJnlLineFilter: Text;
        Amount_InWords: Text;
        VendBank: Record "Vendor Bank Account";
        ComBank: Record "Bank Account";
        Text027: Label 'La devise de la transaction % 1 ne correspond pas à la devise du compte bancaire %2';
        DevBank: Text[20];
        DevTrans: Text[20];
        BankMess: Text[50];
        Vend: Record Vendor;
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[150];
        ComBankCode: Text[60];
        Reference: Text[30];
        VendBankCode: Text[60];
        Text028: Label '%1 ne dispose pas de code IBAN';
        NomDestinataire: Text[60];
        CodeSwiftDest: Text[60];
        NomBeneficiaire: Text[60];
        NomBanqueDestinataire: Text[60];
        DestBank: Record "Bank Account";
    //Amount_InWords: Text;
}

