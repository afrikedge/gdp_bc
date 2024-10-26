codeunit 50013 "FA Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Vous ne pouvez pas mettre en service cette immobilisation car elle a déjà subi un amortissement !';
        Text002: Label 'Souhaitez-vous mettre en service l''immobilisation %1 ?\La nouvelle catégorie de l''immobilisation sera %2';
        Text003: Label 'Aucun plan d''amortissement configuré pour l''immobilisation';
        AddOnSetup: Record "AddOn Setup";
        NosSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        Text004: Label 'Mise en service Immo : %1';
        Text005: Label 'Les groupes de comptabilisation ne doivent pas être identiques !';
        FAPostingGroup: Record "FA Posting Group";
        Text006: Label 'Traiement terminé avec succès !';
        Text007: Label 'Les emplacements d''origine et de destination doivent être différents !';
        Text008: Label 'L''immobilisation a déjà été mise en service le %1';
        Text009: Label 'Le groupe compta immo. ne doit pas être le compte immo encours';
        FADepreciationBook: Record "FA Depreciation Book";
        FASetup: Record "FA Setup";
        Text010: Label 'La date d''acquisition est invalide pour la génération du code de l''immobilisation';
        DimMgt: Codeunit DimensionManagement;

    procedure MiseEnService(var FA: Record "Fixed Asset")
    var
        FALedgerEntry: Record "FA Ledger Entry";
        FADepreciationBook: Record "FA Depreciation Book";
        GenJrnLine: Record "Gen. Journal Line";
        DebAcc: Code[20];
        CreAcc: Code[20];
        Amount: Decimal;
        NextNumber: Code[20];
    begin

        AddOnSetup.Get;

        if FA."Startup Date" <> 0D then
            Error(Text008, FA."Startup Date");

        FA.TestField("Startup Posting Date");

        FALedgerEntry.SetRange("FA No.", FA."No.");
        FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
        if FALedgerEntry.FindFirst then
            Error(Text001);

        FADepreciationBook.SetRange("FA No.", FA."No.");
        if not FADepreciationBook.FindFirst then
            Error(Text003);

        if not Confirm(StrSubstNo(Text002, FADepreciationBook."FA No.", FADepreciationBook."Starting FA Posting Group"))
          then
            exit;


        FADepreciationBook.CalcFields("Book Value");
        //FADepreciationBook.TESTFIELD(FADepreciationBook."Book Value");

        FADepreciationBook.TestField("Depreciation Starting Date");


        FADepreciationBook.TestField(FADepreciationBook."FA Posting Group");
        FADepreciationBook.TestField(FADepreciationBook."Starting FA Posting Group");

        if FADepreciationBook."FA Posting Group" = FADepreciationBook."Starting FA Posting Group"
          then
            Error(Text005);

        //Compte Immo encours
        FAPostingGroup.Get(FADepreciationBook."FA Posting Group");
        FAPostingGroup.TestField(FAPostingGroup."Acquisition Cost Account");
        FAPostingGroup.TestField("Groupe Immo Encours");
        CreAcc := FAPostingGroup."Acquisition Cost Account";

        FAPostingGroup.Get(FADepreciationBook."Starting FA Posting Group");
        FAPostingGroup.TestField(FAPostingGroup."Acquisition Cost Account");
        if FAPostingGroup."Groupe Immo Encours" then
            Error(Text009);
        DebAcc := FAPostingGroup."Acquisition Cost Account";

        Amount := FADepreciationBook."Book Value";

        if Amount <> 0 then
            CreateGLEntryMES(DebAcc, CreAcc, Amount, FA, FA."Startup Posting Date");

        FADepreciationBook."FA Posting Group" := FADepreciationBook."Starting FA Posting Group";
        FADepreciationBook."Starting FA Posting Group" := '';
        FADepreciationBook.Modify;


        FA."Startup Date" := Today;
        FA.MiseEnService := true;
        FA.Codification := GenerateCodeImmo(FA);
        FA."Old Number" := FA."No.";
        FA.Modify;


        //Les immos encours ont une souche particuliere
        //L'immo prend un numéro normal des qu'il est mis en service
        if not FA."Preserve Number" then begin
            AddOnSetup.TestField("FA In Service Nos.");
            NextNumber := NosSeriesMgt.GetNextNo(AddOnSetup."FA In Service Nos.", WorkDate, true);
            FA.Rename(NextNumber);
        end;

        Message(Text006);
    end;

    local procedure CreateGLEntryMES(DebitAcc: Code[20]; CreditAcc: Code[20]; Amt: Decimal; FA: Record "Fixed Asset"; PostingDate: Date)
    var
        BalAccNo: Code[20];
        Item1: Record Item;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimId: Integer;
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField("FA Starting Nos.");
        AddOnSetup.TestField("NoVAT Prod. Posting Group");

        SourceCodeSetup.Get;

        //Item1.GET(LineItemAdj."Item No.");

        Clear(GenJnlLine);
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document Date" := PostingDate;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."FA Starting Nos.", WorkDate, true);
        //GenJnlLine."Document No." := ItemAdj."No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Purchase;
        GenJnlLine.Validate(GenJnlLine."Account No.", DebitAcc);
        GenJnlLine.Description := StrSubstNo(Text004, FA."No.");
        GenJnlLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        GenJnlLine.Validate(GenJnlLine.Amount, Amt);

        GenJnlLine."External Document No." := FA."No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Fixed Asset G/L Journal";
        GenJnlLine.SetHideValidation(true);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

        BalAccNo := CreditAcc;
        GenJnlLine.Validate("Bal. Account No.", BalAccNo);
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Purchase;
        GenJnlLine.Validate("Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");


        DimId := CreateDim(DATABASE::"Fixed Asset", FA."No.", GenJnlLine);
        if DimId > 0 then
            GenJnlLine."Dimension Set ID" := DimId;
        //GenJnlLine."Shortcut Dimension 1 Code" := FA."Global Dimension 1 Code";
        //GenJnlLine."Shortcut Dimension 2 Code" := FA."Global Dimension 1 Code";
        //GenJnlLine."Dimension Set ID" := FA."Dimension Set ID";


        //ItemJnlPostLine.AFK_GetGenJnlPostLine(GenJnlPostLine);
        if GenJnlLine.Amount <> 0 then
            GenJnlPostLine.RunWithCheck(GenJnlLine);

        //EXIT(GenJnlLine."Document No.");
    end;

    procedure InsertNewTransfer(var FA: Record "Fixed Asset"; CodeImmo: Code[20]; PostingDate: Date; Descr: Text[100]; NewLocation: Code[10]; ExtDocNo: Text[30]; NewSubLocation: Code[10]): Boolean
    var
        FATransfert: Record "FA Transfer";
        NextNum: Integer;
        FALoc: Record "FA Location";
        FASubLoc: Record "FA SubLocation";
        DefDim: Record "Default Dimension";
    begin

        //FA.GET(CodeImmo);

        if ((FA."Location Code" = NewLocation) and (FA."FA Sub Location" = NewSubLocation)) then
            Error(Text007);

        Clear(FATransfert);

        if FATransfert.FindLast then
            NextNum := FATransfert."Entry No.";

        FATransfert.Description := Descr;
        FATransfert."Entry Date" := Today;
        FATransfert."User ID" := UserId;
        NextNum := NextNum + 1;
        FATransfert."Entry No." := NextNum;
        FATransfert."External Document No." := ExtDocNo;
        FATransfert."Transfer Date" := PostingDate;

        FATransfert."FA Location Code" := FA."FA Location Code";
        if FALoc.Get(FATransfert."FA Location Code") then
            FATransfert."Old FA Location" := FALoc.Name;

        FATransfert."FA Location Code New" := NewLocation;
        FALoc.Get(NewLocation);
        FATransfert."New FA Location" := FALoc.Name;

        FATransfert."FA Sub Location Code" := NewSubLocation;
        if FASubLoc.Get(NewLocation, NewSubLocation) then
            FATransfert."FA Sub Location Name" := FASubLoc.Name;

        FATransfert."FA No." := CodeImmo;

        FATransfert.Insert;


        FA."FA Location Code" := NewLocation;
        FA."FA Sub Location" := NewSubLocation;
        FA.Modify;

        if FALoc.Get(NewLocation) then begin
            if FALoc."Project Code" <> '' then begin
                if DefDim.Get('5600', FA."No.", 'PROJET') then begin
                    DefDim."Dimension Value Code" := FALoc."Project Code";
                    DefDim.Modify;
                end else begin
                    DefDim.Init;
                    DefDim."Table ID" := 5600;
                    DefDim."Dimension Code" := 'PROJET';
                    DefDim."Dimension Value Code" := FALoc."Project Code";
                    DefDim."No." := FA."No.";
                    DefDim."Value Posting" := DefDim."Value Posting"::"Same Code";
                    DefDim.Insert;
                end;
            end;
        end;

        exit(true);
    end;

    procedure GenerateCodeImmo(FA: Record "Fixed Asset"): Code[30]
    var
        Categorie: Code[4];
        Numero: Code[10];
        Annee: Code[2];
        Emplacement: Code[8];
        Nbre: Integer;
        i: Integer;
        AcqDate: Date;
    begin

        FASetup.Get;
        FASetup.TestField(FASetup."Default Depr. Book");
        FADepreciationBook.Get(FA."No.", FASetup."Default Depr. Book");

        //Categorie := COPYSTR(FADepreciationBook."FA Posting Group",1,4);
        Nbre := StrLen(Format(FA."No."));
        if Nbre < 10 then begin
            for i := Nbre to 9 do begin
                Numero := Numero + '0';
            end;
        end;

        AcqDate := 0D;
        //IF FADepreciationBook."G/L Acquisition Date"<>0D THEN
        //  AcqDate := FADepreciationBook."G/L Acquisition Date";
        if FADepreciationBook."Depreciation Starting Date" <> 0D then
            AcqDate := FADepreciationBook."Depreciation Starting Date";

        if AcqDate = 0D then
            if FA."Startup Date" <> 0D then
                AcqDate := FA."Startup Date";

        if AcqDate = 0D then
            Error(Text010);
        //FADepreciationBook.TESTFIELD("G/L Acquisition Date");

        Numero := Numero + Format(FA."No.");
        Categorie := CopyStr(FADepreciationBook."FA Posting Group", 1, 4);
        Annee := CopyStr(Format(Date2DMY(AcqDate, 3)), 3, 2);
        Emplacement := CopyStr(FA."FA Location Code", 1, 8);

        exit(Categorie + '/' + Numero + '/' + Annee + '/' + Emplacement)
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; var GenJrnLine1: Record "Gen. Journal Line"): Integer
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        GenJrnLine1."Shortcut Dimension 1 Code" := '';
        GenJrnLine1."Shortcut Dimension 2 Code" := '';
        //TODO
        // exit(
        //   DimMgt.GetDefaultDimID(
        //     TableID, No, GenJrnLine1."Source Code",
        //     GenJrnLine1."Shortcut Dimension 1 Code", GenJrnLine1."Shortcut Dimension 2 Code", 0, 0));
    end;

    procedure GenerateNosTransfer(Update: Boolean): Code[20]
    begin
        AddOnSetup.Get;
        if AddOnSetup."FA Transfer Nos." <> '' then begin
            exit(NosSeriesMgt.GetNextNo(AddOnSetup."FA Transfer Nos.", WorkDate, Update));
        end;
    end;

    procedure GenerateNosCession(Update: Boolean): Code[20]
    begin
        AddOnSetup.Get;
        if AddOnSetup."FA Cession Nos." <> '' then begin
            exit(NosSeriesMgt.GetNextNo(AddOnSetup."FA Cession Nos.", WorkDate, Update));
        end;
    end;

    procedure GenerateNosRebus(Update: Boolean): Code[20]
    begin
        AddOnSetup.Get;
        if AddOnSetup."FA Rebut Nos." <> '' then begin
            exit(NosSeriesMgt.GetNextNo(AddOnSetup."FA Rebut Nos.", WorkDate, Update));
        end;
    end;

    procedure GenerateNosMES(Update: Boolean): Code[20]
    begin
        AddOnSetup.Get;
        if AddOnSetup."FA Starting Nos. Impr" <> '' then begin
            exit(NosSeriesMgt.GetNextNo(AddOnSetup."FA Starting Nos. Impr", WorkDate, Update));
        end;
    end;

    procedure GenerateNosInventaire(Update: Boolean): Code[20]
    begin
        AddOnSetup.Get;
        if AddOnSetup."FA Inventory Nos." <> '' then begin
            exit(NosSeriesMgt.GetNextNo(AddOnSetup."FA Inventory Nos.", WorkDate, Update));
        end;
    end;

    procedure ShowEcrituresMES(FA: Record "Fixed Asset")
    var
        GLEntry: Record "G/L Entry";
        GLEntryPage: Page "General Ledger Entries";
    begin

        GLEntry.Reset;
        if FA."Old Number" <> '' then
            GLEntry.SetRange(GLEntry."External Document No.", FA."Old Number")
        else
            GLEntry.SetRange(GLEntry."External Document No.", FA."No.");
        PAGE.Run(20, GLEntry);
    end;

    procedure AFK_GetNewDescr(ValEntry: Record "Value Entry"): Text[50]
    var
        FraisAnn1: Record "Item Charge";
        Item1: Record Item;
    begin
        if FraisAnn1.Get(ValEntry."Item Charge No.") then
            exit(FraisAnn1.Description)
        else
            if Item1.Get(ValEntry."Item No.") then
                exit(Item1.Description);
    end;
}

