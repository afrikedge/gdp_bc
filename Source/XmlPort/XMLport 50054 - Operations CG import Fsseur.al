xmlport 50054 "Operations CG import Fsseur"
{
    Caption = 'Monthly invoices import';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Import Data"; "Import Data")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING(CreditAmount);
                fieldattribute(AccounNo; "Import Data".GLAccountNo)
                {
                }
                fieldattribute(ExternalDoc; "Import Data".Description2)
                {
                }
                fieldattribute(PostingDate; "Import Data".PostingDate)
                {
                }
                fieldattribute(DueDate; "Import Data".PostingDate2)
                {
                }
                fieldattribute(Descr; "Import Data".Description)
                {
                }
                fieldattribute(Amount; "Import Data".Amount)
                {
                }
                fieldattribute(CodeDevise; "Import Data".PieceNo)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Cust2: Record Customer;
                begin
                    //Process Date Here
                end;

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    strDate: Code[10];
                begin

                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000, 1));

                    GenJrnLine.Init;
                    GenJrnLine."Journal Template Name" := ModeleFeuille;
                    GenJrnLine."Journal Batch Name" := NomFeuille;
                    LineNo := LineNo + 10000;
                    GenJrnLine."Line No." := LineNo;
                    JrnTmplName.Get(GenJrnLine."Journal Template Name");
                    JrnTmplName.TestField(JrnTmplName."Source Code");
                    GenJrnLine."Source Code" := JrnTmplName."Source Code";




                    Evaluate(GenJrnLine."Posting Date", "Import Data".PostingDate);
                    GenJrnLine.Validate("Posting Date");

                    GenJrnLine."Document No." := 'MIGCL' + Format(BesoinNo);
                    GenJrnLine."External Document No." := CopyStr("Import Data".DocNum2, 1, 35);

                    //GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice;
                    if "Import Data".Amount > 0 then
                        GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
                    else
                        GenJrnLine."Document Type" := GenJrnLine."Document Type"::Payment;

                    //IF UPPERCASE("Import Data".ExternalDocNo)='BANQUE' THEN BEGIN
                    //  GenJrnLine."Account Type" := GenJrnLine."Account Type"::"Bank Account";

                    //END ELSE BEGIN
                    GenJrnLine."Account Type" := GenJrnLine."Account Type"::Vendor;
                    //END;

                    GenJrnLine.Validate(GenJrnLine."Account No.", "Import Data".GLAccountNo);


                    //GenJrnLine.TESTFIELD("Account No.");

                    //Cust2.GET("Monthly Invoice Data".CustomerNo);
                    //Vend2.CheckBlockedVendOnJnls(Vend2,"Document Type",FALSE);
                    GenJrnLine.Description := CopyStr("Import Data".Description, 1, 50);
                    //GenJrnLine."Posting Group" := Cust2."Customer Posting Group";
                    //GenJrnLine."Salespers./Purch. Code" := Cust2."Salesperson Code";
                    //"Payment Terms Code" := Vend2."Payment Terms Code";
                    //GenJrnLine."Due Date" := "Monthly Invoice Data".DueDate;
                    //GenJrnLine.VALIDATE("Bill-to/Pay-to No.","Monthly Invoice Data".CustomerNo);
                    //GenJrnLine.VALIDATE("Sell-to/Buy-from No.","Monthly Invoice Data".CustomerNo);
                    GenJrnLine."Gen. Posting Type" := 0;
                    GenJrnLine."Gen. Bus. Posting Group" := '';
                    GenJrnLine."Gen. Prod. Posting Group" := '';
                    GenJrnLine."VAT Bus. Posting Group" := '';
                    GenJrnLine."VAT Prod. Posting Group" := '';
                    GenJrnLine.Validate("Currency Code", "Import Data".PieceNo);

                    //GenJrnLine.VALIDATE("Currency Factor" , ROUND(1 / "Import Data".DebitAmount,0.000000000000001));

                    GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
                    GenJrnLine.Validate("Bal. Account No.", '999999');

                    //VALIDATE("Payment Terms Code");
                    GenJrnLine.Amount := "Import Data".Amount;
                    GenJrnLine.Validate(Amount);

                    Evaluate(GenJrnLine."Due Date", "Import Data".PostingDate2);
                    GenJrnLine.Validate(GenJrnLine."Due Date");

                    //GenJrnLine.VALIDATE(GenJrnLine."Due Date",Import Data::PostingDate2);

                    /*
                      //Centre de cout
                      IF "Import Data".CodeAnalytique<>'' THEN
                        GenJrnLine.VALIDATE("Shortcut Dimension 2 Code","Import Data".CodeAnalytique);
                    
                      //Region
                      IF "Import Data".CodeAnalytique4<>'' THEN
                        GenJrnLine.ValidateShortcutDimCode(4,"Import Data".CodeAnalytique4);
                    
                      //projet
                      IF "Import Data".CodeAnalytique3<>'' THEN
                        GenJrnLine.ValidateShortcutDimCode(5,"Import Data".CodeAnalytique3);
                    
                      //Canal de vente
                      IF "Import Data".CodeAnalytique2<>'' THEN
                        GenJrnLine.ValidateShortcutDimCode(3,"Import Data".CodeAnalytique2);
                    
                      //Budget
                      IF "Import Data".CodeAnalytique5<>'' THEN
                        GenJrnLine.VALIDATE("Shortcut Dimension 1 Code","Import Data".CodeAnalytique5);
                        */

                    GenJrnLine.Insert(true);

                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(ModeleFeuille; ModeleFeuille)
                {
                    Caption = 'Journal Template';
                    TableRelation = "Gen. Journal Template";
                    ApplicationArea = All;
                }
                field(NomFeuille; NomFeuille)
                {
                    Caption = 'Gen. Journal';
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

    trigger OnPostXmlPort()
    begin


        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin

        //AddOnSetup.GET;
        //AddOnSetup.TESTFIELD("Sales Templ Journal Code");

        if ModeleFeuille = '' then Error('Invalid Model');
        if NomFeuille = '' then Error('Invalid feuille');

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", NomFeuille);
        //GenJrnLine.DELETEALL;
        if GenJrnLine.FindFirst then Error(Text001, GenJrnBatch);
        LineNo := 0;


        BesoinNo := 0;
        //IF "Monthly Invoice Data".FIND('-') THEN
        //NbreTotalLignes :=34226;
        if NbreTotalLignes = 0 then Error('Entrez le nombre de lignes');
        Window.Open(Text008);
    end;

    var
        GenJrnTemplate: Code[20];
        GenJrnBatch: Code[20];
        PostingDate: Date;
        GenJrnTable: Record "Gen. Journal Batch";
        GenJrnLine: Record "Gen. Journal Line";
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        LineNo: Integer;
        Cust2: Record Customer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Traitement...        @2@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        AddOnSetup: Record "AddOn Setup";
        JrnTmplName: Record "Gen. Journal Template";
        Text002: Label 'This account %1 does not exists !';
        GLAcc2: Record "G/L Account";
        GrpeComptabanque: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        Vend2: Record Vendor;
        ModeleFeuille: Code[20];
        NomFeuille: Code[20];

    procedure GetCorrectAcc(AccToCheck: Code[20]): Code[20]
    var
        GLAcc1: Record "G/L Account";
    begin
        /*
        IF Corresp.GET(AccToCheck) THEN BEGIN
            EXIT(Corresp.NewAccNumber);
        END ELSE BEGIN
           //IF GLAcc1.GET(COPYSTR(AccToCheck,1,7)) THEN
           //  EXIT(COPYSTR(AccToCheck,1,7))
           //ELSE
            ERROR(Text002,AccToCheck);
        END;
        */
        /*
        IF GLAcc1.GET(COPYSTR(AccToCheck,1,7)) THEN BEGIN
          EXIT(COPYSTR(AccToCheck,1,7));
        END ELSE BEGIN
          IF Corresp.GET(AccToCheck) THEN
            EXIT(Corresp.NewAccNumber)
          ELSE
            ERROR(Text002,AccToCheck);
        END;
        */

    end;

    procedure GetCorrectVendorAcc(AccToCheck: Code[20]): Code[20]
    var
        GLAcc1: Record "G/L Account";
        Vend1: Record Vendor;
    begin
        /*
        IF Vend1.GET(AccToCheck) THEN BEGIN
          EXIT(AccToCheck);
        END ELSE BEGIN
          //IF Corresp.GET(AccToCheck) THEN
          //  EXIT(Corresp.NewAccNumber)
          //ELSE
            ERROR(Text002,AccToCheck);
        END;
        */

    end;
}

