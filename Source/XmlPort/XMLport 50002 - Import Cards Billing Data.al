xmlport 50002 "Import Cards Billing Data"
{
    Caption = 'Import Moneytech invoices';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement("Import Data"; "Import Data")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING(EntryNo) ORDER(Ascending);
                fieldattribute(CustNo; "Import Data".GLAccountNo)
                {
                }
                fieldattribute(Descr; "Import Data".Description)
                {
                }
                fieldattribute(CustName; "Import Data".Description2)
                {
                }
                fieldattribute(TransactionNo; "Import Data".DocumentNo)
                {
                }
                fieldattribute(MontantBrut; "Import Data".DebitAmount)
                {
                }
                fieldattribute(Remise; "Import Data".Amount)
                {
                }
                fieldattribute(NetAPayer; "Import Data".CreditAmount)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    NetToPay: Decimal;
                    MontantBrut: Decimal;
                    Remise: Decimal;
                    DimSetE: Integer;
                begin

                    BesoinNo := BesoinNo + 1;
                    //Window.UPDATE(1,
                    //ROUND(BesoinNo / NbreTotalLignes * 10000,1));


                    MontantBrut := "Import Data".DebitAmount;
                    Remise := "Import Data".Amount;
                    NetToPay := "Import Data".CreditAmount;
                    //MESSAGE('%1 %2 %3',MontantBrut,Remise,NetToPay);
                    //IF NetToPay<>MontantBrut+Remise THEN ERROR(Text006,"Import Data".DocumentNo);//070520 Controle désactivé

                    //Debit du client
                    Clear(GenJrnLine);
                    GenJrnLine."Journal Template Name" := GenJrnTemplate;
                    GenJrnLine."Journal Batch Name" := GenJrnBatch;
                    LineNo := LineNo + 10000;
                    GenJrnLine."Line No." := LineNo;
                    JrnTmplName.Get(GenJrnLine."Journal Template Name");
                    JrnTmplName.TestField(JrnTmplName."Source Code");
                    GenJrnLine."Source Code" := JrnTmplName."Source Code";

                    if NetToPay > 0 then
                        GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
                    else
                        GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";
                    GenJrnLine."Document No." := "Import Data".DocumentNo;

                    GenJrnLine.Validate("Posting Date", PostingDate);

                    GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;

                    GLAccNo := "Import Data".GLAccountNo;
                    GenJrnLine.Validate("Account No.", GLAccNo);

                    Cust2.Get(GLAccNo);

                    //GenJrnLine.Description := COPYSTR("Import Data".Description,1,49);
                    GenJrnLine.Description := Cust2.Name;

                    GenJrnLine.Validate("Currency Code", '');

                    GenJrnLine.Amount := NetToPay;
                    GenJrnLine.Validate(Amount);

                    LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;

                    //AddOnSetup.TESTFIELD("Postpaid Cards Account");
                    //GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
                    //GenJrnLine.VALIDATE(GenJrnLine."Bal. Account No.",AddOnSetup."Postpaid Cards Account");

                    // IF ((GLAccNo[1]='6') OR (GLAccNo[1]='7')) THEN
                    //      GenJrnLine.VALIDATE(GenJrnLine."VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");

                    //IF GenJrnLine.Amount=0 THEN
                    //  ERROR(Text005);

                    DimSetE := GenJrnLine."Dimension Set ID";
                    if (GenJrnLine.Amount <> 0) then
                        GenJrnLine.Insert(true);







                    //Credit du compte des cartes postpayees
                    Clear(GenJrnLine);
                    GenJrnLine."Journal Template Name" := GenJrnTemplate;
                    GenJrnLine."Journal Batch Name" := GenJrnBatch;
                    LineNo := LineNo + 10000;
                    GenJrnLine."Line No." := LineNo;
                    JrnTmplName.Get(GenJrnLine."Journal Template Name");
                    JrnTmplName.TestField(JrnTmplName."Source Code");
                    GenJrnLine."Source Code" := JrnTmplName."Source Code";

                    if NetToPay > 0 then
                        GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
                    else
                        GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";
                    GenJrnLine."Document No." := "Import Data".DocumentNo;
                    GenJrnLine.Validate("Posting Date", PostingDate);
                    GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

                    if VendorType = VendorType::GALITT then begin

                        if IsGPRO then begin
                            AddOnSetup2.TestField(AddOnSetup2."Galitt Fact Men Postpaid GPRO");
                            GLAccNo := AddOnSetup2."Galitt Fact Men Postpaid GPRO";
                        end else begin
                            AddOnSetup2.TestField("Galitt Facture Mensue Postpaid");
                            GLAccNo := AddOnSetup2."Galitt Facture Mensue Postpaid";
                        end;

                    end else begin

                        if IsGPRO then begin
                            AddOnSetup.TestField(AddOnSetup."GPRO Cards Account");
                            GLAccNo := AddOnSetup."GPRO Cards Account";
                        end else begin
                            AddOnSetup.TestField("Postpaid Cards Account");
                            GLAccNo := AddOnSetup."Postpaid Cards Account";
                        end;

                    end;
                    GenJrnLine.Validate("Account No.", GLAccNo);
                    //GenJrnLine.Description := COPYSTR("Import Data".Description,1,49);
                    GenJrnLine.Description := Cust2.Name;

                    GenJrnLine.Validate("Currency Code", '');

                    GenJrnLine.Amount := -(MontantBrut);
                    GenJrnLine.Validate(Amount);

                    LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;

                    if ((GLAccNo[1] = '6') or (GLAccNo[1] = '7')) then begin
                        GenJrnLine.Validate(GenJrnLine."VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
                        GenJrnLine."Gen. Posting Type" := GenJrnLine."Gen. Posting Type"::Sale;
                    end;

                    //IF GenJrnLine.Amount=0 THEN
                    //  ERROR(Text005);
                    if (GenJrnLine.Amount <> 0) then begin
                        GenJrnLine."Dimension Set ID" := DimSetE;
                        GenJrnLine.Insert(true);

                        GenJrnLine."Dimension Set ID" := DimSetE;
                        GenJrnLine.Modify;
                    end;




                    //Débit de la remise
                    if (Remise <> 0) then begin
                        Clear(GenJrnLine);
                        GenJrnLine."Journal Template Name" := GenJrnTemplate;
                        GenJrnLine."Journal Batch Name" := GenJrnBatch;
                        LineNo := LineNo + 10000;
                        GenJrnLine."Line No." := LineNo;
                        JrnTmplName.Get(GenJrnLine."Journal Template Name");
                        JrnTmplName.TestField(JrnTmplName."Source Code");
                        GenJrnLine."Source Code" := JrnTmplName."Source Code";

                        if NetToPay > 0 then
                            GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
                        else
                            GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";
                        GenJrnLine."Document No." := "Import Data".DocumentNo;

                        GenJrnLine.Validate("Posting Date", PostingDate);

                        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";


                        AddOnSetup.TestField(AddOnSetup."Cards Discount Account");
                        GLAccNo := AddOnSetup."Cards Discount Account";
                        GenJrnLine.Validate("Account No.", GLAccNo);

                        //GenJrnLine.Description := COPYSTR("Import Data".Description,1,49);
                        GenJrnLine.Description := Cust2.Name;

                        GenJrnLine.Validate("Currency Code", '');

                        GenJrnLine.Amount := -(Remise);
                        GenJrnLine.Validate(Amount);

                        LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;

                        if ((GLAccNo[1] = '6') or (GLAccNo[1] = '7')) then begin
                            GenJrnLine.Validate(GenJrnLine."VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
                            GenJrnLine."Gen. Posting Type" := GenJrnLine."Gen. Posting Type"::Sale;
                        end;

                        if GenJrnLine.Amount <> 0 then begin
                            GenJrnLine."Dimension Set ID" := DimSetE;
                            GenJrnLine.Insert(true);

                            GenJrnLine."Dimension Set ID" := DimSetE;
                            GenJrnLine.Modify;
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
                field(VendorType; VendorType)
                {
                    Caption = 'Type fournisseur cartes';
                    ApplicationArea = All;
                }
                field(PPostingDateCtrl; PostingDate)
                {
                    Caption = 'Posting Date';
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
        //AddOnSetup.TESTFIELD(AddOnSetup."Sales by Cards Import Tmpl");

        //GenJrnTemplate:=AddOnSetup."Sales by Cards Import Tmpl";
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

        GenJrnTable.Get(GenJrnTemplate, GenJrnBatch);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch);
        if GenJrnLine.FindFirst then Error(Text001, GenJrnBatch);
        LineNo := 0;

        BesoinNo := 0;
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
        Text005: Label 'Le montant ne doit pas être nul sur la ligne %1';
        Text006: Label 'Erreur dans le fichier. Le Montant net doit être égal au Montant brut - Montant Remise sur la ligne %1';
        IsGPRO: Boolean;
        VendorType: Option Autres,GALITT;
        AddOnSetup2: Record "AddOn Setup2";

    procedure SetJournalCode(JournalTemplateCode: Code[20]; JournalCode: Code[20])
    begin
        GenJrnBatch := JournalCode;
        GenJrnTemplate := JournalTemplateCode;
    end;

    procedure SetIsGPRO(isGpro1: Boolean)
    begin
        IsGPRO := isGpro1;
    end;
}

