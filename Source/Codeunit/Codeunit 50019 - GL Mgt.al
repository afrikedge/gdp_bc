codeunit 50019 "GL Mgt"
{

    trigger OnRun()
    begin
        Message('%1', 20230321D - 20230201D);
    end;

    var
        GenJrnTemplate: Code[20];
        AddOnSetup: Record "AddOn Setup";
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        HavePostMoneyTechTrans: Boolean;
        GenJrnTableND: Record "Gen. Journal Batch";
        GenJrnBatch_ND: Code[20];
        GenJrnBatch_NC: Code[20];
        GenJrnTableNC: Record "Gen. Journal Batch";
        PurchReq: Codeunit "Purchase Requisition Mgt";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        GenJrnBatch: Code[20];
        GenJrnTable: Record "Gen. Journal Batch";
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text002: Label 'This account %1 does not exists !';
        Text003: Label 'The journal template model is required';
        Text004: Label 'The journal code is required';
        Text005: Label 'Provisions commande de vente %1';
        Text006: Label 'Provisions frais annexes commande %1';
        Text007: Label 'Les provisions de frais annexes ont déjà été validées pour ce document';
        Text009: Label 'Provisions commande d''achat %1';
        Text010: Label 'Souhaitez-vous retourner ce chèque : %1  ?';
        Text011: Label 'Souhaitez-vous clôturer la lettre de crédit : %1  ?';
        Text012: Label 'Les factures de provisions de frais annexes seront créés pour ce document. Souhaitez-vous continuer ?';
        Text013: Label 'Traitement terminé : %1 factures de frais annexes créés';
        Text014: Label 'Provision Cde';
        Text015: Label 'Prov. frais annexes';
        Text016: Label 'Vous devez extourner les écritures provisions avant de facturer ce document';
        Text017: Label 'Le document de paiement n''a pas été configuré pour \le modèle %1\la feuille %2\le type %3';
        Text019: Label 'Souhaitez-vous confirmer ce chèque : %1  ?';
        Text018: Label 'Achat de devise LC %1';
        Text020: Label 'Vous devez configurer les groupes de comptabilisation pour le compte général %1 ';
        SourceCodeSetup: Record "Source Code Setup";
        AFK_Text001: Label 'Livraison Cde %1';
        AFK_Err0001: Label 'Le numéro de chèque %1 n''appartient plus à la plage autorisée : %2 .. %3';
        AFK_Text002: Label 'Traitement terminé avec succès';
        AFK_Text003: Label 'Voulez-vous envoyer l''article %1 - %2 en validation ?';
        AFK_Text004: Label 'Voulez-vous valider cet article  %1 - %2 ?';
        AFK_Text005: Label 'Voulez-vous envoyer le fournisseur %1 - %2 en validation ?';
        AFK_Text006: Label 'Voulez-vous valider ce fournisseur  %1 - %2 ?';
        SecMgt: Codeunit "Security Mgt";
        AFK_Text007: Label 'Fonction non autorisée';
        AFK_Text008: Label 'Voulez-vous valider cet article  %1 - %2 ? \Il faut vous assurer que toutes les contraintes analytiques ont été renseignées';

    procedure ConvertInLocalCurr(CodeDevise: Code[20]; PostingDate: Date; AmountToConvert: Decimal) Reponse: Decimal
    begin
        if CodeDevise = '' then
            Reponse := AmountToConvert
        else
            Reponse :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostingDate, CodeDevise, AmountToConvert,
                      CurrExchRate.ExchangeRate(PostingDate, CodeDevise)));
    end;

    procedure GetPostingAllowedDatesOnGroupsUsers(var AllowPostingFrom: Date; var AllowPostingTo: Date; var SetupRecordID: RecordID)
    var
        UserGroupMember: Record "User Group Member";
        UserGroup: Record "User Group";
    begin
        AddOnSetup.Get;
        if not AddOnSetup."GL Security On Group Users" then exit;

        UserGroupMember.Reset;
        UserGroupMember.SetRange("User Name", UserId);
        //UserGroupMember.SETRANGE("Company Name",COMPANYNAME);
        if UserGroupMember.FindFirst then begin
            if UserGroup.Get(UserGroupMember."User Group Code") then begin
                AllowPostingFrom := UserGroup."Allow Posting From";
                AllowPostingTo := UserGroup."Allow Posting To";
                SetupRecordID := UserGroup.RecordId;
            end;
        end;
    end;

    procedure CheckParamsGLAcc(GLAcc: Code[20])
    var
        ParamGL: Record "General Posting Setup";
        GLAccount: Record "G/L Account";
    begin
        GLAccount.Get(GLAcc);
        if not ParamGL.Get(GLAccount."Gen. Bus. Posting Group", GLAccount."Gen. Prod. Posting Group") then
            Error(Text020, GLAcc);
    end;

    procedure CreateAdjustmentNaphta(ItemJournalLine: Record "Item Journal Line"; OrderNo: Code[20])
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        if ItemJournalLine.Quantity = 0 then exit;

        if ((ItemJournalLine."Document Type" <> ItemJnlLine."Document Type"::"Sales Return Receipt")
        and (ItemJournalLine."Document Type" <> ItemJnlLine."Document Type"::"Sales Shipment"))
         then
            exit;

        Item1.Get(ItemJournalLine."Item No.");

        SourceCodeSetup.Get;
        AddOnSetup.Get;
        SourceCode := SourceCodeSetup."Item Journal";

        if not AddOnSetup."Activer ajustement Naphta" then exit;

        AddOnSetup.TestField("Naphta Fictif Location");
        //TODO Check Product Code Here
        //if Item1."Product Group Code" <> AddOnSetup."Naphta Product Group" then exit;
        if Item1."No." <> '70009-0000' then exit;

        ItemJnlLine.Init;
        ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AjustNaphta;
        ItemJnlLine."Posting Date" := ItemJournalLine."Posting Date";
        ItemJnlLine."Document Date" := ItemJournalLine."Posting Date";
        ItemJnlLine."Document No." := ItemJournalLine."Document No.";
        ItemJnlLine."External Document No." := ItemJournalLine."External Document No.";

        if ItemJournalLine."Document Type" = ItemJournalLine."Document Type"::"Sales Shipment" then//Livraison
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
        else//Avoir
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";


        ItemJnlLine.Validate("Item No.", ItemJournalLine."Item No.");
        ItemJnlLine.Description := StrSubstNo(AFK_Text001, OrderNo);

        ItemJnlLine.Validate("Location Code", AddOnSetup."Naphta Fictif Location");
        ItemJnlLine.Validate(Quantity, Abs(ItemJournalLine.Quantity));





        ItemJnlLine.Validate("Unit of Measure Code", ItemJournalLine."Unit of Measure Code");
        ItemJnlLine."Invoiced Quantity" := Abs(ItemJournalLine.Quantity);
        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

        ItemJnlLine."Shortcut Dimension 1 Code" := ItemJournalLine."Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := ItemJournalLine."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := ItemJournalLine."Dimension Set ID";

        ItemJnlLine.Validate(ItemJnlLine."Unit Amount", 0);

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;

    procedure CheckPlageCheques(BankAcc2: Record "Bank Account"; UseCheckNo: Code[20])
    begin
        //**********************************************************
        //**********************************************************
        AddOnSetup.Get;
        if not AddOnSetup."Desactivate Check Nos Control" then
            if not AFK_IsInPlage(UseCheckNo, BankAcc2."Starting Check No.", BankAcc2."Ending Check No.") then
                Error(StrSubstNo(AFK_Err0001, UseCheckNo, BankAcc2."Starting Check No.", BankAcc2."Ending Check No."));
        //**********************************************************
        //**********************************************************
    end;

    procedure ValidateItem(Item1: Record Item; Status: Integer)
    begin

        if Status = 0 then begin
            if not Confirm(StrSubstNo(AFK_Text003, Item1."No.", Item1.Description)) then exit;
            if Item1."Validation Status" <> Item1."Validation Status"::Created then exit;
            Item1."Validation Status" := Item1."Validation Status"::InWorkflowCDG;
            Item1."Created By UserID" := UserId;
            Item1."Created By Date" := Today;
        end;

        if Status = 1 then begin
            if not Confirm(StrSubstNo(AFK_Text008, Item1."No.", Item1.Description)) then exit;
            if Item1."Validation Status" <> Item1."Validation Status"::InWorkflowCDG then exit;

            Item1."Validation Status" := Item1."Validation Status"::InWorkflowFOUR;
            Item1."Validated CDG By UserID" := UserId;
            Item1."Validated CDG By Date" := Today;
        end;

        if Status = 2 then begin

            if not SecMgt.CanValidateItems then Error(AFK_Text007);

            if not Confirm(StrSubstNo(AFK_Text004, Item1."No.", Item1.Description)) then exit;
            if Item1."Validation Status" <> Item1."Validation Status"::InWorkflowFOUR then exit;

            Item1.TestField(Item1."Item Category Code");
            Item1.TestField(Item1."Base Unit of Measure");
            Item1.TestField(Item1."Gen. Prod. Posting Group");
            if (Item1.Type = Item1.Type::Inventory) then
                Item1.TestField(Item1."Inventory Posting Group");
            Item1.TestField(Item1."VAT Prod. Posting Group");

            Item1."Validation Status" := Item1."Validation Status"::Validated;
            Item1."Validated By UserID" := UserId;
            Item1."Validated By Date" := Today;
        end;

        Item1.Modify;
        Message(AFK_Text002);
    end;

    procedure ValidateVendor(Vend1: Record Vendor; Status: Integer)
    begin

        if Status = 0 then begin
            if not Confirm(StrSubstNo(AFK_Text005, Vend1."No.", Vend1.Name)) then exit;
            if Vend1."Validation Status" <> Vend1."Validation Status"::Created then exit;
            Vend1."Validation Status" := Vend1."Validation Status"::InWorkflow;
            Vend1."Created By UserID" := UserId;
            Vend1."Created By Date" := Today;
        end;

        if Status = 1 then begin

            if not SecMgt.CanValidateVendors then Error(AFK_Text007);

            if not Confirm(StrSubstNo(AFK_Text006, Vend1."No.", Vend1.Name)) then exit;
            if Vend1."Validation Status" <> Vend1."Validation Status"::InWorkflow then exit;

            //Vend1.TESTFIELD(Vend1.Name);
            //Vend1.TESTFIELD(Vend1."VAT Registration No.");
            Vend1.TestField(Vend1."Gen. Bus. Posting Group");
            Vend1.TestField(Vend1."Vendor Posting Group");
            Vend1.TestField(Vend1."VAT Bus. Posting Group");

            Vend1."Validation Status" := Vend1."Validation Status"::Validated;
            Vend1."Validated By UserID" := UserId;
            Vend1."Validated By Date" := Today;
        end;

        Vend1.Modify;
        Message(AFK_Text002);
    end;

    procedure AddGLInfos(GenJrnLine1: Record "Gen. Journal Line"; GLEntryNo: Integer)
    var
        GLInfos: Record "G/l Entry Infos";
    begin
        if not DoAddInfos(GenJrnLine1) then
            exit;

        Clear(GLInfos);
        GLInfos."Entry No." := GLEntryNo;
        GLInfos."Item No." := GenJrnLine1.CodeArticleProvisions;
        GLInfos.TypeProvision := GenJrnLine1.TypeProvision;
        GLInfos."Vendor Code" := GenJrnLine1.VendorCodeProvisions;
        GLInfos.Insert;
    end;

    local procedure DoAddInfos(GenJrnLine: Record "Gen. Journal Line"): Boolean
    begin
        if GenJrnLine.CodeArticleProvisions <> '' then exit(true);
        if GenJrnLine.VendorCodeProvisions <> '' then exit(true);
    end;

    procedure UpdateReconciliationInfos(GenJrnLine2: Record "Gen. Journal Line"; GLEntryNo: Integer)
    var
        ReconInfo: Record "Reconciliation Info";
    begin
        ReconInfo.Reset;
        ReconInfo.SetRange("Customer No.", GenJrnLine2."Account No.");
        ReconInfo.SetRange("Journal Template Name", GenJrnLine2."Journal Template Name");
        ReconInfo.SetRange("Journal Batch Name", GenJrnLine2."Journal Batch Name");
        ReconInfo.SetRange("Line No.", GenJrnLine2."Line No.");
        ReconInfo.ModifyAll("G/L Entry No", GLEntryNo);
        ReconInfo.ModifyAll(ReconInfo."Journal Batch Name", '');
        ReconInfo.ModifyAll(ReconInfo."Journal Template Name", '');
    end;



    procedure TemplateSelectionFromBatchCCL(GenJnlManagement: codeunit GenJnlManagement; var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        //********************************************************************
        //TODO
        OpenFromBatch := true;
        GenJnlTemplate.Get(GenJnlBatch."Journal Template Name");
        GenJnlTemplate.TestField("Page ID");
        GenJnlBatch.TestField(Name);

        GenJnlLine.FilterGroup := 2;
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.FilterGroup := 0;

        GenJnlLine."Journal Template Name" := '';
        GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
        PAGE.Run(50144, GenJnlLine);
        //********************************************************************
    end;

    procedure TemplateSelectionFromBatchTRESO(var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        //********************************************************************
        //TODO
        OpenFromBatch := true;
        GenJnlTemplate.Get(GenJnlBatch."Journal Template Name");
        GenJnlTemplate.TestField("Page ID");
        GenJnlBatch.TestField(Name);

        GenJnlLine.FilterGroup := 2;
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.FilterGroup := 0;

        GenJnlLine."Journal Template Name" := '';
        GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
        PAGE.Run(50268, GenJnlLine);
        //********************************************************************
    end;

    procedure TemplateSelectionFromBatchTRESO_VIREMENT(var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        //********************************************************************
        //TODO
        OpenFromBatch := true;
        GenJnlTemplate.Get(GenJnlBatch."Journal Template Name");
        GenJnlTemplate.TestField("Page ID");
        GenJnlBatch.TestField(Name);

        GenJnlLine.FilterGroup := 2;
        GenJnlLine.SetRange("Journal Template Name", GenJnlTemplate.Name);
        GenJnlLine.FilterGroup := 0;

        GenJnlLine."Journal Template Name" := '';
        GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
        PAGE.Run(50200, GenJnlLine);
        //********************************************************************
    end;

    procedure AFK_IsInPlage(Number: Code[20]; MinNo: Code[20]; MaxNo: Code[20]): Boolean
    var
        DecimalNo: Decimal;
        StartPos: Integer;
        EndPos: Integer;
        NewNo: Text[30];
        DecimalToCheck: Decimal;
        DecimalMin: Decimal;
        DecimalMax: Decimal;
    begin
        //**********************************************************
        //Teste si un numéro est contenu dans la plage MinNo..MaxNo
        //**********************************************************
        GetIntegerPos(Number, StartPos, EndPos);
        Evaluate(DecimalToCheck, CopyStr(Number, StartPos, EndPos - StartPos + 1));

        GetIntegerPos(MinNo, StartPos, EndPos);
        Evaluate(DecimalMin, CopyStr(MinNo, StartPos, EndPos - StartPos + 1));

        GetIntegerPos(MaxNo, StartPos, EndPos);
        Evaluate(DecimalMax, CopyStr(MaxNo, StartPos, EndPos - StartPos + 1));

        exit((DecimalToCheck >= DecimalMin) and (DecimalToCheck <= DecimalMax));
    end;

    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        StartPos := 0;
        EndPos := 0;
        if No <> '' then begin
            i := StrLen(No);
            repeat
                IsDigit := No[i] in ['0' .. '9'];
                if IsDigit then begin
                    if EndPos = 0 then
                        EndPos := i;
                    StartPos := i;
                end;
                i := i - 1;
            until (i = 0) or (StartPos <> 0) and not IsDigit;
        end;
    end;

    procedure VATCorrectionGDP(var SalesH: Record "Sales Header")
    var
        Item1: Record Item;
        Cust2: Record Customer;
        AddOnSetup2: Record "AddOn Setup2";
        VATPostingSetup: Record "VAT Posting Setup";
        RDSFees: Decimal;
        FERFees: Decimal;
        OMHFees: Decimal;
        ENVFees: Decimal;
        SalesLine: Record "Sales Line";
        TotalFeesAmount: Decimal;
        TVARedevance: Decimal;
        TauxTVA: Decimal;
        TVAArticle: Decimal;
        HTHorsRedevance: Decimal;
        TauxTVAArticle: Decimal;
        TauxTVARedevance: Decimal;
        TotalTVA: Decimal;
        HTAFacturer: Decimal;
    begin

        AddOnSetup.Get;
        AddOnSetup2.Get;

        if AddOnSetup."Cancel Fees Retention Posting" then exit;
        Cust2.Get(SalesH."Sell-to Customer No.");
        if Cust2."GDP Partner" then exit;

        if SalesH."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesH."Currency Code");

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesH."Document Type");
        SalesLine.SetRange("Document No.", SalesH."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        //SalesLine.SETFILTER("Qty. to Invoice",'<>0');
        if SalesLine.FindSet then
            repeat

                OMHFees := 0;
                FERFees := 0;
                ENVFees := 0;
                RDSFees := 0;
                TauxTVA := 0;
                Item1.Get(SalesLine."No.");
                if Item1."VAT Correction" then begin
                    AfkCalculateFeesRetention(SalesLine, Item1, Cust2, FERFees, OMHFees, ENVFees, RDSFees);
                    TotalFeesAmount := OMHFees + FERFees + ENVFees + RDSFees;
                    if (TotalFeesAmount <> 0) then begin

                        HTAFacturer := SalesLine."Unit Price" * SalesLine."Qty. to Invoice";
                        HTHorsRedevance := HTAFacturer - TotalFeesAmount;
                        //VATPostingSetup.GET(SalesLine."VAT Bus. Posting Group",SalesLine."VAT Prod. Posting Group");
                        VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", Item1."VAT Prod. Posting Group");
                        TauxTVAArticle := VATPostingSetup."VAT %";
                        TVAArticle := Round(HTHorsRedevance * TauxTVAArticle / 100, Currency."Amount Rounding Precision");

                        AddOnSetup2.TestField(AddOnSetup2."Fee Redevance VAT%");
                        TauxTVARedevance := AddOnSetup2."Fee Redevance VAT%";

                        if (TauxTVAArticle = 0) then
                            TauxTVARedevance := 0;

                        TVARedevance := Round(TotalFeesAmount * TauxTVARedevance / 100, Currency."Amount Rounding Precision");

                        TotalTVA := TVAArticle + TVARedevance;
                        if (HTAFacturer <> 0) then
                            TauxTVA := Round(100 * TotalTVA / HTAFacturer, 0.0000000001);

                        //Edit151122
                        TVAArticle := TVAArticle + TVARedevance;
                        TVARedevance := 0;


                        if ((SalesLine."VAT %" <> TauxTVA)
                            or (SalesLine.VAT15Amount <> TVAArticle) or (SalesLine.VAT20Amount <> TVARedevance)) then begin
                            SalesLine."VAT %" := TauxTVA;
                            SalesLine.Validate(Amount);
                            SalesLine.VAT15Amount := TVAArticle;
                            SalesLine.VAT20Amount := TVARedevance;
                            SalesLine.Modify;
                        end;


                    end;
                end;

            until SalesLine.Next = 0;

        //AfkSalesPost.AfkCalculateFeesRetention
        //"VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
    end;

    procedure AfkCalculateFeesRetention(SalesLine1: Record "Sales Line"; Item1: Record Item; Cust2: Record Customer; var FERFees: Decimal; var OMHFees: Decimal; var ENVFees: Decimal; var RDSFees: Decimal)
    var
        RDSUnitPrice: Decimal;
    begin

        AddOnSetup.Get;
        RDSUnitPrice := Item1."RDS Fees Price";
        if not AddOnSetup."Activate RDS Fees Retention" then
            RDSUnitPrice := 0;

        if (Cust2."Sales Channel Code" <> AddOnSetup."Station Sales Channel") then //JN201118 Exclure client non reseaux
            RDSUnitPrice := 0;

        //Calculs
        if ((Cust2."Sales Channel Code" <> AddOnSetup."Bornage Sales Channel") and
          (Cust2."Sales Channel Code" <> AddOnSetup."Soute Sales Channel")) then
            FERFees := Round(Item1."FER Fees Price" * SalesLine1."Qty. to Invoice (Base)", Currency."Amount Rounding Precision");
        OMHFees := Round(Item1."OMH Fees Price" * SalesLine1."Qty. to Invoice (Base)", Currency."Amount Rounding Precision");
        ENVFees := Round(Item1."ENV Fees Price" * SalesLine1."Qty. to Invoice (Base)", Currency."Amount Rounding Precision");

        if AddOnSetup."Activate RDS Fees Retention" then
            RDSFees := Round(RDSUnitPrice * SalesLine1."Qty. to Invoice (Base)", Currency."Amount Rounding Precision");//RDS Fees JN030918
    end;

    procedure CalcBestUnitPrice(var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean; CalledByFieldNo: Integer)
    var
        SalesPrice: Record "Sales Price";
        BestSalesPrice: Record "Sales Price";
        SalesPricesMgt: codeunit "Sales Price Calc. Mgt.";
        Item: record Item;
        BestSalesPriceFound: Boolean;
        IsHandled: Boolean;
    begin
        //*************************************************************
        //Maj prendre les prix les plus recents et les plus spécifiques
        //*************************************************************


        //Dernier prix spécifique
        SalesPrice.RESET;
        SalesPrice.SETCURRENTKEY("Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
        SalesPrice.SETRANGE(SalesPrice."Sales Type", SalesPrice."Sales Type"::Customer);
        IF SalesPrice.FINDSET THEN
            REPEAT
                IF SalesPrice."Starting Date" >= BestSalesPrice."Starting Date" THEN BEGIN
                    BestSalesPrice := SalesPrice;
                    FoundSalesPrice := TRUE;
                END;
            UNTIL SalesPrice.NEXT = 0;

        //Dernier prix de groupe
        IF NOT BestSalesPriceFound THEN BEGIN
            SalesPrice.RESET;
            SalesPrice.SETCURRENTKEY("Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            SalesPrice.SETRANGE(SalesPrice."Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
            IF SalesPrice.FINDSET THEN
                REPEAT
                    IF SalesPrice."Starting Date" >= BestSalesPrice."Starting Date" THEN BEGIN
                        BestSalesPrice := SalesPrice;
                        FoundSalesPrice := TRUE;
                    END;
                UNTIL SalesPrice.NEXT = 0;
        END;


        //Dernier prix Tous
        IF NOT BestSalesPriceFound THEN BEGIN
            SalesPrice.RESET;
            SalesPrice.SETCURRENTKEY("Sales Type", "Sales Code", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
            SalesPrice.SETRANGE(SalesPrice."Sales Type", SalesPrice."Sales Type"::"All Customers");
            IF SalesPrice.FINDSET THEN
                REPEAT
                    IF SalesPrice."Starting Date" >= BestSalesPrice."Starting Date" THEN BEGIN
                        BestSalesPrice := SalesPrice;
                        FoundSalesPrice := TRUE;
                    END;
                UNTIL SalesPrice.NEXT = 0;
        END;

        // No price found in agreement
        if Item.Get(SalesLine."No.") then;
        if not FoundSalesPrice then begin
            SalesPricesMgt.ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            ConvertPriceToUoM('', Item."Unit Price", SalesLine);
            SalesPricesMgt.ConvertPriceLCYToFCY('', Item."Unit Price");

            Clear(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
            BestSalesPrice."Allow Line Disc." := SalesLine."Allow Line Disc.";
            BestSalesPrice."Allow Invoice Disc." := SalesLine."Allow Invoice Disc.";
        end;

        TempSalesPrice := BestSalesPrice;
    end;

    local procedure ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; var UnitPrice: Decimal; SalesLine: record "Sales Line")
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * SalesLine."Qty. per Unit of Measure";
    end;
}

