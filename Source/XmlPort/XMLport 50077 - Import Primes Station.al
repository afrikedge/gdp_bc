xmlport 50077 "Import Primes Station"
{
    Caption = 'Import from Excel';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF8;
    UseRequestPage = false;

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
                fieldattribute(ExternalDocNo; "Import Data".ExternalDocNo)
                {
                }
                fieldattribute(CodeStation; "Import Data".CodeTiers)
                {
                }
                fieldattribute(NomStation; "Import Data".Description)
                {
                }
                fieldattribute(Libelle; "Import Data".Description2)
                {
                }
                fieldattribute(MontantCredit; "Import Data".CreditAmount)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                begin

                    BesoinNo := BesoinNo + 1;
                    //Window.UPDATE(1,
                    //ROUND(BesoinNo / NbreTotalLignes * 10000,1));

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

                    //GenJrnLine."Document No." := DocNum;

                    Evaluate(GenJrnLine."Posting Date", "Import Data".PostingDate);

                    GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";

                    GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;

                    GenJrnLine."External Document No." := "Import Data".ExternalDocNo;



                    GLAccNo := "Import Data".CodeTiers;
                    GenJrnLine.Validate("Account No.", GLAccNo);





                    //Cust2.GET(AddOnSetup."Default Customer");
                    //Vend2.CheckBlockedVendOnJnls(Vend2,"Document Type",FALSE);


                    //GenJrnLine.Description := COPYSTR("Import Data".Description,1,37)+' - '+COPYSTR("Import Data".InvoiceNo,1,10);

                    //GenJrnLine."Posting Group" := Cust2."Customer Posting Group";
                    //GenJrnLine."Salespers./Purch. Code" := Cust2."Salesperson Code";
                    //"Payment Terms Code" := Vend2."Payment Terms Code";
                    //GenJrnLine."Due Date" := "Monthly Invoice Data".DueDate;
                    //GenJrnLine.VALIDATE("Bill-to/Pay-to No.","Monthly Invoice Data".CustomerNo);
                    //GenJrnLine.VALIDATE("Sell-to/Buy-from No.","Monthly Invoice Data".CustomerNo);
                    //GenJrnLine."Gen. Posting Type" := ;
                    //GenJrnLine."Gen. Bus. Posting Group" := '';
                    //GenJrnLine."Gen. Prod. Posting Group" := '';

                    //IF ("Import Data".LocationCode<>'') THEN
                    //  GenJrnLine.VALIDATE("VAT Bus. Posting Group", "Import Data".LocationCode);

                    //IF ("Import Data".LocationCode2<>'') THEN
                    //  GenJrnLine.VALIDATE("VAT Prod. Posting Group" , "Import Data".LocationCode2);

                    GenJrnLine.Validate("Currency Code", '');

                    //GenJrnLine."Bal. Account Type" :=  GenJrnLine."Bal. Account Type"::"Bank Account";
                    //GenJrnLine.VALIDATE("Bal. Account No.","Import Data".BalGLAccountNo);


                    //IF "Import Data".DebitAmount>0 THEN
                    //  GenJrnLine.Amount := "Import Data".DebitAmount
                    //ELSE
                    GenJrnLine.Amount := -"Import Data".CreditAmount;
                    GenJrnLine.Validate(Amount);

                    LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;

                    GenJrnLine.Description := CopyStr("Import Data".Description2, 1, 49);

                    //VAT
                    /*AddOnSetup.TESTFIELD(AddOnSetup."NoVAT Prod. Posting Group");
                    IF (GenJrnLine."Account Type"=GenJrnLine."Account Type"::"G/L Account") THEN
                      IF "Import Data".InvoiceNo='' THEN
                        IF ((GLAccNo[1]='6') OR (GLAccNo[1]='7')) THEN
                          GenJrnLine.VALIDATE(GenJrnLine."VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
                          */



                    //Contrepartie
                    GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::"G/L Account";
                    GenJrnLine.Validate("Bal. Account No.", AddOnSetup."Primes Station Acc");
                    GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Sale;
                    LastAmountTotal := LastAmountTotal + (-GenJrnLine.Amount);


                    GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."VAT Group Primes Gerant");
                    /*
                    IF ("Import Data".LocationCode2<>'') THEN BEGIN
                    
                        IF (UPPERCASE(COPYSTR("Import Data".LocationCode,1,1))='G') THEN
                          GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::"G/L Account"
                        ELSE
                          GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::"Bank Account";
                        GenJrnLine.VALIDATE(GenJrnLine."Bal. Account No.","Import Data".LocationCode2);
                    
                    
                        IF (GenJrnLine."Bal. Account Type"=GenJrnLine."Bal. Account Type"::"G/L Account") THEN
                          IF "Import Data".InvoiceNo='' THEN
                            IF ((GenJrnLine."Bal. Account No."[1]='6') OR (GenJrnLine."Bal. Account No."[1]='7')) THEN
                              GenJrnLine.VALIDATE(GenJrnLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
                        LastAmountTotal := LastAmountTotal + (-GenJrnLine.Amount);
                    
                    END;
                    */



                    if GenJrnLine.Amount <> 0 then
                        GenJrnLine.Insert(true);

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
        AddOnSetup.TestField(AddOnSetup."Primes Station Acc");
        AddOnSetup.TestField(AddOnSetup."VAT Group Primes Gerant");

        //GenJrnTemplate:=AddOnSetup."Payroll Tmpl Journal";
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

    procedure SetFeuille(Modele: Code[10]; NomFeuille: Code[10])
    begin
        GenJrnBatch := NomFeuille;
        GenJrnTemplate := Modele;
    end;
}

