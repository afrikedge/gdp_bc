xmlport 50005 "Import Budget Entries"
{
    Caption = 'Import Budget Entries';
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
                fieldattribute(BudgetCode;"Import Data".CodeAnalytique)
                {
                }
                fieldattribute(GLAccount;"Import Data".GLAccountNo)
                {
                }
                fieldattribute(Date;"Import Data".PostingDate)
                {
                }
                fieldattribute(Amount;"Import Data".Amount)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    BudgetEntry: Record "G/L Budget Entry";
                    DimValue: Record "Dimension Value";
                begin

                    BesoinNo := BesoinNo + 1;

                    Clear(BudgetEntry);
                    BudgetEntry."Budget Name" := AddOnSetup."Code Budget Def";
                     if DimValue.Get(GLSetup."Global Dimension 1 Code","Import Data".CodeAnalytique) then
                       BudgetEntry.Description := DimValue.Name;

                    BudgetEntry."G/L Account No." := "Import Data".GLAccountNo;
                    Evaluate(BudgetEntry.Date,"Import Data".PostingDate);
                    BudgetEntry.Amount := "Import Data".Amount;
                    BudgetEntry.Validate("Global Dimension 1 Code","Import Data".CodeAnalytique);
                    BudgetEntry.Insert(true);
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
        AddOnSetup.TestField(AddOnSetup."Code Budget Def");
    end;

    trigger OnPostXmlPort()
    begin

        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin


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
        TransH: Record "Adjustment Header";
        TransLine: Record "Adjustment Line";
        AddOnSetup2: Record "AddOn Setup2";
}

