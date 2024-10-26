report 50182 AnnexeOV
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/AnnexeOV.rdlc';
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
            column(LineNo; "Line No.")
            {
            }
            column(GenJrDocNo; "Document No.")
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
                column(RefFour; RefFour)
                {
                }
                column(VendNo; VendNo)
                {
                }
                column(VendName; VendName)
                {
                }
                column(GenDocNo; GenDocNo)
                {
                }
                column(GenPostingDate; GenPostingDate)
                {
                }
                column(MontantFacture; MontantFacture)
                {
                }
                column(Beneficiaire; Beneficiaire)
                {
                }
                column(NumCompte; NumCompte)
                {
                }
                column(Domiciliation; Domiciliation)
                {
                }
                column(Motif; Text028)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DocumentNo := VendLedgEntry."Document No.";
                    RefFour := VendLedgEntry."External Document No.";
                    DocDate := VendLedgEntry."Document Date";
                    DocDescrip := VendLedgEntry.Description;
                    VendNo := VendLedgEntry."Vendor No.";
                    MontantFacture := -(VendLedgEntry."Purchase (LCY)" * 1.2);
                    VendLedgEntry.CalcFields("Amount (LCY)");
                    AmountLCY := -(VendLedgEntry."Amount (LCY)");
                    AmountToApply := -(VendLedgEntry."Amount to Apply");
                    if VendLedgEntry.Next <> 0 then;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, Counter);
                    VendLedgEntry.FindFirst;
                    DocumentNo := '';
                    RefFour := '';
                    DocDate := 0D;
                    AmountLCY := 0;
                    VendNo := '';
                    MontantFacture := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                PaymentTerms: Record "Payment Terms";
                DimMgt: Codeunit DimensionManagement;
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin

                if "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor then
                    Error(Text018);
                if "Gen. Journal Line"."Account No." = '' then
                    Error(Text019);
                if "Gen. Journal Line".Amount = 0 then
                    Error(Text023);
                if "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."Bal. Account Type"::"Bank Account" then
                    Error(Text024);
                if "Gen. Journal Line"."Bal. Account No." = '' then
                    Error(Text025);

                Vend.Get("Gen. Journal Line"."Account No.");

                VendLedgEntry.SetRange(VendLedgEntry."Vendor No.", "Gen. Journal Line"."Account No.");
                VendLedgEntry.SetRange(VendLedgEntry."Applies-to ID", "Gen. Journal Line"."Applies-to ID");
                Counter := VendLedgEntry.Count;
                if VendLedgEntry.FindFirst then
                    NbTLet.InitTextVariable;
                NbTLet.FormatNoText(TotalAmountLetter, "Gen. Journal Line".Amount, "Gen. Journal Line"."Currency Code");

                FormatAddr.Company(CompanyAddr, Company);
                GenPostingDate := "Gen. Journal Line"."Posting Date";
                GenDocNo := "Gen. Journal Line"."Document No.";
                VendName := Vend.Name;

                VendBankAccount.SetRange(VendBankAccount.Code, "Gen. Journal Line"."Recipient Bank Account");
                VendBankAccount.SetRange(VendBankAccount."Vendor No.", "Gen. Journal Line"."Account No.");
                if VendBankAccount.FindFirst then
                    Beneficiaire := VendBankAccount."Name 2";
                Domiciliation := VendBankAccount.Name;
                NumCompte := Format(VendBankAccount."Bank Branch No." + '.' + VendBankAccount."Agency Code" + '.' + VendBankAccount."Bank Account No." + '.' + VendBankAccount."RIB Key Text");
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                Company.Get;
                Company.CalcFields(Picture);
                Counter := 0;
                VendName := '';
                Domiciliation := '';
                NumCompte := '';
                Beneficiaire := '';
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
        Fact = 'N° facture/ND';
        Date = 'Date';
        Descrip = 'Description';
        Montant = 'Montant';
        Ref = 'N° Document';
        Ann = 'Récapitulatif des OV';
        vendN = 'N° Fournisseur';
        vendNa = 'Nom Fournisseur';
        MtantFacture = 'Montant Facture';
        CptDomiciliation = 'Domiciliation';
        CptBeneficiaire = 'Bénéficiaire';
        CptNumCompte = 'N° de Compte';
        CptMotif = 'Motif';
    }

    var
        GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        GenJnlLineFilter: Text;
        VendBank: Record "Vendor Bank Account";
        ComBank: Record "Bank Account";
        DevBank: Text[20];
        DevTrans: Text[20];
        BankMess: Text[50];
        Vend: Record Vendor;
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[80];
        Reference: Text[23];
        Company: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        Text007: Label 'Par le débit de notre compte ****';
        Text018: Label '%1 or %2 must be specified.';
        Text019: Label 'Vous devez spécifier le compte fournisseur';
        Text020: Label 'Vous devez spécfier le compte bancaire du fournisseur %1';
        Text021: Label 'Vous devez spécifier une reférence';
        Text022: Label 'Mode de règlement doit être virement';
        Text023: Label 'Montant non spécifié';
        Text024: Label 'Le compte de contrepartie doit être Banque';
        Text025: Label 'Vous devez renseigner la banque';
        Text026: Label '%1 ne dispose pas de compte bancaire défini';
        Text027: Label 'La devise de la transaction % 1 ne correspond pas à la devise du compte bancaire %2';
        VendLedgEntry: Record "Vendor Ledger Entry";
        Counter: Integer;
        DocumentNo: Code[20];
        DocDescrip: Text[60];
        DocDate: Date;
        AmountLCY: Decimal;
        RefFour: Text[50];
        VendNo: Code[20];
        AmountToApply: Decimal;
        VendName: Text[250];
        GenDocNo: Code[10];
        GenPostingDate: Date;
        MontantFacture: Decimal;
        VendBankAccount: Record "Vendor Bank Account";
        Beneficiaire: Text[80];
        NumCompte: Text[50];
        Text028: Label 'Diverses factures';
        Domiciliation: Text[50];
}

