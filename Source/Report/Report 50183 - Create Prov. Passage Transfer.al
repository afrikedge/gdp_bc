report 50183 "Create Prov. Passage Transfer"
{
    Caption = 'Provisions Vente';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Posted Adjustment Header";"Posted Adjustment Header")
        {
            DataItemTableView = SORTING("Document Type","No.") WHERE("Document Type"=CONST(Transfer),"Item Category Code"=CONST('PBL'));
            dataitem("Posted Adjustment Line";"Posted Adjustment Line")
            {
                DataItemLink = "Document Type"=FIELD("Document Type"),"Document No."=FIELD("No.");
                DataItemTableView = SORTING("Document Type","Document No.","Line No.");

                trigger OnAfterGetRecord()
                begin
                    ProvisionsItemMgt.TraiterProvisionFraisPassageTransfert("Posted Adjustment Header",
                      ModeleFeuille,NomFeuille,PostingDate,LastDocNo,DateDeb,DateFin,LineNum,"Posted Adjustment Line");
                end;

                trigger OnPostDataItem()
                begin
                    LastDocNo := IncStr(LastDocNo);
                end;
            }

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
                IsDepotGDP: Boolean;
                Loc: Record Location;
            begin
                
                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));
                
                    if "Posted Adjustment Header".Status="Posted Adjustment Header".Status::Cancelled then
                      CurrReport.Skip;
                
                    if Loc.Get("Posted Adjustment Header"."Location Code") then
                      if Loc."GDP Location" then CurrReport.Skip;
                
                    if Loc.Get("Posted Adjustment Header"."Transfer-to Code") then
                      if Loc."GDP Location" then CurrReport.Skip;
                
                    /*IF IsTransfertMassif THEN
                      IF "Posted Adjustment Header"."Location Code"<>AddOnSetup."GRT Location Code" THEN
                        CurrReport.SKIP;
                
                    IF NOT IsTransfertMassif THEN
                      IF "Posted Adjustment Header"."Location Code"=AddOnSetup."GRT Location Code" THEN
                        CurrReport.SKIP;*/
                
                    Clear(NoSeriesMgt);
                
                    if LastDocNo='' then
                        LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",false);

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
                //AddOnSetup.TESTFIELD(AddOnSetup."Invoice To Receive Account");

                GenJrnTableND.Get(ModeleFeuille,NomFeuille);

                if DateDeb=0D then Error(Text008);
                if DateFin=0D then Error(Text008);
                "Posted Adjustment Header".SetRange("Posting Date",DateDeb,DateFin);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name",ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name",NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001,NomFeuille);

                BesoinNo :=0;

                Window.Open(Text008);


                GenJrnTableND.TestField("No. Series");

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
                field(DateDeb;DateDeb)
                {
                    Caption = 'Starting Date';
                }
                field(DateFin;DateFin)
                {
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        PostingDate := DateFin;
                    end;
                }
                field(PostingDate;PostingDate)
                {
                    Caption = 'Posting Date';
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
        DateDeb: Date;
        DateFin: Date;
        Text009: Label 'Veuillez entrer la date début';
        Text010: Label 'Veuillez entrer la date fin';
        ProvisionsItemMgt: Codeunit "Provisions Item Mgt";
        IsTransfertMassif: Boolean;

    procedure SetFeuille(CodeModele1: Code[10];CodeFeuille1: Code[10])
    begin
        ModeleFeuille:=CodeModele1;
        NomFeuille:=CodeFeuille1;
    end;

    procedure SetTransfertMassif(isMassif: Boolean)
    begin
        IsTransfertMassif:=isMassif;
    end;
}

