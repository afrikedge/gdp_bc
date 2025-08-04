xmlport 50003 "Import LPSA Transfers"
{
    Caption = 'Import LPSA Transfers';
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
                fieldattribute(BEXNumber; "Import Data".DocumentNo)
                {
                }
                fieldattribute(OTNumber; "Import Data".ExternalDocNo)
                {
                }
                fieldattribute(Immatriculation; "Import Data".DocNum1)
                {
                }
                fieldattribute(ShipmentDate; "Import Data".PostingDate)
                {
                }
                fieldattribute(ItemNum; "Import Data".DocNum2)
                {
                }
                fieldattribute(Volume; "Import Data".DebitAmount)
                {
                }
                fieldattribute(DepotOrigin; "Import Data".LocationCode)
                {
                }
                fieldattribute(DepotDest; "Import Data".LocationCode2)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    Text005: Label 'Le transfert %1 existe déjà avec ce numéro document externe %2';
                begin

                    TransH.Reset;
                    TransH.SetRange("External Document No.", "Import Data".ExternalDocNo);
                    if TransH.FindFirst then
                        Error(Text005, TransH."No.", "Import Data".ExternalDocNo);


                    BesoinNo := BesoinNo + 1;

                    Clear(TransH);
                    TransH."Document Type" := TransH."Document Type"::Transfer;
                    TransH."No." := '';

                    TransLine.LockTable;
                    TransH.Insert(true);

                    TransH."Item Category Code" := AddOnSetup."PBL Category Code";
                    TransH."External Document No." := "Import Data".ExternalDocNo;
                    TransH."BEX Number" := "Import Data".DocumentNo;
                    TransH.nomchauffeur := "Import Data".DocNum1;
                    Evaluate(TransH."Posting Date", "Import Data".PostingDate);
                    TransH.Validate("Location Code", "Import Data".LocationCode);
                    TransH.Validate("Transfer-to Code", "Import Data".LocationCode2);
                    TransH.Validate("In-Transit Code", AddOnSetup."LPSA Transit Transfer Location");
                    TransH.Modify;

                    TransLine.Init;
                    TransLine."Document Type" := TransLine."Document Type"::Transfer;
                    TransLine."Document No." := TransH."No.";
                    TransLine.Validate(TransLine."Item No.", "Import Data".DocNum2);
                    TransLine.Validate(Quantity, "Import Data".DebitAmount);
                    TransLine.Validate(TransLine."Qty to return", "Import Data".DebitAmount);
                    TransLine.Insert;
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
        AddOnSetup.TestField(AddOnSetup."LPSA Transit Transfer Location");
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
}

