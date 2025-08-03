xmlport 50006 "Import Inventaire Stock"
{
    Caption = 'Import Inventaire Stock';
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
                fieldattribute(CodeMagasin; "Import Data".LocationCode)
                {
                }
                fieldattribute(CodeArticle; "Import Data".GLAccountNo)
                {
                }
                fieldattribute(Volume; "Import Data".DebitAmount)
                {
                }
                fieldattribute(Cout; "Import Data".CreditAmount)
                {
                }
                fieldattribute(Cargo; "Import Data".ExternalDocNo)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    BudgetEntry: Record "G/L Budget Entry";
                    DimValue: Record "Dimension Value";
                begin

                    BesoinNo := BesoinNo + 1;

                    Clear(ItemJournalLine);
                    ItemJournalLine."Journal Template Name" := GenJrnTemplate;
                    ItemJournalLine."Journal Batch Name" := GenJrnBatch;
                    ItemJournalLine."Line No." := BesoinNo;

                    ItemJournalLine.Validate(ItemJournalLine."Posting Date", DateCompta);
                    ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                    ItemJournalLine.Validate(ItemJournalLine."Item No.", "Import Data".GLAccountNo);
                    ItemJournalLine.Validate(ItemJournalLine."Location Code", "Import Data".LocationCode);
                    ItemJournalLine.Validate(ItemJournalLine.Quantity, "Import Data".DebitAmount);
                    if "Import Data".CreditAmount > 0 then
                        ItemJournalLine.Validate(ItemJournalLine."Unit Amount", "Import Data".CreditAmount);
                    ItemJournalLine.Validate(ItemJournalLine."Document No.", DocNum);
                    ItemJournalLine.Validate(ItemJournalLine."Ref Cargo", "Import Data".ExternalDocNo);

                    ItemJournalLine.Insert(true);
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
                field(GenJrnTemplate; GenJrnTemplate)
                {
                    Caption = 'General journal template';
                    TableRelation = "Item Journal Template";
                    ApplicationArea = All;
                }
                field(GenJrnBatch; GenJrnBatch)
                {
                    Caption = 'Posting journal Batch';
                    TableRelation = "Item Journal Batch";
                    ApplicationArea = All;
                }
                field(DateCompta; DateCompta)
                {
                    ApplicationArea = All;
                }
                field("N° Document"; DocNum)
                {
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
        //AddOnSetup.TESTFIELD(AddOnSetup."Code Budget Def");
    end;

    trigger OnPostXmlPort()
    begin

        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin


        LineNo := 0;

        BesoinNo := 0;
        Window.Open(Text008);

        if GenJrnTemplate = '' then Error(Text003);
        if GenJrnBatch = '' then Error(Text004);
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
}

