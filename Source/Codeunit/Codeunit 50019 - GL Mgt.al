codeunit 50019 "GL Mgt"
{

    trigger OnRun()
    begin
        Message('%1',20230321D-20230201D);
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

    procedure ConvertInLocalCurr(CodeDevise: Code[20];PostingDate: Date;AmountToConvert: Decimal) Reponse: Decimal
    begin
        if CodeDevise='' then
          Reponse := AmountToConvert
        else
          Reponse :=
                Round(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    PostingDate,CodeDevise,AmountToConvert,
                    CurrExchRate.ExchangeRate(PostingDate,CodeDevise)));
    end;

    procedure GetPostingAllowedDatesOnGroupsUsers(var AllowPostingFrom: Date;var AllowPostingTo: Date;var SetupRecordID: RecordID)
    var
        UserGroupMember: Record "User Group Member";
        UserGroup: Record "User Group";
    begin
        AddOnSetup.Get;
        if not AddOnSetup."GL Security On Group Users" then exit;

        UserGroupMember.Reset;
        UserGroupMember.SetRange("User Name",UserId);
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
        if not ParamGL.Get(GLAccount."Gen. Bus. Posting Group",GLAccount."Gen. Prod. Posting Group") then
          Error(Text020,GLAcc);
    end;

    procedure CreateAdjustmentNaphta(ItemJournalLine: Record "Item Journal Line";OrderNo: Code[20])
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        if ItemJournalLine.Quantity=0 then exit;

        if ((ItemJournalLine."Document Type" <> ItemJnlLine."Document Type"::"Sales Return Receipt")
        and  (ItemJournalLine."Document Type" <> ItemJnlLine."Document Type"::"Sales Shipment"))
         then exit;

        Item1.Get(ItemJournalLine."Item No.");

        SourceCodeSetup.Get;
        AddOnSetup.Get;
        SourceCode := SourceCodeSetup."Item Journal";

        if not AddOnSetup."Activer ajustement Naphta" then exit;

        AddOnSetup.TestField("Naphta Fictif Location");
        if Item1."Product Group Code"<>AddOnSetup."Naphta Product Group" then exit;

        ItemJnlLine.Init;
        ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AjustNaphta;
        ItemJnlLine."Posting Date" := ItemJournalLine."Posting Date";
        ItemJnlLine."Document Date" := ItemJournalLine."Posting Date";
        ItemJnlLine."Document No." := ItemJournalLine."Document No.";
        ItemJnlLine."External Document No." := ItemJournalLine."External Document No.";

        if ItemJournalLine."Document Type"=ItemJournalLine."Document Type"::"Sales Shipment" then//Livraison
          ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
        else//Avoir
          ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";


        ItemJnlLine.Validate("Item No." , ItemJournalLine."Item No.");
        ItemJnlLine.Description := StrSubstNo(AFK_Text001,OrderNo);

        ItemJnlLine.Validate("Location Code", AddOnSetup."Naphta Fictif Location");
        ItemJnlLine.Validate(Quantity , Abs(ItemJournalLine.Quantity));





        ItemJnlLine.Validate("Unit of Measure Code" , ItemJournalLine."Unit of Measure Code");
        ItemJnlLine."Invoiced Quantity" := Abs(ItemJournalLine.Quantity);
        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

        ItemJnlLine."Shortcut Dimension 1 Code" := ItemJournalLine."Shortcut Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := ItemJournalLine."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := ItemJournalLine."Dimension Set ID";

        ItemJnlLine.Validate(ItemJnlLine."Unit Amount",0);

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;

    procedure CheckPlageCheques(BankAcc2: Record "Bank Account";UseCheckNo: Code[20])
    begin
        //**********************************************************
        //**********************************************************
        AddOnSetup.Get;
        if not AddOnSetup."Desactivate Check Nos Control" then
          if not NoSeriesMgt.AFK_IsInPlage(UseCheckNo,BankAcc2."Starting Check No.",BankAcc2."Ending Check No.") then
            Error(StrSubstNo(AFK_Err0001,UseCheckNo,BankAcc2."Starting Check No.",BankAcc2."Ending Check No."));
        //**********************************************************
        //**********************************************************
    end;

    procedure ValidateItem(Item1: Record Item;Status: Integer)
    begin

        if Status=0 then begin
          if not Confirm(StrSubstNo(AFK_Text003,Item1."No.",Item1.Description)) then exit;
          if Item1."Validation Status" <> Item1."Validation Status"::Created then exit;
          Item1."Validation Status" := Item1."Validation Status"::InWorkflowCDG;
          Item1."Created By UserID" := UserId;
          Item1."Created By Date" := Today;
        end;

        if Status=1 then begin
          if not Confirm(StrSubstNo(AFK_Text008,Item1."No.",Item1.Description)) then exit;
          if Item1."Validation Status" <> Item1."Validation Status"::InWorkflowCDG then exit;

          Item1."Validation Status" := Item1."Validation Status"::InWorkflowFOUR;
          Item1."Validated CDG By UserID" := UserId;
          Item1."Validated CDG By Date" := Today;
        end;

        if Status=2 then begin

          if not SecMgt.CanValidateItems then Error(AFK_Text007);

          if not Confirm(StrSubstNo(AFK_Text004,Item1."No.",Item1.Description)) then exit;
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

    procedure ValidateVendor(Vend1: Record Vendor;Status: Integer)
    begin

        if Status=0 then begin
          if not Confirm(StrSubstNo(AFK_Text005,Vend1."No.",Vend1.Name)) then exit;
          if Vend1."Validation Status" <> Vend1."Validation Status"::Created then exit;
          Vend1."Validation Status" := Vend1."Validation Status"::InWorkflow;
          Vend1."Created By UserID" := UserId;
          Vend1."Created By Date" := Today;
        end;

        if Status=1 then begin

          if not SecMgt.CanValidateVendors then Error(AFK_Text007);

          if not Confirm(StrSubstNo(AFK_Text006,Vend1."No.",Vend1.Name)) then exit;
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

    procedure AddGLInfos(GenJrnLine1: Record "Gen. Journal Line";GLEntryNo: Integer)
    var
        GLInfos: Record "G/l Entry Infos";
    begin
        if not DoAddInfos(GenJrnLine1) then
          exit;

        Clear(GLInfos);
        GLInfos."Entry No.":= GLEntryNo;
        GLInfos."Item No." := GenJrnLine1.CodeArticleProvisions;
        GLInfos.TypeProvision := GenJrnLine1.TypeProvision;
        GLInfos."Vendor Code" := GenJrnLine1.VendorCodeProvisions;
        GLInfos.Insert;
    end;

    local procedure DoAddInfos(GenJrnLine: Record "Gen. Journal Line"): Boolean
    begin
        if GenJrnLine.CodeArticleProvisions <> '' then exit (true);
        if GenJrnLine.VendorCodeProvisions <> '' then exit (true);
    end;

    procedure UpdateReconciliationInfos(GenJrnLine2: Record "Gen. Journal Line";GLEntryNo: Integer)
    var
        ReconInfo: Record "Reconciliation Info";
    begin
        ReconInfo.Reset;
        ReconInfo.SetRange("Customer No.",GenJrnLine2."Account No.");
        ReconInfo.SetRange("Journal Template Name",GenJrnLine2."Journal Template Name");
        ReconInfo.SetRange("Journal Batch Name",GenJrnLine2."Journal Batch Name");
        ReconInfo.SetRange("Line No.",GenJrnLine2."Line No.");
        ReconInfo.ModifyAll("G/L Entry No",GLEntryNo);
        ReconInfo.ModifyAll(ReconInfo."Journal Batch Name",'');
        ReconInfo.ModifyAll(ReconInfo."Journal Template Name",'');
    end;
}

