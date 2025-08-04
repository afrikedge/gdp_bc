xmlport 50004 "Import LPSA Receptions"
{
    Caption = 'Import LPSA Transfers (Receipts)';
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
                fieldattribute(OTNumber; "Import Data".ExternalDocNo)
                {
                }
                fieldattribute(ReceiptDate; "Import Data".PostingDate)
                {
                }
                fieldattribute(ItemNum; "Import Data".DocNum2)
                {
                }
                fieldattribute(Volume; "Import Data".DebitAmount)
                {
                }
                fieldattribute(DepotDest; "Import Data".LocationCode2)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                begin

                    BesoinNo := BesoinNo + 1;

                    Clear(TransH);
                    TransH.Reset;
                    TransH.SetRange("External Document No.", "Import Data".ExternalDocNo);
                    if not TransH.FindFirst then Error(Text005, "Import Data".ExternalDocNo);
                    TransH.TestField(TransH.Status, TransH.Status::Released);

                    Evaluate(TransH."Receipt Date", "Import Data".PostingDate);
                    //MESSAGE("Import Data".LocationCode2);
                    if TransH."Transfer-to Code" <> "Import Data".LocationCode2 then
                        Error(Text006, "Import Data".ExternalDocNo, TransH."Transfer-to Code");
                    TransH.Modify;





                    TransLine.Reset;
                    TransLine.SetRange("Document Type", TransLine."Document Type"::Transfer);
                    TransLine.SetRange("Document No.", TransH."No.");
                    if TransLine.FindFirst then begin

                        TransferReason.Reset;
                        TransferReason.SetRange(TransferReason."Document Type", TransferReason."Document Type"::Transfer);
                        TransferReason.SetRange(TransferReason."Document No.", TransH."No.");
                        TransferReason.SetRange(TransferReason."Line No.", TransLine."Line No.");
                        TransferReason.DeleteAll;

                        TransLine.TestField(TransLine."Item No.", "Import Data".DocNum2);

                        TransferReason.Init;
                        TransferReason."Document Type" := TransferReason."Document Type"::Transfer;
                        TransferReason."Document No." := TransH."No.";
                        if "Import Data".DebitAmount > TransLine.Quantity then
                            TransferReason."Adjustment Type" := TransferReason."Adjustment Type"::Gain
                        else
                            TransferReason."Adjustment Type" := TransferReason."Adjustment Type"::Perte;
                        TransferReason.Validate("Reason Code", AddOnSetup."LPSA Adjustment Reason Code");
                        TransferReason.Validate(Quantity, Abs("Import Data".DebitAmount - TransLine.Quantity));
                        TransferReason.Insert;

                        TransLine.AFK_RefreshAdjustQty;
                        TransLine.Modify;
                    end;
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
        AddOnSetup.TestField(AddOnSetup."LPSA Adjustment Reason Code");
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
        Text005: Label 'Le transfert %1 n''existe pas dans la liste';
        Text006: Label 'Le magasin de destination du transfert %1 doit être %2';
        TransferReason: Record "Transfer Reason Code";
}

