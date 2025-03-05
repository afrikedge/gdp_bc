codeunit 50031 VendorInvoiceMgt
{
    Permissions = TableData "Vendor Ledger Entry" = rm,
                  TableData "Purch. Rcpt. Header" = rm;

    trigger OnRun()
    var
        VendReceiptDoc: Record "Purch. Rcpt. Header";
        VendInvDoc: Record "Legal Status";
        PurchInvH: Record "Purch. Inv. Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PH: Record "Purchase Header";
        montHT: Decimal;
        montTTC: Decimal;
    begin
    end;

    var
        Text001: Label '&Envoyer en traitement';
        Selection: Integer;
        Text002: Label 'Vous devez joindre la facture scannée en PJ';
        Text003: Label 'Le numéro de facture %1 existe déjà pour ce fournisseur.';
        Text004: Label '&Valider le paiement';
        Text005: Label 'Aucune réception n''a été validée pour cette commande';
        Text006: Label '&Terminer le litige et envoyer en paiement';
        Text007: Label 'Il existe une réception non conforme associée à la commande %1 liée à cette facture';
        Text013: Label 'Le numéro de commande doit correspondre à celui du document facture scannée %1';
        Text008: Label 'Il existe au moins une réception de cette commande en attente de validation conformité';
        Text009: Label '&Produits conformes,&Signaler une non conformité';
        Text010: Label '&Produits conformes';
        //SMTPSetup: Record "SMTP Mail Setup";
        Text011: Label 'Aucune adresse email trouvée pour l''envoi de l''alerte.';
        Text012: Label 'Aucune ligne de facture pour ce paiement';
        Text014: Label 'La ligne de facture %1 n''a pas été validée pour le paiement';
        PayMgt: Codeunit "Payment Management";
        Text015: Label 'Le document a déjà été validé et ne peut plus être annulé';
        StepEntry: Record "Document Step History";
        UserSetup: Record "User Setup";
        Text016: Label '&Terminer le litige';
        Text017: Label 'Il n''existe aucune facture fournisseur recue avec ce numéro %1 pour le fournisseur %2';
        Text018: Label 'Veuillez indiquer un demandeur pour la validation de la facture fournisseur %1';
        Text019: Label 'La facture n''a pas encore été comptabilisée';
        Text020: Label '&Envoyer en validation';
        EmailMgt: Codeunit "SQL Mgt";
        Text021: Label '&Valider le paiement,&Refuser le paiement et envoyer en litige';
        Text022: Label '&Envoyer en validation,&Rejeter la facture';
        Text023: Label '&Valider,&Refuser la facture,Renvoyer en comptabilité fournisseur';
        Text024: Label '&Valider la facture';
        Text025: Label 'La facture sera rejetée. Un email sera envoyé au fournisseur avec le motif de rejet.\Vous-vous continuer ?';
        Text026: Label 'La facture sera rejetée.\Vous-vous continuer ?';
        Text027: Label 'La facture sera envoyée en litige.\Voulez-vous vraiment refuser la facture ?';
        AddOnSetup2: Record "AddOn Setup2";
        Text028: Label '&Autoriser le paiement,&Refuser la facture';
        ObjetEmailFsseur: Label 'Rejet de votre facture N° %1 du %2';
        Text029: Label 'Payment of %1 %2';
        DimMgt: Codeunit DimensionManagement;
        Text030: Label 'La facture fournisseur %1 %2 doit être en attente de comptabilisation pour pouvoir valider ce document';
        Text031: Label 'La facture fournisseur %1 %2 doit être en attente de paiement pour pouvoir valider ce document';
        Text032: Label 'La date d''arrivée de la facture doit etre comprise entre le %1 et le %2';
        Text033: Label '&Envoyer en validation,&Refuser la facture,Renvoyer en comptabilité fournisseur';
        SecMgt: Codeunit "Security Mgt";
        Text034: Label '&Rejeter la facture,&Archiver';
        Text035: Label '&Autoriser la comptabilisation';
        Text036: Label '&Renvoyer en validation,&Archiver';
        Text037: Label '&Valider,&Refuser la facture';
        Text038: Label '&Renvoyer en validation,&Archiver';
        Text039: Label 'La facture sera archivée et ne sera plus traitée.\Vous-vous continuer ?';
        Text040: Label 'Aucune facture enregistrée trouvée pour ce document';
        Text041: Label 'Le document a été envoyé en validation';
        TypeAction: Option " ",FinLitige;
        PostedPurchInv: Record "Purch. Inv. Header";
        Text042: Label 'Il existe une facture enregistrée %1 correspondant à ce document, cette facture doit etre lettrée pour pouvoir archiver ce document. ';
        Text043: Label 'Vous devez saisir des montants positifs pour le type "Facture" et négatifs pour le type "Avoir"';
        TextErrorSameCurrency: Label 'La devise %1 doit être la même que sur le document facture recue %2 qui est : %3';
        TextErrorSameHT: Label 'Le montant HT %1 doit être le même que sur le document facture recue %2 qui est : %3';
        TextErrorSameTTC: Label 'Le montant TTC %1 doit être le même que sur le document facture recue %2 qui est : %3';

    procedure TraiterFacture(var VendInvoiceDoc: Record "Vendor Invoice Doc"): Boolean
    begin

        if VendInvoiceDoc.Status = VendInvoiceDoc.Status::EnSaisie then begin
            Selection := StrMenu(Text001, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationEnSaisie(VendInvoiceDoc);
            exit(true);
        end;

        if VendInvoiceDoc.Status = VendInvoiceDoc.Status::Receptionee then begin
            if VendInvoiceDoc."Posted Invoice No" <> '' then begin
                Selection := StrMenu(Text036, 1);
                if Selection = 0 then exit;
                if Selection = 1 then ValidationPreSaisie(VendInvoiceDoc);
                if Selection = 2 then Archiver(VendInvoiceDoc);
                exit(true);
            end else begin
                Selection := StrMenu(Text034, 1);
                if Selection = 0 then exit;
                if Selection = 1 then RejetPreSaisie(VendInvoiceDoc);
                if Selection = 2 then Archiver(VendInvoiceDoc);
                exit(true);
            end;
        end;

        if VendInvoiceDoc.Status = VendInvoiceDoc.Status::Rejetee then begin
            Selection := StrMenu(Text035, 1);
            if Selection = 0 then exit;
            if Selection = 1 then AutoriserComptabilisation(VendInvoiceDoc);
            exit(true);
        end;

        if VendInvoiceDoc.Status in [VendInvoiceDoc.Status::AttenteValResp1,
          VendInvoiceDoc.Status::AttenteValResp2, VendInvoiceDoc.Status::AttenteValResp3] then begin

            Selection := StrMenu(Text037, 1);

            if Selection = 0 then exit;
            if Selection = 1 then ValidationResponsable(VendInvoiceDoc);
            if Selection = 2 then RefusValidation(VendInvoiceDoc);
            //IF Selection = 3 THEN RenvoyerEnComptaFournisseur(VendInvoiceDoc);
            exit(true);
        end;


        if VendInvoiceDoc.Status = VendInvoiceDoc.Status::Litigieuse then begin
            Selection := StrMenu(Text038, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationPreSaisie(VendInvoiceDoc);
            if Selection = 2 then Archiver(VendInvoiceDoc);
            exit(true);
        end;

        if VendInvoiceDoc.Status = VendInvoiceDoc.Status::Validee then begin
            Selection := StrMenu(Text028, 1);
            if Selection = 0 then exit;
            if Selection = 1 then AutoriserPaiementDAF(VendInvoiceDoc);
            if Selection = 2 then RefusValidation(VendInvoiceDoc);
            exit(true);
        end;

        //EXIT(TRUE);
    end;

    local procedure ValidationEnSaisie(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
    begin

        CheckVendInvoice(VendInvoiceDoc);

        CheckIfDocHasLinks(VendInvoiceDoc);
        //if not VendInvoiceDoc.HasLinks then Error(Text002);

        VendInvoiceDoc.Status := VendInvoiceDoc.Status::Receptionee;
        VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::Receptionee;
        VendInvoiceDoc."Sent To Validation Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc.Modify;
        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
          'Facture réceptionnée', VendInvoiceDoc.Status::Receptionee, TypeAction::" ");
    end;

    local procedure ValidationPreSaisie(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
        IsFinLitige: Boolean;
    begin

        CheckVendInvoice(VendInvoiceDoc);

        CheckIfDocHasLinks(VendInvoiceDoc);
        //if not VendInvoiceDoc.HasLinks then Error(Text002);

        IsFinLitige := VendInvoiceDoc.Status = VendInvoiceDoc.Status::Litigieuse;

        VendInvoiceDoc.Status := VendInvoiceDoc.Status::AttenteValResp1;
        VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::AttenteValResp1;
        VendInvoiceDoc."Sent To Validation Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc.Validator := GetWorkflowUser(VendInvoiceDoc, 1);

        VendInvoiceDoc.Modify;

        if IsFinLitige then
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Attente vérification', VendInvoiceDoc.Status::AttenteValResp1, TypeAction::FinLitige)
        else
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Attente vérification', VendInvoiceDoc.Status::AttenteValResp1, TypeAction::" ");

        SendEmail_Facture(VendInvoiceDoc, 1);
    end;

    local procedure AutoriserComptabilisation(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
    begin

        CheckVendInvoice(VendInvoiceDoc);

        CheckIfDocHasLinks(VendInvoiceDoc);
        //if not VendInvoiceDoc.HasLinks then Error(Text002);

        VendInvoiceDoc.Status := VendInvoiceDoc.Status::Receptionee;
        VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::Receptionee;
        VendInvoiceDoc."Sent To Validation Date" := CreateDateTime(Today, Time);
        //VendInvoiceDoc.Validator := GetWorkflowUser(VendInvoiceDoc,1);

        VendInvoiceDoc.Modify;
        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
          'Autorisation comptabilisation', VendInvoiceDoc.Status::Receptionee, TypeAction::" ");


        //SendEmail_Facture(VendInvoiceDoc,1);
    end;

    local procedure RejetPreSaisie(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
        Vend1: Record Vendor;
    begin

        CheckVendInvoice(VendInvoiceDoc);
        VendInvoiceDoc.TestField(VendInvoiceDoc."Reason for rejection");
        if VendInvoiceDoc."Send Email for rejection" then
            if not Confirm(Text025) then exit;

        if not VendInvoiceDoc."Send Email for rejection" then
            if not Confirm(Text026) then exit;

        //IF NOT VendInvoiceDoc.HASLINKS THEN ERROR(Text002);

        VendInvoiceDoc.Status := VendInvoiceDoc.Status::Rejetee;
        VendInvoiceDoc."Sent To Validation Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc.Modify;
        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
          'Rejet de la facture au fournisseur', VendInvoiceDoc.Status::Rejetee, TypeAction::" ");

        //Envoi du mail au fournisseur
        //***********************************
        if VendInvoiceDoc."Send Email for rejection" then begin
            Vend1.Get(VendInvoiceDoc."Vendor No");
            Vend1.TestField("E-Mail");
            AddOnSetup2.Get;
            AddOnSetup2.TestField("Email Vend Invoice Refusal");
            SendEmail_RejetFsseur(VendInvoiceDoc, Vend1."E-Mail", AddOnSetup2."Email Vend Invoice Refusal");
        end;
    end;

    local procedure ValidationResponsable(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Legal Status";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        if VendInvoiceDoc."Validation Level" = VendInvoiceDoc."Validation Level"::AttenteValResp1 then begin
            ValidationResponsable1(VendInvoiceDoc);
            exit;
        end;

        if VendInvoiceDoc."Validation Level" = VendInvoiceDoc."Validation Level"::AttenteValResp2 then begin
            ValidationResponsable2(VendInvoiceDoc);
            exit;
        end;

        if VendInvoiceDoc."Validation Level" = VendInvoiceDoc."Validation Level"::AttenteValResp3 then begin
            ValidationResponsable3(VendInvoiceDoc);
            exit;
        end;
    end;

    local procedure ValidationResponsable1(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        CheckVendInvoice(VendInvoiceDoc);

        if CanGoToNextLevel(VendInvoiceDoc, 2) then begin

            //VendInvoiceDoc.Validator := USERID;
            VendInvoiceDoc.Status := VendInvoiceDoc.Status::AttenteValResp2;
            VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::AttenteValResp2;
            VendInvoiceDoc.Validator := GetWorkflowUser(VendInvoiceDoc, 2);
            VendInvoiceDoc.Modify;
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Attente pré-validation', VendInvoiceDoc.Status::AttenteValResp2, TypeAction::" ");
            SendEmail_Facture(VendInvoiceDoc, 2);
        end else begin
            ValidationResponsable3(VendInvoiceDoc);
        end;
    end;

    local procedure ValidationResponsable2(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        CheckVendInvoice(VendInvoiceDoc);

        if CanGoToNextLevel(VendInvoiceDoc, 3) then begin

            //VendInvoiceDoc.Validator := USERID;
            VendInvoiceDoc.Status := VendInvoiceDoc.Status::AttenteValResp3;
            VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::AttenteValResp3;
            VendInvoiceDoc.Validator := GetWorkflowUser(VendInvoiceDoc, 3);
            VendInvoiceDoc.Modify;
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Attente validation finale', VendInvoiceDoc.Status::AttenteValResp3, TypeAction::" ");
            SendEmail_Facture(VendInvoiceDoc, 3);
        end else begin
            ValidationResponsable3(VendInvoiceDoc);
        end;
    end;

    local procedure ValidationResponsable3(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        WkflCode: Record "Custom Workflow Config";
    begin

        CheckVendInvoice(VendInvoiceDoc);

        WkflCode.Get(WkflCode."Workflow Type"::VendorInvoice, VendInvoiceDoc."Workflow Code");

        if (not WkflCode.Regularisation) then begin

            VendInvoiceDoc.Validator := UserId;
            VendInvoiceDoc.Status := VendInvoiceDoc.Status::Validee;
            VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::Validee;

            VendInvoiceDoc.Modify;
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Facture validée', VendInvoiceDoc.Status::Validee, TypeAction::" ");

        end else begin

            MarquerCommePayee(VendInvoiceDoc);

        end;
    end;

    local procedure RenvoyerEnComptaFournisseur(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        CheckVendInvoice(VendInvoiceDoc);
        VendInvoiceDoc.Validator := UserId;
        VendInvoiceDoc.Status := VendInvoiceDoc.Status::Receptionee;
        VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::Receptionee;

        VendInvoiceDoc.Modify;
        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
          'Facture renvoyée en compta fsseur', VendInvoiceDoc.Status::Receptionee, TypeAction::" ");
    end;

    local procedure Archiver(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
        IsFinLitige: Boolean;
    begin

        if not Confirm(Text039) then exit;

        IsFinLitige := VendInvoiceDoc.Status = VendInvoiceDoc.Status::Litigieuse;

        CheckVendInvoice(VendInvoiceDoc);
        VendInvoiceDoc.Validator := UserId;
        VendInvoiceDoc.Status := VendInvoiceDoc.Status::Archived;
        VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::Archived;

        VendInvoiceDoc.Modify;

        if IsFinLitige then
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Facture archivée', VendInvoiceDoc.Status::Archived, TypeAction::FinLitige)
        else
            InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
              'Facture archivée', VendInvoiceDoc.Status::Archived, TypeAction::" ");

        //Verifier si une facture a ete enregistree avec ce numéro qu'elle est lettree
        PostedPurchInv.Reset;
        PostedPurchInv.SetCurrentKey("Pay-to Vendor No.");
        PostedPurchInv.SetRange("Pay-to Vendor No.", VendInvoiceDoc."Vendor No");
        PostedPurchInv.SetRange("Vendor Invoice No.", VendInvoiceDoc."Vendor Invoice No.");
        if PostedPurchInv.FindFirst then begin
            PostedPurchInv.CalcFields(Closed);
            if not PostedPurchInv.Closed then
                Error(Text042, PostedPurchInv."No.");
        end;
    end;

    local procedure RefusValidation(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
    begin

        CheckVendInvoice(VendInvoiceDoc);
        VendInvoiceDoc.TestField(VendInvoiceDoc."Reason for refusal");

        if not Confirm(Text027) then exit;

        VendInvoiceDoc.Status := VendInvoiceDoc.Status::Litigieuse;
        VendInvoiceDoc."Sent To Validation Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc.Modify;
        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
          'Mise en litige', VendInvoiceDoc.Status::Litigieuse, TypeAction::" ");


        EnvoiEmailRefus_Facture(VendInvoiceDoc);
    end;

    procedure ValidationAutoFactureCompta(PurchH: Record "Purchase Header"; VendorAmountTTC: decimal; VendorAmountHT: decimal)
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
        NveauStatus: Text[30];
        IdStatut: Integer;
        PurchReq: Record "PO Tracking Information";
        EmailTo: Text[100];
    begin

        //Que faire dans le cas ou la cde n'est pas liée à une requisition?
        if PurchH."Skip Invoice Control" then exit;

        if PurchH."Document Type" = PurchH."Document Type"::"Return Order" then exit;
        //IF PurchH."Document Type" = PurchH."Document Type"::"Credit Memo" THEN EXIT;
        //IF PurchH."Document Type" <> PurchH."Document Type"::Order THEN EXIT;


        VendInvoiceDoc1.Reset;
        VendInvoiceDoc1.SetCurrentKey("Vendor No", "Vendor Invoice No.");
        VendInvoiceDoc1.SetRange("Vendor No", PurchH."Buy-from Vendor No.");
        if PurchH."Document Type" = PurchH."Document Type"::"Credit Memo" then
            VendInvoiceDoc1.SetRange("Vendor Invoice No.", PurchH."Vendor Cr. Memo No.")
        else
            VendInvoiceDoc1.SetRange("Vendor Invoice No.", PurchH."Vendor Invoice No.");
        if not VendInvoiceDoc1.FindFirst then begin
            //IF PurchH."Order Class"<>'' THEN EXIT;//Anciennes commandes avant golive
            if SecMgt.CanPostVendInvoiceDirectly then
                exit
            else
                Error(Text017, PurchH."Vendor Invoice No.", PurchH."Buy-from Vendor No.");

        end;

        if (VendInvoiceDoc1.Status <> VendInvoiceDoc1.Status::Receptionee) then
            Error(Text030, VendInvoiceDoc1."Reference Number", VendInvoiceDoc1."Vendor Invoice No.");


        ControlMontantAFacturer(PurchH, VendInvoiceDoc1, VendorAmountTTC, VendorAmountHT);
        /*
        PurchH.CALCFIELDS(Amount);
        PurchH.CALCFIELDS("Amount Including VAT");
        IF ABS(PurchH.Amount)<>ABS(VendInvoiceDoc1.MontantHTVA) THEN
          ERROR(TextErrorSameHT,PurchH.Amount,VendInvoiceDoc1."Reference Number",VendInvoiceDoc1.MontantHTVA);
        
        IF ABS(PurchH."Amount Including VAT")<>ABS(VendInvoiceDoc1.MontantTTC) THEN
          ERROR(TextErrorSameHT,PurchH."Amount Including VAT",VendInvoiceDoc1."Reference Number",VendInvoiceDoc1.MontantTTC);
          */

        if ((PurchH."Currency Code" = '') or (PurchH."Currency Code" = 'MGA')) then begin

            if ((Format(VendInvoiceDoc1.Devise) <> '') and (Format(VendInvoiceDoc1.Devise) <> 'MGA')) then
                Error(TextErrorSameCurrency, PurchH."Currency Code",
                  VendInvoiceDoc1."Reference Number", Format(VendInvoiceDoc1.Devise));

        end else begin

            if (PurchH."Currency Code") <> Format(VendInvoiceDoc1.Devise) then
                Error(TextErrorSameCurrency, PurchH."Currency Code",
                  VendInvoiceDoc1."Reference Number", Format(VendInvoiceDoc1.Devise));
        end;
        //VendInvoiceDoc1.TESTFIELD(VendInvoiceDoc1.Status,VendInvoiceDoc1.Status::Validee);

        PurchH.TestField("Buy-from Vendor No.", VendInvoiceDoc1."Vendor No");

        //Le numéro de commande doit etre le meme
        if PurchH."Document Type" = PurchH."Document Type"::Order then
            //IF VendInvoiceDoc1."Order No" <> '' THEN
            if VendInvoiceDoc1."Order No" <> PurchH."No." then
                Error(Text013, VendInvoiceDoc1."Order No");


        ValidationPreSaisie(VendInvoiceDoc1);

        //VendInvoiceDoc1.Validator := GetIdUserDAF();
        //VendInvoiceDoc1.Status := VendInvoiceDoc1.Status::Comptabilise;
        VendInvoiceDoc1."Posted Invoice No" := PurchH."Posting No.";
        VendInvoiceDoc1."Due Date" := PurchH."Due Date";
        //VendInvoiceDoc1."Validation Level" := VendInvoiceDoc1."Validation Level"::Comptabilise;
        VendInvoiceDoc1.Modify;

        /*
        InsertNewStep(StepEntry."Document Type"::VendorInvoice,VendInvoiceDoc1."Entry No", VendInvoiceDoc1."Reference Number",
          'Facture comptabilisée',VendInvoiceDoc1.Status::Comptabilise);
        */

    end;

    procedure ValidationAutoPaiement(VendNo: Code[20]; VendInvoiceNo1: Code[35]; PostedPaymentDocNo1: Code[20]; VendInvoiceNo2: Code[35]; PostedPaymentDocNo2: Code[20])
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
        NveauStatus: Text[30];
        IdStatut: Integer;
        PurchOrder: Record "Purchase Header";
        IsArchived: Boolean;
        IsLitigieuse: Boolean;
    begin

        //Facture est 1er element de lettrage
        VendInvoiceDoc1.Reset;
        VendInvoiceDoc1.SetCurrentKey("Vendor No", "Vendor Invoice No.");
        VendInvoiceDoc1.SetRange("Vendor No", VendNo);
        VendInvoiceDoc1.SetRange("Vendor Invoice No.", VendInvoiceNo1);
        if VendInvoiceDoc1.FindFirst then
            ControleLettrageFacture(VendInvoiceDoc1, PostedPaymentDocNo1);

        //END ELSE BEGIN

        //Facture est 2eme element de lettrage

        VendInvoiceDoc1.Reset;
        VendInvoiceDoc1.SetCurrentKey("Vendor No", "Vendor Invoice No.");
        VendInvoiceDoc1.SetRange("Vendor No", VendNo);
        VendInvoiceDoc1.SetRange("Vendor Invoice No.", VendInvoiceNo2);
        if VendInvoiceDoc1.FindFirst then
            ControleLettrageFacture(VendInvoiceDoc1, PostedPaymentDocNo2);

        //END;
    end;

    local procedure ControleLettrageFacture(var VendInvoiceDoc1: Record "Vendor Invoice Doc"; PostedPaymentDocNo: Code[20])
    var
        NveauStatus: Text[30];
        IdStatut: Integer;
        PurchOrder: Record "Purchase Header";
        IsArchived: Boolean;
        IsLitigieuse: Boolean;
    begin

        if ((VendInvoiceDoc1.Status <> VendInvoiceDoc1.Status::AttentePaiement) and
            (VendInvoiceDoc1.Status <> VendInvoiceDoc1.Status::Archived) and
            (VendInvoiceDoc1.Status <> VendInvoiceDoc1.Status::Payee) and
            (VendInvoiceDoc1.Status <> VendInvoiceDoc1.Status::Litigieuse)) then
            Error(Text031, VendInvoiceDoc1."Reference Number", VendInvoiceDoc1."Vendor Invoice No.");
        //VendInvoiceDoc1.TESTFIELD(VendInvoiceDoc1.Status,VendInvoiceDoc1.Status::AttentePaiement);

        IsArchived := VendInvoiceDoc1.Status = VendInvoiceDoc1.Status::Archived;
        IsLitigieuse := VendInvoiceDoc1.Status = VendInvoiceDoc1.Status::Litigieuse;

        if not IsArchived then
            VendInvoiceDoc1.Status := VendInvoiceDoc1.Status::Payee;
        if IsLitigieuse then
            VendInvoiceDoc1.Status := VendInvoiceDoc1.Status::Archived;
        VendInvoiceDoc1."Payment Doc" := PostedPaymentDocNo;
        VendInvoiceDoc1."Payment Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc1."Pay By" := UserId;
        VendInvoiceDoc1.Modify;

        NveauStatus := 'Facture payee';
        if ((IsArchived) or (IsLitigieuse)) then
            NveauStatus := 'Facture régularisée';
        IdStatut := VendInvoiceDoc1.Status::Payee;

        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc1."Entry No",
          VendInvoiceDoc1."Reference Number", NveauStatus, IdStatut, TypeAction::" ");
    end;

    local procedure ControlMontantAFacturer(PurchH: Record "Purchase Header"; VendInvoiceDoc1: Record "Vendor Invoice Doc"; MontantTTC: Decimal; MontantHT: Decimal)
    var
        MontantAfacturer: Decimal;
        PurchLine: Record "Purchase Line";
    // MontantHT: Decimal;
    // MontantTTC: Decimal;
    begin

        /*MontantAfacturer:=0;
        PurchLine.RESET;
        PurchLine.SETRANGE(PurchLine."Document Type",PurchH."Document Type");
        PurchLine.SETRANGE(PurchLine."Document No.",PurchH."No.");
        IF PurchLine.FINDSET THEN
          REPEAT
            MontantAfacturer := MontantAfacturer + PurchLine.GetLineAmountToHandle(PurchLine."Qty. to Invoice");
          UNTIL PurchLine.NEXT=0;
          */

        //CalcInvAmounts(PurchH, MontantHT, MontantTTC);

        UserSetup.Get(UserId);
        if not UserSetup.CanPostDirectPurchInvNoControl then begin

            if Abs(MontantHT) <> Abs(VendInvoiceDoc1.MontantHTVA) then
                Error(TextErrorSameHT, MontantHT, VendInvoiceDoc1."Reference Number", VendInvoiceDoc1.MontantHTVA);

            if Abs(MontantTTC) <> Abs(VendInvoiceDoc1.MontantTTC) then
                Error(TextErrorSameTTC, MontantTTC, VendInvoiceDoc1."Reference Number", VendInvoiceDoc1.MontantTTC);

        end;

    end;

    local procedure AutoriserPaiementDAF(var VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        CheckVendInvoice(VendInvoiceDoc);

        //IF NOT VendInvoiceDoc.HASLINKS THEN ERROR(Text002);

        VendInvoiceDoc.Status := VendInvoiceDoc.Status::AttentePaiement;
        VendInvoiceDoc."Validation Level" := VendInvoiceDoc."Validation Level"::AttenteBAP;
        VendInvoiceDoc."Sent To Validation Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc.Modify;
        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc."Entry No", VendInvoiceDoc."Reference Number",
          'Bon à payer', VendInvoiceDoc.Status::AttentePaiement, TypeAction::" ");


        //Liberer la facture fournisseur pour le paiement
        /*
        VendLedgEntry.RESET;
        VendLedgEntry.SETRANGE("External Document No.",VendInvoiceDoc."Vendor Invoice No.");
        IF VendLedgEntry.FINDSET THEN
        REPEAT
          IF VendLedgEntry."On Hold"='GDP' THEN BEGIN
            VendLedgEntry."On Hold":='';
            VendLedgEntry.MODIFY;
          END;
        UNTIL VendLedgEntry.NEXT=0;
        */

    end;

    local procedure CheckVendInvoice(VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        VendInvoiceDoc1: Record "Vendor Invoice Doc";
        DateMinArrivee: Date;
        DateMaxArrivee: Date;
    begin

        VendInvoiceDoc.TestField("Arrival Date");

        //VendInvoiceDoc.TESTFIELD("Vendor No");
        //IF NOT VendInvoiceDoc.FactureDirecte THEN VendInvoiceDoc.TESTFIELD("Order No");
        //VendInvoiceDoc.TESTFIELD("Invoice Date");

        //JN26092 controle des montants
        if VendInvoiceDoc.Type = VendInvoiceDoc.Type::Invoice then
            if ((VendInvoiceDoc.MontantHTVA < 0) or (VendInvoiceDoc.MontantTTC < 0)) then
                Error(Text043);

        if VendInvoiceDoc.Type = VendInvoiceDoc.Type::CreditMemo then
            if ((VendInvoiceDoc.MontantHTVA > 0) or (VendInvoiceDoc.MontantTTC > 0)) then
                Error(Text043);


        if (VendInvoiceDoc.Status = VendInvoiceDoc.Status::EnSaisie) then begin
            DateMaxArrivee := Today;
            DateMinArrivee := CalcDate('<-3D>', Today);
            if ((VendInvoiceDoc."Arrival Date" > DateMaxArrivee) or (VendInvoiceDoc."Arrival Date" < DateMinArrivee)) then
                Error(Text032, DateMinArrivee, DateMaxArrivee);
        end;


        if VendInvoiceDoc.Status <> VendInvoiceDoc.Status::EnSaisie then begin
            //IF ((VendInvoiceDoc.Status<>VendInvoiceDoc.Status::Receptionee) OR (VendInvoiceDoc."Posted Invoice No"<>'')) THEN
            VendInvoiceDoc.TestField("Workflow Code");
            VendInvoiceDoc.TestField("Vendor No");
            VendInvoiceDoc.TestField("Vendor Invoice No.");
        end;

        VendInvoiceDoc1.Reset;
        VendInvoiceDoc1.SetCurrentKey("Vendor No", "Vendor Invoice No.");
        VendInvoiceDoc1.SetRange("Vendor No", VendInvoiceDoc."Vendor No");
        VendInvoiceDoc1.SetRange("Vendor Invoice No.", VendInvoiceDoc."Vendor Invoice No.");
        VendInvoiceDoc1.SetFilter("Entry No", '<>%1', VendInvoiceDoc."Entry No");
        if VendInvoiceDoc1.FindFirst then Error(Text003, VendInvoiceDoc."Vendor Invoice No.");

        CheckIfDocHasLinks(VendInvoiceDoc);
        //if not VendInvoiceDoc.HasLinks then Error(Text002);
    end;

    procedure InsertNewStep(DocType: Integer; EntryID: Integer; InvNo: Code[35]; NewStatus: Text[50]; NewStatusID: Integer; TypeAction: Integer)
    var
        StepEntry: Record "Document Step History";
        NextStepId: Integer;
    begin

        StepEntry.Reset;
        StepEntry.SetRange(StepEntry."Document Type", DocType);
        StepEntry.SetRange(StepEntry."Document No.", InvNo);
        if StepEntry.FindLast then
            NextStepId := StepEntry."Step ID" + 1
        else
            NextStepId := 1;


        StepEntry.Init;
        StepEntry."Document Type" := DocType;
        StepEntry."Document No." := InvNo;
        //StepEntry.EntryID := EntryID;
        StepEntry."Step ID" := NextStepId;
        StepEntry.Action := StepEntry.Action::"Change Status";
        StepEntry."New Status" := NewStatus;
        //StepEntry."Created Document" := CreatedDocument;
        StepEntry."New Status ID" := NewStatusID;
        StepEntry.UserID := UserId;
        StepEntry."Action Date" := CreateDateTime(Today, Time);
        StepEntry.TypeAction := TypeAction;
        StepEntry.Insert;
    end;

    procedure EnvoiEmailLitige_Facture(VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        Objet: Text;
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text;
        CCAdress: Text;
        Sender: Text[150];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
        PurchOrder: Record "Purchase Header";
    begin
        //Email a l'acheteur et aux comptables
        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        ToAdress := GetEmailsAcheteurs_New();
        CCAdress := GetEmailGroupComptables();

        Objet := 'Nouveau litige sur une facture : ' + CodeDocument;
        CodeDocument := VendInvoiceDoc."Vendor Invoice No.";
        Commentaires := VendInvoiceDoc."Order No";
        //ToAdress := GetEmail(PurchReq."Requestor ID");
        //CCAdress := '';
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Facture d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text011);
    end;

    procedure SendEmail(Objet: Text[80]; CodeDocument: Text[30]; Commentaires: Text[150]; ToAdress: Text; CCAdress: Text; Sender: Text[100]; SendDate: Text[50]; DocType: Text[30])
    var
        // SMTPMail: Codeunit "SMTP Mail";
        NewObjet: Text;
        EmailToSend: Record "Tampon Payment Vendor Email" temporary;
        EmailMgt: Codeunit EmailMgt;
    begin

        EmailToSend.Init();
        //EmailToSend.EntryID := EmailMgt.GetNextEntryNoInEmailRec();
        EmailToSend.EmailObject := Objet;
        EmailToSend.BodyAsHTML := CreateEmailBody(CodeDocument, Commentaires, Sender, SendDate, DocType);
        EmailToSend.SendTo := ToAdress;
        EmailToSend.EmailType := EmailToSend.EmailType::VendorInvoice;
        EmailToSend."User ID" := UserId;
        EmailToSend."Entry Date" := Today;
        EmailToSend."Document No." := CodeDocument;
        if (CCAdress <> '') then
            EmailToSend.SendToCC := CCAdress;

        EmailMgt.SendEmail(EmailToSend);
    end;

    local procedure CreateEmailBody(CodeDocument: Text[30]; Commentaires: Text[150]; Sender: Text[80]; SendDate: Text[50]; DocType: Text[30]): Text
    var
        BodyText: Text;
    begin
        BodyText := '<html><body>';
        BodyText += '<table border="0" he cellpadding="0" cellspacing="0" width="100%" bgcolor="#ecf0f1">';
        BodyText += '<span style="font-family: Tahoma; font-size: 12;">';
        BodyText += '<p>D&eacute;tails du document :</p>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Document : <strong>' + DocType + ' ' + CodeDocument + '</strong></li>';
        BodyText += '</ul>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Trait&eacute; par : <strong>' + Sender + '</strong></li>';
        BodyText += '</ul>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Trait&eacute; le : <strong>' + SendDate + '</strong></li>';
        BodyText += '</ul>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Commentaires : <em>' + Commentaires + '</em></li>';
        BodyText += '</ul>';
        BodyText += '</span>';
        BodyText += '<p>&nbsp;</p>';
        BodyText += '<p style="color: rgb(210, 11, 0);"><big>_________________________________</big></p>';
        BodyText += '<p style="color: rgb(0, 113, 66);">Message envoy&eacute; depuis Dynamics Business Central.</p>';
        BodyText += '</body></html>';

        exit(BodyText);
    end;

    procedure GetEmail(UserId: Code[50]): Text
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField(UserSetup."E-Mail");
        exit(UserSetup."E-Mail");
    end;

    local procedure SendEmail_Facture(FactureFsseur: Record "Vendor Invoice Doc"; Niveau: Integer)
    var
        Objet: Text[80];
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text;
        CCAdress: Text;
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
    begin

        exit;//Envoi de mail désactivé

        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        FactureFsseur.TestField(Validator);

        Objet := 'Nouvelle facture d''achat à valider : ' + FactureFsseur."Reference Number";

        CodeDocument := FactureFsseur."Vendor Invoice No.";
        ToAdress := GetEmail(FactureFsseur.Validator);
        CCAdress := '';
        AddCCInterimDemandeur(FactureFsseur, CCAdress, Niveau);
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Facture d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text011);
    end;

    local procedure SendEmail_Facture_DAF(FactureFsseur: Record "Vendor Invoice Doc")
    var
        Objet: Text[80];
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text;
        CCAdress: Text;
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
    begin

        exit;//Envoi de mail désactivé

        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        FactureFsseur.TestField(Validator);

        Objet := 'Nouvelle facture d''achat comptabilisée : ' + FactureFsseur."Reference Number";
        CodeDocument := FactureFsseur."Vendor Invoice No.";
        ToAdress := GetEmail(FactureFsseur.Validator);
        CCAdress := '';
        AddCCInterimSG(FactureFsseur, CCAdress);
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Facture d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text011);
    end;

    local procedure GetEmailResp(WCode: Code[20]; var EmailCC: Text; Niveau: Integer): Text[100]
    var
        UserSetup: Record "User Setup";
        WUser: Record "Custom Workflow Config";
    begin
        UserSetup.Get(UserId);
        WUser.Get(WUser."Workflow Type"::VendorInvoice, WCode);

        if (Niveau = 1) then begin
            if WUser."Activate Interim 1" then begin
                if WUser."Interim User 1" <> '' then begin
                    if EmailCC = '' then
                        EmailCC := GetEmail(WUser."Interim User 1")
                    else
                        EmailCC := EmailCC + '; ' + GetEmail(WUser."Interim User 1");
                end;
            end;
        end;
        if (Niveau = 2) then begin
            if WUser."Activate Interim 2" then begin
                if WUser."Interim User 2" <> '' then begin
                    if EmailCC = '' then
                        EmailCC := GetEmail(WUser."Interim User 2")
                    else
                        EmailCC := EmailCC + '; ' + GetEmail(WUser."Interim User 2");
                end;
            end;
        end;
        if (Niveau = 3) then begin
            if WUser."Activate Interim 3" then begin
                if WUser."Interim User 3" <> '' then begin
                    if EmailCC = '' then
                        EmailCC := GetEmail(WUser."Interim User 3")
                    else
                        EmailCC := EmailCC + '; ' + GetEmail(WUser."Interim User 3");
                end;
            end;
        end;
        //EXIT(GetEmail(UserSetup."Approver ID"));
    end;

    local procedure GetEmailGroupAcheteurs(): Text
    var
        _RecepientPURCH: Text;
        _RecepientCC: Text;
        _ReceipientTEMP: Record "User Setup" temporary;
        ReqMgt: Codeunit "Logistique Mgt";
    begin
        //gReqMgt.GetmailContact_SETUP(

        //EXIT('');
        /*
        gRequisitionSetup.GET;
        _ReceipientTEMP.RESET;
        _ReceipientTEMP.DELETEALL;
        _RecepientPURCH := ReqMgt.GetmailContact_SETUP(gRequisitionSetup."PR Approval Group Code",USERID,
                                                      gRequisitionSetup."PR Purchaser Group Code",TRUE,_ReceipientTEMP);
        EXIT(_RecepientPURCH);
        */

    end;

    procedure GetEmailGroupComptables(): Text
    var
        _RecepientPURCH: Text;
        _RecepientCC: Text;
        USetup: Record "User Setup" temporary;
        ReqMgt: Codeunit "Logistique Mgt";
    begin

        USetup.Reset;
        USetup.SetRange(USetup.IsVendorAccountant, true);
        if USetup.FindSet then
            repeat
                USetup.TestField("E-Mail");
                if _RecepientPURCH = '' then
                    _RecepientPURCH := USetup."E-Mail"
                else
                    _RecepientPURCH := _RecepientPURCH + '; ' + USetup."E-Mail";
            until USetup.Next = 0;

        exit(_RecepientPURCH);
    end;

    local procedure AddCCInterimDemandeur(VendInvoice: Record "Vendor Invoice Doc"; var EmailCC: Text; Niveau: Integer)
    var
        WUser: Record "Custom Workflow Config";
    begin

        WUser.Get(WUser."Workflow Type"::VendorInvoice, VendInvoice."Workflow Code");

        if (Niveau = 1) then begin
            if WUser."Activate Interim 1" then begin
                if WUser."Interim User 1" <> '' then begin
                    if EmailCC = '' then
                        EmailCC := GetEmail(WUser."Interim User 1")
                    else
                        EmailCC := EmailCC + '; ' + GetEmail(WUser."Interim User 1");
                end;
            end;
        end;
        if (Niveau = 2) then begin
            if WUser."Activate Interim 2" then begin
                if WUser."Interim User 2" <> '' then begin
                    if EmailCC = '' then
                        EmailCC := GetEmail(WUser."Interim User 2")
                    else
                        EmailCC := EmailCC + '; ' + GetEmail(WUser."Interim User 2");
                end;
            end;
        end;
        if (Niveau = 3) then begin
            if WUser."Activate Interim 3" then begin
                if WUser."Interim User 3" <> '' then begin
                    if EmailCC = '' then
                        EmailCC := GetEmail(WUser."Interim User 3")
                    else
                        EmailCC := EmailCC + '; ' + GetEmail(WUser."Interim User 3");
                end;
            end;
        end;
    end;

    local procedure AddCCInterimSG(VendInvoice: Record "Vendor Invoice Doc"; var EmailCC: Text)
    var
        WUser: Record "Custom Workflow Config";
    begin

        AddOnSetup2.Get;
        if AddOnSetup2."Activate Interim DAF" then begin
            if AddOnSetup2."Interim User DAF" <> '' then begin
                if EmailCC = '' then
                    EmailCC := GetEmail(AddOnSetup2."Interim User DAF")
                else
                    EmailCC := EmailCC + '; ' + GetEmail(AddOnSetup2."Interim User DAF");
            end;
        end;
    end;

    local procedure GetIDResp(UserId: Code[50]): Code[50]
    var
        UserSetup: Record "User Setup";
    begin
        if (UserSetup.Get(UserId)) then
            exit(UserSetup."Approver ID");
    end;

    procedure GetEmailsAcheteurs_New() Emails: Text
    var
        UserSetup: Record "User Setup";
    begin
        /*
        UserSetup.SETRANGE(UserSetup."Purchasing Dept",TRUE);
        IF UserSetup.FINDSET THEN
        REPEAT
          IF Emails = '' THEN
                Emails := UserSetup."E-Mail"
            ELSE
                Emails := Emails + '; ' + UserSetup."E-Mail";
        UNTIL UserSetup.NEXT=0;
        */

    end;

    local procedure GetWorkflowUser(VendInv: Record "Vendor Invoice Doc"; Level: Integer): Code[50]
    var
        WUser: Record "Custom Workflow Config";
    begin
        WUser.Get(WUser."Workflow Type"::VendorInvoice, VendInv."Workflow Code");
        if (Level = 1) then begin
            WUser.TestField("User 1");
            exit(WUser."User 1");
        end;
        if (Level = 2) then begin
            WUser.TestField("User 2");
            exit(WUser."User 2");
        end;
        if (Level = 3) then begin
            WUser.TestField("User 3");
            exit(WUser."User 3");
        end;
    end;

    local procedure CanGoToNextLevel(VendInv: Record "Vendor Invoice Doc"; NextLevel: Integer): Boolean
    var
        WUser: Record "Custom Workflow Config";
    begin
        WUser.Get(WUser."Workflow Type"::VendorInvoice, VendInv."Workflow Code");
        if (NextLevel = 1) then begin
            Error('Invalid Level');
        end;

        if (NextLevel = 2) then
            exit(WUser."User 2" <> '');

        if (NextLevel = 3) then
            exit(WUser."User 3" <> '');
    end;

    local procedure GetIdUserDAF(): Code[50]
    begin
        AddOnSetup2.Get;
        AddOnSetup2.TestField(AddOnSetup2."User DAF");
        exit(AddOnSetup2."User DAF");
    end;

    procedure GetServicesUserFilter() Rep: Text
    var
        WUser: Record "Custom Workflow Config";
    begin

        WUser.Reset;
        WUser.SetRange(WUser."User 1", UserId);
        if WUser.FindSet then
            repeat
                if Rep = '' then
                    Rep := WUser."Workflow Code"
                else
                    Rep := Rep + '|' + WUser."Workflow Code";
            until WUser.Next = 0;

        WUser.Reset;
        WUser.SetRange(WUser."User 2", UserId);
        if WUser.FindSet then
            repeat
                if Rep = '' then
                    Rep := WUser."Workflow Code"
                else
                    Rep := Rep + '|' + WUser."Workflow Code";
            until WUser.Next = 0;

        WUser.Reset;
        WUser.SetRange(WUser."User 3", UserId);
        if WUser.FindSet then
            repeat
                if Rep = '' then
                    Rep := WUser."Workflow Code"
                else
                    Rep := Rep + '|' + WUser."Workflow Code";
            until WUser.Next = 0;

        WUser.Reset;
        WUser.SetRange(WUser."Interim User 1", UserId);
        WUser.SetRange(WUser."Activate Interim 1", true);
        if WUser.FindSet then
            repeat
                if Rep = '' then
                    Rep := WUser."Workflow Code"
                else
                    Rep := Rep + '|' + WUser."Workflow Code";
            until WUser.Next = 0;

        WUser.Reset;
        WUser.SetRange(WUser."Interim User 2", UserId);
        WUser.SetRange(WUser."Activate Interim 2", true);
        if WUser.FindSet then
            repeat
                if Rep = '' then
                    Rep := WUser."Workflow Code"
                else
                    Rep := Rep + '|' + WUser."Workflow Code";
            until WUser.Next = 0;

        WUser.Reset;
        WUser.SetRange(WUser."Interim User 3", UserId);
        WUser.SetRange(WUser."Activate Interim 3", true);
        if WUser.FindSet then
            repeat
                if Rep = '' then
                    Rep := WUser."Workflow Code"
                else
                    Rep := Rep + '|' + WUser."Workflow Code";
            until WUser.Next = 0;

        if Rep = '' then
            Rep := ';:*%';// Show nothing
    end;

    procedure CanValidateAsUser1(VendInvoice: Record "Vendor Invoice Doc"): Boolean
    var
        WUser: Record "Custom Workflow Config";
    begin

        VendInvoice.TestField("Workflow Code");
        WUser.Get(WUser."Workflow Type"::VendorInvoice, VendInvoice."Workflow Code");

        if WUser."User 1" = UserId then
            exit(true);

        if WUser."Activate Interim 1" then
            if WUser."Interim User 1" = UserId then
                exit(true);
    end;

    procedure CanValidateAsUser2(VendInvoice: Record "Vendor Invoice Doc"): Boolean
    var
        WUser: Record "Custom Workflow Config";
    begin

        VendInvoice.TestField("Workflow Code");
        WUser.Get(WUser."Workflow Type"::VendorInvoice, VendInvoice."Workflow Code");

        if WUser."User 2" = UserId then
            exit(true);

        if WUser."Activate Interim 2" then
            if WUser."Interim User 2" = UserId then
                exit(true);
    end;

    procedure CanValidateAsUser3(VendInvoice: Record "Vendor Invoice Doc"): Boolean
    var
        WUser: Record "Custom Workflow Config";
    begin

        VendInvoice.TestField("Workflow Code");
        WUser.Get(WUser."Workflow Type"::VendorInvoice, VendInvoice."Workflow Code");

        if WUser."User 3" = UserId then
            exit(true);

        if WUser."Activate Interim 3" then
            if WUser."Interim User 3" = UserId then
                exit(true);
    end;

    procedure CanValidateAsDAF(): Boolean
    var
        WUser: Record "Custom Workflow Config";
    begin
        AddOnSetup2.Get;
        AddOnSetup2.TestField(AddOnSetup2."User DAF");

        if AddOnSetup2."User DAF" = UserId then
            exit(true);

        if AddOnSetup2."Activate Interim DAF" then
            if AddOnSetup2."Interim User DAF" = UserId then
                exit(true);
    end;

    procedure CanValidateAsCompta(): Boolean
    var
        WUser: Record "Custom Workflow Config";
    begin
        UserSetup.Reset;
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange(IsVendorAccountant, true);
        exit(UserSetup.FindFirst);
    end;

    procedure SendEmail_RejetFsseur(VendInv: Record "Vendor Invoice Doc"; ToAdress: Text[80]; CCAdress: Text)
    var
        EmailToSend: Record "Tampon Payment Vendor Email";
        EmailMgt: Codeunit EmailMgt;
        NewObjet: Text;
        Objet: Text;
    begin

        Objet := STRSUBSTNO(ObjetEmailFsseur, VendInv."Vendor Invoice No.", FORMAT(VendInv."Invoice Date"));

        EmailToSend.Init();
        //EmailToSend.EntryID := EmailMgt.GetNextEntryNoInEmailRec();
        EmailToSend.EmailObject := Objet;
        EmailToSend.BodyAsHTML := CreateEmailBody(VendInv);
        EmailToSend.SendTo := ToAdress;
        EmailToSend.EmailType := EmailToSend.EmailType::VendorInvoice;
        EmailToSend."User ID" := UserId;
        EmailToSend."Entry Date" := Today;
        EmailToSend."Document No." := VendInv."Reference Number";
        if (CCAdress <> '') then
            EmailToSend.SendToCC := CCAdress;

        EmailMgt.SendEmail(EmailToSend);
    end;

    local procedure CreateEmailBody(VendInv: Record "Vendor Invoice Doc"): Text
    var
        BodyText: Text;
    begin
        BodyText := '<html><body>';

        BodyText += '<span style="font-family: Arial;">Madame, Monsieur,<br>';
        BodyText += '<br>Nous avons bien reçu votre facture que nous sommes contraints ';
        BodyText += 'de retourner par le pr&eacute;sent mail afin qu&#8217;elle soit corrig&eacute;e ';
        BodyText += 'pour le motif <span style="font-weight: bold;"> : "' + VendInv."Reason for rejection" + '". </span><br><br>';
        BodyText += 'avant le traitement pour le motif &eacute;nonc&eacute;.<br><br>';
        BodyText += 'De ce fait, nous vous prions de r&eacute;gulariser la facture et de nous faire ';
        BodyText += 'parvenir la version rectificative dans les 5 jours &agrave; la r&eacute;ception en vue de son traitement. <br><br>';
        BodyText += 'Nous vous remercions d&#8217;avance de prendre en compte notre demande afin ';
        BodyText += 'de traiter efficacement les paiements des montants de facture corrects ';
        BodyText += 'selon les conditions de paiement que nous avons convenue ensemble. <br><br>';
        BodyText += 'Nous vous informons que l&#8217;&eacute;ch&eacute;ance ne courra qu&#8217;apr&egrave;s r&eacute;ception ';
        BodyText += 'd&eacute;finitive de vos factures en r&egrave;gles et en bonne et due forme.&nbsp; <br>';
        BodyText += '<br>Comptant sur votre collaboration.<br><br><br>';
        BodyText += '<br><span style="font-weight: bold;">Comptabilité fournisseurs</span><br>';
        BodyText += 'Galana Distribution Pétrolière S.A.<br>';
        BodyText += 'Immeuble PRADON Antanimena, 2ème étage. </span><br>';

        BodyText += '</body></html>';

        exit(BodyText);
    end;

    procedure InsertNewPayment(PostedVendInvoiceEntry: Record "Vendor Ledger Entry"; var GenJnlLine: Record "Gen. Journal Line"; var LastLineNo: Integer; var NextDocNo: Code[20]; GenJnlBatch: Record "Gen. Journal Batch"; GenJnlTemplate: Record "Gen. Journal Template")
    var
        Vendor: Record Vendor;
    begin

        GenJnlLine.Init;
        //Window2.UPDATE(1,TempPaymentBuffer."Vendor No.");
        GenJnlLine."Journal Template Name" := GenJnlTemplate.Name;
        GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
        LastLineNo := LastLineNo + 10000;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";

        GenJnlLine."Document No." := NextDocNo;
        NextDocNo := IncStr(NextDocNo);

        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.SetHideValidation(true);
        GenJnlLine.Validate("Posting Date", WorkDate);
        //ShowPostingDateWarning := ShowPostingDateWarning OR
        //  SetPostingDate(GenJnlLine,GetApplDueDate(TempPaymentBuffer."Vendor Ledg. Entry No."),PostingDate);
        GenJnlLine.Validate("Account No.", PostedVendInvoiceEntry."Vendor No.");
        Vendor.Get(PostedVendInvoiceEntry."Vendor No.");
        //IF (Vendor."Pay-to Vendor No." <> '') AND (Vendor."Pay-to Vendor No." <> "Account No.") THEN
        //  MESSAGE(Text025,Vendor.TABLECAPTION,Vendor."No.",Vendor.FIELDCAPTION("Pay-to Vendor No."),
        //    Vendor."Pay-to Vendor No.");
        //"Bal. Account Type" := BalAccType;
        //VALIDATE("Bal. Account No.",BalAccNo);
        GenJnlLine.Validate("Currency Code", PostedVendInvoiceEntry."Currency Code");
        //"Message to Recipient" := GetMessageToRecipient(SummarizePerVend);
        //"Bank Payment Type" := BankPmtType;
        //IF SummarizePerVend THEN BEGIN
        //  "Applies-to ID" := "Document No.";
        //  Description := STRSUBSTNO(Text029,TempPaymentBuffer."Vendor No.");
        //END ELSE
        PostedVendInvoiceEntry.CalcFields(PostedVendInvoiceEntry."Remaining Amount");
        GenJnlLine.Description :=
          StrSubstNo(
            Text029,
            PostedVendInvoiceEntry."Document Type",
            PostedVendInvoiceEntry."Document No.");
        GenJnlLine."Source Line No." := PostedVendInvoiceEntry."Entry No.";
        GenJnlLine."Shortcut Dimension 1 Code" := PostedVendInvoiceEntry."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := PostedVendInvoiceEntry."Global Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := PostedVendInvoiceEntry."Dimension Set ID";
        GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
        GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
        GenJnlLine.Validate(Amount, -PostedVendInvoiceEntry."Remaining Amount");
        GenJnlLine."Applies-to Doc. Type" := PostedVendInvoiceEntry."Document Type";
        GenJnlLine."Applies-to Doc. No." := PostedVendInvoiceEntry."Document No.";
        GenJnlLine."Payment Method Code" := PostedVendInvoiceEntry."Payment Method Code";
        GenJnlLine."Creditor No." := PostedVendInvoiceEntry."Creditor No.";
        GenJnlLine."Payment Reference" := PostedVendInvoiceEntry."Payment Reference";
        GenJnlLine."Exported to Payment File" := PostedVendInvoiceEntry."Exported to Payment File";
        GenJnlLine."Applies-to Ext. Doc. No." := PostedVendInvoiceEntry."Applies-to Ext. Doc. No.";

        UpdateDimensions(GenJnlLine);
        GenJnlLine.Insert;
        //GenJnlLineInserted := TRUE;
    end;

    local procedure UpdateDimensions(var GenJnlLine: Record "Gen. Journal Line")
    var
        DimBuf: Record "Dimension Buffer";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry2: Record "Dimension Set Entry" temporary;
        DimVal: Record "Dimension Value";
        NewDimensionID: Integer;
        DimSetIDArr: array[10] of Integer;
    begin
        GenJnlLine.CreateDimFromDefaultDim(GenJnlLine.FieldNo(GenJnlLine."Account No."));
        GenJnlLine.CreateDimFromDefaultDim(GenJnlLine.FieldNo(GenJnlLine."Bal. Account No."));
        GenJnlLine.CreateDimFromDefaultDim(GenJnlLine.FieldNo(GenJnlLine."Salespers./Purch. Code"));
        GenJnlLine.CreateDimFromDefaultDim(GenJnlLine.FieldNo(GenJnlLine."Job No."));
        GenJnlLine.CreateDimFromDefaultDim(GenJnlLine.FieldNo(GenJnlLine."Campaign No."));
        // with GenJnlLine do begin
        //     NewDimensionID := "Dimension Set ID";
        //     CreateDim(
        //       DimMgt.TypeToTableID1("Account Type"), "Account No.",
        //       DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
        //       DATABASE::Job, "Job No.",
        //       DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
        //       DATABASE::Campaign, "Campaign No.");
        //     if NewDimensionID <> "Dimension Set ID" then begin
        //         DimSetIDArr[1] := "Dimension Set ID";
        //         DimSetIDArr[2] := NewDimensionID;
        //         "Dimension Set ID" :=
        //           DimMgt.GetCombinedDimensionSetID(DimSetIDArr, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        //     end;
        // end;
    end;


    procedure EnvoiEmailRefus_Facture(VendInvoiceDoc: Record "Vendor Invoice Doc")
    var
        Objet: Text;
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text;
        CCAdress: Text;
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
        PurchOrder: Record "Purchase Header";
    begin
        //Email a l'acheteur et aux comptables
        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        AddOnSetup2.Get;

        ToAdress := AddOnSetup2."Email Vend Invoice Refusal";
        //CCAdress := GetEmailGroupComptables();

        CodeDocument := VendInvoiceDoc."Vendor Invoice No.";
        Objet := 'Nouveau Refus sur une facture : ' + VendInvoiceDoc."Reference Number";

        Commentaires := 'Motif du refus : ' + VendInvoiceDoc."Reason for refusal";
        //ToAdress := GetEmail(PurchReq."Requestor ID");
        //CCAdress := '';
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Facture d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text011);
    end;

    procedure RegulFactureFournisseur(var VendInvoiceDoc: Record "Vendor Invoice Doc") Nbre: Integer
    var
        PostedPurchInv: Record "Purch. Inv. Header";
    begin
        //Envoyer en validation une facture deja comptabilisée dans NAV
        PostedPurchInv.Reset;
        PostedPurchInv.SetCurrentKey("Vendor Invoice No.", "Posting Date");
        PostedPurchInv.SetRange(PostedPurchInv."Vendor Invoice No.", VendInvoiceDoc."Vendor Invoice No.");
        PostedPurchInv.SetRange(PostedPurchInv."Buy-from Vendor No.", VendInvoiceDoc."Vendor No");
        if PostedPurchInv.FindFirst then begin
            if ((PostedPurchInv."Buy-from Vendor No." = VendInvoiceDoc."Vendor No") and
              (VendInvoiceDoc.Status = VendInvoiceDoc.Status::Receptionee)) then begin

                ValidationPreSaisie(VendInvoiceDoc);
                VendInvoiceDoc."Posted Invoice No" := PostedPurchInv."No.";
                VendInvoiceDoc."Due Date" := PostedPurchInv."Due Date";
                VendInvoiceDoc.Modify;
                Nbre := Nbre + 1;
            end;
        end;

        if Nbre = 0 then
            Message(Text040)
        else
            Message(Text041);
    end;

    local procedure CheckIfDocHasLinks(VendInvoiceDoc1: Record "Vendor Invoice Doc")
    var
        DocumentAttach: record "Document Attachment";
    begin
        if not VendInvoiceDoc1.HasLinks then Error(Text002);
        // DocumentAttach.Reset();
        // DocumentAttach.SetRange("Table ID", Database::"Vendor Invoice Doc");
        // DocumentAttach.SetRange("No.", VendInvoiceDoc1."Reference Number");
        // //DocumentAttach.SetRange("Document Type", DocumentAttach."Document Type"::"VendorInvoice");
        // if (DocumentAttach.IsEmpty) then
        //     error(Text002);
    end;

    local procedure MarquerCommePayee(var VendInvoiceDoc1: Record "Vendor Invoice Doc")
    var
        NveauStatus: Text[30];
        IdStatut: Integer;
        PurchOrder: Record "Purchase Header";
    begin
        VendInvoiceDoc1.Status := VendInvoiceDoc1.Status::Payee;
        VendInvoiceDoc1."Payment Doc" := '';
        VendInvoiceDoc1."Payment Date" := CreateDateTime(Today, Time);
        VendInvoiceDoc1."Pay By" := UserId;
        VendInvoiceDoc1.Modify;

        NveauStatus := 'Facture payee(Hors paiement)';
        IdStatut := VendInvoiceDoc1.Status::Payee;

        InsertNewStep(StepEntry."Document Type"::VendorInvoice, VendInvoiceDoc1."Entry No",
          VendInvoiceDoc1."Reference Number", NveauStatus, IdStatut, TypeAction::" ");
    end;

    local procedure CalcInvAmounts(PurchaseH: Record "Purchase Header"; var TotalHT: Decimal; var TotalTTC: Decimal)
    var
        TempPurchLine: Record "Purchase Line" temporary;
        PurchPost: Codeunit "Purch.-Post";
        VATAmountLine: Record "VAT Amount Line" temporary;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
    begin
        Clear(TempPurchLine);
        Clear(PurchPost);
        TempPurchLine.DeleteAll;
        VATAmountLine.DeleteAll;
        PurchPost.GetPurchLines(PurchaseH, TempPurchLine, 1);
        TempPurchLine.CalcVATAmountLines(1, PurchaseH, TempPurchLine, VATAmountLine);
        TempPurchLine.UpdateVATOnLines(1, PurchaseH, TempPurchLine, VATAmountLine);
        VATAmount := VATAmountLine.GetTotalVATAmount;
        VATBaseAmount := VATAmountLine.GetTotalVATBase;
        VATDiscountAmount :=
          VATAmountLine.GetTotalVATDiscount(PurchaseH."Currency Code", PurchaseH."Prices Including VAT");
        TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

        TotalHT := TotalAmountInclVAT - VATAmount;
        TotalTTC := TotalAmountInclVAT;
    end;
}

