codeunit 50021 "Item Conso to FA Mgt"
{

    trigger OnRun()
    begin
        //231117 Calcul automatique de lajustement de cout de l'immo quand le cout de l'article est ajusté
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Souhaitez vous valider l''octroi du prêt ?';
        Text002: Label 'La facture de vente %1 a été créée\La facture d''achat %2 a été créée';
        Text003: Label 'Les quantités cédées doivent etre égales aux quantités reçues.';
        NosSeriesMgt: Codeunit NoSeriesManagement;
        SingleCodeunit: Codeunit SingleInstance;
        Text004: Label 'Vous ne pouvez pas retourner une quantité supérieure à la quantité prêtée sur la ligne %1';
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text005: Label 'Voulez-vous valider la sortie de produits ?';
        Text006: Label 'Voulez-vous créer un nouveau remboursement ?';
        Text007: Label 'Traitement terminé avec succès';
        Text008: Label 'Aucune ligne à valider !';
        GenJnlLine: Record "Gen. Journal Line";
        Text009: Label 'Sortie pour immobilisation %1';
        GenPostingSetup: Record "General Posting Setup";
        Currency: Record Currency;
        SourceCodeSetup: Record "Source Code Setup";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text010: Label 'L''immobilisation a déjà été mise en service le %1';
        Text011: Label 'Vous ne pouvez pas mettre en service cette immobilisation car elle a déjà subi un amortissement !';
        Text012: Label 'Aucun plan d''amortissement configuré pour l''immobilisation';
        Text013: Label 'Le groupe compta immo. ne doit pas être le compte immo encours';
        IsMultipleMES: Boolean;
        DimMgt: Codeunit DimensionManagement;

    procedure PostSortie(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        LineExits: Boolean;
        ResteARemb: Decimal;
        AmountToInvoice: Decimal;
    begin

        if not Confirm(Text005) then exit;

        //ItemAdj.TESTFIELD("Vendor No.");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status, ItemAdj.Status::Open);


        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;


        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet then
            repeat

                Item1.Get(AdjustLine."Item No.");

                AdjustLine.TestField("Location Code");
                AdjustLine.TestField("Item No.");
                AdjustLine.TestField(Quantity);
                AdjustLine.TestField("FA Code");


                //Dépot d'origine - Ajustement négatif
                ItemJnlLine.Init;
                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::"FA Conso";
                ItemJnlLine."Posting Date" := ItemAdj."Posting Date";
                ItemJnlLine."Document Date" := ItemAdj."Posting Date";
                ItemJnlLine."Document No." := ItemAdj."No.";
                //ItemJnlLine."External Document No." := ItemAdj."External Document No.";
                ItemJnlLine."External Document No." := Format(AdjustLine."Line No.");//231117******

                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

                LineExits := true;

                ItemJnlLine.Validate("Item No.", AdjustLine."Item No.");
                ItemJnlLine.Description := StrSubstNo(Text009, ItemAdj."No.");
                ;

                ItemJnlLine.Validate("Location Code", AdjustLine."Location Code");
                ItemJnlLine.Validate(Quantity, Abs(AdjustLine.Quantity));

                ItemJnlLine.Validate("Unit of Measure Code", AdjustLine."Unit of Measure Code");
                ItemJnlLine."Invoiced Quantity" := Abs(AdjustLine.Quantity);
                ItemJnlLine."Source Code" := SourceCode;
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

                ItemJnlLine."Shortcut Dimension 1 Code" := AdjustLine."Shortcut Dimension 1 Code";
                ItemJnlLine."Shortcut Dimension 2 Code" := AdjustLine."Shortcut Dimension 2 Code";
                ItemJnlLine."Dimension Set ID" := AdjustLine."Dimension Set ID";

                AmountToInvoice := ItemJnlLine.Amount;

                SingleCodeunit.Set_IsPostingSortieImmo(true);
                ItemJnlPostLine.RunWithCheck(ItemJnlLine);


                if AmountToInvoice > 0 then begin
                    IsMultipleMES := true;
                    CreateMiseEnServiceImmoDOP(ItemAdj, AdjustLine, AmountToInvoice);
                end;
                SingleCodeunit.Set_IsPostingSortieImmo(false);



            until AdjustLine.Next = 0;



        ArchiveDoc(ItemAdj);

        if not LineExits then
            Error(Text008)
        else
            Message(Text007);
    end;

    // local procedure CreateMiseEnServiceImmo(var ItemAdj: Record "Adjustment Header"; LineItemAdj: Record "Adjustment Line"; Amt: Decimal)
    // var
    //     BalAccNo: Code[20];
    //     Item1: Record Item;
    //     GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    //     FA: Record "Fixed Asset";
    //     FALedgerEntry: Record "FA Ledger Entry";
    //     FADepreciationBook: Record "FA Depreciation Book";
    //     CodeDepr: Code[20];
    //     FAPostingGroup: Record "FA Posting Group";
    // begin
    //     AddOnSetup.Get;
    //     AddOnSetup.TestField(AddOnSetup."Fiscal Depreciation Book");

    //     SourceCodeSetup.Get;

    //     Item1.Get(LineItemAdj."Item No.");
    //     FA.Get(LineItemAdj."FA Code");

    //     if not IsMultipleMES then
    //         if FA."Startup Date" <> 0D then
    //             Error(Text010, FA."Startup Date");

    //     FALedgerEntry.SetRange("FA No.", FA."No.");
    //     FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
    //     if FALedgerEntry.FindFirst then
    //         Error(Text011);

    //     FADepreciationBook.SetRange("FA No.", FA."No.");
    //     if not FADepreciationBook.FindFirst then
    //         Error(Text012);


    //     //Compte immo encours
    //     FAPostingGroup.Get(FADepreciationBook."FA Posting Group");
    //     FAPostingGroup.TestField("Groupe Immo Encours");


    //     //Compte mise en service
    //     FAPostingGroup.Get(FADepreciationBook."Starting FA Posting Group");
    //     if FAPostingGroup."Groupe Immo Encours" then
    //         Error(Text013);


    //     CodeDepr := FADepreciationBook."FA Posting Group";
    //     FADepreciationBook."FA Posting Group" := FADepreciationBook."Starting FA Posting Group";
    //     FADepreciationBook."Starting FA Posting Group" := CodeDepr;
    //     FADepreciationBook.Modify;


    //     Clear(GenJnlLine);
    //     GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
    //     GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
    //     GenJnlLine."Document Date" := ItemAdj."Posting Date";
    //     GenJnlLine."Posting Date" := ItemAdj."Posting Date";
    //     //GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."Debit Notes Nos.",GenJnlLine."Posting Date",TRUE);
    //     GenJnlLine."Document No." := ItemAdj."No.";
    //     GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
    //     GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
    //     GenJnlLine.Validate(GenJnlLine."Account No.", LineItemAdj."FA Code");
    //     GenJnlLine.Validate(GenJnlLine."Depreciation Book Code", AddOnSetup."Fiscal Depreciation Book");
    //     GenJnlLine.Description := StrSubstNo(Text009, ItemAdj."No.");
    //     GenJnlLine.Validate(GenJnlLine.Amount, Amt);

    //     GenJnlLine."External Document No." := ItemAdj."No.";
    //     GenJnlLine."Source Code" := SourceCodeSetup."Fixed Asset G/L Journal";
    //     GenJnlLine.SetHideValidation(true);
    //     GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

    //     BalAccNo := getCompteImmoEncours(CodeDepr);
    //     GenJnlLine.Validate("Bal. Account No.", BalAccNo);
    //     //GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::" ";
    //     GenJnlLine."Bal. VAT Prod. Posting Group" := AddOnSetup."NoVAT Prod. Posting Group";

    //     GenJnlLine."Shortcut Dimension 1 Code" := LineItemAdj."Shortcut Dimension 1 Code";
    //     GenJnlLine."Shortcut Dimension 2 Code" := LineItemAdj."Shortcut Dimension 2 Code";
    //     GenJnlLine."Dimension Set ID" := LineItemAdj."Dimension Set ID";


    //     ItemJnlPostLine.AFK_GetGenJnlPostLine(GenJnlPostLine);
    //     GenJnlPostLine.RunWithCheck(GenJnlLine);


    //     UpdateAxeProjetImmo(FA, LineItemAdj."Dimension Set ID");
    //     FA."Startup Date" := Today;
    //     FA.MiseEnService := true;
    //     FA.Modify;

    //     //EXIT(GenJnlLine."Document No.");
    // end;

    local procedure CreateMiseEnServiceImmoDOP(var ItemAdj: Record "Adjustment Header"; LineItemAdj: Record "Adjustment Line"; Amt: Decimal)
    var
        BalAccNo: Code[20];
        Item1: Record Item;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        InventoryPostingTo: codeunit "Inventory Posting To G/L";
        FA: Record "Fixed Asset";
        FALedgerEntry: Record "FA Ledger Entry";
        FADepreciationBook: Record "FA Depreciation Book";
        CodeDepr: Code[20];
        FAPostingGroup: Record "FA Posting Group";
        DimId: Integer;
        NextNumber: Code[20];
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Fiscal Depreciation Book");

        SourceCodeSetup.Get;

        Item1.Get(LineItemAdj."Item No.");
        FA.Get(LineItemAdj."FA Code");

        if not IsMultipleMES then
            if FA."Startup Date" <> 0D then
                Error(Text010, FA."Startup Date");


        FADepreciationBook.SetRange("FA No.", FA."No.");
        if not FADepreciationBook.FindFirst then
            Error(Text012);


        if not FA.MiseEnService then begin

            FALedgerEntry.SetRange("FA No.", FA."No.");
            FALedgerEntry.SetRange("FA Posting Type", FALedgerEntry."FA Posting Type"::Depreciation);
            if FALedgerEntry.FindFirst then
                Error(Text011);

            //Compte immo encours
            FAPostingGroup.Get(FADepreciationBook."FA Posting Group");
            FAPostingGroup.TestField("Groupe Immo Encours");

            //Compte mise en service
            FAPostingGroup.Get(FADepreciationBook."Starting FA Posting Group");
            if FAPostingGroup."Groupe Immo Encours" then
                Error(Text013);

            CodeDepr := FADepreciationBook."FA Posting Group";
            FADepreciationBook."FA Posting Group" := FADepreciationBook."Starting FA Posting Group";
            FADepreciationBook."Starting FA Posting Group" := CodeDepr;
            FADepreciationBook.Modify;

        end else begin

            FAPostingGroup.Get(FADepreciationBook."FA Posting Group");
            if FAPostingGroup."Groupe Immo Encours" then
                Error(Text013);

        end;


        Clear(GenJnlLine);
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
        GenJnlLine."Document Date" := ItemAdj."Posting Date";
        GenJnlLine."Posting Date" := ItemAdj."Posting Date";
        //GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."Debit Notes Nos.",GenJnlLine."Posting Date",TRUE);
        GenJnlLine."Document No." := ItemAdj."No.";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine.Validate(GenJnlLine."Account No.", LineItemAdj."FA Code");
        GenJnlLine.Validate(GenJnlLine."Depreciation Book Code", AddOnSetup."Fiscal Depreciation Book");
        GenJnlLine.Description := StrSubstNo(Text009, ItemAdj."No.");
        GenJnlLine.Validate(GenJnlLine.Amount, Amt);







        //GenJnlLine."External Document No.":=ItemAdj."No.";
        GenJnlLine."External Document No." := Format(LineItemAdj."Line No.");//231117**************

        GenJnlLine."Source Code" := SourceCodeSetup."Fixed Asset G/L Journal";
        GenJnlLine.SetHideValidation(true);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

        BalAccNo := getCOGSAcc(Item1);
        GenJnlLine.Validate("Bal. Account No.", BalAccNo);
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Purchase;
        GenJnlLine."Bal. VAT Prod. Posting Group" := AddOnSetup."NoVAT Prod. Posting Group";

        GenJnlLine."Shortcut Dimension 1 Code" := LineItemAdj."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := LineItemAdj."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := LineItemAdj."Dimension Set ID";

        InventoryPostingTo := SingleCodeunit.Get_InventoryPostingToGL();
        InventoryPostingTo.PostGenJnlLine(GenJnlLine);
        //ItemJnlPostLine.AFK_GetGenJnlPostLine(GenJnlPostLine);
        //GenJnlPostLine.RunWithCheck(GenJnlLine);


        if not FA.MiseEnService then begin
            UpdateAxeProjetImmo(FA, LineItemAdj."Dimension Set ID");
            FA."Startup Date" := Today;
            FA.MiseEnService := true;
            FA."Old Number" := FA."No.";
            FA.Modify;

            //L'immo prend un numéro normal des qu'il est mis en service
            if not FA."Preserve Number" then begin
                AddOnSetup.TestField("FA In Service Nos.");
                NextNumber := NosSeriesMgt.GetNextNo(AddOnSetup."FA In Service Nos.", WorkDate, true);
                FA.Rename(NextNumber);
            end;
        end;

        //EXIT(GenJnlLine."Document No.");
    end;

    local procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    begin
        ItemAdjustMgt.ArchiveDoc(ItemAdj);
        ItemAdj.SetIsArchive(true);
        ItemAdj.Delete(true);
    end;

    local procedure getCOGSAcc(Item: Record Item): Code[20]
    begin
        GenPostingSetup.Get('', Item."Gen. Prod. Posting Group");
        GenPostingSetup.TestField("COGS Account");
        exit(GenPostingSetup."COGS Account");
    end;

    local procedure getCompteAmort(Immo: Record "Fixed Asset"): Code[20]
    var
        FAPostingGroup: Record "FA Posting Group";
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        FADepreciationBook.SetRange("FA No.", Immo."No.");
        FADepreciationBook.FindFirst;
        FADepreciationBook.TestField("FA Posting Group");

        //Immo.TESTFIELD(FADepreciationBook."FA Posting Group");
        FAPostingGroup.Get(FADepreciationBook."FA Posting Group");
        FAPostingGroup.TestField(FAPostingGroup."Depreciation Expense Acc.");
        exit(FAPostingGroup."Depreciation Expense Acc.");
    end;

    local procedure getCompteImmoEncours(FAPostingCode: Code[20]): Code[20]
    var
        FAPostingGroup: Record "FA Posting Group";
        FADepreciationBook: Record "FA Depreciation Book";
    begin
        //FADepreciationBook.SETRANGE("FA No.",Immo."No.");
        //FADepreciationBook.FINDFIRST ;
        //FADepreciationBook.TESTFIELD("FA Posting Group");

        //Immo.TESTFIELD(FADepreciationBook."FA Posting Group");
        FAPostingGroup.Get(FAPostingCode);
        FAPostingGroup.TestField(FAPostingGroup."Groupe Immo Encours");
        FAPostingGroup.TestField(FAPostingGroup."Acquisition Cost Account");
        exit(FAPostingGroup."Acquisition Cost Account");
    end;

    local procedure UpdateAxeProjetImmo(FA: Record "Fixed Asset"; DimSetId: Integer)
    var
        DimSetEntry: Record "Dimension Set Entry";
        CodeProjet: Code[20];
        DocDim: Record "Default Dimension";
    begin
        //get section axe projet
        CodeProjet := '';
        if DimSetEntry.Get(DimSetId, 'PROJET') then
            CodeProjet := DimSetEntry."Dimension Value Code";

        if CodeProjet <> '' then begin
            if DocDim.Get(5600, FA."No.", 'PROJET') then begin
                DocDim.TestField(DocDim."Dimension Value Code", CodeProjet);
            end else begin
                DocDim.Init;
                DocDim."Table ID" := 5600;
                DocDim."Dimension Code" := 'PROJET';
                DocDim."Dimension Value Code" := CodeProjet;
                DocDim."No." := FA."No.";
                DocDim."Value Posting" := DocDim."Value Posting"::"Same Code";
                DocDim.Insert;
            end;
        end;
    end;

    procedure GetDimSetId(Type1: Integer; No1: Code[20]; var GenJrnLine1: Record "Gen. Journal Line"): Integer
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

    procedure CreateLigneAdjustCoutDOP(ItemAdj: Record "Posted Adjustment Header"; LineItemAdj: Record "Posted Adjustment Line"; ModeleFeuille: Code[20]; FeuilleImmo: Code[20]; LastDocNum: Code[20]; var LineNum: Integer): Boolean
    var
        BalAccNo: Code[20];
        Item1: Record Item;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        FA: Record "Fixed Asset";
        FALedgerEntry: Record "FA Ledger Entry";
        FADepreciationBook: Record "FA Depreciation Book";
        CodeDepr: Code[20];
        FAPostingGroup: Record "FA Posting Group";
        DimId: Integer;
        NextNumber: Code[20];
        FAJournalLine: Record "FA Journal Line";
        Amt: Decimal;
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Fiscal Depreciation Book");

        SourceCodeSetup.Get;

        Item1.Get(LineItemAdj."Item No.");
        FA.Get(LineItemAdj."FA Code");


        FADepreciationBook.SetRange("FA No.", FA."No.");
        if not FADepreciationBook.FindFirst then
            Error(Text012);




        Clear(GenJnlLine);
        GenJnlLine."Journal Template Name" := ModeleFeuille;
        GenJnlLine."Journal Batch Name" := FeuilleImmo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."FA Posting Type" := GenJnlLine."FA Posting Type"::"Acquisition Cost";
        GenJnlLine."Document Date" := ItemAdj."Posting Date";
        GenJnlLine."Posting Date" := ItemAdj."Posting Date";
        //GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."Debit Notes Nos.",GenJnlLine."Posting Date",TRUE);
        GenJnlLine."Document No." := LastDocNum;
        GenJnlLine."Line No." := LineNum;
        LineNum := LineNum + 1;

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Fixed Asset";
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine.Validate(GenJnlLine."Account No.", LineItemAdj."FA Code");
        GenJnlLine.Validate(GenJnlLine."Depreciation Book Code", AddOnSetup."Fiscal Depreciation Book");
        GenJnlLine.Description := StrSubstNo(Text009, ItemAdj."No.");

        Amt := GetCoutAjustedDOP(ItemAdj."No.", LineItemAdj."Line No.");

        GenJnlLine.Validate(GenJnlLine.Amount, Amt);


        GenJnlLine."External Document No." := ItemAdj."No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Fixed Asset G/L Journal";
        //GenJnlLine.SetHideValidation(TRUE);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

        BalAccNo := getCOGSAcc(Item1);
        GenJnlLine.Validate("Bal. Account No.", BalAccNo);
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Purchase;
        GenJnlLine."Bal. VAT Prod. Posting Group" := AddOnSetup."NoVAT Prod. Posting Group";

        GenJnlLine."Shortcut Dimension 1 Code" := LineItemAdj."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := LineItemAdj."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := LineItemAdj."Dimension Set ID";



        if GenJnlLine.Amount <> 0 then begin
            GenJnlLine.Insert(true);
            exit(true);
        end;
        exit(false);
    end;

    local procedure GetCoutAjustedDOP(CodeSortie: Code[20]; NumLigne: Integer): Decimal
    var
        CoutTotalSortieStock: Decimal;
        CoutTotalAcquisition: Decimal;
    begin

        CoutTotalSortieStock := GetCoutSortieArticle(CodeSortie, NumLigne);
        CoutTotalAcquisition := GetCoutAcquisitionImmo(CodeSortie, NumLigne);

        exit(-CoutTotalSortieStock - CoutTotalAcquisition);
    end;

    local procedure GetCoutSortieArticle(CodeSortie: Code[20]; NumLigne: Integer): Decimal
    var
        ILE: Record "Item Ledger Entry";
    begin
        ILE.Reset;
        ILE.SetCurrentKey("Document No.", "Document Type", "Document Line No.");
        ILE.SetRange("Document No.", CodeSortie);
        if ILE.FindSet then
            repeat
                if (ILE."External Document No." = Format(NumLigne)) then begin
                    ILE.CalcFields(ILE."Cost Amount (Actual)");
                    exit(ILE."Cost Amount (Actual)");
                end;
            until ILE.Next = 0;
    end;

    local procedure GetCoutAcquisitionImmo(CodeSortie: Code[20]; NumLigne: Integer) Rep: Decimal
    var
        FAEntry: Record "FA Ledger Entry";
    begin
        FAEntry.Reset;
        FAEntry.SetCurrentKey("Document No.", "Posting Date");
        FAEntry.SetRange("Document No.", CodeSortie);
        if FAEntry.FindSet then
            repeat
                if (FAEntry."External Document No." = Format(NumLigne)) then begin
                    Rep := Rep + (FAEntry.Amount);
                end;
            until FAEntry.Next = 0;
    end;
}

