xmlport 50079 "Import Op. Gerant NC"
{
    Caption = 'Import Notes de crédit Gérant';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF8;
    UseRequestPage = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Import Data"; "Import Data")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING(EntryNo) ORDER(Ascending);
                fieldattribute(PostingDate; "Import Data".PostingDate)
                {
                }
                fieldattribute(PostingDate2; "Import Data".PostingDate2)
                {
                }
                fieldattribute(NumGerant; "Import Data".ExternalDocNo)
                {
                }
                fieldattribute(CodeStation; "Import Data".CodeTiers)
                {
                }
                fieldattribute(DateTrait; "Import Data".Description)
                {
                }
                fieldattribute(NumReleve; "Import Data".CodeAnalytique3)
                {
                }
                fieldattribute(DateTrans; "Import Data".GLAccountNo)
                {
                }
                fieldattribute(HeureTrans; "Import Data".CodeAnalytique2)
                {
                }
                fieldattribute(NomClient; "Import Data".Description2)
                {
                }
                fieldattribute(NumCarte; "Import Data".CodeAnalytique4)
                {
                }
                fieldattribute(Produit; "Import Data".CodeAnalytique5)
                {
                }
                fieldattribute(Qty; "Import Data".CodeAnalytique6)
                {
                }
                fieldattribute(MontantTPE; "Import Data".Amount)
                {
                }
                fieldattribute(MontantFG; "Import Data".DebitAmount)
                {
                }
                fieldattribute(MontantNet; "Import Data".CreditAmount)
                {
                }
                fieldattribute(NumTicket; "Import Data".DocNum1)
                {
                }
                fieldattribute(Pompiste; "Import Data".DocNum2)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    GenJrnLine2: Record "Gen. Journal Line";
                    TransactionDate: Date;
                begin

                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000, 1));

                    //Dette fournisseur
                    Clear(GenJrnLine);
                    GenJrnLine."Journal Template Name" := GenJrnTemplate;
                    GenJrnLine."Journal Batch Name" := GenJrnBatch;
                    LineNo := LineNo + 10000;
                    GenJrnLine."Line No." := LineNo;
                    JrnTmplName.Get(GenJrnLine."Journal Template Name");
                    JrnTmplName.TestField(JrnTmplName."Source Code");
                    GenJrnLine."Source Code" := JrnTmplName."Source Code";
                    //GenJrnLine.VALIDATE("Posting Date","Import Data".PostingDate);

                    GenJrnTable.TestField("No. Series");
                    if GenJrnTable."No. Series" <> '' then begin
                        Clear(NoSeriesMgt);

                        if LastDocNo = '' then begin
                            GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTable."No. Series", GenJrnLine."Posting Date", false);
                            LastDocNo := GenJrnLine."Document No.";
                        end else begin
                            if (LastAmountTotal <> 0) then
                                GenJrnLine."Document No." := (LastDocNo)
                            else
                                GenJrnLine."Document No." := IncStr(LastDocNo);
                            LastDocNo := GenJrnLine."Document No.";
                        end;
                    end;

                    if VendorType = VendorType::GALITT then begin
                        Evaluate(TransactionDate, "Import Data".GLAccountNo);
                        GenJrnLine."Posting Date" := TransactionDate;
                    end else
                        Evaluate(GenJrnLine."Posting Date", "Import Data".PostingDate);


                    GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";

                    GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;

                    GLAccNo := "Import Data".CodeTiers;
                    GenJrnLine.Validate("Account No.", GLAccNo);

                    if VendorType = VendorType::GALITT then
                        Descr := Text007 + ' ' + Format("Import Data".PostingDate) + '..' + Format("Import Data".Description)
                    else
                        Descr := Text007 + ' ' + Format("Import Data".PostingDate) + '..' + Format("Import Data".PostingDate2);

                    GenJrnLine.Description := CopyStr(Descr, 1, 49);
                    //GenJrnLine.Description := COPYSTR("Import Data".Description,1,37)+' - '+COPYSTR("Import Data".InvoiceNo,1,10);

                    GenJrnLine."External Document No." := "Import Data".CodeAnalytique3;
                    GenJrnLine.Validate("Currency Code", '');

                    GenJrnLine.Amount := -"Import Data".CreditAmount;
                    GenJrnLine.Validate(Amount);

                    LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;

                    //Contrepartie
                    GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::"G/L Account";

                    if VendorType = VendorType::Autres then begin
                        if ImportType = ImportType::Prepaid then
                            GenJrnLine.Validate("Bal. Account No.", AddOnSetup."CAP CreditNote Gerant Prepaid");
                        if ImportType = ImportType::PostPaid then
                            GenJrnLine.Validate("Bal. Account No.", AddOnSetup."CAP CreditNote Gerant Postpaid");
                        if ImportType = ImportType::GPRO then
                            GenJrnLine.Validate("Bal. Account No.", AddOnSetup."CAP CreditNote Gerant GPRO");
                    end;

                    if VendorType = VendorType::GALITT then begin
                        if ImportType = ImportType::Prepaid then
                            GenJrnLine.Validate("Bal. Account No.", AddOnSetup2."Galitt NC Gerant Prepaid");

                        if ImportType = ImportType::PostPaid then
                            GenJrnLine.Validate("Bal. Account No.", AddOnSetup2."Galitt NC Gerant Postpaid");

                        if ImportType = ImportType::GPRO then
                            GenJrnLine.Validate("Bal. Account No.", AddOnSetup2."Galitt NC Gerant GPRO");
                    end;

                    GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Sale;
                    LastAmountTotal := LastAmountTotal + (-GenJrnLine.Amount);


                    GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."CAP VAT Group NDNC Gerant");

                    if GenJrnLine.Amount <> 0 then begin

                        Clear(GenJrnLine2);
                        GenJrnLine2.SetRange("Journal Template Name", GenJrnTemplate);
                        GenJrnLine2.SetRange("Journal Batch Name", GenJrnBatch);
                        GenJrnLine2.SetRange("Account No.", GenJrnLine."Account No.");
                        GenJrnLine2.SetRange("Posting Date", GenJrnLine."Posting Date");

                        if GenJrnLine2.FindFirst then begin

                            GenJrnLine2.Validate(Amount, GenJrnLine2.Amount + GenJrnLine.Amount);
                            GenJrnLine2.Modify;

                        end else begin

                            GenJrnLine.Insert(true);

                        end;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(GenJrnTemplate; GenJrnTemplate)
                {
                    Caption = 'General journal template';
                    TableRelation = "Gen. Journal Template";
                    Visible = false;
                    ApplicationArea = All;
                }
                field(GenJrnBatch; GenJrnBatch)
                {
                    Caption = 'Posting journal Batch';
                    TableRelation = "Gen. Journal Batch";
                    Visible = false;
                    ApplicationArea = All;
                }
                field("N° Document"; DocNum)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(VendorType; VendorType)
                {
                    Caption = 'Type fournisseur cartes';
                    ApplicationArea = All;
                }
                field(ImportType; ImportType)
                {
                    Caption = 'Import Type';
                    ApplicationArea = All;
                }
                field(NbreTotalLignes; NbreTotalLignes)
                {
                    Caption = 'Total lines';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin

        GLSetup.Get;
        AddOnSetup.Get;
        AddOnSetup2.Get;

        if (VendorType = VendorType::Autres) then
            AddOnSetup.TestField(AddOnSetup."CAP CreditNote Gerant Prepaid");

        if (VendorType = VendorType::GALITT) then
            AddOnSetup2.TestField(AddOnSetup2."Galitt NC Gerant Prepaid");

        AddOnSetup.TestField(AddOnSetup."CAP VAT Group NDNC Gerant");
    end;

    trigger OnPostXmlPort()
    begin

        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin



        if GenJrnTemplate = '' then Error(Text003);
        if GenJrnBatch = '' then Error(Text004);
        //IF DocNum='' THEN ERROR(Text005);

        GenJrnTable.Get(GenJrnTemplate, GenJrnBatch);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch);
        if GenJrnLine.FindFirst then Error(Text001, GenJrnBatch);
        LineNo := 0;

        BesoinNo := 0;
        if NbreTotalLignes = 0 then
            NbreTotalLignes := 100;
        Window.Open(Text008);
    end;

    var
        GenJrnTemplate: Code[20];
        GenJrnBatch: Code[20];
        PostingDate: Date;
        GenJrnTable: Record "Gen. Journal Batch";
        GenJrnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Cust2: Record Customer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        AddOnSetup: Record "AddOn Setup";
        JrnTmplName: Record "Gen. Journal Template";
        GLAcc2: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        Vend2: Record Vendor;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LastDocNo: Code[20];
        LastAmountTotal: Decimal;
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text002: Label 'This account %1 does not exists !';
        Text003: Label 'The journal template model is required';
        Text004: Label 'The journal code is required';
        DocNum: Code[20];
        Text005: Label 'Vous devez selectionner un code document';
        Text006: Label 'Note de débit Gérant';
        Text007: Label 'Note de crédit Gérant';
        Descr: Text[100];
        ImportType: Option PostPaid,Prepaid,GPRO;
        VendorType: Option Autres,GALITT;
        AddOnSetup2: Record "AddOn Setup2";

    procedure SetFeuille(Modele: Code[10]; NomFeuille: Code[10])
    begin
        GenJrnBatch := NomFeuille;
        GenJrnTemplate := Modele;
    end;
}

