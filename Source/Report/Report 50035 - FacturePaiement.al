report 50035 FacturePaiement
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/FacturePaiement.rdlc';
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
                column(MontantFacture; AmountLCY)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DocumentNo := VendLedgEntry."Document No.";
                    RefFour := VendLedgEntry."External Document No.";
                    DocDate := VendLedgEntry."Document Date";
                    DocDescrip := VendLedgEntry.Description;
                    VendNo := VendLedgEntry."Vendor No.";
                    //MontantFacture:=-(VendLedgEntry."Purchase (LCY)" * 1.2);
                    MontantFacture := -(VendLedgEntry."Purchase (LCY)");
                    VendLedgEntry.CalcFields("Amount (LCY)");
                    AmountLCY := -(VendLedgEntry."Amount (LCY)");
                    AmountToApply := (VendLedgEntry."Amount to Apply");
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

                Amount_InWords := TotalAmountLetter[1] + ' ' + TotalAmountLetter[2];

                FormatAddr.Company(CompanyAddr, Company);
                GenPostingDate := "Gen. Journal Line"."Posting Date";
                GenDocNo := "Gen. Journal Line"."Document No.";
                VendName := Vend.Name;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                Company.Get;
                Company.CalcFields(Picture);
                Counter := 0;
                VendName := '';
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
        Montant = 'Montant Paiement';
        Ref = 'N° Document';
        Ann = 'ANNEXE';
        vendN = 'N° Fournisseur';
        vendNa = 'Nom Fournisseur';
        MtantFacture = 'Montant Facture';
    }

    var
        Amount_InWords: Text;
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
        Reference: Text[20];
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
        DocDescrip: Text[100];
        DocDate: Date;
        AmountLCY: Decimal;
        RefFour: Text[50];
        VendNo: Code[20];
        AmountToApply: Decimal;
        VendName: Text[250];
        GenDocNo: Code[10];
        GenPostingDate: Date;
        MontantFacture: Decimal;
}

