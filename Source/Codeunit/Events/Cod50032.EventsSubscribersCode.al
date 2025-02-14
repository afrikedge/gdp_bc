codeunit 50032 "EventsSubscribers Code"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"AccSchedManagement", 'OnBeforeTestBalance', '', true, true)]
    local procedure AccSchedManagement_OnBeforeTestBalance(var GLAccount: Record "G/L Account"; var AccScheduleName: Record "Acc. Schedule Name"; var AccScheduleLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; AmountType: Integer; var ColValue: Decimal; CalcAddCurr: Boolean; var TestBalance: Boolean; var GLEntry: Record "G/L Entry"; var GLBudgetEntry: Record "G/L Budget Entry"; var Balance: Decimal)
    begin
        if (AmountType = 0) then begin  //"Account Schedule Amount Type"::"Net Amount"
            IF AccScheduleLine."Creditor Balance" THEN
                IF ColValue < 0 THEN
                    ColValue := ABS(ColValue)
                ELSE
                    ColValue := 0;

            IF AccScheduleLine."Debitor Balance" THEN
                IF ColValue > 0 THEN
                    ColValue := ABS(ColValue)
                ELSE
                    ColValue := 0;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnCheckDimensionsOnAfterAssignDimTableIDs', '', true, true)]
    local procedure GenJnlCheckLine_OnCheckDimensionsOnAfterAssignDimTableIDs(var GenJournalLine: Record "Gen. Journal Line"; var TableID: array[10] of Integer; var No: array[10] of Code[20]; var CheckDone: Boolean)
    var
        SingleInstanceCu: Codeunit SingleInstance;
    begin
        if (SingleInstanceCu.Get_AFK_EscapeCheck_MultiLevelAdjmt()) then
            CheckDone := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"User Setup Management", 'OnBeforeIsPostingDateValidWithSetup', '', true, true)]
    local procedure UserSetupManagement_OnBeforeIsPostingDateValidWithSetup(PostingDate: Date; var Result: Boolean; var IsHandled: Boolean; var SetupRecordID: RecordID)
    var
        GLSetup: record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AFKGLMgt: Codeunit "GL Mgt";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
    begin
        IsHandled := true;

        if UserId <> '' then
            if UserSetup.Get(UserId) then begin
                UserSetup.CheckAllowedPostingDates(1);
                AllowPostingFrom := UserSetup."Allow Posting From";
                AllowPostingTo := UserSetup."Allow Posting To";
                SetupRecordID := UserSetup.RecordId;
            end;

        //******
        AFKGLMgt.GetPostingAllowedDatesOnGroupsUsers(AllowPostingFrom, AllowPostingTo, SetupRecordID);
        //******

        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            GLSetup.GetRecordOnce();
            GLSetup.CheckAllowedPostingDates(1);
            AllowPostingFrom := GLSetup."Allow Posting From";
            AllowPostingTo := GLSetup."Allow Posting To";
            SetupRecordID := GLSetup.RecordId;
        end;

        if AllowPostingTo = 0D then
            AllowPostingTo := DMY2Date(31, 12, 9999);

        Result := PostingDate in [AllowPostingFrom .. AllowPostingTo];
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnCodeOnBeforeFinishPosting', '', true, true)]
    local procedure GenJnlPostLine_OnCodeOnBeforeFinishPosting(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; FirstEntryNo: Integer)
    var
        AFK_MoneyTechMgt: Codeunit "Conso by Cards Mgt";
        AFK_ProvisionMgt: Codeunit "Provisions Cde Mgt";
        AFK_ProvisionItemMgt: Codeunit "Provisions Item Mgt";
    begin
        if GenJournalLine."MoneyTech Import No." <> '' then
            AFK_MoneyTechMgt.PostMoneyTechTrans(GenJournalLine."MoneyTech Import No.");

        if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::Order then
            AFK_ProvisionMgt.ConfirmProvisions(GenJournalLine."External Document No.", GenJournalLine.VolumeProvisions);

        if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::VarStock then
            AFK_ProvisionMgt.ConfirmProvisionsVarStock(GenJournalLine."External Document No.", GenJournalLine.VolumeProvisions);

        if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::Passage then
            AFK_ProvisionItemMgt.ConfirmProvisionsPassage(GenJournalLine."DateDeb Provisions", GenJournalLine."DateFin Provisions");

        if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::PassageTransfer then
            AFK_ProvisionItemMgt.ConfirmProvisionsPassageTransfert(GenJournalLine."DateDeb Provisions", GenJournalLine."DateFin Provisions");

        if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::Transfer then
            AFK_ProvisionItemMgt.ConfirmProvisionsTransfert(GenJournalLine."DateDeb Provisions", GenJournalLine."DateFin Provisions", GenJournalLine.NumDocProvisions);

        if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::TransportVente then
            AFK_ProvisionItemMgt.ConfirmProvisionsTransportVente(GenJournalLine."DateDeb Provisions", GenJournalLine."DateFin Provisions");

        // if GenJournalLine.TypeProvision = GenJournalLine.TypeProvision::Cargo then
        //     AFKItemCargoMgt.ConfirmerAjustementCargo(GenJournalLine);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGLAcc', '', true, true)]
    local procedure GenJnlPostLine_OnBeforePostGLAcc(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var GLEntryNo: Integer; var IsHandled: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
    begin
        if GenJournalLine."CC Document Type" = GenJournalLine."CC Document Type"::ChequeGarantie then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostCust', '', true, true)]
    local procedure GenJnlPostLine_OnBeforePostCust(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var IsHandled: Boolean)
    var
    begin
        if GenJournalLine."CC Document Type" = GenJournalLine."CC Document Type"::ChequeGarantie then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostVend', '', true, true)]
    local procedure GenJnlPostLine_OnBeforePostVend(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
    begin
        if GenJournalLine."CC Document Type" = GenJournalLine."CC Document Type"::ChequeGarantie then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostBankAcc', '', true, true)]
    local procedure GenJnlPostLine_OnBeforePostBankAcc(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
    begin
        if GenJournalLine."CC Document Type" = GenJournalLine."CC Document Type"::ChequeGarantie then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCheckGLAccDirectPosting', '', true, true)]
    local procedure GenJnlPostLine_OnBeforeCheckGLAccDirectPosting(var GenJournalLine: Record "Gen. Journal Line"; GLAcc: Record "G/L Account"; var IsHandled: Boolean)
    var
    begin
        IsHandled := true;
        if not GenJournalLine."System-Created Entry" then
            if GenJournalLine."Posting Date" = NormalDate(GenJournalLine."Posting Date") then
                IF GenJournalLine."CC Document Type" = GenJournalLine."CC Document Type"::" " THEN
                    GLAcc.TestField("Direct Posting", true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', true, true)]
    local procedure GenJnlPostLine_OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    var
    begin
        CustLedgerEntry."Check Date" := GenJournalLine."Check Date";
        CustLedgerEntry."Check No." := GenJournalLine."Check No.";
        CustLedgerEntry."CC Document Type" := GenJournalLine."CC Document Type";
        CustLedgerEntry."Transaction Date" := TODAY;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', true, true)]
    local procedure GenJnlPostLine_OnAfterInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    var
    begin
        VendorLedgerEntry."Transaction Date" := TODAY;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', true, true)]
    local procedure GenJnlPostLine_OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        AFK_SecMgt: codeunit "Security Mgt";
    begin
        AFK_SecMgt.CheckCanUseBankAcc(GenJournalLine."Account No.");
        BankAccountLedgerEntry."Check Date" := GenJournalLine."Check Date";
        BankAccountLedgerEntry."Check No." := GenJournalLine."Check No.";
        BankAccountLedgerEntry."CC Document Type" := GenJournalLine."CC Document Type";

        IF GenJournalLine."Origin Type" = GenJournalLine."Origin Type"::LC THEN BEGIN
            BankAccountLedgerEntry."LC Number" := GenJournalLine."Origin No.";
            BankAccountLedgerEntry."LC Curr Purchase Line No." := GenJournalLine."Origin Line No.";
        END;
        IF GenJournalLine."Origin Type" = GenJournalLine."Origin Type"::EchPayment THEN BEGIN
            BankAccountLedgerEntry."LC Number" := GenJournalLine."Origin No.";
            BankAccountLedgerEntry."LC Ech Payment Line No." := GenJournalLine."Origin Line No.";
        END;
        BankAccountLedgerEntry."Transaction Date" := TODAY;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', true, true)]
    local procedure GenJnlPostLine_OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    var
        AFKGenMgt: codeunit "GL Mgt";
    begin
        AFKGenMgt.AddGLInfos(GenJournalLine, GLEntry."Entry No.");
        GLEntry."Transaction Date" := TODAY;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterPostApply', '', true, true)]
    local procedure GenJnlPostLine_OnAfterPostApply(GenJnlLine: Record "Gen. Journal Line"; var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer"; var NewCVLedgEntryBuf2: Record "CV Ledger Entry Buffer")
    var
        GestFacturesFourn: codeunit VendorInvoiceMgt;
        AFK_DoNotCheckPayment: Boolean;
    begin
        AFK_DoNotCheckPayment := false;
        //AFKAddOnSetup.GET;
        IF ((NewCVLedgEntryBuf."Document No." = NewCVLedgEntryBuf."Applies-to Doc. No.")
              AND (GenJnlLine.Destinataire = 'AFK_RETENUE')) THEN
            AFK_DoNotCheckPayment := TRUE;//Retenue a la source, ne pas controler
        IF NOT AFK_DoNotCheckPayment THEN
            GestFacturesFourn.ValidationAutoPaiement(OldCVLedgEntryBuf."CV No.",
              OldCVLedgEntryBuf."External Document No.", GenJnlLine."Document No.",
              NewCVLedgEntryBuf."External Document No.", OldCVLedgEntryBuf."Document No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeRaiseExceedLengthError', '', true, true)]
    local procedure GenJnlPostBatch_OnBeforeRaiseExceedLengthError(var GenJournalBatch: Record "Gen. Journal Batch"; var RaiseError: Boolean; var GenJnlLine: Record "Gen. Journal Line")
    var
        AFK_SecMgt: codeunit "Security Mgt";
    begin
        AFK_SecMgt.CheckAccessUserJournal(GenJnlLine, FALSE, TRUE);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnAfterPostGenJournalLine', '', true, true)]
    local procedure GenJnlPostBatch_OnAfterPostGenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; var Result: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        AFKTresoMgt: codeunit "Treso Mgt";
        SingleInstanceCu: Codeunit SingleInstance;
    begin
        IF SingleInstanceCu.Get_SendVendorEmails_AFK() THEN
            AFKTresoMgt.CreateDocEmailVendorTransfer(GenJournalLine);

        AFKTresoMgt.AFK_ProcessFeuilleReglementCCL(GenJournalLine);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterGetItem', '', true, true)]
    local procedure ItemJnlCheckLine_OnAfterGetItem(Item: Record Item; var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    var
        AddonSetup2: record "AddOn Setup2";
        AFK_SecMgt: Codeunit "Security Mgt";
    begin
        Item.TESTFIELD(Item."Validation Status", Item."Validation Status"::Validated);
        IF (AddonSetup2."Block zero unit cost") THEN
            ItemJournalLine.TESTFIELD("Unit Cost");
        IF ItemJournalLine.Quantity <> 0 THEN
            AFK_SecMgt.CheckWarehouseUser(ItemJournalLine."Location Code");

        ////Controle du cargo pour les ajustements positifs de PBL sur feuille
        //   AddonSetup.GET;
        //   IF ItemJnlLine."Adjustment Type"=ItemJnlLine."Adjustment Type"::" " THEN
        //     IF ((ItemJnlLine."Entry Type"=ItemJnlLine."Entry Type"::"Positive Adjmt.") OR
        //           (ItemJnlLine."Entry Type"=ItemJnlLine."Entry Type"::Purchase)) THEN
        //       BEGIN
        //         //AddonSetup.TESTFIELD(AddonSetup."PBL Category Code");
        //         //IF ItemJnlLine."Item Category Code" = AddonSetup."PBL Category Code" THEN
        //         IF Item."Cargo Mgt" THEN 
        //           IF NOT AddonSetup."Desactivate Stock Value Mgt" THEN
        //             IF ((ItemJnlLine."Document Type"=ItemJnlLine."Document Type"::"Purchase Receipt")
        //               OR (ItemJnlLine."Document Type"=ItemJnlLine."Document Type"::"Purchase Invoice")) THEN //***
        //                 IF ItemJnlLine.Quantity <>0 THEN            //JN180917 
        //                   ItemJnlLine.TESTFIELD(ItemJnlLine."Ref Cargo");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    local procedure ItemJnlPostLine_OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        Item: record Item;
    begin

        Item.Get(ItemJournalLine."Item No.");

        NewItemLedgEntry."Adjustment Type" := ItemJournalLine."Adjustment Type";

        IF ItemJournalLine."Adjustment Type" <> ItemJournalLine."Adjustment Type"::"Invoiced Conso" THEN//ADDED***
            IF NewItemLedgEntry.Description = Item.Description THEN
                NewItemLedgEntry.Description := '';

        NewItemLedgEntry."Adjustment Type" := ItemJournalLine."Adjustment Type";
        NewItemLedgEntry."Ref Cargo" := ItemJournalLine."Ref Cargo";
        NewItemLedgEntry."Reason Code" := ItemJournalLine."Reason Code";
        NewItemLedgEntry."User ID" := USERID;
        NewItemLedgEntry."Transaction Date" := TODAY;
        NewItemLedgEntry."Type Ecr Cargo" := ItemJournalLine."Type Ecr Cargo";
        NewItemLedgEntry."Sales Channel Code" := ItemJournalLine."Sales Channel Code";
        NewItemLedgEntry."LUB Expiration Date" := ItemJournalLine."LUB Expiration Date";//JN110321
        NewItemLedgEntry."Batch Number" := ItemJournalLine."Batch Number";//JN110321

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', true, true)]
    local procedure ItemJnlCheckLine_OnAfterInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var ValueEntryNo: Integer; var ItemApplnEntryNo: Integer; GlobalValueEntry: Record "Value Entry"; TransferItem: Boolean; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; var OldItemLedgerEntry: Record "Item Ledger Entry")
    var
    begin
        //IF (Item."Item Category Code"=AFKSetup."PBL Category Code") THEN 
        // AFK_CargoMgt.FillCargoEntries(ItemLedgEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterGetGLSetup', '', true, true)]
    local procedure ItemJnlCheckLine_GeneralLedgerSetup(var GeneralLedgerSetup: Record "General Ledger Setup")
    var
        AFKSetup: record "AddOn Setup";
    begin
        AFKSetup.GET;
        AFKSetup.TESTFIELD(AFKSetup."PBL Category Code");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure SalesPost_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        AFKSetup: record "AddOn Setup";
    begin
        AFKSetup.GET;
        AFKSetup.TESTFIELD(AFKSetup."PBL Category Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckAndUpdate', '', true, true)]
    local procedure SalesPost_OnBeforeCheckAndUpdate(var SalesHeader: Record "Sales Header"; var ModifyHeader: Boolean)
    var
        AddOnSetup: record "AddOn Setup";
        AFKCust: Record Customer;
        AFK_Prov_Mgt: codeunit "Provisions Cde Mgt";
        AFK_SalesPostControl: codeunit "Sales Order Process";
        AFKErr001: Label 'Le document sera validé à la date du %1. Voulez-vous continuer ?';
        AFKErr002: Label 'Le client à facturer %1 ne doit pas être différent du code client !';
    begin
        AFK_SalesPostControl.CheckCanPostSalesOrder(SalesHeader);

        AddOnSetup.GET;
        IF SalesHeader.Invoice THEN BEGIN

            IF NOT CONFIRM(STRSUBSTNO(AFKErr001, SalesHeader."Posting Date")) THEN ERROR('');

            AFKCust.GET(SalesHeader."Sell-to Customer No.");

            IF AFKCust."Sales Channel Code" <> AddOnSetup."JIRAMA Sales Channel" THEN  //180319 Only JIRAMA Customer
                IF SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." THEN
                    ERROR(AFKErr002, SalesHeader."Bill-to Customer No.");

            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                AFK_Prov_Mgt.CheckEcrituresProvisions(SalesHeader."No.");


            IF NOT AddOnSetup."Skip AMSA/JIRAMA Docs Control" THEN BEGIN
                IF AFKCust."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel" THEN BEGIN
                    //Rec.TESTFIELD(Rec."JIRAMA Invoice No.");
                    //Rec.TESTFIELD(Rec."JIRAMA Order Ref.");
                END;
                IF AFKCust."Sales Channel Code" = AddOnSetup."AMSA Sales Channel" THEN BEGIN
                    //Rec.TESTFIELD(Rec."AMSA Cost Code");
                END;
            END;

        END;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCalcVATAmountLines', '', true, true)]
    local procedure SalesPost_OnRunOnBeforeCalcVATAmountLines(var TempSalesLineGlobal: Record "Sales Line" temporary; var SalesHeader: Record "Sales Header"; var TempVATAmountLine: Record "VAT Amount Line" temporary; var IsHandled: Boolean)
    var
        AfkReleaseDoc: codeunit "GL Mgt";
    begin
        IF SalesHeader.Invoice THEN
            AfkReleaseDoc.VATCorrectionGDP(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', true, true)]
    local procedure SalesPost_OnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; PostedWhseShipmentLine: Record "Posted Whse. Shipment Line"; SalesHeader: Record "Sales Header"; WhseShip: Boolean; WhseReceive: Boolean; ItemLedgShptEntryNo: Integer; xSalesLine: record "Sales Line"; var TempSalesLineGlobal: record "Sales Line" temporary; var IsHandled: Boolean)
    var
        AfkReleaseDoc: codeunit "GL Mgt";
    begin
        SalesShptLine."Your Reference" := SalesHeader."Your Reference";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    local procedure SalesPost_OnAfterPostSalesLines(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        AFK_ConsignationMgt: codeunit "Item Consignation Mgt";
        AFK_SortieRefact: codeunit "Item Invoiced Conso Mgt";
    begin
        AFK_ConsignationMgt.ConfirmConsignationSalesQty(SalesInvoiceHeader);
        AFK_SortieRefact.ConfirmSortieSalesInv(SalesInvoiceHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePosting', '', true, true)]
    local procedure SalesPost_OnAfterFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        SalesWflwMgt: codeunit "Sales Order Process";
    begin
        SalesWflwMgt.ValidationAuto(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnDeleteAfterPostingOnBeforeDeleteSalesHeader', '', true, true)]
    local procedure SalesPost_OnDeleteAfterPostingOnBeforeDeleteSalesHeader(var SalesHeader: Record "Sales Header")
    var
        SalesWflwMgt: codeunit "Sales Order Process";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        SalesWflwMgt.ValidationAutoFacturationTotale(SalesHeader);
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostItemJnlLineOnBeforeCopyTrackingFromSpec', '', true, true)]
    local procedure SalesPost_OnPostItemJnlLineOnBeforeCopyTrackingFromSpec(TrackingSpecification: Record "Tracking Specification"; var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; IsATO: Boolean)
    var
        CustAFK: record "Customer";
    begin
        IF CustAFK.GET(SalesHeader."Sell-to Customer No.") THEN
            ItemJnlLine."Sales Channel Code" := CustAFK."Sales Channel Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostItemJnlLine', '', true, true)]
    local procedure SalesPost_OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line"; OriginalItemJnlLine: Record "Item Journal Line"; var ItemShptEntryNo: Integer; IsATO: Boolean; var TempHandlingSpecification: Record "Tracking Specification"; var TempATOTrackingSpecification: Record "Tracking Specification"; TempWarehouseJournalLine: Record "Warehouse Journal Line" temporary; ShouldPostItemJnlLine: Boolean)
    var
        AFK_ItemMgt: Codeunit "GL Mgt";
    begin
        AFK_ItemMgt.CreateAdjustmentNaphta(ItemJournalLine, SalesHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
    local procedure SalesPostYesNo_OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
    var
        AFK_SalesProcess: Codeunit "Sales Order Process";
        AFKErr01: Label 'Option non disponible, sélectionnez Livrer ou Facturer';
    begin
        if (SalesHeader.Ship and SalesHeader.Invoice) then
            if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
                error(AFKErr01);
        if SalesHeader.Ship then
            AFK_SalesProcess.CheckCanShipSalesOrder(SalesHeader);
        AFK_SalesProcess.CheckCanPostSalesOrder(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnAfterConfirmPost', '', true, true)]
    local procedure SalesPostPrint_OnAfterConfirmPost(var SalesHeader: Record "Sales Header")
    var
        AFK_SalesProcess: Codeunit "Sales Order Process";
        AFKErr01: Label 'Option non disponible, sélectionnez Livrer ou Facturer';
    begin
        if (SalesHeader.Ship and SalesHeader.Invoice) then
            if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then
                error(AFKErr01);
        if SalesHeader.Ship then
            AFK_SalesProcess.CheckCanShipSalesOrder(SalesHeader);
        AFK_SalesProcess.CheckCanPostSalesOrder(SalesHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeArchiveSalesQuote', '', true, true)]
    local procedure SalesQuotetoOrder_OnBeforeArchiveSalesQuote(var SalesQuoteHeader: Record "Sales Header"; var SalesOrderHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        IsHandled := true;
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesQuoteHeader);
        SalesQuoteHeader.TESTFIELD(Status, SalesQuoteHeader.Status::Released);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCheckPostRestrictions', '', true, true)]
    local procedure PurchPost_OnBeforeCheckPostRestrictions(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        AFK_Prov_Mgt: Codeunit "Provisions Cde Mgt";
        TextAFK002: label 'Le code fournisseur à payer %1 ne doit pas être différent de code fournisseur';
    begin
        //AddOnSetup.GET;

        IF PurchaseHeader."Pay-to Vendor No." <> PurchaseHeader."Buy-from Vendor No." THEN
            ERROR(TextAFK002, PurchaseHeader."Pay-to Vendor No.");

        IF PurchaseHeader.Invoice THEN
            IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN
                AFK_Prov_Mgt.CheckEcrituresProvisions(PurchaseHeader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertPostedHeaders', '', true, true)]
    local procedure PurchPost_OnAfterInsertPostedHeaders(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var PurchSetup: Record "Purchases & Payables Setup"; var Window: Dialog)
    var
        Cargo: record Cargo;
        AFK_Prov_Mgt: Codeunit "Provisions Cde Mgt";
        AFKVendInvMgt: Codeunit VendorInvoiceMgt;
        TextAFK002: label 'Le code fournisseur à payer %1 ne doit pas être différent de code fournisseur';
    begin
        //AddOnSetup.GET;
        IF PurchaseHeader.Receive THEN
            if (Cargo.Get(PurchaseHeader."Ref Cargo")) then
                if (PurchaseHeader."Currency Factor" <> 0) then begin
                    Cargo."Exchange Rate" := (1 / PurchaseHeader."Currency Factor");
                    Cargo.Modify();
                end;

        IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice THEN
            IF PurchaseHeader."Created By Doc Type" = PurchaseHeader."Created By Doc Type"::ProvisionsFA THEN
                AFK_Prov_Mgt.ConfirmProvisionsFA(PurchaseHeader."No.", PurchaseHeader."Posting No.");

        //   IF PurchaseHeader.Invoice THEN
        //     IF ((PurchaseHeader."Document Type"=PurchaseHeader."Document Type"::Invoice) OR //121017
        //       (PurchaseHeader."Document Type"=PurchaseHeader."Document Type"::Order))THEN
        //         AFK_MFilesMgt.CheckMFilesOrder(PurchaseHeader);

        // IF PurchaseHeader.Invoice THEN
        //     AFKVendInvMgt.ValidationAutoFactureCompta(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', true, true)]
    local procedure PurchPost_OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean)
    var
        AFKVendInvMgt: Codeunit VendorInvoiceMgt;
    begin

        //IF PurchaseHeader.Invoice THEN
        AFKVendInvMgt.ValidationAutoFactureCompta(PurchHeader, Abs(TotalPurchLine."Amount Including VAT"), abs(TotalPurchLine.Amount));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean)
    begin
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchase-Post Prepayments", 'OnBeforePostVendorEntry', '', true, true)]
    // local procedure PurchasePostPrepayments_OnBeforePostVendorEntry(var GenJnlLine: Record "Gen. Journal Line"; TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer"; CommitIsSupressed: Boolean; PurchaseHeader: Record "Purchase Header"; DocumentType: Option)
    // var
    //     AFKVendInvMgt: Codeunit VendorInvoiceMgt;
    // begin
    //     //IF PurchaseHeader.Invoice THEN
    //     AFKVendInvMgt.ValidationAutoFactureCompta(PurchaseHeader, abs(TotalPrepmtInvLineBuffer."Amount Incl. VAT"), abs(TotalPrepmtInvLineBuffer.Amount));
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostInvoice', '', true, true)]
    local procedure PurchPost_OnAfterPostInvoice(var PurchHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; TotalPurchLine: Record "Purchase Line"; TotalPurchLineLCY: Record "Purchase Line"; CommitIsSupressed: Boolean; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        VendAFK: Record Vendor;
        AFKVendPostingGroup: Record "Vendor Posting Group";
        SourceDeductionBaseAmt: Decimal;
        SourceDeductionBaseAmtLCY: Decimal;
        GenJnlLine: Record "Gen. Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: record Currency;
        TextAFK001: label 'La retenue à la source ne doit pas être activée en cas d''achat au comptant';
    begin
        IF PurchHeader."Vendor Retention Posting Group" <> '' THEN begin
            IF PurchHeader."Bal. Account No." <> '' THEN
                ERROR(TextAFK001);
            AFKVendPostingGroup.GET(PurchHeader."Vendor Retention Posting Group");
            AFKVendPostingGroup.TESTFIELD("Retention Account");

            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := PurchHeader."Posting Date";
            GenJnlLine."Document Date" := PurchHeader."Document Date";
            GenJnlLine.Description := PurchHeader."Posting Description";
            GenJnlLine."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := PurchHeader."Dimension Set ID";
            GenJnlLine."Reason Code" := PurchHeader."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine."Account No." := PurchHeader."Pay-to Vendor No.";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
            GenJnlLine."Document No." := VendorLedgerEntry."Document No.";
            GenJnlLine."External Document No." := VendorLedgerEntry."External Document No.";
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := AFKVendPostingGroup."Retention Account";
            GenJnlLine."Currency Code" := PurchHeader."Currency Code";

            SourceDeductionBaseAmtLCY := TotalPurchLineLCY.Amount;
            SourceDeductionBaseAmt :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                PurchHeader."Posting Date", PurchHeader."Currency Code",
                SourceDeductionBaseAmtLCY, PurchHeader."Currency Factor");

            GenJnlLine.Amount := ROUND(SourceDeductionBaseAmt * (AFKVendPostingGroup."Retention %" / 100), Currency."Amount Rounding Precision");
            GenJnlLine.Correction := PurchHeader.Correction;
            GenJnlLine."Source Currency Code" := PurchHeader."Currency Code";
            GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
            GenJnlLine.Destinataire := 'AFK_RETENUE';

            GenJnlLine."Amount (LCY)" := ROUND(SourceDeductionBaseAmtLCY * (AFKVendPostingGroup."Retention %" / 100));
            IF PurchHeader."Currency Code" = '' THEN
                GenJnlLine."Currency Factor" := 1
            ELSE
                GenJnlLine."Currency Factor" := PurchHeader."Currency Factor";
            GenJnlLine."Applies-to Doc. Type" := VendorLedgerEntry."Document Type";
            GenJnlLine."Applies-to Doc. No." := VendorLedgerEntry."Document No.";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
            GenJnlLine."Source No." := PurchHeader."Pay-to Vendor No.";
            GenJnlLine."Source Code" := VendorLedgerEntry."Source Code";
            GenJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
            GenJnlLine."IC Partner Code" := PurchHeader."Pay-to IC Partner Code";
            GenJnlLine."Allow Zero-Amount Posting" := TRUE;
            GenJnlLine."Salespers./Purch. Code" := PurchHeader."Purchaser Code";
            IF GenJnlLine.Amount <> 0 THEN
                GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteAfterPosting', '', true, true)]
    local procedure PurchPost_OnBeforeDeleteAfterPosting(var PurchaseHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var SkipDelete: Boolean; CommitIsSupressed: Boolean; var TempPurchLine: Record "Purchase Line" temporary; var TempPurchLineGlobal: Record "Purchase Line" temporary; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.ArchPurchDocumentNoConfirm(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteApprovalEntries', '', true, true)]
    local procedure PurchPost_OnBeforeDeleteApprovalEntries(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        AddOnSetup: Record "AddOn Setup";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        IsHandled := true;
        AddOnSetup.GET;
        IF not AddOnSetup."Preserve Purch Approval Entry" THEN
            ApprovalsMgmt.DeleteApprovalEntries(PurchaseHeader.RecordId());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnBeforeCopyDocumentFields', '', true, true)]
    local procedure PurchPost_OnPostItemJnlLineOnBeforeCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; WhseReceive: Boolean; WhseShip: Boolean; InvtPickPutaway: Boolean)
    var
        AddOnSetup: Record "AddOn Setup";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        AddOnSetup.GetRecordOnce();
        IF (PurchaseLine.GetParentCategory() = AddOnSetup."LUBS Item Category") THEN
            IF PurchaseHeader."Purchase Type" = PurchaseHeader."Purchase Type"::AchatMarchandise THEN BEGIN
                PurchaseLine.TESTFIELD("Expiration Date");
                PurchaseLine.TESTFIELD("Batch Number");
            END;

        ItemJournalLine."Ref Cargo" := PurchaseHeader."Ref Cargo";
        ItemJournalLine."LUB Expiration Date" := PurchaseLine."Expiration Date";//JN110321
        ItemJournalLine."Batch Number" := PurchaseLine."Batch Number";//JN110321
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
    local procedure PurchPostYesNo_OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    var
        AFKErr01: Label 'Option non disponible, sélectionnez Livrer ou Facturer';
    begin
        if (PurchaseHeader.Ship and PurchaseHeader.Invoice) then
            if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then
                error(AFKErr01);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnAfterConfirmPost', '', true, true)]
    local procedure PurchPostPrint_OnAfterConfirmPost(PurchaseHeader: Record "Purchase Header")
    var
        AFKErr01: Label 'Option non disponible, sélectionnez Livrer ou Facturer';
    begin
        if (PurchaseHeader.Ship and PurchaseHeader.Invoice) then
            if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then
                error(AFKErr01);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnCreatePurchHeaderOnBeforePurchOrderHeaderModify', '', true, true)]
    local procedure PurchQuotetoOrder_OnCreatePurchHeaderOnBeforePurchOrderHeaderModify(var PurchOrderHeader: Record "Purchase Header"; var PurchHeader: Record "Purchase Header")
    var
        ServRequisition: record "Purchase Requisition";
        SRmgt: Codeunit "Purchase Requisition Mgt";
    begin
        PurchOrderHeader."Code Demande" := PurchHeader."Code Demande";
        PurchOrderHeader."Code Budget" := PurchHeader."Code Budget";
        IF PurchHeader."Code Demande" <> '' THEN
            PurchOrderHeader."Purchase Type" := PurchOrderHeader."Purchase Type"::AchatAutre
        ELSE
            PurchOrderHeader."Purchase Type" := PurchOrderHeader."Purchase Type"::AchatMarchandise;

        PurchOrderHeader.DelaiDeLivraison := PurchHeader.DelaiDeLivraison;


        ServRequisition.GET(PurchHeader."Code Demande");
        SRmgt.RefreshRemainingQtyReq(ServRequisition);

        IF PurchOrderHeader."Offer Prepayment %" > 0 THEN
            PurchOrderHeader."Prepayment %" := PurchOrderHeader."Offer Prepayment %";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeInsertPurchOrderLine', '', true, true)]
    local procedure PurchQuotetoOrder_OnBeforeInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; PurchOrderHeader: Record "Purchase Header"; PurchQuoteLine: Record "Purchase Line"; PurchQuoteHeader: Record "Purchase Header")
    var
        PurchReqLine: Record "Purchase Requisition Line";
        //ServRequisition: record "Purchase Requisition";
        SRmgt: Codeunit "Purchase Requisition Mgt";
        QteRestanteACder: Decimal;
        TextErr001: label 'Vous ne pouvez pas commander plus de %1 unités pour l''article %2. \La quantitée restante a commander est %3';
    begin
        IF PurchQuoteHeader."Offer Prepayment %" > 0 THEN begin
            PurchOrderLine.Validate("Prepayment %", PurchQuoteHeader."Offer Prepayment %");
        end;
        IF (PurchQuoteLine.Type <> PurchQuoteLine.Type::" ") THEN BEGIN
            PurchQuoteLine.TESTFIELD(PurchQuoteLine.Quantity);
            PurchQuoteLine.TESTFIELD(PurchQuoteLine."Direct Unit Cost");
        END;
        IF PurchReqLine.GET(PurchQuoteLine."Purch Req No.", PurchQuoteLine."Purch Req Line No.") THEN BEGIN
            IF PurchReqLine.Type <> PurchReqLine.Type::" " THEN BEGIN

                QteRestanteACder := PurchReqLine."Quantity (Base)" - PurchReqLine."Ordered Quantity (Base)";

                IF (PurchReqLine."Ordered Quantity (Base)" + PurchQuoteLine."Quantity (Base)") > PurchReqLine."Quantity (Base)" THEN
                    ERROR(TextErr001, PurchReqLine."Quantity (Base)", PurchReqLine."No.", QteRestanteACder);
            END;
        END;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeDeletePurchQuote', '', true, true)]
    local procedure PurchQuotetoOrder_OnBeforeDeletePurchQuote(var QuotePurchHeader: Record "Purchase Header"; var OrderPurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        ServRequisition: record "Purchase Requisition";
        SRmgt: Codeunit "Purchase Requisition Mgt";
    begin
        if (ServRequisition.GET(QuotePurchHeader."Code Demande")) then
            SRmgt.RefreshRemainingQtyReq(ServRequisition);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", 'OnBeforeUnApplyCustomer', '', true, true)]
    local procedure CustEntryApplyPostedEntries_OnBeforeUnApplyCustomer(DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var IsHandled: Boolean)
    var
        AFK_SecMgt: Codeunit "Security Mgt";
    begin
        AFK_SecMgt.CheckCanReverseReconciliation();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeGetPurchDocTypeUsage', '', true, true)]
    local procedure DocumentPrint_OnBeforeGetPurchDocTypeUsage(PurchaseHeader: Record "Purchase Header"; var ReportSelectionUsage: Enum "Report Selection Usage"; var IsHandled: Boolean)
    var
        AFK_SecMgt: Codeunit "Security Mgt";
    begin
        if (PurchaseHeader."Purchase Type" = PurchaseHeader."Purchase Type"::AchatAutre) then begin
            ReportSelectionUsage := ReportSelectionUsage::PurchaseOrderServices;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforePrintCheck', '', true, true)]
    local procedure DocumentPrint_OnBeforePrintCheck(var GenJournalLine: Record "Gen. Journal Line"; var IsPrinted: Boolean)
    var
        BankAcc: Record "Bank Account";
        ReportSelections: Record "Report Selections";
        AFK_SecMgt: Codeunit "Security Mgt";
    begin
        IF GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"Bank Account" THEN begin
            IF BankAcc.GET(GenJournalLine."Bal. Account No.") THEN begin
                ReportSelections.PrintReport(BankAcc."Check Report Usage", GenJournalLine);
                IsPrinted := true;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"GenJnlManagement", 'OnBeforeLookupName', '', true, true)]
    local procedure GenJnlManagement_OnBeforeLookupName(var GenJnlBatch: Record "Gen. Journal Batch"; var GenJnlLine: Record "Gen. Journal Line")
    var
        AFK_AddOnSetup: Record "AddOn Setup";
        AFK_SecMgt: Codeunit "Security Mgt";
        FiltresFeuilles: Text[2000];
    begin
        AFK_AddOnSetup.GET;
        IF AFK_AddOnSetup."Security on Journal" THEN BEGIN
            FiltresFeuilles := AFK_SecMgt.GetFiltresFeuilles(GenJnlBatch."Journal Template Name");
            GenJnlBatch.FilterGroup(2);
            GenJnlBatch.SetFilter(GenJnlBatch.Name, FiltresFeuilles);
            GenJnlBatch.FilterGroup(0);
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item-Check Avail.", 'OnBeforeShowWarningForThisItem', '', true, true)]
    local procedure ItemCheckAvail_OnBeforeShowWarningForThisItem(Item: Record Item; var ShowWarning: Boolean; var IsHandled: Boolean)
    var
    begin
        if not Item.IsNonInventoriableType() then begin
            ShowWarning := true;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.Header-Printed", 'OnBeforeModify', '', true, true)]
    local procedure PurchHeaderPrinted_OnBeforeShowWarningForThisItem(var PurchaseHeader: Record "Purchase Header")
    var
    begin
        PurchaseHeader.Printed := true;
        PurchaseHeader."Printed Date" := Today;
        PurchaseHeader."Printed By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Availability Forms Mgt", 'OnAfterCalcItemPlanningFields', '', true, true)]
    local procedure ItemAvailabilityFormsMgt_OnAfterCalcItemPlanningFields(var Item: Record Item)
    var
    begin
        item.CalcFields("Qty. in Transit AFK");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Availability Forms Mgt", 'OnAfterCalculateNeed', '', true, true)]
    local procedure ItemAvailabilityFormsMgt_OnAfterCalculateNeed(var Item: Record Item; var GrossRequirement: Decimal; var PlannedOrderReceipt: Decimal; var ScheduledReceipt: Decimal; var PlannedOrderReleases: Decimal)
    var
    begin
        ScheduledReceipt := ScheduledReceipt + Item."Qty. in Transit AFK";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterUpdateSalesDocLines', '', true, true)]
    local procedure ReleaseSalesDocument_OnAfterUpdateSalesDocLines(var SalesHeader: Record "Sales Header"; var LinesWereModified: Boolean; PreviewMode: Boolean)
    var
        GLMgt: Codeunit "GL Mgt";
    begin
        GLMgt.VATCorrectionGDP(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnCodeOnBeforeModifyHeader', '', true, true)]
    local procedure ReleasePurchaseDocument_OnCodeOnBeforeModifyHeader(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
    begin
        IF PurchaseHeader."Purchase Type" = PurchaseHeader."Purchase Type"::AchatAutre THEN
            PurchaseHeader."Order Date" := Today;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnAfterCalcScheduledReceipt', '', true, true)]
    local procedure AvailabletoPromise_OnAfterCalcScheduledReceipt(var Item: Record Item; var ScheduledReceipt: Decimal)
    var
    begin
        Item.CalcFields("Qty. in Transit AFK");
        ScheduledReceipt := ScheduledReceipt + Item."Qty. in Transit AFK";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Posting To G/L", 'OnPostInvtPostBufOnAfterInitGenJnlLine', '', true, true)]
    local procedure InventoryPostingToGL_OnPostInvtPostBufOnAfterInitGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var ValueEntry: Record "Value Entry")
    var
        FAMgt: codeunit "FA Mgt";
        Descr: Text[100];
    begin
        Descr := FAMgt.AFK_GetNewDescr(ValueEntry);
        if (Descr <> '') then
            GenJournalLine.Description := Descr;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopyPurchInvLinesToDocOnAfterTransferFields', '', true, true)]
    local procedure CopyDocumentMgt_OnCopyPurchInvLinesToDocOnAfterTransferFields(var FromPurchaseLine: Record "Purchase Line"; var FromPurchaseHeader: Record "Purchase Header"; var ToPurchaseHeader: Record "Purchase Header"; FromPurchInvHeader: Record "Purch. Inv. Header"; var FromPurchInvLine: Record "Purch. Inv. Line")
    var
        AFK_ProvisionMgt: codeunit "Provisions Cde Mgt";
        Descr: Text[100];
    begin
        AFK_ProvisionMgt.SetSoucheExtourneProvisionFA(FromPurchInvHeader, ToPurchaseHeader);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineItemPrice', '', true, true)]
    local procedure SalesPriceCalcMgt_OnAfterFindSalesLineItemPrice(var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; var FoundSalesPrice: Boolean; CalledByFieldNo: Integer)
    var
        GLMgt: codeunit "GL Mgt";
        Descr: Text[100];
    begin
        GLMgt.CalcBestUnitPrice(SalesLine, TempSalesPrice, FoundSalesPrice, CalledByFieldNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnBeforeSalesHeaderStartDate', '', true, true)]
    local procedure SalesPriceCalcMgt_OnBeforeSalesHeaderStartDate(var SalesHeader: Record "Sales Header"; var DateCaption: Text[30]; var StartDate: Date; var IsHandled: Boolean)
    var
        SingleCodeunit: codeunit "SingleInstance";
        SalesPriceDate: Date;
    begin
        SalesPriceDate := SingleCodeunit.Get_SalesPriceDate();
        IF SalesPriceDate <> 0D then begin
            StartDate := SalesPriceDate;
            IsHandled := true;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnGenerEntriesOnBeforeGenJnlPostLineRunWithCheck', '', true, true)]
    local procedure PaymentManagement_OnGenerEntriesOnBeforeGenJnlPostLineRunWithCheck(var GenJnlLine: Record "Gen. Journal Line"; PaymentHeader: Record "Payment Header"; StepLedger: Record "Payment Step Ledger")
    var
    begin
        GenJnlLine."Check No." := PaymentHeader."Check Number";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnPostInvPostingBufferOnBeforeGenJnlPostLineRunWithCheck', '', true, true)]
    local procedure PaymentManagement_OnPostInvPostingBufferOnBeforeGenJnlPostLineRunWithCheck(var GenJnlLine: Record "Gen. Journal Line"; var PaymentHeader: Record "Payment Header"; var PaymentClass: Record "Payment Class"; PaymentLine: Record "Payment Line")
    var
    begin
        GenJnlLine."Check No." := PaymentHeader."Check Number";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PostSales-Delete", 'OnBeforeDeleteHeader', '', true, true)]
    local procedure PostSalesDelete_OnBeforeDeleteHeader(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var SalesInvoiceHeaderPrepmt: Record "Sales Invoice Header"; var SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header"; var IsHandled: Boolean)
    var
        SingleCU: Codeunit SingleInstance;
    begin
        //Deletion forced by Sales Order Process (do not delete related docs)
        if (SingleCU.Get_AllowDeletionSalesHeader()) then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ArchiveManagement", 'OnBeforeAutoArchivePurchDocument', '', true, true)]
    local procedure ArchiveManagement_OnBeforeDeleteHeader(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        ArchiveMgt: Codeunit "ArchiveManagement";
    begin
        ArchiveMgt.ArchPurchDocumentNoConfirm(PurchaseHeader);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item-Check Avail.", 'OnBeforeShowWarningForThisItemOnBeforeItemGet', '', true, true)]
    local procedure ItemCheckAvail_OnBeforeShowWarningForThisItemOnBeforeItemGet(ItemNo: Code[20]; var ShowWarning: Boolean; var IsHandled: Boolean)
    var
        SingleCU: Codeunit SingleInstance;
    begin
        if (SingleCU.Get_IsAfkShowItemWarning()) then begin
            IsHandled := true;
            SingleCU.Set_IsAfkShowItemWarning(false);
            ShowWarning := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostVendorEntry', '', true, false)]
    local procedure OnAfterInitVATAmounts_VendDeductions(var GenJnlLine: Record "Gen. Journal Line"; var PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; CommitIsSupressed: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        AfkGLMgt: codeunit "GL Mgt";
    begin
        AfkGLMgt.PostVendorDeductions(PurchHeader, GenJnlLine, GenJnlPostLine, TotalPurchLineLCY, TotalPurchLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInvoicePostingBufferAssignAmounts', '', true, false)]
    local procedure SalesPost_OOnAfterInvoicePostingBufferAssignAmounts(SalesLine: Record "Sales Line"; var TotalAmount: Decimal; var TotalAmountLCY: Decimal; SalesLineACY: Record "Sales Line"; var TotalVAT: Decimal; var TotalVATACY: Decimal; var TotalVATBase: Decimal; var TotalVATBaseACY: Decimal; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        SalesPostingMgt: codeunit "SalesPostingMgt";
    begin
        SalesPostingMgt.AddGLPostingLinesForRetention(SalesLine, SalesLineACY, InvoicePostBuffer, TotalVAT, TotalVATACY, TotalAmount, TotalAmountLCY, TempInvoicePostBuffer);
    end;


    //OnAfterInvoicePostingBufferAssignAmounts
    [Obsolete('Moved to Sales Invoice Posting implementation. Use the new event OnPrepareLineOnAfterUpdateInvoicePostingBuffer in codeunit 825 "Sales Post Invoice Events".', '19.0')]
    [IntegrationEvent(false, false)]
    local procedure OnFillInvoicePostingBufferOnAfterUpdateInvoicePostBuffer(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var GenJnlLineDocNo: Code[20]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendPurchaseDocForApproval', '', true, false)]
    local procedure ApprovalsMgmt_OnSendPurchaseDocForApproval(var PurchaseHeader: Record "Purchase Header")
    var
        BudgetMgt: codeunit "Purchase Requisition Mgt";
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then
            BudgetMgt.CheckPurchaseOrderInWflw(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.Header-Printed", 'OnBeforeModify', '', true, false)]
    local procedure PurchHeaderPrinted_OnBeforeModify(var PurchaseHeader: Record "Purchase Header")
    var
        BudgetMgt: codeunit "Purchase Requisition Mgt";
    begin
        PurchaseHeader.Printed := TRUE;
        PurchaseHeader."Printed Date" := TODAY;
        PurchaseHeader."Printed By" := USERID;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", 'OnAfterTableHasNumberFieldPrimaryKey', '', true, false)]
    local procedure DocumentAttachmentMgmt_OnAfterTableHasNumberFieldPrimaryKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    var
        BudgetMgt: codeunit "Purchase Requisition Mgt";
    begin
        if (TableNo = Database::"Vendor Invoice Doc") then begin
            FieldNo := 20;
            Result := true;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostItemJnlLine', '', true, false)]
    local procedure ItemJnlPostLine_OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean; var ItemRegister: Record "Item Register"; var ItemLedgEntryNo: Integer; var ItemApplnEntryNo: Integer; var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line")
    var
        signeCU: codeunit SingleInstance;
    begin
        signeCU.Set_InventoryPostingToGL(InventoryPostingToGL);
    end;

    //  [IntegrationEvent(true, false)]
    // local procedure OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean; var ItemRegister: Record "Item Register"; var ItemLedgEntryNo: Integer; var ItemApplnEntryNo: Integer; var WhseJnlRegisterLine: Codeunit "Whse. Jnl.-Register Line")
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAfterTableHasNumberFieldPrimaryKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEPA CT-Fill Export Buffer", 'OnAfterFillExportBuffer', '', true, false)]
    // local procedure SEPACTFillExportBuffer_OnAfterFillExportBuffer(var PaymentExportData: Record "Payment Export Data"; BankExportImportSetup: Record "Bank Export/Import Setup")
    // var
    //     signeCU: codeunit SingleInstance;
    // begin
    //     PaymentExportData."SEPA Charge Bearer Text" := 'CHAR';
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"SEPA CT-Fill Export Buffer", 'OnFillExportBufferOnBeforeInsertPaymentExportData', '', true, false)]
    local procedure SEPACTFillExportBuffer_OnFillExportBufferOnBeforeInsertPaymentExportData(var PaymentExportData: Record "Payment Export Data"; var TempGenJnlLine: Record "Gen. Journal Line" temporary)
    var
    begin
        PaymentExportData."SEPA Charge Bearer Text" := 'SHAR';
    end;









































































































}
