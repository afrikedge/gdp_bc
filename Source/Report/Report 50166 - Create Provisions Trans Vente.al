report 50166 "Create Provisions Trans Vente"
{
    Caption = 'Provisions Vente';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("Posting Date") ORDER(Ascending);
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.") ORDER(Ascending);

                trigger OnAfterGetRecord()
                begin

                    if ("Sales Invoice Line".GetParentCategory() = AddOnSetup."Transport Item Category") then
                        ProvisionsItemMgt.TraiterProvisionTransportVente("Sales Invoice Header", ModeleFeuille, NomFeuille, PostingDate,
                          LastDocNo, DateDeb, DateFin, LineNum, "Sales Invoice Line");
                end;

                trigger OnPostDataItem()
                begin

                    LastDocNo := IncStr(LastDocNo);
                end;
            }

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
            begin

                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000, 1));

                "Sales Invoice Header".CalcFields("Sales Invoice Header".Cancelled);
                if "Sales Invoice Header".Cancelled then CurrReport.Skip;


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

                "Sales Invoice Header".SetCurrentKey("Sales Invoice Header"."Posting Date");
                "Sales Invoice Header".SetRange("Sales Invoice Header"."Posting Date", DateDeb, DateFin);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name", NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001, NomFeuille);

                BesoinNo := 0;

                Window.Open(Text008);

                LineNum := 0;
                NbreTotalLignes := "Sales Invoice Header".Count;

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
                    Visible = false;
                }
                field(NomFeuille; NomFeuille)
                {
                    Caption = 'Gen. Journal';
                    Visible = false;

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
        //AddOnSetup.TESTFIELD(AddOnSetup."Prov Transport Vente");
        AddOnSetup.TestField(AddOnSetup."Transport Item Category");
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

