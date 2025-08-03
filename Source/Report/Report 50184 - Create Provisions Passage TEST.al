report 50184 "Create Provisions Passage TEST"
{
    Caption = 'Provisions Vente';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(pro_enteteBE; pro_enteteBE)
        {
            DataItemTableView = SORTING(numBE) WHERE(isconfirme = CONST(true), isAnnule = CONST(false));
            dataitem(pro_enteteBL; pro_enteteBL)
            {
                DataItemLink = numBE = FIELD(numBE);
                DataItemTableView = SORTING(numBL) WHERE(isconfirme = CONST(true), isAnnule = CONST(false));
                dataitem(pro_detailBL; pro_detailBL)
                {
                    DataItemLink = numBL = FIELD(numBL);
                    DataItemTableView = SORTING(numBL, "Line No.");

                    trigger OnAfterGetRecord()
                    begin

                        ProvisionsItemMgt.TraiterProvisionFraisPassage_TEST(pro_enteteBE, ModeleFeuille, NomFeuille, PostingDate,
                            LastDocNo, DateDeb, DateFin, LineNum, pro_detailBL, pro_enteteBL);
                    end;

                    trigger OnPostDataItem()
                    begin

                        LastDocNo := IncStr(LastDocNo);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
            begin

                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000, 1));




                Clear(NoSeriesMgt);

                if LastDocNo = '' then
                    LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series", GenJrnLine."Posting Date", false);
                //END ELSE BEGIN
                //    LastDocNo := INCSTR(LastDocNo);
                //END;


                //CreateEntry := GLMgt.TraiterProvisionCdeAchat("Purchase Header",ModeleFeuille,NomFeuille,PostingDate,LastDocNo,LineNum);

                //IF CreateEntry THEN
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

                GenJrnTableND.Get(ModeleFeuille, NomFeuille);

                if DateDeb = 0D then Error(Text008);
                if DateFin = 0D then Error(Text008);
                pro_enteteBE.SetRange(pro_enteteBE.dateBE, DateDeb, DateFin);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name", NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001, NomFeuille);

                BesoinNo := 0;

                Window.Open(Text008);

                LineNum := 0;
                NbreTotalLignes := pro_enteteBE.Count;

                GenJrnTableND.TestField("No. Series");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateDeb; DateDeb)
                {
                    Caption = 'Starting Date';
                }
                field(DateFin; DateFin)
                {
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        PostingDate := DateFin;
                    end;
                }
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                }
                field(ModeleFeuille; ModeleFeuille)
                {
                    Caption = 'Journal Template';
                    Visible = true;
                }
                field(NomFeuille; NomFeuille)
                {
                    Caption = 'Gen. Journal';
                    Visible = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GenJournalBatch: Record "Gen. Journal Batch";
                        GenJournalBatchPage: Page "General Journal Batches";
                    begin
                        GenJournalBatch.Reset;
                        GenJournalBatch.SetRange(GenJournalBatch."Journal Template Name", ModeleFeuille);
                        if PAGE.RunModal(251, GenJournalBatch) = ACTION::LookupOK then begin
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
        PostingDate := WorkDate;
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

    procedure SetFeuille(CodeModele1: Code[10]; CodeFeuille1: Code[10])
    begin
        ModeleFeuille := CodeModele1;
        NomFeuille := CodeFeuille1;
    end;
}

