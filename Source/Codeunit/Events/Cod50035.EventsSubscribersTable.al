codeunit 50035 "EventsSubscribers Table"
{
    [EventSubscriber(ObjectType::Table, Database::"Currency", 'OnBeforeGetGainLossAccount', '', true, true)]
    local procedure Currency_OnBeforeGetGainLossAccount(var Currency: Record Currency; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
    // AddOnSetup: record "AddOn Setup";
    // TresoMgt: codeunit "Treso Mgt";
    begin
        // AddOnSetup.GET;
        // AddOnSetup.TESTFIELD(AddOnSetup."PROGAL Vendor Code");
        //IF (AddOnSetup."PROGAL Vendor Code" = DtldCVLedgEntryBuffer."CV No.") THEN
        //EXIT(TresoMgt.GetGainLossAccount_PROGAL(DtldCVLedgEntryBuffer));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", 'OnBeforeCheckBlockedVend', '', true, true)]
    local procedure Vendor_OnBeforeCheckBlockedVend(Vendor: Record Vendor; Source: Option Journal,Document; DocType: Option; Transaction: Boolean; var IsHandled: Boolean)
    var
    begin
        Vendor.TESTFIELD(Vendor."Validation Status", Vendor."Validation Status"::Validated);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Issued Reminder Header", 'OnBeforePrintRecords', '', true, true)]
    local procedure OnBeforePrintRecords_IssuedReminderHeader(var IssuedReminderHeader: Record "Issued Reminder Header"; ShowRequestForm: Boolean; SendAsEmail: Boolean; HideDialog: Boolean; var IsHandled: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        //DummyReportSelections: Record "Report Selections";
        ReminderLevel: Record "Reminder Level";
        ReminderHeader: Record "Issued Reminder Header";
        IssuedReminderHeaderToSend: Record "Issued Reminder Header";
        ReportDistributionMgt: Codeunit "Report Distribution Management";
        SuppresSendDialogQst: Label 'Do you want to suppress send dialog?';

    begin
        IsHandled := true;

        ReminderLevel.Get(IssuedReminderHeader."Reminder Terms Code", IssuedReminderHeader."Reminder Level");

        if SendAsEmail then begin
            ReminderHeader.Copy(IssuedReminderHeader);
            if (not HideDialog) and (ReminderHeader.Count > 1) then
                if Confirm(SuppresSendDialogQst) then
                    HideDialog := true;
            if ReminderHeader.FindSet() then
                repeat
                    IssuedReminderHeaderToSend.Copy(IssuedReminderHeader);
                    IssuedReminderHeaderToSend.SetRecFilter();
                    DocumentSendingProfile.TrySendToEMail(
                      ReminderLevel."AG1 Report Usage".AsInteger(), IssuedReminderHeaderToSend, IssuedReminderHeaderToSend.FieldNo("No."),
                      ReportDistributionMgt.GetFullDocumentTypeText(IssuedReminderHeader), IssuedReminderHeaderToSend.FieldNo("Customer No."), not HideDialog)
                until ReminderHeader.Next() = 0;
        end else
            DocumentSendingProfile.TrySendToPrinter(
              ReminderLevel."AG1 Report Usage".AsInteger(), IssuedReminderHeader,
              IssuedReminderHeaderToSend.FieldNo("Customer No."), ShowRequestForm);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnShowContactOnBeforeOpenContactList', '', true, true)]
    local procedure Customer_OnShowContactOnBeforeOpenContactList(var Contact: Record Contact; var ContactPageID: Integer)
    var
    begin
        Contact.SetRange(Signataire, true);
    end;


    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure Vendor_OnAfterValidateEvent_No(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Name', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Name(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Name 2', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Name2(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Address', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Address(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Address 2', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Address2(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Vendor Posting Group', true, true)]
    local procedure Vendor_OnAfterValidateEvent_VendorPostingGroup(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Currency Code', true, true)]
    local procedure Vendor_OnAfterValidateEvent_CurrencyCode(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Payment Terms Code', true, true)]
    local procedure Vendor_OnAfterValidateEvent_PaymentTermsCode(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Blocked', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Blocked(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Pay-to Vendor No.', true, true)]
    local procedure Vendor_OnAfterValidateEvent_PaytoVendorNo(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Payment Method Code', true, true)]
    local procedure Vendor_OnAfterValidateEvent_PaymentMethodCode(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Gen. Bus. Posting Group', true, true)]
    local procedure Vendor_OnAfterValidateEvent_GenBusPostingGroup(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'E-Mail', true, true)]
    local procedure Vendor_OnAfterValidateEvent_EMail(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'VAT Bus. Posting Group', true, true)]
    local procedure Vendor_OnAfterValidateEvent_VATBusPostingGroup(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;


    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Block Payment Tolerance', true, true)]
    local procedure Vendor_OnAfterValidateEvent_BlockPaymentTolerance(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Prepayment %', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Prepayment(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Preferred Bank Account Code', true, true)]
    local procedure Vendor_OnAfterValidateEvent_PreferredBankAccountCode(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Transporter', true, true)]
    local procedure Vendor_OnAfterValidateEvent_Transporter(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Related Customer', true, true)]
    local procedure Vendor_OnAfterValidateEvent_RelatedCustomer(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Vendor Retention Posting Group', true, true)]
    local procedure Vendor_OnAfterValidateEvent_VendorRetentionPostingGroup(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'STAT Code', true, true)]
    local procedure Vendor_OnAfterValidateEvent_STATCode(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'CIF/CIS', true, true)]
    local procedure Vendor_OnAfterValidateEvent_CIFCIS(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Trade Number', true, true)]
    local procedure Vendor_OnAfterValidateEvent_TradeNumber(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'GDP Partner', true, true)]
    local procedure Vendor_OnAfterValidateEvent_GDPPartner(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Activity Area', true, true)]
    local procedure Vendor_OnAfterValidateEvent_ActivityArea(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        FilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        FilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnBeforeVerifyOnInventory', '', true, true)]
    local procedure ItemLedgerEntry_OnBeforeVerifyOnInventory(var ItemLedgerEntry: Record "Item Ledger Entry"; var IsHandled: Boolean; ErrorMessageText: Text)
    var
        Item: Record Item;
        Loc: Record Location;
        FilesMgt: Codeunit "AG1 Master Files Mgt";

    begin
        IsHandled := true;
        if not ItemLedgerEntry.Open then
            exit;
        if ItemLedgerEntry.Quantity >= 0 then
            exit;
        case ItemLedgerEntry."Entry Type" of
            ItemLedgerEntry."Entry Type"::Consumption, ItemLedgerEntry."Entry Type"::"Assembly Consumption", ItemLedgerEntry."Entry Type"::Transfer:
                Error(ErrorMessageText);
            else begin
                Item.Get(ItemLedgerEntry."Item No.");
                Loc.GET(ItemLedgerEntry."Location Code");//********
                if Item.PreventNegativeInventory() then
                    IF not Loc."Allow Negative Stock" then//********
                        Error(ErrorMessageText);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterOnInsert', '', true, true)]
    local procedure SalesHeader_OnAfterOnInsert(var SalesHeader: Record "Sales Header")
    var
        SOProcess: Codeunit "Sales Order Process";
    begin
        SalesHeader."User ID" := USERID;
        SOProcess.InsertNewStep(SalesHeader."No.", 0, FORMAT(SalesHeader."Delivery Status"), '');
        SalesHeader."Dispatching Status" := SalesHeader."Dispatching Status"::NonTraite;
        SalesHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnDeleteOnBeforeArchiveSalesDocument', '', true, true)]
    local procedure SalesHeader_OnDeleteOnBeforeArchiveSalesDocument(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        SOProcess: Codeunit "Sales Order Process";
        SingleCU: Codeunit SingleInstance;
    begin
        IF not SingleCU.Get_AllowDeletionSalesHeader then
            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                SalesHeader.TestField("Delivery Status", SalesHeader."Delivery Status"::Saisie);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs', '', true, true)]
    local procedure SalesHeader_OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs(var SalesHeader: Record "Sales Header"; var Cust: Record Customer; var IsHandled: Boolean)
    var
    begin
        Cust.TestField("Responsibility Center");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeUpdateShipToCodeFromCust', '', true, true)]
    local procedure SalesHeader_OnBeforeUpdateShipToCodeFromCust(var SalesHeader: Record "Sales Header"; var Customer: Record Customer; var IsHandled: Boolean)
    var
    begin
        SalesHeader.Validate("Shipment Method Code", Customer."Shipment Method Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesHeader_OnAfterValidateEvent_No(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesInvHeader2: Record "Sales Invoice Header";
        AFK_ERR001: Label 'Ce numéro a déjà été utilisé pour une commande';
        AFK_ERR002: Label 'Ce numéro a déjà été utilisé pour une facture';
    begin
        //JN Controle des code facture et commandes
        IF Rec."Document Type" = Rec."Document Type"::Order THEN begin
            SalesHeaderArchive.RESET;
            SalesHeaderArchive.SETRANGE("Document Type", SalesHeaderArchive."Document Type"::Order);
            SalesHeaderArchive.SETRANGE("No.", Rec."No.");
            IF SalesHeaderArchive.FINDFIRST THEN
                ERROR(AFK_ERR001);
        end;

        IF Rec."Document Type" = Rec."Document Type"::Invoice THEN begin
            SalesInvHeader2.RESET;
            SalesInvHeader2.SETRANGE("Pre-Assigned No.", Rec."No.");
            IF SalesInvHeader2.FINDFIRST THEN
                ERROR(AFK_ERR002);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeConfirmBillToCustomerChange', '', true, true)]
    local procedure SalesHeader_OnBeforeConfirmBillToCustomerChange(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; CurrFieldNo: Integer; var Confirmed: Boolean; var IsHandled: Boolean)
    var
    begin
        Confirmed := true;
        IsHandled := true;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateBillToCustomerNoOnBeforeRecallModifyAddressNotification', '', true, true)]
    local procedure SalesHeader_OnValidateBillToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header"; var xSalesHeader: Record "Sales Header")
    var
        AFK_Text004: Label 'Le document provient d''une sortie à refacturer %1, le code client ne doit pas être changé sur la facture';
    begin
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN BEGIN
            IF (SalesHeader."Created By Doc Type" = SalesHeader."Created By Doc Type"::SortieARefacturer) THEN
                IF SalesHeader."Created By Doc No." <> '' THEN
                    ERROR(AFK_Text004, SalesHeader."Created By Doc No.");
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeGetShipmentMethodCode', '', true, true)]
    local procedure SalesHeader_OnBeforeGetShipmentMethodCode(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
    begin
        IsHandled := true;
        if (SalesHeader."Sell-to Customer No." <> '') then begin
            Customer.Get(SalesHeader."Sell-to Customer No.");
            SalesHeader.Validate("Shipment Method Code", Customer."Shipment Method Code");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateLocationCode', '', true, true)]
    local procedure SalesHeader_OnBeforeValidateLocationCode(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Loc: Record Location;
        AFK_ERR003: Label 'Vous ne devez pas seléctionner un magasin de ce type';
    begin
        IF Loc.GET(SalesHeader."Location Code") THEN
            IF ((Loc."Location Type" = Loc."Location Type"::Expedition) OR
                (Loc."Location Type" = Loc."Location Type"::TransferTransit)) THEN
                ERROR(AFK_ERR003);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSetSecurityFilterOnRespCenter', '', true, true)]
    local procedure SalesHeader_OnBeforeSetSecurityFilterOnRespCenter(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Loc: Record Location;
        AFK_ERR003: Label 'Vous ne devez pas seléctionner un magasin de ce type';
    begin
        SalesHeader.SETRANGE("User ID", USERID);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnDeleteOnBeforeTestStatusOpen', '', true, true)]
    local procedure SalesHeader_OnDeleteOnBeforeTestStatusOpen(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        SalesHeader: Record "Sales Header";
        AFKSOMgt: Codeunit "Sales Order Process";
        AFK_Text008: Label 'Vous n''etes pas autorisé à supprimer cette ligne.';
    begin
        //Prevent Deletion by CCL
        if (SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.")) then
            if NOT AFKSOMgt.CanUpdateOrderLineAfterValidation(SalesHeader) then
                Error(AFK_Text008);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateNo', '', true, true)]
    local procedure SalesLine_OnBeforeValidateNo(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        AFK_Text004: Label 'Le type doit être "Article"';
    begin
        if (SalesLine.Type = SalesLine.Type::"G/L Account") then
            Error(AFK_Text004);
        if (SalesLine.Type = SalesLine.Type::Resource) then
            Error(AFK_Text004);
        if (SalesLine.Type = SalesLine.Type::"Charge (Item)") then
            Error(AFK_Text004);
        if (SalesLine.Type = SalesLine.Type::"Fixed Asset") then
            IF SalesLine."Document Type" = SalesLine."Document Type"::Order then
                Error(AFK_Text004);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnCopyFromItemOnAfterCheck', '', true, true)]
    local procedure SalesHeader_OnCopyFromItemOnAfterCheck(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        SalesHeader: record "Sales Header";
        AfkLoc: Record Location;
        Cust2: record Customer;
        AFK_AddOnSetup: record "AddOn Setup";
        AFK_SecMgt: Codeunit "Security Mgt";
        AFK_Text002: Label 'Impossible de facturer directement des articles, vous devez passer par une commande';
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        Cust2.GET(SalesHeader."Sell-to Customer No.");
        Cust2.TESTFIELD(Cust2."Sales Category Code");

        AFK_AddOnSetup.GET;
        IF Item.Type = Item.Type::Inventory THEN BEGIN
            IF NOT AFK_SecMgt.CanAddItemOnSalesInv THEN BEGIN
                IF ((SalesHeader."Document Type" IN [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"]) AND
                     (SalesHeader."Created By Doc Type" <> SalesHeader."Created By Doc Type"::Consignation)) THEN
                    IF Cust2."Sales Channel Code" <> AFK_AddOnSetup."AMSA Sales Channel" THEN
                        ERROR(AFK_Text002);
            END;
        END;

        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
            Item.TESTFIELD("Sales Category Code", Cust2."Sales Category Code");


        IF AfkLoc.GET(SalesLine."Location Code") THEN
            Item.TESTFIELD("Item Category Code", AfkLoc."Item Category Code");

        SalesLine."FER Fees Price" := Item."FER Fees Price";
        SalesLine."OMH Fees Price" := Item."OMH Fees Price";
        SalesLine."ENV Fees Price" := Item."ENV Fees Price";
        SalesLine."RDS Fees Price" := Item."RDS Fees Price";

        SalesLine."Shipment Group" := Item."Shipment Group";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateLocationCodeOnBeforeSetShipmentDate', '', true, true)]
    local procedure SalesLine_OnValidateLocationCodeOnBeforeSetShipmentDate(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        Loc: Record Location;
        EnteteBL: Record pro_enteteBL;
        AfkItem: record Item;
        AFK_Text003: Label 'Le magasin de ce type ne doit pas être utilisé sur ce document !';
        AFK_Text005: Label 'Le numéro BL %1 a été confirmé pour cette commande, le code magasin ne doit plus être modifié.';
    begin
        //Reserver les magasin spécifiques pour les commandes
        IF Loc.GET(SalesLine."Location Code") THEN
            IF SalesLine."Document Type" <> SalesLine."Document Type"::Order THEN
                IF Loc."Location Type" <> Loc."Location Type"::" " THEN
                    ERROR(AFK_Text003);

        IF Loc.GET(SalesLine."Location Code") THEN BEGIN
            EnteteBL.RESET;
            EnteteBL.SETRANGE(EnteteBL.NavOrderNo, SalesLine."No.");
            EnteteBL.SETRANGE(EnteteBL.isconfirme, TRUE);
            IF EnteteBL.FINDFIRST THEN
                IF Loc."Location Type" <> Loc."Location Type"::Expedition THEN
                    ERROR(AFK_Text005, EnteteBL.numBL);

            //IF SalesHeader."Document Type"=SalesHeader."Document Type"::Order THEN
            IF AfkItem.GET(SalesLine."No.") THEN
                AfkItem.TESTFIELD("Item Category Code", Loc."Item Category Code");
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateQuantityOnAfterCalcBaseQty', '', true, true)]
    local procedure SalesLine_OnValidateQuantityOnAfterCalcBaseQty(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        SalesHeader: record "Sales Header";
        DispachingMgt: Codeunit "Logistique Mgt";
        AFK_SecMgt: Codeunit "Security Mgt";
        AFKSOMgt: Codeunit "Sales Order Process";
        AFK_Text004: Label 'Le type doit être "Article"';
        AFK_Text006: Label 'Vous ne pouvez pas rentrer cette quantité. \La quantité déjà livrée est %1. \La quantité en cours de livraison (Dispaching) est %2';

        AFK_Text007: Label 'Impossible de mettre à jour cette quantité lors de la facturation JIRAMA car la ligne provient d''une expédition enregistrée.';

        QtyInDispaching: Decimal;
    begin
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN begin
                QtyInDispaching := DispachingMgt.GetQtyEnTourneeCde(SalesLine."Document No.", SalesLine."No.", SalesLine."Unit of Measure Code",
                  SalesLine."Qty. per Unit of Measure");
                IF
                  (ABS(SalesLine.Quantity) < ABS(SalesLine."Quantity Shipped") + QtyInDispaching) AND (SalesLine."Shipment No." = '')
                THEN
                    ERROR(AFK_Text006, ABS(SalesLine."Quantity Shipped"), QtyInDispaching);
            end;

            IF ((SalesLine."Document Type" = SalesLine."Document Type"::Invoice) AND (AFKSOMgt.IsCdeJIRAMA(SalesHeader))
              and (SalesLine."Shipment No." <> '') AND (xSalesLine.Quantity <> 0)) THEN begin
                IF NOT AFK_SecMgt.CanUpdateSOAfterValidation THEN
                    ERROR(AFK_Text007);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateUnitPrice', '', true, true)]
    local procedure SalesLine_OnBeforeValidateUnitPrice(var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        SalesHeader: record "Sales Header";
        AFK_Text001: Label 'You cannot set the unit price because this order is from a validated Quote';
    begin
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            IF SalesHeader."Quote No." <> '' THEN
                ERROR(AFK_Text001);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitQtyToShip', '', true, true)]
    local procedure SalesLine_OnAfterInitQtyToShip(var SalesLine: Record "Sales Line"; CurrFieldNo: Integer)
    var
    begin
        SalesLine."Qty to prepare" := SalesLine."Qty. to Ship";
        ;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeOnInsert', '', true, true)]
    local procedure PurchasHeader_OnBeforeOnInsert(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
    begin
        PurchaseHeader."User ID" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeleteRecordInApprovalRequest', '', true, true)]
    local procedure PurchasHeader_OnBeforeDeleteRecordInApprovalRequest(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        AddOnSetup: record "AddOn Setup";
    begin
        AddOnSetup.GET;
        IF AddOnSetup."Preserve Purch Approval Entry" THEN
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeletePurchaseLines', '', true, true)]
    local procedure PurchasHeader_OnBeforeDeletePurchaseLines(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        AddOnSetup: record "AddOn Setup";
        BudgetLineP: record "Purchase Budget Line";
        PurchLine: Record "Purchase Line";
        ServRequisitionMgt: Codeunit "Purchase Requisition Mgt";
        SingleInstanceCU: Codeunit SingleInstance;
        ReservMgt: Codeunit "Reservation Management";
    begin
        BudgetLineP.RESET;
        BudgetLineP.SETRANGE("Document Type", PurchaseHeader."Document Type");
        BudgetLineP.SETRANGE("Document No.", PurchaseHeader."No.");
        BudgetLineP.DELETEALL;

        IF PurchaseHeader."Code Demande" <> '' THEN
            ServRequisitionMgt.RefreshRemainingQtyReqByCode(PurchaseHeader."Code Demande");

        if (SingleInstanceCU.Get_IsSolderCommande()) then begin
            if PurchLine.FindSet() then begin
                ReservMgt.DeleteDocumentReservation(
                    Database::"Purchase Line", PurchaseHeader."Document Type".AsInteger(), PurchaseHeader."No.", PurchaseHeader.GetHideValidationDialog());
                repeat
                    PurchLine.SuspendStatusCheck(true);
                    PurchLine.Delete();
                until PurchLine.Next() = 0;
            end;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidateBuyFromVendorNoBeforeRecreateLines', '', true, true)]
    local procedure PurchasHeader_OnValidateBuyFromVendorNoBeforeRecreateLines(var PurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; var Vendor: Record Vendor)
    var
        MasterFilesMgt: Codeunit "AG1 Master Files Mgt";
        TextErr01: Label 'Ce fournisseur a été blacklisté';
        ServRequisitionMgt: Codeunit "Purchase Requisition Mgt";
    begin
        MasterFilesMgt.AFK_TestMFilesInvoice(PurchaseHeader);
        PurchaseHeader."Vendor Retention Posting Group" := Vendor."Vendor Retention Posting Group";
        IF Vendor.Statut = Vendor.Statut::BlackListe THEN
            ERROR(TextErr01);
        //JN001 Remplir les lignes de la SR le cas echéant
        ServRequisitionMgt.CreateLinesOffer(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeConfirmUpdateField', '', true, true)]
    local procedure PurchasHeader_OnBeforeConfirmUpdateField(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header"; UpdatingFieldNo: Integer; CurrentFieldNo: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
        MasterFilesMgt: Codeunit "AG1 Master Files Mgt";
        TextErr01: Label 'Ce fournisseur a été blacklisté';
        ServRequisitionMgt: Codeunit "Purchase Requisition Mgt";
    begin
        if (CurrentFieldNo = PurchaseHeader.fieldno("Pay-to Vendor No.")) then begin
            IsHandled := true;
            Result := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidatePayToVendorNo', '', true, true)]
    local procedure PurchasHeader_OnBeforeValidatePayToVendorNo(var PurchaseHeader: Record "Purchase Header"; var xPurchaseHeader: Record "Purchase Header"; var Confirmed: Boolean; var IsHandled: Boolean)
    var
        Vend: Record Vendor;
        MasterFilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.AFK_TestMFilesInvoice(PurchaseHeader);
        if (Vend.Get(PurchaseHeader."Pay-to Vendor No.")) then
            Vend.TESTFIELD(Vend."Validation Status", Vend."Validation Status"::Validated);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyPayToVendorFieldsFromVendor', '', true, true)]
    local procedure PurchasHeader_OnAfterCopyPayToVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; xPurchaseHeader: Record "Purchase Header")
    var
        AFK_Setup: Record "AddOn Setup2";
        MasterFilesMgt: Codeunit "AG1 Master Files Mgt";
    begin
        AFK_Setup.GET;
        IF (AFK_Setup."Def Prepmt. Payment Terms Code" <> '') THEN
            PurchaseHeader."Prepmt. Payment Terms Code" := AFK_Setup."Def Prepmt. Payment Terms Code"
        ELSE
            PurchaseHeader."Prepmt. Payment Terms Code" := Vendor."Payment Terms Code";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeCheckPrepmtAmounts', '', true, true)]
    local procedure PurchaseLine_OnBeforeCheckPrepmtAmounts(var PurchaseLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header"; CurrentFieldNo: Integer; var IsHandled: Boolean; xPurchaseLine: Record "Purchase Line")
    var
        SingleInstanceCU: Codeunit SingleInstance;
    begin
        if (SingleInstanceCU.Get_IsSolderCommande()) then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignGLAccountValues', '', true, true)]
    local procedure PurchaseLine_OnAfterAssignGLAccountValues(var PurchLine: Record "Purchase Line"; GLAccount: Record "G/L Account"; PurchHeader: Record "Purchase Header"; xPurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary)
    var
        UserSetupCheck: record "User Setup";
        SingleInstanceCU: Codeunit SingleInstance;
        AFK_Text0002: Label 'Vous n''êtes pas autorisé à utilisé un compte général sur les commandes';

    begin
        IF PurchLine."Document Type" = PurchLine."Document Type"::Order THEN BEGIN
            UserSetupCheck.GET(USERID);
            IF NOT UserSetupCheck."GLAccount on Purchase Order" THEN
                ERROR(AFK_Text0002);
        END;

        IF NOT PurchLine."System-Created Entry" THEN
            GLAccount.TESTFIELD(GLAccount."Purchased Account", TRUE);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnCopyFromItemOnAfterCheck', '', true, true)]
    local procedure PurchaseLine_OnCopyFromItemOnAfterCheck(var PurchaseLine: Record "Purchase Line"; Item: Record Item; CallingFieldNo: Integer)
    var
    begin
        Item.TESTFIELD(Item."Validation Status", Item."Validation Status"::Validated);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignFieldsForNo', '', true, true)]
    local procedure PurchaseLine_OnAfterAssignFieldsForNo(var PurchLine: Record "Purchase Line"; var xPurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        BudgetMgt: Codeunit "Purchase Requisition Mgt";
    begin
        PurchLine."Purchase Account" := BudgetMgt.GetPurchAcc(PurchLine);
        PurchLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitOutstandingQty', '', true, true)]
    local procedure PurchaseLine_OnAfterInitOutstandingQty(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line")
    var
        BudgetMgt: Codeunit "Purchase Requisition Mgt";
    begin
        PurchaseLine."Partially Received" := (PurchaseLine.Quantity <> 0) AND (PurchaseLine."Outstanding Quantity" <> 0) AND (PurchaseLine."Quantity Received" <> 0);
        PurchaseLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnGetCustomerAccountOnAfterCustGet', '', true, true)]
    local procedure GenJournalLine_OnGetCustomerAccountOnAfterCustGet(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; CallingFieldNo: Integer)
    var
        BudgetMgt: Codeunit "Purchase Requisition Mgt";
    begin
        GenJournalLine."Customer Name" := Customer.Name;
        GenJournalLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnModifyOnBeforeTestCheckPrinted', '', true, true)]
    local procedure GenJournalLine_OnModifyOnBeforeTestCheckPrinted(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        AFKSecMgt: Codeunit "Security Mgt";
        TextErrImportMoneyTech: Label 'Vous pouvez pas modifier cette ligne car il s''agit d''une écriture importée à partir de MoneyTech.';
    begin
        IF GenJournalLine."MoneyTech Import No." <> '' THEN
            ERROR(TextErrImportMoneyTech);

        AFKSecMgt.CheckAccessUserJournal(GenJournalLine, TRUE, FALSE);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeOnDelete', '', true, true)]
    local procedure GenJournalLine_OnBeforeOnDelete(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        TextErrImportMoneyTech: Label 'Vous pouvez pas modifier cette ligne car il s''agit d''une écriture importée à partir de MoneyTech.';
    begin
        IF GenJournalLine."MoneyTech Import No." <> '' THEN
            ERROR(TextErrImportMoneyTech);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeIsAdHocBalAccDescription', '', true, true)]
    local procedure GenJournalLine_OnBeforeIsAdHocBalAccDescription(GenJournalLine: Record "Gen. Journal Line"; xGenJournalLine: Record "Gen. Journal Line"; var Result: Boolean; var IsHandled: Boolean)
    var
    begin
        if (GenJournalLine."CC Document Type" <> GenJournalLine."CC Document Type"::" ") then begin
            IsHandled := true;
            Result := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeCheckDirectPosting', '', true, true)]
    local procedure GenJournalLine_OnBeforeCheckDirectPosting(var GLAccount: Record "G/L Account"; var IsHandled: Boolean; GenJournalLine: Record "Gen. Journal Line")
    var
    begin
        if (GenJournalLine."CC Document Type" <> GenJournalLine."CC Document Type"::" ") then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnValidateBalAccountNoOnAfterAssignValue', '', true, true)]
    local procedure GenJournalLine_OnValidateBalAccountNoOnAfterAssignValue(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line")
    var
        Cust: record Customer;
        Vend: Record Vendor;
        GLAcc: Record "G/L Account";
        BankAcc: Record "G/L Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
    begin
        case GenJournalLine."Bal. Account Type" of
            GenJournalLine."Account Type"::"G/L Account":
                begin
                    GLAcc.Get(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Bal. Account Name" := GLAcc.Name;
                end;
            GenJournalLine."Account Type"::"Bank Account":
                begin
                    BankAcc.Get(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Bal. Account Name" := BankAcc.Name;
                end;
            GenJournalLine."Account Type"::Customer:
                begin
                    Cust.Get(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Bal. Account Name" := Cust.Name;
                end;
            GenJournalLine."Account Type"::Vendor:
                begin
                    Vend.Get(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Bal. Account Name" := Vend.Name;
                end;
            GenJournalLine."Account Type"::"Fixed Asset":
                begin
                    FA.Get(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Bal. Account Name" := FA.Description;
                end;
            GenJournalLine."Account Type"::"IC Partner":
                begin
                    ICPartner.Get(GenJournalLine."Bal. Account No.");
                    GenJournalLine."Bal. Account Name" := ICPartner.Name;
                end;
        end;
        GenJournalLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateAmount', '', true, true)]
    local procedure GenJournalLine_OnAfterValidateAmount(var GenJnlLine: Record "Gen. Journal Line")
    var
        SingleCU: codeunit SingleInstance;
        AFK_Error02: Label 'L''écriture provient d''une lettre de crédit. Vous ne pouvez pas changer le montant';
    begin
        IF NOT SingleCU.Get_CanUpdateAchatDevise() THEN BEGIN
            IF GenJnlLine."Origin Type" = GenJnlLine."Origin Type"::LC THEN
                IF GenJnlLine."Origin No." <> '' THEN
                    ERROR(AFK_Error02);

            IF GenJnlLine."Origin Type" = GenJnlLine."Origin Type"::EchPayment THEN
                IF GenJnlLine."Origin No." <> '' THEN
                    ERROR(AFK_Error02);
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Posting Group", 'OnAfterValidateEvent', 'Payables Account', true, true)]
    local procedure VendorPostingGroup_OnAfterValidateEvent_PayablesAccount(var Rec: Record "Vendor Posting Group"; var xRec: Record "Vendor Posting Group")
    var
    begin
        IF Rec."Retention %" <> 0 THEN
            Rec.FIELDERROR(Rec."Payables Account");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Posting Group", 'OnAfterValidateEvent', 'Retention Group', true, true)]
    local procedure VendorPostingGroup_OnAfterValidateEvent_RetentionGroup(var Rec: Record "Vendor Posting Group"; var xRec: Record "Vendor Posting Group")
    var
    begin
        IF Rec."Retention Group" = TRUE THEN
            IF Rec."Payables Account" <> '' THEN
                Rec.FIELDERROR(Rec."Payables Account");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Posting Group", 'OnAfterValidateEvent', 'Retention %', true, true)]
    local procedure VendorPostingGroup_OnAfterValidateEvent_Retention(var Rec: Record "Vendor Posting Group"; var xRec: Record "Vendor Posting Group")
    var
    begin
        IF (Rec."Retention %" <> 0) THEN
            IF Rec."Payables Account" <> '' THEN
                Rec.FIELDERROR(Rec."Payables Account");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Posting Group", 'OnAfterValidateEvent', 'Retention Account', true, true)]
    local procedure VendorPostingGroup_OnAfterValidateEvent_RetentionAccount(var Rec: Record "Vendor Posting Group"; var xRec: Record "Vendor Posting Group")
    var
    begin
        IF (Rec."Retention Account" <> '') THEN
            IF Rec."Payables Account" <> '' THEN
                Rec.FIELDERROR(Rec."Payables Account");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Header", 'OnBeforeSetSecurityFilterOnRespCenter', '', true, true)]
    local procedure SalesInvoiceHeader_OnBeforeSetSecurityFilterOnRespCenter(var SalesInvoiceHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
    var
    begin
        SalesInvoiceHeader.SETRANGE("User ID", USERID);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Invoice Line", 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure SalesInvoiceLine_OnAfterInitFromSalesLine(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    var
        AFKItem1: record Item;
    begin
        IF (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
            AFKItem1.GET(SalesLine."No.");
            SalesInvLine."OMH Fees Price" := AFKItem1."OMH Fees Price";
            SalesInvLine."FER Fees Price" := AFKItem1."FER Fees Price";
            SalesInvLine."ENV Fees Price" := AFKItem1."ENV Fees Price";
            SalesInvLine."RDS Fees Price" := AFKItem1."RDS Fees Price";
        END;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Header", 'OnBeforeSetSecurityFilterOnRespCenter', '', true, true)]
    local procedure SalesCrMemoHeader_OnBeforeSetSecurityFilterOnRespCenter(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsHandled: Boolean)
    var
    begin
        SalesCrMemoHeader.SETRANGE("User ID", USERID);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Cr.Memo Line", 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure SalesCrMemoLine_OnAfterInitFromSalesLine(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line")
    var
        AFKItem1: Record Item;
    begin
        IF (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
            AFKItem1.GET(SalesLine."No.");
            SalesCrMemoLine."OMH Fees Price" := AFKItem1."OMH Fees Price";
            SalesCrMemoLine."FER Fees Price" := AFKItem1."FER Fees Price";
            SalesCrMemoLine."ENV Fees Price" := AFKItem1."ENV Fees Price";
            SalesCrMemoLine."RDS Fees Price" := AFKItem1."RDS Fees Price";
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnBeforeReverseEntries', '', true, true)]
    local procedure ReversalEntry_OnBeforeReverseEntries(Number: Integer; RevType: Integer; var IsHandled: Boolean; HideDialog: Boolean; var ReversalEntry: Record "Reversal Entry"; var HideWarningDialogs: Boolean)
    var
        AFK_SecMgt: codeunit "Security Mgt";
    begin
        AFK_SecMgt.CheckCanReverseTransaction();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnAfterCheckCust', '', true, true)]
    local procedure ReversalEntry_OnAfterCheckCust(Customer: Record Customer; CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        PayDoc: record "Payment Header";
        PayStatus: record "Payment Status";
        AFK_Err001: Label 'Vous ne pouvez pas contrepasser %1 n° %2 car l''écriture est associée à un document de paiement %3 qui n''est pas dans un statut annulable';
    begin
        PayDoc.RESET;
        PayDoc.SETCURRENTKEY("Customer No.", "Origin Document N°");
        PayDoc.SETRANGE("Customer No.", CustLedgerEntry."Customer No.");
        PayDoc.SETRANGE("Origin Document N°", CustLedgerEntry."Document No.");
        IF PayDoc.FINDFIRST THEN
            IF PayStatus.GET(PayDoc."Payment Class", PayDoc."Status No.") THEN
                IF not PayStatus.Cancellable THEN
                    ERROR(AFK_Err001, CustLedgerEntry.TABLECAPTION, CustLedgerEntry."Entry No.", PayDoc."No.");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Reversal Entry", 'OnInsertFromGLEntryOnBeforeTempReversalEntryInsert', '', true, true)]
    local procedure ReversalEntry_OnInsertFromGLEntryOnBeforeTempReversalEntryInsert(var TempReversalEntry: Record "Reversal Entry" temporary; GLEntry: Record "G/L Entry"; RevType: Option Transaction,Register; var TempRevertTransactionNoRecordInteger: Record "Integer" temporary; ReversalEntry: Record "Reversal Entry")
    var
        AFK_SecMgt: codeunit "Security Mgt";
    begin
        AFK_SecMgt.CheckReverseAmount(ReversalEntry."Amount (LCY)");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Code', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_Code(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Name', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_Name(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Name 2', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_Name2(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Bank Branch No.', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_BankBranchNo(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        Rec.IBAN := MasterFilesMgt.CollectIBAN(Rec);
        Rec.Modify();

        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Bank Account No.', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_BankAccountNo(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        Rec.IBAN := MasterFilesMgt.CollectIBAN(Rec);
        Rec.Modify();

        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Currency Code', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_CurrencyCode(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'IBAN', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_IBAN(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'SWIFT Code', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_SWIFTCode(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'Agency Code', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_AgencyCode(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        Rec.IBAN := MasterFilesMgt.CollectIBAN(Rec);
        Rec.Modify();

        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'RIB Key', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_RIBKey(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        Rec.IBAN := MasterFilesMgt.CollectIBAN(Rec);
        Rec.Modify();

        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterValidateEvent', 'RIB Checked', true, true)]
    local procedure VendorBankAccount_OnAfterValidateEvent_RIBChecked(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        MasterFilesMgt.ResetVendorValidation(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Export Data", 'OnAfterSetCustomerAsRecipient', '', true, true)]
    local procedure PaymentExportData_OnAfterSetCustomerAsRecipient(var PaymentExportData: Record "Payment Export Data"; var Customer: Record Customer; var CustomerBankAccount: Record "Customer Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        PaymentExportData.CustRecipientBankAccLongNum := CustomerBankAccount.AFKGetLongAccountNum();
        PaymentExportData.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Export Data", 'OnAfterSetVendorAsRecipient', '', true, true)]
    local procedure PaymentExportData_OnAfterSetSetVendorAsRecipient(var PaymentExportData: Record "Payment Export Data"; var Vendor: Record Vendor; var VendorBankAccount: Record "Vendor Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        PaymentExportData.VendRecipientBankAccLongNum := VendorBankAccount.AFKGetLongAccountNum();
        PaymentExportData.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Export Data", 'OnAfterSetBankAsRecipient', '', true, true)]
    local procedure PaymentExportData_OnAfterSetBankAsRecipient(var PaymentExportData: Record "Payment Export Data"; var BankAccount: Record "Bank Account")
    var
        MasterFilesMgt: codeunit "AG1 Master Files Mgt";
    begin
        PaymentExportData.SenderBankLongAccNum := BankAccount.AFKGetLongAccountNum();
        PaymentExportData.Modify();
    end;








































}
