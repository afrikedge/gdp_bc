report 50173 "Create Entries Cargo Item"
{
    Caption = 'Compta. écarts Cargo';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Cargo Entry"; "Item Cargo Entry")
        {
            DataItemTableView = SORTING("Posting Date") ORDER(Ascending);

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
                CreateEntry := CargoMgt.TraiterComptaStockCargo("Item Cargo Entry", ModeleFeuille, NomFeuille, PostingDate, LastDocNo, DateDeb, DateFin, LineNum);

                //IF CreateEntry THEN
                /*
                IF ("Sales Invoice Line"."Item Category Code"=AddOnSetup."Transport Item Category") THEN
               ProvisionsItemMgt.TraiterProvisionTransportVente("Sales Invoice Header",ModeleFeuille,NomFeuille,PostingDate,
                 LastDocNo,DateDeb,DateFin,LineNum,"Sales Invoice Line");
                 */
                if CreateEntry then
                    LastDocNo := IncStr(LastDocNo);

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

                //"Item Cargo Entry".SETCURRENTKEY("Sales Invoice Header"."Posting Date");
                "Item Cargo Entry".SetRange("Posting Date", DateDeb, DateFin);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name", NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001, NomFeuille);

                BesoinNo := 0;

                Window.Open(Text008);

                LineNum := 0;
                NbreTotalLignes := "Item Cargo Entry".Count;

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
        CargoMgt: Codeunit "Item Value Cargo Mgt";

    procedure SetFeuille(CodeModele1: Code[10]; CodeFeuille1: Code[10])
    begin
        ModeleFeuille := CodeModele1;
        NomFeuille := CodeFeuille1;
    end;
}

