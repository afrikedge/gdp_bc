xmlport 50050 "Import Camion Fsseurs"
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
            tableelement("Import Data";"Import Data")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING(EntryNo) ORDER(Ascending);
                fieldattribute(CodeMagasin;"Import Data".ExternalDocNo)
                {
                }
                fieldattribute(CodeArticle;"Import Data".GLAccountNo)
                {
                }
                fieldattribute(NomCourt;"Import Data".Description)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    BudgetEntry: Record "G/L Budget Entry";
                    DimValue: Record "Dimension Value";
                    Camion: Record pro_moyentransport;
                begin

                    BesoinNo := BesoinNo + 1;

                    Clear(Camion);

                    if Camion.Get("Import Data".ExternalDocNo) then begin
                      Camion.codetransporteur :='';
                      if "Import Data".GLAccountNo<>'' then begin
                        Camion.codetransporteur := "Import Data".GLAccountNo;
                        if Vend2.Get("Import Data".GLAccountNo) then begin
                          Vend2."Name 2" := "Import Data".Description;
                          Vend2.Modify;
                        end else begin
                          ListeAbsents := ListeAbsents+';'+"Import Data".GLAccountNo;
                        end;
                      end;
                      Camion.Modify;
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
        Message('%1',ListeAbsents);
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
        ListeAbsents: Text[1024];
}

