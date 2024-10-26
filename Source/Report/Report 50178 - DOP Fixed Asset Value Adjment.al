report 50178 "DOP Fixed Asset Value Adjment"
{
    Caption = 'Compta. écarts coûts immo';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted Adjustment Header";"Posted Adjustment Header")
        {
            DataItemTableView = SORTING("Document Type","No.") ORDER(Ascending) WHERE("Document Type"=CONST("FA Conso"));
            dataitem("Posted Adjustment Line";"Posted Adjustment Line")
            {
                DataItemLink = "Document Type"=FIELD("Document Type"),"Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type","Document No.","Line No.") ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin

                    GenJrnTableND.TestField("No. Series");
                        Clear(NoSeriesMgt);

                    if LastDocNo='' then
                      LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",false);

                    CreateEntry:=false;

                    CreateEntry:=FAConsoMgt.CreateLigneAdjustCoutDOP("Posted Adjustment Header",
                      "Posted Adjustment Line",ModeleFeuille,NomFeuille,LastDocNo,LineNum);

                    if CreateEntry then LastDocNo := IncStr(LastDocNo);
                end;
            }

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
                Cust: Record Customer;
            begin
                
                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));
                
                    /*GenJrnTableND.TESTFIELD("No. Series");
                    CLEAR(NoSeriesMgt);
                
                    IF LastDocNo='' THEN
                        LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",FALSE);
                    //END ELSE BEGIN
                    //    LastDocNo := INCSTR(LastDocNo);
                    //END;
                    CreateEntry:=FALSE;
                
                   IF Cust.GET("Sales Header"."Sell-to Customer No.") THEN
                     IF ((Cust."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel")
                       OR (Cust."Sales Channel Code" = AddOnSetup."JOVENNA Sales Channel")) THEN
                     CreateEntry := GLMgt.TraiterProvisionCdeVenteVarStockJIRAMA("Sales Header",ModeleFeuille,NomFeuille,PostingDate,LastDocNo,LineNum);
                
                   IF CreateEntry THEN LastDocNo := INCSTR(LastDocNo);*/

            end;

            trigger OnPostDataItem()
            var
                LastDocNo: Code[20];
                CommandeVente: Record "Sales Header";
                GenerateNewDocNo: Boolean;
                LineNum: Integer;
            begin
                Window.Close;
                Message(TxtTraitementTerminé);
            end;

            trigger OnPreDataItem()
            begin
                AddOnSetup.Get;

                GenJrnTableND.Get(ModeleFeuille,NomFeuille);

                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name",ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name",NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001,NomFeuille);

                BesoinNo :=0;

                "Posted Adjustment Header".SetRange("Posting Date",DateDeb,DateFin);

                Window.Open(Text008);

                LineNum:=0;
                 NbreTotalLignes := "Posted Adjustment Header".Count;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PostingDate;PostingDate)
                {
                    Caption = 'Posting Date';
                    Visible = false;
                }
                field(ModeleFeuille;ModeleFeuille)
                {
                    Caption = 'Journal Template';
                    Visible = false;
                }
                field(NomFeuille;NomFeuille)
                {
                    Caption = 'Gen. Journal';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        GenJournalBatchPage: Page "General Journal Batches";
                    begin
                        GenJournalBatch.Reset;
                        GenJournalBatch.SetRange(GenJournalBatch."Journal Template Name",ModeleFeuille);
                        if PAGE.RunModal(251, GenJournalBatch) = ACTION::LookupOK then
                        begin
                          NomFeuille := GenJournalBatch.Name;
                          //NewFASubLocationName := FASubLoc.Name;
                        end;
                    end;
                }
                field(DateDeb;DateDeb)
                {
                    Caption = 'Date début';
                }
                field(DateFin;DateFin)
                {
                    Caption = 'Date fin';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField("Provision Tmpl Journal");
        ModeleFeuille := AddOnSetup."Provision Tmpl Journal";
        PostingDate:=WorkDate;
    end;

    var
        PostingDate: Date;
        ModeleFeuille: Code[10];
        NomFeuille: Code[10];
        AddOnSetup: Record "AddOn Setup";
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        GenJrnTemplate: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJrnTableND: Record "Gen. Journal Batch";
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        LineNum: Integer;
        LastDocNo: Code[20];
        GLMgt: Codeunit "Provisions Cde Mgt";
        FAConsoMgt: Codeunit "Item Conso to FA Mgt";
        DateDeb: Date;
        DateFin: Date;
        CreateEntry: Boolean;

    procedure SetFeuille(CodeModele1: Code[10];CodeFeuille1: Code[10])
    begin
        ModeleFeuille:=CodeModele1;
        NomFeuille:=CodeFeuille1;
    end;
}

