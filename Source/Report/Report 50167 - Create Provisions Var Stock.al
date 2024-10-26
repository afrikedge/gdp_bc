report 50167 "Create Provisions Var Stock"
{
    Caption = 'Provisions Vente';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = SORTING("Document Type","No.") ORDER(Ascending) WHERE("Document Type"=CONST(Order));

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
                Cust: Record Customer;
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
                    CreateEntry:=false;

                   if Cust.Get("Sales Header"."Sell-to Customer No.") then
                     if ((Cust."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel")
                       or (Cust."Sales Channel Code" = AddOnSetup."JOVENNA Sales Channel")) then
                     CreateEntry := GLMgt.TraiterProvisionCdeVenteVarStockJIRAMA("Sales Header",ModeleFeuille,NomFeuille,PostingDate,LastDocNo,LineNum);

                   if CreateEntry then LastDocNo := IncStr(LastDocNo);
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
                //AddOnSetup.TESTFIELD(AddOnSetup."Unbilled Revenues Account");
                AddOnSetup.TestField(AddOnSetup."JIRAMA Sales Channel");
                AddOnSetup.TestField(AddOnSetup."JOVENNA Sales Channel");

                GenJrnTableND.Get(ModeleFeuille,NomFeuille);


                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name",ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name",NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001,NomFeuille);

                BesoinNo :=0;

                Window.Open(Text008);

                LineNum:=0;
                 NbreTotalLignes := "Sales Header".Count;
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

    procedure SetFeuille(CodeModele1: Code[10];CodeFeuille1: Code[10])
    begin
        ModeleFeuille:=CodeModele1;
        NomFeuille:=CodeFeuille1;
    end;
}

