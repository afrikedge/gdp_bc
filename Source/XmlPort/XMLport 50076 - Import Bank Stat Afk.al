xmlport 50076 "Import Bank Stat Afk"
{
    Caption = 'Import des écritures relévé bancaire';
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
            tableelement("Import Fuel Statement";"Import Fuel Statement")
            {
                AutoSave = false;
                XmlName = 'ImportData';
                SourceTableView = SORTING(EntryNo) ORDER(Ascending);
                fieldattribute(DateTrans;"Import Fuel Statement"."Date of control")
                {
                }
                fieldattribute(DateValeur;"Import Fuel Statement".DateRefuel)
                {
                }
                fieldattribute(Libelle;"Import Fuel Statement"."Vehicule Description")
                {
                }
                fieldattribute(Debit;"Import Fuel Statement".Valeur1)
                {
                }
                fieldattribute(Credit;"Import Fuel Statement".Valeur2)
                {
                }

                trigger OnAfterInsertRecord()
                var
                    StrSource: Text[50];
                    RecToPost: Record "Periodic Base Value";
                    Valeur: Decimal;
                    Qte: Decimal;
                    EmployeeNo: Code[20];
                    DatePrestee: Date;
                    Qte1: Decimal;
                    Emp: Record Employee;
                    DateTrans: Date;
                    DateValeur: Date;
                    Descript: Text[50];
                    DebitAmt: Decimal;
                    CreditAmt: Decimal;
                begin

                    LineNo := LineNo + 1;

                    Evaluate(Descript , "Import Fuel Statement"."Vehicule Description");

                    Evaluate(DateTrans , "Import Fuel Statement"."Date of control");
                    Evaluate(DateValeur , "Import Fuel Statement".DateRefuel);

                    if "Import Fuel Statement".Valeur1<>'' then
                      Evaluate(DebitAmt , "Import Fuel Statement".Valeur1);

                    if "Import Fuel Statement".Valeur2<>'' then
                      Evaluate(CreditAmt , "Import Fuel Statement".Valeur2);


                    InsertStatLine(LineNo,DateTrans,DateValeur,(-DebitAmt+CreditAmt),Descript);
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
                field(PayPeriod;PayPeriod)
                {
                    Caption = 'Payroll Period';
                    TableRelation = "Payroll Period" WHERE (Status=CONST(Opened));
                    Visible = false;
                }
                field(TypeHS;TypeHS)
                {
                    Caption = 'Type HS';
                    Visible = false;
                }
                field(DateDeb;DateDeb)
                {
                    Caption = 'From';
                    Editable = false;
                    Visible = false;
                }
                field(DateFin;DateFin)
                {
                    Caption = 'To';
                    Editable = false;
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
        /*
        PayrollPer.RESET;
        //PayrollPer.SETRANGE(PayrollPer.Closed,FALSE);
        PayrollPer.SETFILTER(PayrollPer."Starting Date",'>=%1',DMY2DATE(1,DATE2DMY(TODAY,2),DATE2DMY(TODAY,3)));
        IF PayrollPer.FINDFIRST THEN BEGIN
          PayPeriod := PayrollPer.Code;
          DateDeb := PayrollPer."Starting Date";
          DateFin := PayrollPer."Ending Date";
        END;
        */

    end;

    trigger OnPostXmlPort()
    begin

        //Window.CLOSE;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    var
        Cte: Record Constant;
    begin

        LineNo := 0;
        BesoinNo :=0;
        //Window.OPEN(Text008);

        BankAccRecLine.Reset;
        BankAccRecLine.SetRange(BankAccRecLine."Statement No.",StatementCode);
        BankAccRecLine.SetRange(BankAccRecLine."Bank Account No.",BankAccNo);
        if BankAccRecLine.FindFirst then
          Error(Text007);

        //IF NOT CONFIRM(STRSUBSTNO(Text001,TypeHS)) THEN ERROR('');
    end;

    var
        LineNo: Integer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        FSLine: Record "Fuel Statement Line";
        FSNumber: Code[20];
        CodeConstante: Code[20];
        NomConstante: Text[50];
        Cte: Record Constant;
        Text001: Label 'Voulez-vous importer les heures supplémentaire du type %1';
        DateDeb: Date;
        DateFin: Date;
        PayPeriod: Code[20];
        PayrollPer: Record "Payroll Period";
        Text002: Label 'Le code agent ne doit pas être vide !';
        Text003: Label 'La date ne doit pas être vide !';
        Text004: Label 'Le code agence ne doit pas être vide !';
        Text005: Label 'La valeur doit être un montant';
        Text006: Label 'La valeur est invalide pour %1';
        TypeHS: Option "Heures suppl 130%","Heures suppl 150%","Heures Majorées 40%","Heures Majorées 30%","Nombre Heures Majorés 50%",HS06,HS07,HS08,HS09,HS10;
        XtraHour: Record "Extra Hour";
        CodeVal: Code[20];
        StatementCode: Code[20];
        BankAccNo: Code[20];
        BankAccRecLine: Record "Bank Acc. Reconciliation Line";
        Text007: Label 'La liste dans rélévé bancaire doit etre vide pour initier cette opération';

    procedure SetFSNumber(FSNum: Code[20])
    begin
        FSNumber:=FSNum;
    end;

    procedure SetInfos(CodeCte: Code[20];AccNum: Code[20])
    begin
        StatementCode := CodeCte;
        BankAccNo := AccNum;
    end;

    local procedure InsertStatLine(LineNum: Integer;TransDate: Date;ValDate: Date;Amt: Decimal;descr: Text[50])
    begin
        BankAccRecLine.Init;
        BankAccRecLine."Bank Account No." := BankAccNo;
        BankAccRecLine."Statement No." := StatementCode;
        BankAccRecLine."Statement Line No." := LineNum;
        BankAccRecLine.Validate("Transaction Date", TransDate);
        BankAccRecLine.Validate("Value Date", ValDate);
        BankAccRecLine.Description := descr;
        BankAccRecLine.Validate("Statement Amount", Amt);
        BankAccRecLine.Insert;
    end;
}

