xmlport 50001 "Import Payroll Data"
{
    Caption = 'Import payroll Data';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement("Import Data";"Import Data")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING(EntryNo) ORDER(Ascending);
                fieldattribute(PostingDate;"Import Data".PostingDate)
                {
                }
                fieldattribute(GLAccNo;"Import Data".GLAccountNo)
                {
                }
                fieldattribute(Descr;"Import Data".Description)
                {
                }
                fieldattribute(Sens;"Import Data".DocNum1)
                {
                }
                fieldattribute(Montant;"Import Data".DebitAmount)
                {
                }
                fieldattribute(CostCenter;"Import Data".CodeAnalytique)
                {
                }
                fieldattribute(CostProject;"Import Data".LocationCode)
                {
                }
                fieldattribute(CostBudget;"Import Data".LocationCode2)
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
                      GenJrnLine."Journal Template Name":= GenJrnTemplate;
                      GenJrnLine."Journal Batch Name" := GenJrnBatch;
                      LineNo := LineNo+10000;
                      GenJrnLine."Line No." := LineNo;
                      JrnTmplName.Get(GenJrnLine."Journal Template Name");
                      JrnTmplName.TestField(JrnTmplName."Source Code");
                      GenJrnLine."Source Code" := JrnTmplName."Source Code";
                      //GenJrnLine.VALIDATE("Posting Date","Import Data".PostingDate);
                      /*
                      GenJrnTable.TESTFIELD("No. Series");
                      IF GenJrnTable."No. Series" <> '' THEN BEGIN
                        CLEAR(NoSeriesMgt);
                    
                        IF LastDocNo='' THEN BEGIN
                          GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTable."No. Series",GenJrnLine."Posting Date",FALSE);
                          LastDocNo := GenJrnLine."Document No.";
                        END ELSE BEGIN
                          IF (LastAmountTotal<>0) THEN
                            GenJrnLine."Document No." :=(LastDocNo)
                          ELSE
                            GenJrnLine."Document No." :=INCSTR(LastDocNo);
                          LastDocNo := GenJrnLine."Document No.";
                        END;
                      END;
                      */
                      GenJrnLine."Document No." := DocNum;
                    
                      Evaluate(GenJrnLine."Posting Date" ,CopyStr("Import Data".PostingDate,1,6));
                    
                      /*
                      DocType1 := "Import Data".CodeTiers2;
                      AccountType1 := "Import Data".Area;
                    
                      IF DocType1='PAYMENT' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::Payment;
                      IF DocType1='INVOICE' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::Invoice;
                      IF DocType1='CREDIT_MEMO' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::"Credit Memo";
                      IF DocType1='REFUND' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::Refund;
                      */
                    
                      //GenJrnLine."External Document No." := "Import Data".ExternalDocNo;
                      GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
                    
                      /*
                      IF AccountType1='GENERAL' THEN GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
                      IF AccountType1='CUSTOMER' THEN GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;
                      IF AccountType1='VENDOR' THEN GenJrnLine."Account Type" := GenJrnLine."Account Type"::Vendor;
                      IF AccountType1='BANK' THEN GenJrnLine."Account Type" := GenJrnLine."Account Type"::"Bank Account";
                    
                      */
                      GLAccNo := "Import Data".GLAccountNo;
                      GenJrnLine.Validate("Account No.",GLAccNo);
                    
                      //GLAcc2.GET(GLAccNo);
                      //Centre de cout
                      if "Import Data".CodeAnalytique<>'' then
                        GenJrnLine.Validate("Shortcut Dimension 2 Code","Import Data".CodeAnalytique);
                    
                      //Project code
                      if "Import Data".LocationCode<>'' then
                        GenJrnLine.ValidateShortcutDimCode(5,"Import Data".LocationCode);
                    
                      //Budget Code
                      if "Import Data".LocationCode2<>'' then
                        GenJrnLine.Validate("Shortcut Dimension 1 Code","Import Data".LocationCode2);
                    
                      //Cust2.GET(AddOnSetup."Default Customer");
                      //Vend2.CheckBlockedVendOnJnls(Vend2,"Document Type",FALSE);
                    
                      GenJrnLine.Description := CopyStr("Import Data".Description,1,49);
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
                      //GenJrnLine."VAT Bus. Posting Group" := '';
                      //GenJrnLine."VAT Prod. Posting Group" := '';
                      GenJrnLine.Validate("Currency Code",'');
                    
                      //GenJrnLine."Bal. Account Type" :=  GenJrnLine."Bal. Account Type"::"Bank Account";
                      //GenJrnLine.VALIDATE("Bal. Account No.","Import Data".BalGLAccountNo);
                    
                    
                      if "Import Data".DocNum1='D' then
                        GenJrnLine.Amount := "Import Data".DebitAmount
                      else
                        GenJrnLine.Amount := -"Import Data".DebitAmount;
                      GenJrnLine.Validate(Amount);
                    
                      LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;
                    
                      //VAT
                      AddOnSetup.TestField(AddOnSetup."NoVAT Prod. Posting Group");
                      //IF (AccountType1='GENERAL') THEN
                      //  IF "Import Data".SeriesNo='' THEN
                          if ((GLAccNo[1]='6') or (GLAccNo[1]='7')) then
                            GenJrnLine.Validate(GenJrnLine."VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
                    
                      //CORRECTION
                      //IF "Import Data".Area='YES' THEN
                      //  GenJrnLine.VALIDATE(Correction,TRUE);
                    
                    //***************************************************************
                    //Workflow onn journals
                    //***************************************************************
                    //IF JournalWflwMgt.WorkflowOnJournal(Rec) THEN BEGIN
                    //  IF JournalWflwMgt.UserCanPostOnJournal(GenJrnLine) THEN
                    //    GenJrnLine."Posting Status":=GenJrnLine."Posting Status"::Released;
                    //END;
                    //***************************************************************
                    
                    
                    
                      //GenJrnLine."Invoice No" := "Import Data".RefDoc2;
                      //GenJrnLine."Applies-to Doc. Type" := GenJrnLine."Applies-to Doc. Type"::Invoice;
                      //GenJrnLine."Applies-to Doc. No.":= "Import Data".RefDoc2;
                    
                      //IF GenJrnLine.Amount>0 THEN
                      //GenJrnLine."Document Type":=GenJrnLine."Document Type"::Payment;
                    
                      if GenJrnLine.Amount<>0 then
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
                field(GenJrnTemplate;GenJrnTemplate)
                {
                    Caption = 'General journal template';
                    TableRelation = "Gen. Journal Template";
                    Visible = false;
                }
                field(GenJrnBatch;GenJrnBatch)
                {
                    Caption = 'Posting journal Batch';
                    TableRelation = "Gen. Journal Batch";
                    Visible = false;
                }
                field("N° Document";DocNum)
                {
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
        //AddOnSetup.TESTFIELD(AddOnSetup."Payroll Tmpl Journal");

        //GenJrnTemplate:=AddOnSetup."Payroll Tmpl Journal";
    end;

    trigger OnPostXmlPort()
    begin

        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin



        if GenJrnTemplate='' then Error(Text003);
        if GenJrnBatch='' then Error(Text004);
        if DocNum='' then Error(Text005);

        GenJrnTable.Get(GenJrnTemplate,GenJrnBatch);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name",GenJrnBatch);
        if GenJrnLine.FindFirst then Error(Text001,GenJrnBatch);
        LineNo := 0;

        BesoinNo :=0;
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

    procedure SetFeuille(Modele: Code[10];NomFeuille: Code[10])
    begin
        GenJrnBatch := NomFeuille;
        GenJrnTemplate := Modele;
    end;
}

