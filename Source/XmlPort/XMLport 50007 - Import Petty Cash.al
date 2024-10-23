xmlport 50007 "Import Petty Cash"
{
    Caption = 'Import from Excel';
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
                fieldattribute(ExternalDocNo;"Import Data".ExternalDocNo)
                {
                }
                fieldattribute(TypeCompte;"Import Data".PieceNo)
                {
                }
                fieldattribute(GLAccNo;"Import Data".GLAccountNo)
                {
                }
                fieldattribute(Descr;"Import Data".Description)
                {
                }
                fieldattribute(MontantDebit;"Import Data".DebitAmount)
                {
                }
                fieldattribute(MontantCredit;"Import Data".CreditAmount)
                {
                }
                fieldattribute(TypeCompteContr;"Import Data".LocationCode)
                {
                }
                fieldattribute(CompteContrePartie;"Import Data".LocationCode2)
                {
                }
                fieldattribute(TVA;"Import Data".InvoiceNo)
                {
                }
                fieldattribute(ProfitCenter;"Import Data".CodeAnalytique)
                {
                }
                fieldattribute(BudgetCode;"Import Data".CodeAnalytique2)
                {
                }
                fieldattribute(CostCenter;"Import Data".CodeAnalytique3)
                {
                }
                fieldattribute(ProjectCode;"Import Data".CodeAnalytique4)
                {
                }
                fieldattribute(RegionCode;"Import Data".CodeAnalytique5)
                {
                }
                fieldattribute(ProfitCenter2;"Import Data".CodeAnalytique6)
                {
                }
                fieldattribute(AxeProduit;"Import Data".CodeAnalytique7)
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
                    
                      GenJrnTable.TestField("No. Series");
                      if GenJrnTable."No. Series" <> '' then begin
                        Clear(NoSeriesMgt);
                    
                        if LastDocNo='' then begin
                          GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTable."No. Series",GenJrnLine."Posting Date",false);
                          LastDocNo := GenJrnLine."Document No.";
                        end else begin
                          if (LastAmountTotal<>0) then
                            GenJrnLine."Document No." :=(LastDocNo)
                          else
                            GenJrnLine."Document No." :=IncStr(LastDocNo);
                          LastDocNo := GenJrnLine."Document No.";
                        end;
                      end;
                    
                      //GenJrnLine."Document No." := DocNum;
                    
                      Evaluate(GenJrnLine."Posting Date" ,"Import Data".PostingDate);
                    
                      /*
                      DocType1 := "Import Data".CodeTiers2;
                      AccountType1 := "Import Data".Area;
                    
                      IF DocType1='PAYMENT' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::Payment;
                      IF DocType1='INVOICE' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::Invoice;
                      IF DocType1='CREDIT_MEMO' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::"Credit Memo";
                      IF DocType1='REFUND' THEN GenJrnLine."Document Type":=GenJrnLine."Document Type"::Refund;
                      */
                      if (UpperCase(CopyStr("Import Data".PieceNo,1,1))='G') then
                        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
                      if  (UpperCase(CopyStr("Import Data".PieceNo,1,1))='C') then
                        GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;
                      if  (UpperCase(CopyStr("Import Data".PieceNo,1,1))='F') then
                        GenJrnLine."Account Type" := GenJrnLine."Account Type"::Vendor;
                      if  (UpperCase(CopyStr("Import Data".PieceNo,1,1))='B') then
                        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"Bank Account";
                    
                      GenJrnLine."External Document No." := "Import Data".ExternalDocNo;
                    
                    
                    
                      GLAccNo := "Import Data".GLAccountNo;
                      GenJrnLine.Validate("Account No.",GLAccNo);
                    
                    
                    
                    
                    
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
                    
                      GenJrnLine.Validate("Currency Code",'');
                    
                      //GenJrnLine."Bal. Account Type" :=  GenJrnLine."Bal. Account Type"::"Bank Account";
                      //GenJrnLine.VALIDATE("Bal. Account No.","Import Data".BalGLAccountNo);
                    
                    
                      if "Import Data".DebitAmount>0 then
                        GenJrnLine.Amount := "Import Data".DebitAmount
                      else
                        GenJrnLine.Amount := -"Import Data".CreditAmount;
                      GenJrnLine.Validate(Amount);
                    
                      LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;
                    
                      GenJrnLine.Description := CopyStr("Import Data".Description,1,49);
                    
                      //VAT
                      AddOnSetup.TestField(AddOnSetup."NoVAT Prod. Posting Group");
                      if (GenJrnLine."Account Type"=GenJrnLine."Account Type"::"G/L Account") then
                        if "Import Data".InvoiceNo='' then
                          if ((GLAccNo[1]='6') or (GLAccNo[1]='7')) then
                            GenJrnLine.Validate(GenJrnLine."VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
                    
                    
                    
                    //Contrepartie
                    if ("Import Data".LocationCode2<>'') then begin
                    
                        if (UpperCase(CopyStr("Import Data".LocationCode,1,1))='G') then
                          GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::"G/L Account";
                        if (UpperCase(CopyStr("Import Data".LocationCode,1,1))='B') then
                          GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::"Bank Account";
                        if (UpperCase(CopyStr("Import Data".LocationCode,1,1))='C') then
                          GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::Customer;
                        if (UpperCase(CopyStr("Import Data".LocationCode,1,1))='F') then
                          GenJrnLine."Bal. Account Type" := GenJrnLine."Account Type"::Vendor;
                    
                        GenJrnLine.Validate(GenJrnLine."Bal. Account No.","Import Data".LocationCode2);
                    
                    
                        if (GenJrnLine."Bal. Account Type"=GenJrnLine."Bal. Account Type"::"G/L Account") then
                          if "Import Data".InvoiceNo='' then
                            if ((GenJrnLine."Bal. Account No."[1]='6') or (GenJrnLine."Bal. Account No."[1]='7')) then
                              GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
                        LastAmountTotal := LastAmountTotal + (-GenJrnLine.Amount);
                    
                    end;
                    
                      //GLAcc2.GET(GLAccNo);
                      //Centre de cout
                      if "Import Data".CodeAnalytique3<>'' then
                        GenJrnLine.Validate("Shortcut Dimension 2 Code","Import Data".CodeAnalytique3);
                    
                      //Project code
                      if "Import Data".CodeAnalytique4<>'' then
                        GenJrnLine.ValidateShortcutDimCode(5,"Import Data".CodeAnalytique4);
                    
                      //Budget Code
                      if "Import Data".CodeAnalytique2<>'' then
                        GenJrnLine.Validate("Shortcut Dimension 1 Code","Import Data".CodeAnalytique2);
                    
                      //Profit center
                      if "Import Data".CodeAnalytique<>'' then
                        GenJrnLine.ValidateShortcutDimCode(3,"Import Data".CodeAnalytique);
                    
                      //Region Code
                      if "Import Data".CodeAnalytique5<>'' then
                        GenJrnLine.ValidateShortcutDimCode(4,"Import Data".CodeAnalytique5);
                    
                    
                      //Profit center 2
                      if "Import Data".CodeAnalytique6<>'' then
                        GenJrnLine.ValidateShortcutDimCode(7,"Import Data".CodeAnalytique6);
                    
                      //Axe Produit
                      if "Import Data".CodeAnalytique7<>'' then
                        GenJrnLine.ValidateShortcutDimCode(8,"Import Data".CodeAnalytique7);
                    
                    
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
                    Visible = false;
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
        //IF DocNum='' THEN ERROR(Text005);

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

