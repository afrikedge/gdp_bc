xmlport 50058 "Import Items Prices"
{
    Caption = 'Import Items Prices';
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
                fieldattribute(SalesType;"Import Data".ExternalDocNo)
                {
                }
                fieldattribute(CodeVente;"Import Data".DocumentNo)
                {
                }
                fieldattribute(ItemCode;"Import Data".DocNum2)
                {
                }
                fieldattribute(UnitPrice;"Import Data".DebitAmount)
                {
                }
                fieldattribute(StartingDate;"Import Data".PostingDate)
                {
                }
                fieldattribute(EndingdDate;"Import Data".PostingDate2)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    PrixUnitaire: Decimal;
                    StartingDate: Date;
                    EndingDate: Date;
                begin

                    BesoinNo := BesoinNo + 1;

                    SalesPrice.Init;

                    if ((UpperCase("Import Data".ExternalDocNo)<>'CLIENT') and
                      (UpperCase("Import Data".ExternalDocNo)<>'GROUPE') and
                      (UpperCase("Import Data".ExternalDocNo)<>'TOUS')) then
                      Error(Error01,BesoinNo);

                    if UpperCase("Import Data".ExternalDocNo)='CLIENT' then begin
                      SalesPrice.Validate("Sales Type",SalesPrice."Sales Type"::Customer);
                      SalesPrice.Validate(SalesPrice."Sales Code","Import Data".DocumentNo);
                    end;

                    if UpperCase("Import Data".ExternalDocNo)='GROUPE' then begin
                      SalesPrice.Validate("Sales Type",SalesPrice."Sales Type"::"Customer Price Group");
                      SalesPrice.Validate(SalesPrice."Sales Code","Import Data".DocumentNo);
                    end;

                    if UpperCase("Import Data".ExternalDocNo)='TOUS' then begin
                      SalesPrice.Validate("Sales Type",SalesPrice."Sales Type"::"All Customers");
                    end;

                    SalesPrice.Validate("Item No.","Import Data".DocNum2);

                    //IF NOT EVALUATE(PrixUnitaire,"Import Data".DebitAmount) THEN ERROR(Error04,BesoinNo);
                    SalesPrice.Validate("Unit Price","Import Data".DebitAmount);

                    if not Evaluate(StartingDate,"Import Data".PostingDate) then Error(Error05,BesoinNo);
                    SalesPrice.Validate("Starting Date",StartingDate);

                    if not Evaluate(EndingDate,"Import Data".PostingDate2) then Error(Error06,BesoinNo);
                    SalesPrice.Validate("Ending Date",EndingDate);

                    if not SalesPrice.Insert then
                      SalesPrice.Modify;
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

        //GLSetup.GET;
        //AddOnSetup.GET;
        //AddOnSetup.TESTFIELD(AddOnSetup."LPSA Adjustment Reason Code");
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
        Text005: Label 'Le transfert %1 n''existe pas dans la liste';
        Text006: Label 'Le magasin de destination du transfert %1 doit être %2';
        TransferReason: Record "Transfer Reason Code";
        SalesPrice: Record "Sales Price";
        Error01: Label 'Le type vente est invalide sur la ligne %1. Ce type doit avoir une des valeurs : CLIENT, GROUPE ou TOUS';
        Error02: Label 'Le code vente est invalide sur la ligne %1. ';
        Error03: Label 'Le N° article est invalide sur la ligne %1.';
        Error04: Label 'Le prix unitaire est invalide sur la ligne %1.';
        Error05: Label 'La date début est invalide sur la ligne %1.';
        Error06: Label 'La date fin est invalide sur la ligne %1.';
}

