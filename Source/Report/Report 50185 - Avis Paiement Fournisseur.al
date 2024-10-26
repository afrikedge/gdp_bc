report 50185 "Avis Paiement Fournisseur"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Avis Paiement Fournisseur.rdlc';
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
            column(DateCompta; "Due Date")
            {
            }
            column(Picture; Company.Picture)
            {
            }
            column(entete; TexteEntete)
            {
            }
            column(PiedDePage; TextPiedPage)
            {
            }
            column(TxtDate; TxtDate)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
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
                    if SiNonLettre then begin
                        DocumentNo := "Gen. Journal Line"."Document No.";
                        RefFour := "Gen. Journal Line"."External Document No.";
                        DocDate := "Gen. Journal Line"."Posting Date";
                        if "Gen. Journal Line"."Payment Method Code" = 'TRAITES' then
                            DocDate := "Gen. Journal Line"."Due Date";
                        DocDescrip := "Gen. Journal Line".Description;
                        VendNo := "Gen. Journal Line"."Account No.";
                        AmountToApply := ("Gen. Journal Line"."Amount (LCY)");
                    end
                    else begin
                        DocumentNo := VendLedgEntry."Document No.";
                        RefFour := VendLedgEntry."External Document No.";
                        DocDate := VendLedgEntry."Posting Date";
                        if "Gen. Journal Line"."Payment Method Code" = 'TRAITES' then begin
                            DocDate := "Gen. Journal Line"."Due Date";
                            GenPostingDate := "Gen. Journal Line"."Due Date";
                        end;
                        DocDescrip := VendLedgEntry.Description;
                        VendNo := VendLedgEntry."Vendor No.";
                        //MontantFacture := -(VendLedgEntry."Purchase (LCY)" * 1.2);
                        MontantFacture := -(VendLedgEntry."Purchase (LCY)");
                        VendLedgEntry.CalcFields("Amount (LCY)");
                        AmountLCY := -(VendLedgEntry."Amount (LCY)");
                        AmountToApply := (VendLedgEntry."Amount to Apply");
                    end;
                    if VendLedgEntry.Next <> 0 then;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, Counter);
                    if VendLedgEntry.FindFirst then;
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

                TxtDate := TextDate;

                if "Gen. Journal Line"."Payment Method Code" = 'VIREMENT' then begin
                    TexteEntete := StrSubstNo(Text028, "Gen. Journal Line"."Document No.", Format("Gen. Journal Line"."Posting Date"));
                    TextPiedPage := Text031;
                end;

                if "Gen. Journal Line"."Payment Method Code" = 'CHEQUES' then begin
                    TexteEntete := StrSubstNo(Text029, "Gen. Journal Line"."Document No.",
                        Format("Gen. Journal Line"."Bal. Account No."),
                        Format("Gen. Journal Line"."Posting Date"));
                    TextPiedPage := Text030;
                end;

                if "Gen. Journal Line"."Payment Method Code" = 'ESPECES' then begin
                    TexteEntete := StrSubstNo(Text034, "Gen. Journal Line"."Document No.",
                        Format("Gen. Journal Line"."Posting Date"));
                    TextPiedPage := Text032;
                end;

                if "Gen. Journal Line"."Payment Method Code" = 'TRAITES' then begin
                    TexteEntete := StrSubstNo(Text033, "Gen. Journal Line"."Document No.");
                    TextPiedPage := Text035;
                    TxtDate := TextDateEcheance;
                end;



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

                if "Gen. Journal Line"."Applies-to ID" = '' then begin
                    Counter := 1;
                    SiNonLettre := true;
                end
                else
                    Counter := VendLedgEntry.Count;

                if VendLedgEntry.FindFirst then;

                NbTLet.InitTextVariable;
                NbTLet.FormatNoText(TotalAmountLetter, "Gen. Journal Line".Amount, "Gen. Journal Line"."Currency Code");

                FormatAddr.Company(CompanyAddr, Company);
                GenPostingDate := "Gen. Journal Line"."Posting Date";
                if "Gen. Journal Line"."Payment Method Code" = 'TRAITES' then
                    GenPostingDate := "Gen. Journal Line"."Due Date";
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
        cord = 'Cordialement';
        Mention = 'Votre compte sera crédité dans les 48 heures.';
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
        DocDescrip: Text[60];
        DocDate: Date;
        AmountLCY: Decimal;
        RefFour: Text[50];
        VendNo: Code[20];
        AmountToApply: Decimal;
        VendName: Text[250];
        GenDocNo: Code[20];
        GenPostingDate: Date;
        MontantFacture: Decimal;
        SiNonLettre: Boolean;
        TexteEntete: Text;
        TextPiedPage: Text;
        Text028: Label 'Nous vous informons avoir payé par virement  ''%1''  le ''%2'' vos factures détaillées ci-après :';
        Text029: Label 'Nous vous informons avoir payé par chèque  ''%1'' banque ''%2''  le ''%3'' vos factures détaillées ci-après :';
        Text030: Label 'Votre chèque sera disponible à la caisse GDP, Immeuble Villa Pradon, Antanimena 2è étage.';
        Text031: Label 'Votre compte sera crédité dans les 48 heures.';
        Text032: Label 'Votre compte orange money - wallet karama sera crédité à réception de cet avis';
        Text033: Label 'Nous vous informons avoir payé par traite %1 vos factures détaillées ci-après :';
        Text034: Label 'Nous vous informons avoir payé par espèces  ''%1''  le ''%2'' vos factures détaillées ci-après :';
        Text035: Label 'Votre traite sera disponible à la caisse GDP, Immeuble Villa Pradon, Antanimena 2è étage.';
        TxtDate: Text;
        TextDate: Label 'Date';
        TextDateEcheance: Label 'Date d''échéance';
}

