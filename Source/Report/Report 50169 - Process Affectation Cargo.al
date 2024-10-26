report 50169 "Process Affectation Cargo"
{
    Caption = 'Process Affectation Cargo';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number=CONST(1));

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
            begin

                if Traitement=Traitement::"ETAPE 0" then
                  CargoMgt.PeriodicProcess_Intro(DateDeb,DateFin);

                if Traitement=Traitement::"ETAPE 1" then
                  CargoMgt.PeriodicProcess_Trait01(DateDeb,DateFin);

                if Traitement=Traitement::"ETAPE 2" then
                  CargoMgt.PeriodicProcess_Trait02(DateDeb,DateFin);

                if Traitement=Traitement::"ETAPE 3" then
                  CargoMgt.PeriodicProcess_Trait03(DateDeb,DateFin);

                if Traitement=Traitement::"ETAPE 4" then
                  CargoMgt.PeriodicProcess_Trait04(DateDeb,DateFin);


                //CargoMgt.PeriodicProcess(DateDeb,DateFin);
            end;

            trigger OnPostDataItem()
            var
                LastDocNo: Code[20];
                CommandeVente: Record "Sales Header";
                GenerateNewDocNo: Boolean;
                LineNum: Integer;
            begin
                //Window.CLOSE;
                Message(TxtTraitementTerminé);
            end;

            trigger OnPreDataItem()
            begin
                //AddOnSetup.GET;
                //AddOnSetup.TESTFIELD(AddOnSetup."Unbilled Revenues Account");
                
                //GenJrnTableND.GET(ModeleFeuille,NomFeuille);
                
                if DateDeb=0D then Error(ErrDateCompta);
                if DateFin=0D then Error(ErrDateCompta);
                /*
                GenJrnLine.RESET;
                GenJrnLine.SETRANGE("Journal Template Name",ModeleFeuille);
                GenJrnLine.SETRANGE("Journal Batch Name",NomFeuille);
                IF GenJrnLine.FINDFIRST THEN ERROR(Text001,NomFeuille);*/
                
                BesoinNo :=0;
                
                //Window.OPEN(Text008);
                
                
                LineNum:=0;
                //NbreTotalLignes := "G/L Entry".COUNT;

            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(PostingDate1;DateDeb)
                {
                    Caption = 'Starting Posting Date';
                }
                field(PostingDate2;DateFin)
                {
                    Caption = 'Ending Posting Date';
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
                field(Traitement;Traitement)
                {
                    Caption = 'Traitement';
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
        //AddOnSetup.TESTFIELD("Provision Tmpl Journal");
        //ModeleFeuille := AddOnSetup."Provision Tmpl Journal";
        //PostingDate:=WORKDATE;
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
        CargoMgt: Codeunit "Item Value Cargo Mgt";
        ItemCargoEntry: Record "Item Cargo Entry";
        DateDeb: Date;
        DateFin: Date;
        Traitement: Option "ETAPE 0","ETAPE 1","ETAPE 2","ETAPE 3","ETAPE 4";

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

    procedure SetCargoEntry(Rec1: Record "Item Cargo Entry")
    begin
        ItemCargoEntry := Rec1;
    end;
}

