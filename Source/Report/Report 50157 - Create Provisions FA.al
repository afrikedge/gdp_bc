report 50157 "Create Provisions FA"
{
    Caption = 'Provisions Fixed Assets';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            dataitem("Purchase Order Tracking"; "Purchase Order Tracking")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Data Type" = CONST(FraisAnnexe));

                trigger OnAfterGetRecord()
                var
                    CreateEntry: Boolean;
                begin
                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000, 1));

                    GenJrnTableND.TestField("No. Series");
                    Clear(NoSeriesMgt);

                    if LastDocNo = '' then
                        LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series", GenJrnLine."Posting Date", false);
                    //END ELSE BEGIN
                    //    LastDocNo := INCSTR(LastDocNo);
                    //END;

                    CreateEntry := GLMgt.TraiterProvisionFraisAnnexesOld("Purchase Header", "Purchase Order Tracking",
                          ModeleFeuille, NomFeuille, PostingDate, LastDocNo, LineNum);

                    if CreateEntry then LastDocNo := IncStr(LastDocNo);
                end;
            }

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
                AddOnSetup.TestField(AddOnSetup."Invoice To Receive Account");

                GenJrnTableND.Get(ModeleFeuille, NomFeuille);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name", NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001, NomFeuille);

                BesoinNo := 0;

                Window.Open(Text008);

                LineNum := 0;
                NbreTotalLignes := "Purchase Header".Count;

                if OrderNum = '' then Error(Text009);

                "Purchase Header".SetRange("Purchase Header"."Document Type", "Purchase Header"."Document Type"::Order);
                "Purchase Header".SetRange("Purchase Header"."No.", OrderNum);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
        OrderNum: Code[20];
        Text009: Label 'Le numéro de la commande ne doit pas être vide!';

    procedure SetOrderNo(OrderNo1: Code[20])
    begin
        OrderNum := OrderNo1;
    end;
}

