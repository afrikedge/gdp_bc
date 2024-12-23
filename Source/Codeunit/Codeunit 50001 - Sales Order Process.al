codeunit 50001 "Sales Order Process"
{
    // //JN0001 Création auto demande de déblocage vers le CRM
    // //JN300517 Ajustement de livraison JIRAMA
    // //JN060917 Possibilite d'annuler une cde bloquee avec le statut a ne plus livrer ds le crm
    // //JN100818 Procédure de solde de commande sécurisée


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Voulez-vous valider la livraison de la commande %1 ?';
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        SalesLine1: Record "Sales Line";
        CustCheckCreditLimit: Page "Check Credit Limit";
        Text002: Label 'Voulez-vous annuler la commande %1. \Si oui la commande ne sera plus traitée.';
        Text003: Label 'Vous ne pouvez pas solder cette commande car la quantité livrée n''a pas été completement été facturée pour l''article %1';
        ArchiveManagement: Codeunit ArchiveManagement;
        Text004: Label 'La commande sera renvoyée en saisie. Voulez-vous continuer ?';
        Text005: Label 'Envoyer en traitement';
        Text006: Label 'Supprimer la commande';
        Text007: Label 'Annuler la commande';
        Text008: Label 'Autoriser la livraison';
        Text009: Label 'Solder la commande';
        Text010: Label 'Renvoyer en saisie';
        Text011: Label 'La commande sera supprimée. Voulez-vous continuer ?';
        Selection: Integer;
        Text012: Label '&Envoyer en traitement,&Supprimer la commande';
        Text013: Label '&Valider les prix,&Renvoyer en saisie';
        Text014: Label '&Annuler la commande';
        Text015: Label '&Autoriser la livraison,&Renvoyer en saisie';
        Text016: Label 'La commande ne peut plus être annulée car elle a déjà été livrée';
        Text017: Label '&Solder la commande';
        ReleaseMgt: Codeunit "Release Sales Document";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        Text018: Label 'Valider le stock,Renvoyer en saisie';
        Cust: Record Customer;
        Text019: Label 'Traitement terminé avec succès !';
        AddOnSetup: Record "AddOn Setup";
        SQLMgt: Codeunit "SQL Mgt";
        Text020: Label 'Cette commande ne doit pas être livrée directement. Vous devez utiliser le dispaching ou un enlèvement pour effectuer la livraison des articles du document.';
        SecMgt: Codeunit "Security Mgt";
        Text021: Label 'Fonction non autorisée !';
        Text022: Label 'Le document ne se trouve pas à un statut où il peut être validé.';
        Text023: Label 'Cette commande doit être livrée par le Dispaching. Or Aucun BL n''a été trouvée pour la commande.';
        Text024: Label 'Cette commande doit être livrée par un document de préparation. Or Aucun document confirmé n''a été trouvée pour la commande.';
        Text025: Label 'Cette commande doit être livrée par un enlèvement. Or Aucun BL n''a été trouvée pour la commande.';
        Text026: Label 'Le BL %1 a été confirmé pour cette commande, vous ne pouvez pas l''annuler';
        Text027: Label 'Le BL %1 a été confirmé pour cette commande. Voulez-vous continuer ?';
        CRMInteg: Codeunit CRReports;
        Text028: Label 'Vous ne pouvez plus traiter la commande car elle est encours de déblocage sur le CRM !';
        Text029: Label 'Cette commande doit être livrée par un enlèvement car elle concerne un client JIRAMA.';
        Text030: Label 'Vous n''êtes pas autorisé à traiter les commandes bloquées';
        Text031: Label 'Quantité à expédier %1  est plus grand que la somme des quantités sur BL %2 Articles %3';
        Text032: Label 'Cette commande est liée à un Bon %1 et ne peut pas être livrée directement. Vous devez la valider à partir de la fiche du Bon.';
        Text033: Label 'La livraison directe ne doit pas se faire à partir du magasin d''expédition';

    procedure TraiterCommande(var SalesH: Record "Sales Header")
    begin

        if SalesH."Delivery Status" = SalesH."Delivery Status"::Saisie then begin
            Selection := StrMenu(Text012, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationEnSaisie(SalesH);
            if Selection = 2 then SupprimerCde(SalesH);
            exit;
        end;

        if SalesH."Delivery Status" = SalesH."Delivery Status"::ValidationTarifs then begin
            Selection := StrMenu(Text013, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationTarifs(SalesH);
            //IF Selection = 2 THEN AnnulerCde(SalesH);
            if Selection = 2 then RetourEnSaisie(SalesH);
            exit;
        end;

        if SalesH."Delivery Status" = SalesH."Delivery Status"::Rupture then begin
            Selection := StrMenu(Text018, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationTarifs(SalesH);
            //IF Selection = 2 THEN AnnulerCde(SalesH);
            if Selection = 2 then RetourEnSaisie(SalesH);

            exit;
        end;

        if SalesH."Delivery Status" = SalesH."Delivery Status"::Bloquee then begin
            //JN060917
            if not SQLMgt.IsCdeANePasLivrerCRM(SalesH."No.") then
                Error(Text028)
            else begin
                if SecMgt.CanDeleteBlockedOrders then begin
                    Selection := StrMenu(Text014, 1);
                    if Selection = 0 then exit;
                    if Selection = 1 then AnnulerCde(SalesH);
                    //IF Selection = 1 THEN RetourEnSaisie(SalesH);
                end else
                    Error(Text030);
            end;

            exit;
        end;

        if SalesH."Delivery Status" = SalesH."Delivery Status"::AttenteOrdreLiv then begin
            Selection := StrMenu(Text015, 1);
            if Selection = 0 then exit;
            if Selection = 1 then ValidationOrdreLivraison(SalesH);
            //IF Selection = 2 THEN AnnulerCde(SalesH);
            if Selection = 2 then RetourEnSaisie(SalesH);
            exit;
        end;

        if SalesH."Delivery Status" = SalesH."Delivery Status"::AttenteLivraison then begin
            Selection := StrMenu(Text017, 1);
            if Selection = 0 then exit;
            //IF Selection = 1 THEN AnnulerCde(SalesH);
            if Selection = 1 then SolderCde(SalesH);//Annuler cette action
            exit;
        end;

        if SalesH."Delivery Status" in [
          SalesH."Delivery Status"::PartiellementLivree,
          SalesH."Delivery Status"::Livree,
          SalesH."Delivery Status"::PartiellementFacturee] then begin
            Selection := StrMenu(Text009, 1);
            if Selection = 0 then exit;
            if Selection = 1 then SolderCde(SalesH);
            exit;
        end;
    end;

    procedure ValidationEnSaisie(var SalesH: Record "Sales Header")
    var
        PricesIsOK: Boolean;
    begin

        SalesH.TestField(SalesH."Sell-to Customer No.");
        SalesH.TestField(SalesH."Ship-to Code");
        SalesH.TestField(SalesH."Shipment Method Code");
        SalesH.TestField(SalesH."Requested Delivery Date");
        SalesH.TestField(SalesH."Currency Code");
        SalesH.TestField(SalesH."Order Date");
        if ContainsInventory(SalesH) then
            SalesH.TestField(SalesH."Location Code");

        CheckShipmentGroup(SalesH);


        PricesIsOK := not TarifsIsNotOk(SalesH);
        if not PricesIsOK then begin

            SalesH."Delivery Status" := SalesH."Delivery Status"::ValidationTarifs;
            SalesH.Modify;

            InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::ValidationTarifs), '');

        end else begin

            ValidationTarifs(SalesH);

        end;
    end;

    procedure ValidationTarifs(var SalesH: Record "Sales Header")
    var
        DoBlocage: Boolean;
    begin

        if StockIndisponible(SalesH) then begin
            SalesH."Delivery Status" := SalesH."Delivery Status"::Rupture;
            SalesH.Modify;

            InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::Rupture), '');
        end else begin
            ValidationStock(SalesH);
        end;
    end;

    local procedure ValidationStock(var SalesH: Record "Sales Header")
    begin
        if BloquerCde(SalesH) then begin
            SalesH."Delivery Status" := SalesH."Delivery Status"::Bloquee;
            SalesH.Modify;
            InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::Bloquee), '');


            //JN0001  ********************
            Commit;//*********************
            CRMInteg.CreateDdeDeblocage(SalesH."No.", SalesH."Sell-to Customer No.");
            //****************************
            //****************************
        end else begin
            ValidationDeblocage(SalesH);
        end;
    end;

    procedure ValidationDeblocage(var SalesH: Record "Sales Header")
    begin
        Cust.Get(SalesH."Sell-to Customer No.");



        if Cust."Disable Shipment Autorisation" then begin

            SalesH."Delivery Status" := SalesH."Delivery Status"::AttenteLivraison;
            InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::AttenteLivraison), '');

        end else begin

            SalesH."Delivery Status" := SalesH."Delivery Status"::AttenteOrdreLiv;
            InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::AttenteOrdreLiv), '');

        end;



        SalesH.Modify;
        Message(Text019);
    end;

    procedure ValidationOrdreLivraison(var SalesH: Record "Sales Header")
    begin
        if not Confirm(StrSubstNo(Text001, SalesH."No.")) then exit;

        SalesH.TestField(SalesH."Sell-to Customer No.");
        SalesH.TestField(SalesH."Ship-to Code");
        SalesH.TestField(SalesH."Shipment Method Code");
        if ContainsInventory(SalesH) then
            SalesH.TestField(SalesH."Location Code");


        SalesH."Shipment Val UserID" := UserId;
        SalesH."Shipment Val Date" := CreateDateTime(Today, Time);
        SalesH."Delivery Status" := SalesH."Delivery Status"::AttenteLivraison;
        SalesH.Modify;

        //********************JN300517
        SetInitialQty(SalesH);
        //********************

        InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::AttenteLivraison), '');
    end;

    procedure ValidationAuto(var SalesH: Record "Sales Header")
    var
        NotShipped: Boolean;
    begin

        //MESSAGE('inv %1 - %2 - ship %3 - %4',SalesH."last Posting No.",SalesH."last Shipping No.",
        //          SalesH.Invoice,SalesH.Ship);

        //IF SalesH."Delivery Status"=SalesH."Delivery Status"::AttenteLivraison THEN BEGIN
        SalesH.CalcFields(SalesH."Completely Shipped");
        if SalesH.InvoicedLineExists() then begin
            SalesH."Delivery Status" := SalesH."Delivery Status"::PartiellementFacturee;
            SalesH.Modify;
            InsertNewStep2(SalesH."No.", 3, Format(SalesH."Delivery Status"::PartiellementFacturee),
                SalesH."Last Posting No.", SalesH."Last Shipping No.", SalesH.Invoice, SalesH.Ship);
        end else begin
            if SalesH."Completely Shipped" then begin
                SalesH."Delivery Status" := SalesH."Delivery Status"::Livree;
                SalesH.Modify;
                InsertNewStep2(SalesH."No.", 2, Format(SalesH."Delivery Status"::Livree), SalesH."Last Posting No.", SalesH."Last Shipping No.",
                    SalesH.Invoice, SalesH.Ship);
            end else begin
                if ShippedLineExists(SalesH) then begin
                    SalesH."Delivery Status" := SalesH."Delivery Status"::PartiellementLivree;
                    SalesH.Modify;
                    InsertNewStep2(SalesH."No.", 2, Format(SalesH."Delivery Status"::PartiellementLivree), SalesH."Last Posting No.",
                       SalesH."Last Shipping No.", SalesH.Invoice, SalesH.Ship);
                end;
            end;
        end;
        //END;
    end;

    procedure ValidationAutoFacturationTotale(var SalesH: Record "Sales Header")
    var
        NotShipped: Boolean;
    begin

        SalesH."Delivery Status" := SalesH."Delivery Status"::Facturee;
        SalesH.Modify;
        InsertNewStep2(SalesH."No.", 3, Format(SalesH."Delivery Status"::Facturee), SalesH."Last Posting No.",
          SalesH."Last Shipping No.", SalesH.Invoice, SalesH.Ship);
    end;

    procedure InformerBlocageCRM()
    begin
    end;

    procedure AnnulerCde(var SalesH: Record "Sales Header")
    var
        CodeBL: Code[20];
    begin
        if not Confirm(StrSubstNo(Text002, SalesH."No.")) then exit;
        if ShippedLineExists(SalesH) then Error(Text016);


        CodeBL := BLEncoursExists(SalesH);
        if CodeBL <> '' then
            Error(Text026, CodeBL);

        ReleaseMgt.PerformManualReopen(SalesH);
        SalesH."Delivery Status" := SalesH."Delivery Status"::Annulee;
        SalesH.Modify;

        InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::Annulee), '');

        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesH);

        SalesH.AFK_AllowDeletion(true);
        SalesH.Delete(true);
        SalesH.Clear_AllowDeletion();
    end;

    procedure SolderCde(var SalesH: Record "Sales Header")
    var
        CodeBL: Code[20];
    begin
        //IF NOT CONFIRM(STRSUBSTNO(Text002,SalesH."No.")) THEN EXIT;

        //***********
        SecMgt.CheckCanCancelSO();
        //***********

        CodeBL := BLEncoursExists(SalesH);
        if CodeBL <> '' then
            if not Confirm(StrSubstNo(Text027, CodeBL)) then Error('');

        ReleaseMgt.PerformManualReopen(SalesH);



        SalesLine1.Reset;
        SalesLine1.SetRange(SalesLine1."Document Type", SalesLine1."Document Type"::Order);
        SalesLine1.SetRange(SalesLine1."Document No.", SalesH."No.");
        if SalesLine1.FindSet then
            repeat

                if SalesLine1."Quantity Invoiced" <> SalesLine1."Quantity Shipped" then
                    Error(Text003, SalesLine1."No.");

                SalesLine1.Validate(SalesLine1.Quantity, SalesLine1."Quantity Shipped");
                SalesLine1.Modify;

            until SalesLine1.Next = 0;


        SalesH."Delivery Status" := SalesH."Delivery Status"::Soldee;
        SalesH.Modify;
        InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::Soldee), '');
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesH);

        SalesH.AFK_AllowDeletion(true);
        SalesH.Delete(true);
        SalesH.Clear_AllowDeletion();


        //COMMIT;//*************************
        //SQLMgt.SolderCommande(SalesH."No.");
    end;

    procedure RetourEnSaisie(var SalesH: Record "Sales Header")
    begin
        SalesH.TestField(SalesH."Return Reason");
        if not Confirm(StrSubstNo(Text004)) then exit;
        SalesH."Delivery Status" := SalesH."Delivery Status"::Saisie;
        SalesH.Modify;

        InsertNewStep(SalesH."No.", 1, Format(SalesH."Delivery Status"::Saisie), '');
    end;

    local procedure TarifsIsNotOk(SalesH: Record "Sales Header"): Boolean
    var
        SalesLineTemp: Record "Sales Line" temporary;
        Item1: Record Item;
    begin

        //Désactiver cette étape
        exit(false);

        if SalesH."Quote No." <> '' then exit(false);

        SalesLine1.Reset;
        SalesLine1.SetRange(SalesLine1."Document Type", SalesLine1."Document Type"::Order);
        SalesLine1.SetRange(SalesLine1."Document No.", SalesH."No.");
        if SalesLine1.FindSet then
            repeat
                if SalesLine1."No." <> '' then begin
                    SalesLineTemp.Copy(SalesLine1);
                    if SalesLine1.Type = SalesLine1.Type::Item then
                        if Item1.Get(SalesLine1."No.") then
                            if Item1.Type = Item1.Type::Inventory then
                                SalesLine1.TestField(SalesLine1."Location Code");
                    SalesLine1.TestField(SalesLine1.Quantity);
                    //SalesLine1.TESTFIELD(SalesLine1."Unit Price");//Si le prix est nul envoyer en validation prix
                    PriceCalcMgt.FindSalesLinePrice(SalesH, SalesLineTemp, SalesLineTemp.FieldNo(SalesLineTemp."No."));
                    if (SalesLine1."Unit Price" <> SalesLineTemp."Unit Price") then
                        if not IsCdeCAP(SalesLine1."Sell-to Customer No.") then //Exclure les recharges cartes
                            exit(true);
                    //IF SalesLine1.Quantity*SalesLine1."Unit Price"<0 THEN
                    //  EXIT(TRUE);
                end;
            until SalesLine1.Next = 0;

        exit(false);
    end;

    procedure BloquerCde(SalesH: Record "Sales Header"): Boolean
    var
        MasterFiles: Codeunit "AG1 Master Files Mgt";
        Bloquer: Boolean;
    begin
        Cust.Get(SalesH."Sell-to Customer No.");
        if Cust."Disable Blocking" then exit(false);

        Bloquer := MasterFiles.AFK_SalesHeaderShowWarning(SalesH);

        exit(Bloquer);
    end;

    local procedure ShippedLineExists(SalesH: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesH."Document Type");
        SalesLine.SetRange("Document No.", SalesH."No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        SalesLine.SetFilter(SalesLine."Quantity Shipped", '<>%1', 0);
        exit(not SalesLine.IsEmpty);
    end;

    procedure SupprimerCde(var SalesH: Record "Sales Header")
    begin
        if not Confirm(StrSubstNo(Text011)) then exit;
        ReleaseMgt.PerformManualReopen(SalesH);

        InsertNewStep(SalesH."No.", 4, Format(SalesH."Delivery Status"::Saisie), '');

        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesH);

        SalesH.Delete(true);
    end;

    local procedure StockIndisponible(SalesH: Record "Sales Header"): Boolean
    var
        Item1: Record Item;
        Loc1: Record Location;
        SingleCu: Codeunit SingleInstance;
    begin

        if Loc1.Get(SalesH."Location Code") then
            if Loc1."Allow Negative Stock" then exit(false);


        SalesLine1.Reset;
        SalesLine1.SetRange(SalesLine1."Document Type", SalesLine1."Document Type"::Order);
        SalesLine1.SetRange(SalesLine1."Document No.", SalesH."No.");
        if SalesLine1.FindSet then
            repeat
                if (SalesLine1.Type = SalesLine1.Type::Item) then begin
                    if Item1.Get(SalesLine1."No.") then
                        if Item1.Type = Item1.Type::Inventory then
                            SalesLine1.TestField(SalesLine1."Location Code");

                    SalesLine1.TestField(SalesLine1.Quantity);

                    //SalesLine1.TESTFIELD(SalesLine1."Unit Price");//Si le prix est nul envoyer en validation prix
                    SingleCu.Set_IsAfkShowItemWarning(true);
                    if ItemCheckAvail.SalesLineShowWarning(SalesLine1) then
                        exit(true);
                end;
            until SalesLine1.Next = 0;

        exit(false);
    end;

    procedure UpdateSalesOrderOnValidation(var SalesH: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        PartShipped: Boolean;
        PartInvoiced: Boolean;
        Livree: Boolean;
    begin

        Livree := true;
        PartShipped := false;
        PartInvoiced := false;

        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document No.", SalesH."No.");
        if SalesLine.FindSet then
            repeat
                if SalesLine."Quantity Shipped" > 0 then
                    PartShipped := true;
                if SalesLine.Quantity <> SalesLine."Quantity Shipped" then
                    Livree := false;
                if SalesLine."Quantity Invoiced" > 0 then
                    PartInvoiced := true;
            until SalesLine.Next = 0;

        if Livree then begin
            if PartInvoiced then
                SalesH."Delivery Status" := SalesH."Delivery Status"::PartiellementFacturee
            else
                SalesH."Delivery Status" := SalesH."Delivery Status"::Livree;
        end else begin
            if PartShipped then begin
                if PartInvoiced then
                    SalesH."Delivery Status" := SalesH."Delivery Status"::PartiellementFacturee
                else
                    SalesH."Delivery Status" := SalesH."Delivery Status"::PartiellementLivree
            end;
        end;
        SalesH.Modify;
    end;

    procedure IsCdeCAP(CodeClient: Code[20]): Boolean
    var
        Cust: Record Customer;
    begin
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."CAP Sales Channel");
        AddOnSetup.TestField(AddOnSetup."CAP Sales Category");
        Cust.Get(CodeClient);
        exit(Cust."Sales Category Code" = AddOnSetup."CAP Sales Category");
    end;

    procedure IsCdeJIRAMA(SalesH: Record "Sales Header"): Boolean
    begin
        AddOnSetup.Get;
        if Cust.Get(SalesH."Sell-to Customer No.") then
            exit(Cust."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel");
    end;

    procedure IsCdeLUBS(SalesH: Record "Sales Header"): Boolean
    begin
        AddOnSetup.Get;
        if Cust.Get(SalesH."Sell-to Customer No.") then
            exit(Cust."Sales Category Code" = AddOnSetup."LUBS Sales Category");
    end;

    procedure IsCdePBL(SalesH: Record "Sales Header"): Boolean
    begin
        AddOnSetup.Get;
        if Cust.Get(SalesH."Sell-to Customer No.") then
            exit(Cust."Sales Category Code" = AddOnSetup."PBL Sales Category");
    end;

    procedure IsCdeGPL(SalesH: Record "Sales Header"): Boolean
    var
        SalesL: Record "Sales Line";
        Item1: Record Item;
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField("GPL Sales Category");

        if Cust.Get(SalesH."Sell-to Customer No.") then begin
            exit(Cust."Sales Category Code" = AddOnSetup."GPL Sales Category");
        end;

        /*IF Cust.GET(SalesH."Sell-to Customer No.") THEN BEGIN
            EXIT(Cust."Sales Channel Code" = AddOnSetup."GPL Sales Channel");
          END;*/

        /*SalesL.RESET;
        SalesL.SETRANGE(SalesL."Document Type",SalesH."Document Type");
        SalesL.SETRANGE(SalesL."Document No.",SalesH."No.");
        IF SalesL.FINDSET THEN REPEAT
          IF Salesl.Type = SalesL.Type::Item THEN
            IF Item1.GET(SalesL."No.") THEN
              IF Item1."Item Category Code"=AddOnSetup."GPL Item Category" THEN
                EXIT(TRUE);
        UNTIL */

    end;

    procedure IsCdeAMSA(SalesH: Record "Sales Header"): Boolean
    begin
        AddOnSetup.Get;
        if Cust.Get(SalesH."Sell-to Customer No.") then
            exit(Cust."Sales Channel Code" = AddOnSetup."AMSA Sales Channel");
    end;

    procedure CheckLivraisonCdeVente(SalesOrder: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Item1: Record Item;
    begin
        /*
        IF SalesOrder."Document Type" = SalesOrder."Document Type"::Invoice THEN
          EXIT;
        
        AddOnSetup.GET;
        AddOnSetup.TESTFIELD(AddOnSetup."Shipment Method Direct");
        IF SalesOrder."Shipment Method Code" = AddOnSetup."Shipment Method Direct" THEN
          EXIT;
        
        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document No.",SalesOrder."No.");
        IF SalesLine.FINDSET THEN REPEAT
        
          IF SalesLine.Type = SalesLine.Type::Item THEN BEGIN
            Item1.GET(SalesLine."No.");
            IF Item1.Type = Item1.Type::Inventory THEN
              IF SalesLine."Qty. to Ship"<>0 THEN BEGIN
                MESSAGE('%1',SalesLine."Qty. to Ship");
                ERROR(Text020);
              END;
          END;
        
        UNTIL SalesLine.NEXT=0;
        */

    end;

    local procedure ContainsInventory(SalesH: Record "Sales Header"): Boolean
    var
        Item1: Record Item;
        Loc2: Record Location;
    begin

        SalesLine1.Reset;
        SalesLine1.SetRange("Document Type", SalesLine1."Document Type"::Order);
        SalesLine1.SetRange("Document No.", SalesH."No.");
        if SalesLine1.FindSet then
            repeat
                if (SalesLine1.Type = SalesLine1.Type::Item) then begin
                    if Item1.Get(SalesLine1."No.") then
                        if Item1.Type = Item1.Type::Inventory then begin
                            SalesLine1.TestField(SalesLine1."Location Code");

                            Loc2.Get(SalesLine1."Location Code");
                            Item1.CalcFields("Parent Category");
                            Loc2.TestField(Loc2."Item Category Code", Item1."Parent Category");

                            exit(true);
                        end;
                end;
            until SalesLine1.Next = 0;

        exit(false);
    end;

    procedure CheckCanPostSalesOrder(SalesH: Record "Sales Header")
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Shipment Method Direct");

        if SalesH."Document Type" <> SalesH."Document Type"::Order then exit;

        if SalesH."Shipment Method Code" = AddOnSetup."Shipment Method Direct" then exit;

        if not (SalesH."Delivery Status" in [SalesH."Delivery Status"::AttenteLivraison,
          SalesH."Delivery Status"::Livree, SalesH."Delivery Status"::PartiellementFacturee,
          SalesH."Delivery Status"::PartiellementLivree]) then
            Error(Text022);
    end;

    procedure CheckCanShipSalesOrder(SalesH: Record "Sales Header")
    var
        enteteBL: Record pro_enteteBL;
        AdjustH: Record "Posted Adjustment Header";
        SalesLine1: Record "Sales Line";
        Loc1: Record Location;
        Item1: Record Item;
        detailBL: Record pro_detailBL;
        rep: Decimal;
        AdjustL: Record "Posted Adjustment Line";
        UnitMeasure: Record "Item Unit of Measure";
        enteteBE: Record pro_enteteBE;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Shipment Method Direct");

        if SalesH."Document Type" <> SalesH."Document Type"::Order then exit;

        if SalesH."Shipment Method Code" = AddOnSetup."Shipment Method Direct" then exit;


        if IsCdePBL(SalesH) then begin

            //IF IsCdeJIRAMA(SalesH) THEN ERROR(Text029);
            if IsCdeJIRAMA(SalesH) = false then begin
                enteteBL.Reset;
                enteteBL.SetRange(enteteBL.NavOrderNo, SalesH."No.");
                if not enteteBL.FindFirst then
                    Error(Text025);

                //Controler que la commande ne peut pas etre livree directement
                enteteBE.Reset;
                enteteBE.SetRange(enteteBE.NavOrderNo, SalesH."No.");
                enteteBE.SetRange(enteteBE.BonIsConfirme, false);
                if enteteBE.FindFirst then
                    if enteteBE.NumBU <> '' then
                        Error(Text032, enteteBE.NumBU);
            end;

        end;



        if ((IsCdeLUBS(SalesH)) or (IsCdeGPL(SalesH))) then begin
            AdjustH.Reset;
            AdjustH.SetRange(AdjustH."Order No.", SalesH."No.");
            if not AdjustH.FindFirst then
                Error(Text024);
        end;


        SalesLine1.Reset;
        SalesLine1.SetRange("Document Type", SalesLine1."Document Type"::Order);
        SalesLine1.SetRange("Document No.", SalesH."No.");

        if SalesLine1.FindSet then
            repeat
                if ((SalesLine1.Type = SalesLine1.Type::Item) and (SalesLine1."Qty. to Ship" > 0)) then begin
                    if Item1.Get(SalesLine1."No.") then
                        if Item1.Type = Item1.Type::Inventory then
                            if Loc1.Get(SalesLine1."Location Code") then begin
                                //Loc1.TESTFIELD(Loc1."Location Type",Loc1."Location Type"::Expedition);//221120

                                //Controle des quantités à expédier en fonction des qtés livrées
                                rep := 0;
                                if Item1."Item Category Code" = 'PBL' then begin

                                    //IF (Loc1."Location Type"=Loc1."Location Type"::Expedition) THEN
                                    //  ERROR(Text033);

                                    enteteBL.Reset;
                                    enteteBL.SetRange(enteteBL.NavOrderNo, SalesLine1."Document No.");
                                    enteteBL.SetRange(enteteBL.isconfirme, true);
                                    if enteteBL.FindSet then
                                        repeat
                                            detailBL.Reset;
                                            detailBL.SetRange(detailBL.numBL, enteteBL.numBL);
                                            detailBL.SetRange(detailBL.NavItemCode, SalesLine1."No.");
                                            if detailBL.FindSet then
                                                repeat
                                                    if detailBL."Unit of Measure Code" = SalesLine1."Unit of Measure Code" then
                                                        rep := rep + detailBL.volumelivre
                                                    else begin
                                                        UnitMeasure.SetRange(UnitMeasure."Item No.", SalesLine1."No.");
                                                        UnitMeasure.SetRange(UnitMeasure.Code, detailBL."Unit of Measure Code");
                                                        if UnitMeasure.FindFirst then
                                                            rep := rep + (detailBL.volumelivre * UnitMeasure."Qty. per Unit of Measure");
                                                    end
                                                until detailBL.Next = 0;
                                        until enteteBL.Next = 0;
                                end
                                else if (Item1."Item Category Code" = 'GPL') or (Item1."Item Category Code" = 'LUB') then begin
                                    AdjustH.Reset;
                                    AdjustH.SetRange(AdjustH."Order No.", SalesLine1."Document No.");
                                    if AdjustH.FindSet then
                                        repeat
                                            AdjustL.Reset;
                                            AdjustL.SetRange(AdjustL."Document No.", AdjustH."No.");
                                            AdjustL.SetRange(AdjustL."Item No.", SalesLine1."No.");
                                            if AdjustL.FindSet then
                                                repeat
                                                    if AdjustL."Unit of Measure Code" = SalesLine1."Unit of Measure Code" then
                                                        rep := rep + AdjustL.Quantity
                                                    else begin
                                                        UnitMeasure.SetRange(UnitMeasure."Item No.", SalesLine1."No.");
                                                        UnitMeasure.SetRange(UnitMeasure.Code, AdjustL."Unit of Measure Code");
                                                        if UnitMeasure.FindFirst then
                                                            rep := rep + (AdjustL.Quantity * UnitMeasure."Qty. per Unit of Measure");
                                                    end
                                                until AdjustL.Next = 0;
                                        until AdjustH.Next = 0;
                                end;
                                //IF rep<SalesLine1."Qty. to Ship"+SalesLine1."Qty. Shipped (Base)" THEN
                                //   ERROR(Text031, SalesLine1."Qty. to Ship", rep-SalesLine1."Qty. Shipped (Base)",SalesLine1."No.");
                                // fin Controle des quantités à expédier en fonction des qtés livrées
                                //****************************************************************************************************
                            end;
                end;
            until SalesLine1.Next = 0;
    end;

    procedure InsertNewStep(OrderNo: Code[20]; "Action": Integer; NewStatus: Text[50]; CreatedDocument: Code[20])
    var
        StepEntry: Record "Document Step History";
        NextStepId: Integer;
    begin
        /*
        0=Creation,
        1=Change Status,
        2=Ship,
        3=Invoice,
        4=Deletion
        */


        StepEntry.Reset;
        StepEntry.SetRange(StepEntry."Document Type", StepEntry."Document Type"::"Sales Order");
        StepEntry.SetRange(StepEntry."Document No.", OrderNo);
        if StepEntry.FindLast then
            NextStepId := StepEntry."Step ID" + 1
        else
            NextStepId := 1;


        StepEntry.Init;
        StepEntry."Document Type" := StepEntry."Document Type"::"Sales Order";
        StepEntry."Document No." := OrderNo;
        StepEntry."Step ID" := NextStepId;
        StepEntry.Action := Action;
        StepEntry."New Status" := NewStatus;
        StepEntry."Created Document" := CreatedDocument;
        StepEntry.UserID := UserId;
        StepEntry."Action Date" := CreateDateTime(Today, Time);
        StepEntry.Insert;

    end;

    procedure InsertNewStep2(OrderNo: Code[20]; "Action": Integer; NewStatus: Text[50]; InvoiceDocument: Code[20]; ShipmentDocument: Code[20]; Invoice: Boolean; Ship: Boolean)
    var
        StepEntry: Record "Document Step History";
        NextStepId: Integer;
    begin
        /*
        0=Creation,
        1=Change Status,
        2=Ship,
        3=Invoice,
        4=Deletion
        */

        if ((Ship) and (ShipmentDocument <> '')) then
            InsertNewStep(OrderNo, 2, NewStatus, ShipmentDocument);

        if ((Invoice) and (InvoiceDocument <> '')) then
            InsertNewStep(OrderNo, 3, NewStatus, InvoiceDocument);

    end;

    procedure CanUpdateOrderHeaderAfterValidation(SalesH: Record "Sales Header"): Boolean
    var
        UserSetup: Record "User Setup";
    begin

        //Suppression de la possibilité de MAJ les commandes bloquées JN 020517 SalesH."Delivery Status"::Bloquee

        if SalesH."Delivery Status" in [SalesH."Delivery Status"::Saisie
          , SalesH."Delivery Status"::ValidationTarifs, SalesH."Delivery Status"::AttenteOrdreLiv,
          SalesH."Delivery Status"::Rupture] then
            exit(true);

        if UserSetup.Get(UserId) then begin
            if IsCdeLUBS(SalesH) then
                exit(UserSetup.CanUpdateLubOrderAfterVal)
            else
                exit(UserSetup.CanUpdateOrderAfterValidation);
        end;
    end;

    procedure CanUpdateOrderLineAfterValidation(SalesH: Record "Sales Header"): Boolean
    var
        UserSetup: Record "User Setup";
    begin

        //Suppression de la possibilité de MAJ les commandes bloquées JN 020517 SalesH."Delivery Status"::Bloquee

        if SalesH."Delivery Status" in [SalesH."Delivery Status"::Saisie
          , SalesH."Delivery Status"::ValidationTarifs, SalesH."Delivery Status"::AttenteOrdreLiv,
          SalesH."Delivery Status"::Rupture] then
            exit(true);

        //IF UserSetup.GET(USERID) THEN
        //  IF UserSetup.CanUpdateOrderAfterValidation THEN
        //    EXIT(TRUE);

        if UserSetup.Get(UserId) then begin
            if IsCdeLUBS(SalesH) then
                exit(UserSetup.CanUpdateLubOrderAfterVal)
            else
                exit(UserSetup.CanUpdateOrderAfterValidation);
        end;

        if IsCdeJIRAMA(SalesH) then exit(true);
    end;

    local procedure BLEncoursExists(SalesH: Record "Sales Header"): Code[20]
    var
        EnteteBL: Record pro_enteteBL;
        AdjustH: Record "Adjustment Header";
    begin
        EnteteBL.Reset;
        EnteteBL.SetRange(EnteteBL.NavOrderNo, SalesH."No.");
        EnteteBL.SetRange(EnteteBL.isconfirme, true);
        if EnteteBL.FindFirst then
            exit(Format(EnteteBL.numBL));
        //ELSE
        //  EXIT('');


        AdjustH.Reset;
        AdjustH.SetRange("Order No.", SalesH."No.");
        if AdjustH.FindFirst then
            exit(AdjustH."No.");
    end;

    local procedure SetInitialQty(SalesH: Record "Sales Header")
    var
        SalesL: Record "Sales Line";
    begin
        SalesL.Reset;
        SalesL.SetRange("Document Type", SalesH."Document Type");
        SalesL.SetRange("Document No.", SalesH."No.");
        if SalesL.FindSet then
            repeat
                SalesL."Initial Qty" := SalesL.Quantity;
                SalesL.Modify;
            until SalesL.Next = 0;
    end;

    procedure IsFactureEnregLub(PostedSalesH: Record "Sales Invoice Header"): Boolean
    begin
        AddOnSetup.Get;
        if Cust.Get(PostedSalesH."Sell-to Customer No.") then
            exit(Cust."Sales Category Code" = AddOnSetup."LUBS Sales Category");
    end;

    local procedure CheckShipmentGroup(SalesH: Record "Sales Header")
    var
        SLine: Record "Sales Line";
    begin
        AddOnSetup.Get;
        if not AddOnSetup."Dispaching Post Shipment" then exit;

        if not IsCdePBL(SalesH) then exit;
        if SalesH."Shipment Method Code" <> 'TRP' then exit;

        SLine.SetRange(SLine."Document Type", SalesH."Document Type");
        SLine.SetRange(SLine."Document No.", SalesH."No.");
        if SLine.FindSet then
            repeat
                SLine.TestField(SLine."Shipment Group");

            until SLine.Next = 0;
    end;
}

