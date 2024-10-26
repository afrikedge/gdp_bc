report 50165 "Reverse Provisions"
{
    Caption = 'Provisions Vente';
    ProcessingOnly = true;

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = SORTING("Entry No.") ORDER(Ascending);

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
            begin
                
                /*IF (("G/L Entry"."Entry Type"<>"G/L Entry"."Entry Type"::) AND
                    ("G/L Entry"."Entry Type"<>"G/L Entry"."Entry Type"::VAT)) THEN
                    ERROR(ErrTypeEcr);*/
                
                
                
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
                
                   CreateEntry := GLMgt.TraiterProvisionCdeVente("Sales Header",ModeleFeuille,NomFeuille,PostingDate,LastDocNo,LineNum);
                
                   IF CreateEntry THEN LastDocNo := INCSTR(LastDocNo);*/
                
                //IF "Reversal Entry"."Entry Type"="Reversal Entry"."Entry Type"::"G/L Account" THEN
                   AddLigneEcr("G/L Entry");

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
                //AddOnSetup.GET;
                //AddOnSetup.TESTFIELD(AddOnSetup."Unbilled Revenues Account");

                GenJrnTableND.Get(ModeleFeuille,NomFeuille);

                if PostingDate=0D then Error(ErrDateCompta);

                GenJrnLine.Reset;
                GenJrnLine.SetRange("Journal Template Name",ModeleFeuille);
                GenJrnLine.SetRange("Journal Batch Name",NomFeuille);
                if GenJrnLine.FindFirst then Error(Text001,NomFeuille);

                BesoinNo :=0;

                Window.Open(Text008);

                if TransactionNo>0 then begin
                  "G/L Entry".SetCurrentKey("Transaction No.");
                  "G/L Entry".SetRange("G/L Entry"."Transaction No.",TransactionNo)
                end else begin
                  "G/L Entry".SetRange("G/L Entry"."Entry No.",StartingEntryNo,EndingEntryNo);
                end;

                LineNum:=0;
                 NbreTotalLignes := "G/L Entry".Count;
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
        GLMgt: Codeunit "GL Mgt";
        ErrDateCompta: Label 'Date de comptabilisation éronnée';
        ErrTypeEcr: Label 'Type écriture doit être comptable ou TVA';
        Text002: Label 'Contr %1';
        TransactionNo: Integer;
        StartingEntryNo: Integer;
        EndingEntryNo: Integer;

    procedure SetFeuille(CodeModele1: Code[10];CodeFeuille1: Code[10])
    begin
        ModeleFeuille:=CodeModele1;
        NomFeuille:=CodeFeuille1;
    end;

    local procedure AddLigneEcr(GLEntry: Record "G/L Entry")
    var
        GenJrnLine: Record "Gen. Journal Line";
        GLAccNo: Code[20];
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
    begin
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := NomFeuille;

        LineNum := LineNum + 10;
        GenJrnLine."Line No." := LineNum;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);
        GenJrnLine.Correction:=true;

        GenJrnLine."Document No." := GLEntry."Document No.";
        GenJrnLine."External Document No." := GLEntry."External Document No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := GLEntry."G/L Account No.";

        GLMgt.CheckParamsGLAcc(GLAccNo);
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");



        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        GenJrnLine.Description := CopyStr(StrSubstNo(Text002,GLEntry.Description),1,49);


        GenJrnLine.Validate(GenJrnLine.Amount, -GLEntry.Amount);

        GenJrnLine.Validate("Currency Code",'');

        GenJrnLine."Shortcut Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
        GenJrnLine."Shortcut Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
        GenJrnLine."Dimension Set ID" := GLEntry."Dimension Set ID";

        if GenJrnLine.Amount<>0 then
          GenJrnLine.Insert(true);
    end;

    procedure SetTransactionNo(Deb: Integer;Fin: Integer)
    begin
        //TransactionNo := TransNo;
        StartingEntryNo:=Deb;
        EndingEntryNo:=Fin;
    end;

    procedure SetTransactionNo2(TransNo: Integer)
    begin
        TransactionNo := TransNo;
    end;
}

