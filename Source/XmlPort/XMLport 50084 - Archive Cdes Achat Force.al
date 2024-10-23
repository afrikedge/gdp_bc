xmlport 50084 "Archive Cdes Achat Force"
{
    Caption = 'Solder commandes d''achat';
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
                fieldattribute(CodeCommande;"Import Data".DocumentNo)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    PurchH: Record "Purchase Header";
                    PurchHArchive: Record "Purchase Header BckGDP";
                begin

                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));

                    if PurchH.Get(PurchH."Document Type"::Order,"Import Data".DocumentNo) then begin
                      PurchHArchive.Init;
                      PurchHArchive.TransferFields(PurchH);
                      PurchHArchive.Insert;

                      PurchH."Processing Status":=PurchH."Processing Status"::Soldee;
                      PurchH."GDP Deletion":=true;
                      PurchH.Modify;
                      ArchiveMgt.ArchPurchDocumentNoConfirm(PurchH);
                      PurchH.Delete;
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
        //MESSAGE('%1',ListeAbsents);
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin


        LineNo := 0;

        NbreTotalLignes:=300;
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
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text002: Label 'This account %1 does not exists !';
        Text003: Label 'The journal template model is required';
        Text004: Label 'The journal code is required';
        ArchiveMgt: Codeunit ArchiveManagement;
}

