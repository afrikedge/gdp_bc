report 50156 "Create Provisions Achat"
{
    // Genere des provisions pour commandes normales d'achat recu non facturees
    // Genere des provisions de variation de stock pour commandes anticipées

    Caption = 'Provisions Vente';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = SORTING("Document Type","No.") ORDER(Ascending) WHERE("Document Type"=CONST(Order));

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
            begin




                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));

                    GenJrnTableND.TestField("No. Series");
                    Clear(NoSeriesMgt);

                    if LastDocNo='' then
                        LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",false);
                    //END ELSE BEGIN
                    //    LastDocNo := INCSTR(LastDocNo);
                    //END;
                    CreateEntry := GLMgt.TraiterProvisionCdeAchat("Purchase Header",
                      ModeleFeuille,NomFeuille,PostingDate,LastDocNo,LineNum,DateDeb,DateFin);


                   if CreateEntry then LastDocNo := IncStr(LastDocNo);

                   if (("Purchase Header"."Order Date">=DateDeb) and ("Purchase Header"."Order Date"<=DateFin)) then begin
                     if "Purchase Header".Anticipated then begin
                        CreateEntry := GLMgt.TraiterProvisionCdeAchatVarStockAnticipee("Purchase Header",
                          ModeleFeuille,NomFeuille,PostingDate,LastDocNo,LineNum);

                        if CreateEntry then LastDocNo := IncStr(LastDocNo);
                     end;
                   end;
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
                AddOnSetup.TestField(AddOnSetup."Invoice To Receive Account");

                GenJrnTableND.Get(ModeleFeuille,NomFeuille);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name",ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name",NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001,NomFeuille);

                BesoinNo :=0;

                Window.Open(Text008);

                if ((DateDeb=0D) or (DateFin=0D)) then Error(Text009);


                //"Purchase Header".SETRANGE("Order Date",DateDeb,DateFin);

                LineNum:=0;
                 NbreTotalLignes := "Purchase Header".Count;
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
                    Caption = 'Date commande début';
                }
                field(DateFin;DateFin)
                {
                    Caption = 'Date commande fin';
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
        Text009: Label 'Veuillez saisir une plage de dates commande';

    procedure SetFeuille(CodeModele1: Code[10];CodeFeuille1: Code[10])
    begin
        ModeleFeuille:=CodeModele1;
        NomFeuille:=CodeFeuille1;
    end;
}

