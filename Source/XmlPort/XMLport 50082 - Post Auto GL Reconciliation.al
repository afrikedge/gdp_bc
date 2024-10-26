xmlport 50082 "Post Auto GL Reconciliation"
{
    Caption = 'Post automatic g/l reconciliation';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    Permissions = TableData "G/L Entry"=rm;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement("G/L Entry";"G/L Entry")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING("Entry No.");
                fieldattribute(EntryID;"G/L Entry"."Entry No.")
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    BudgetEntry: Record "G/L Budget Entry";
                    DimValue: Record "Dimension Value";
                    GLEntry: Record "G/L Entry";
                begin

                    BesoinNo := BesoinNo + 1;
                    if NbreTotalLignes>0 then
                       Window.Update(1,Round(BesoinNo / NbreTotalLignes * 10000,1));

                    GLEntry.Get("G/L Entry"."Entry No.");
                    GLEntry.TestField(GLEntry."G/L Account No.",GLAccountNo);

                    TotalAmount := TotalAmount + GLEntry.Amount;

                    if LetterToSet <> '' then begin
                      GLEntry.Letter := LetterToSet;
                      GLEntry."Applies-to ID" := '';
                      GLEntry."Letter Date" := LetterDate;
                      GLEntry.Modify;
                    end;
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
                field(GLAccNum;GLAccountNo)
                {
                    Caption = 'GL Account No';
                    TableRelation = "G/L Account";
                }
                field(LastPostingDate;LetterDate)
                {
                    Caption = 'Last Entry Posting Date';
                }
                field(NombreLines;NbreTotalLignes)
                {
                    Caption = 'Number of lines to import';
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
        //AddOnSetup.TESTFIELD(AddOnSetup."Code Budget Def");
        NbreTotalLignes:=100;
    end;

    trigger OnPostXmlPort()
    begin

        if TotalAmount <> 0 then
          Error(Text005);

        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin


        LineNo := 0;

        BesoinNo :=0;
        Window.Open(Text008);

        //IF GenJrnTemplate='' THEN ERROR(Text003);
        if GLAccountNo='' then Error(Text004);

        GetLetter;
    end;

    var
        GenJrnTemplate: Code[20];
        GenJrnBatch: Code[20];
        PostingDate: Date;
        GenJrnTable: Record "Item Journal Batch";
        GenJrnLine: Record "Item Journal Line";
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
        TransH: Record "Adjustment Header";
        TransLine: Record "Adjustment Line";
        ItemJournalLine: Record "Item Journal Line";
        DateCompta: Date;
        DocNum: Code[20];
        GLAccountNo: Code[20];
        TotalAmount: Decimal;
        Text005: Label 'La somme des montants doit être nulle';
        LetterToSet: Text[3];
        LetterDate: Date;

    procedure GetLetter()
    var
        GLEntry2: Record "G/L Entry";
    begin
        if LetterToSet <> '' then
          exit;
        GLEntry2.SetFilter("G/L Account No.",GLAccountNo);
        GLEntry2.SetCurrentKey("G/L Account No.",Letter);
        if GLEntry2.FindLast then
          LetterToSet := GLEntry2.Letter;
        if GLEntry2.FindLast then
          if LetterToSet < UpperCase(GLEntry2.Letter) then
            LetterToSet := UpperCase(GLEntry2.Letter);
        NextLetter(LetterToSet);
    end;

    procedure NextLetter(var Letter: Text[3])
    var
        i: Integer;
    begin
        if Letter = 'ZZZ' then
          exit;
        if Letter = '' then begin
          Letter := 'AAA';
          exit;
        end;
        if Letter[3] <> 'Z' then begin
          i := Letter[3];
          i := i + 1;
          Letter[3] := i;
        end else
          if Letter[2] <> 'Z' then begin
            i := Letter[2];
            i := i + 1;
            Letter[2] := i;
            Letter[3] := 'A';
          end else begin
            i := Letter[1];
            i := i + 1;
            Letter[1] := i;
            Letter[2] := 'A';
            Letter[3] := 'A';
          end;
    end;

    procedure SetAccount(AccNo: Code[20])
    begin
        GLAccountNo := AccNo;
    end;
}

