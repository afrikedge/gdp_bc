report 50024 "Traite Fournisseur"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Traite Fournisseur.rdlc';
    EnableExternalImages = true;
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
            column(DueDate_GenJnLine; Format("Due Date", 0, 4))
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
                IncludeCaption = true;
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
            column(ComBank_Num; ComBank."Bank Account No.")
            {
            }
            column(Vend_Name; Vend.Name)
            {
            }
            column(Vend_Addr; Vend.Address)
            {
            }
            column(TotalAmountLetter; Amount_InWords)
            {
            }
            column(VendBank_Name; VendBank.Name)
            {
            }
            column(VendBank_Num; VendBank."Bank Account No.")
            {
            }
            column(ComBank_Contact; ComBank.Contact)
            {
            }
            column(ComBank_BranchNo; ComBank."Bank Branch No.")
            {
            }
            column(ComBank_AgencyCode; ComBank."Agency Code")
            {
            }
            column(ComBank_RibKey; ComBank."RIB Key")
            {
            }
            column(VendBank_BranchNo; VendBank."Bank Branch No.")
            {
            }
            column(VendBank_AgencyCode; VendBank."Agency Code")
            {
            }
            column(VendBank_RibKey; VendBank."RIB Key")
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Company_Adresse; Company.Address)
            {
            }
            column(CompanyInfo_Picture; Company.Picture)
            {
            }
            column(CompanyInfo_TraitePicture; Company.TraitePicture)
            {
            }
            column(Vend_Adresse; Vend.Address)
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

                if "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor then
                    Error(Text018);
                if "Gen. Journal Line"."Account No." = '' then
                    Error(Text019);
                /*IF "Gen. Journal Line"."Recipient Bank Account"=''THEN
                  ERROR(Text020,"Gen. Journal Line"."Account No.");*/
                if "Gen. Journal Line"."Payment Method Code" <> 'TRAITES' then
                    Error(Text022);
                if "Gen. Journal Line".Amount = 0 then
                    Error(Text023);
                //IF "Gen. Journal Line"."Bal. Account Type"<>"Gen. Journal Line"."Bal. Account Type"::"Bank Account" THEN
                //  ERROR(Text024);
                if "Gen. Journal Line"."Bal. Account No." = '' then
                    Error(Text025);
                VendBank.Reset;
                if "Gen. Journal Line"."Recipient Bank Account" <> '' then begin
                    VendBank.SetCurrentKey(VendBank."Vendor No.", VendBank.Code);
                    VendBank.SetRange("Vendor No.", "Gen. Journal Line"."Account No.");
                    VendBank.SetRange(Code, "Gen. Journal Line"."Recipient Bank Account");
                    VendBank.FindFirst;
                end;
                /*IF (VendBank.FINDFIRST) AND (VendBank."Bank Account No." ='') THEN
                  ERROR(Text026,"Gen. Journal Line"."Account No.");
                */
                ComBank.SetRange("No.", "Gen. Journal Line"."Bal. Account No.");
                if ComBank.FindFirst then begin
                    if (ComBank."Currency Code" = 'MGA') or (ComBank."Currency Code" = '') then
                        DevBank := 'MGA'
                    else
                        DevBank := ComBank."Currency Code";
                    if ComBank."Bank Account No." = '' then
                        Error(Text026, "Gen. Journal Line"."Bal. Account No.");
                    if DevBank <> DevTrans then
                        Error(Text027);

                end;
                Reference := Format("Gen. Journal Line"."Document No.");//+'GAL'+FORMAT(DATE2DMY(TODAY,3));

                Vend.Get("Gen. Journal Line"."Account No.");
                NbTLet.InitTextVariable;
                //TODO Montants
                //NbTLet.FormatNoTextFR(TotalAmountLetter, "Gen. Journal Line".Amount, "Gen. Journal Line"."Currency Code");

                FormatAddr.Company(CompanyAddr, Company);

            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                Company.Get;
                Company.CalcFields(Picture);
                Company.CalcFields(TraitePicture);
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
        Text001 = 'LETTRE DE CHANGE';
        Text002 = 'N° LC';
        Text004 = 'BP Ar';
        Text005 = 'Veuillez payer le';
        Text006 = 'RIB du Bénéficaire';
        Text008 = 'Code Banque';
        Text009 = 'Code Agence';
        Text010 = 'N° Compte';
        Text011 = 'Clé RIB';
        Text012 = 'La somme en lettres';
        Text013 = 'En règlement de';
        Text014 = 'RIB du Tiré';
        Text015 = 'Signature Aval';
        Text016 = 'Signature Bénéficiaire';
        Text017 = 'Signature Tiré valant autorisation de débit';
        Text018 = 'A';
        Text019 = 'à l''ordre de';
        Titre = 'LETTRE DE PAIEMENT par LETTRE DE CHANGE n°';
        NomBen = 'Nom bénéficiaire :';
        Addr = 'Adresse :';
        Nom_Pren = 'Nom et prénoms :';
        Cni = 'N° CNI :';
        Duplicat = 'Duplicata :';
        Sign = 'Signature';
        MessFact = 'Veuillez trouver ci-joint les détails de règlement de vos factures :';
        MessTraite = 'Veuillez accuser réception de la traite n°';
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
        Text022: Label 'Mode de règlement doit être Traite';
        Text023: Label 'Montant non spécifié';
        Text024: Label 'Le compte de contrepartie doit être Banque';
        Text025: Label 'Vous devez renseigner la banque';
        Text026: Label '%1 ne dispose pas de compte bancaire défini';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        GenJnlLineFilter: Text;
        VendBank: Record "Vendor Bank Account";
        ComBank: Record "Bank Account";
        Text027: Label 'La devise de la transaction % 1 ne correspond pas à la devise du compte bancaire %2';
        DevBank: Text[20];
        DevTrans: Text[20];
        BankMess: Text[50];
        Vend: Record Vendor;
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[150];
        Reference: Text[20];
        Company: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        Amount_InWords: Text;
}

