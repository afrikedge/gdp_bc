codeunit 50000 "Logistique Mgt"
{
    // //300517 Gestion des ajustements des qtés lors de la livraison BL JIRAMA
    // //141117 BSL requis a la confirmation
    // //050118 Check unicity Customer BE
    // //230118 AFK004 Check BE confirmation before posting BL
    // //040418 Check that delivery date is on allowed posting period
    // //201218 Check Delivery Site
    // //070318 Dispaching in NAV

    Permissions = TableData "Sales Invoice Header" = rim;

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Voulez-vous confirmer le bon d''enlèvement ?';
        Text002: Label 'Bon d''enlèvement %1';
        AddOnSetup: Record "AddOn Setup";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text003: Label 'Le document a été confirmé avec succès';
        Text004: Label 'Voulez-vous confirmer le bon de livraison ?';
        SalesRelease: Codeunit "Release Sales Document";
        Text005: Label 'Aucun article trouvé à livrer sur la commande %1';
        UOMgt: Codeunit "Unit of Measure Management";
        Text006: Label 'Quantity per unit of measure must be defined.';
        Text007: Label 'Veuillez saisir le volume à 15°C sur la ligne %1';
        Text008: Label 'Enlèvement généré à partir de la commande %1';
        Text009: Label 'Bon de livraison généré à partir de la commande %1';
        Text010: Label 'Veuillez entrer les quantités à enlever sur les lignes';
        Text011: Label 'Le Bon d''enlèvement %1 a été créé\Le Bon de livraison %2 a été créé';
        SQLMgt: Codeunit "SQL Mgt";
        TransferMgt: Codeunit "Item Transfer Mgt";
        Text012: Label 'Voulez-vous annuler le bon de livraison ?';
        Text013: Label 'Voulez-vous annuler le bon d''enlèvement ?';
        Text014: Label 'Vérifiez si la quantité à 15°C a été saisie en LITRES ou en M3';
        JIRAMAMgt: Codeunit "JIRAMA Sales Mgt";
        NoMessage: Boolean;
        Text015: Label 'Le volume livré ne doit pas être supérieur au volume à livrer';
        SalesProcess: Codeunit "Sales Order Process";
        Text016: Label 'Vous ne pouvez pas enlever cette quantité. La quantité déjà enlevée est %1';
        Text017: Label 'BE%1';
        Text018: Label 'BL%1';
        Text019: Label 'Veuillez saisir le volume livré sur la ligne %1';
        Text020: Label '%1-%2-%3';
        Text021: Label 'Veuillez saisir le volume livré sur la ligne %1';
        Text022: Label 'Le Bon d''enlèvement %1 lié à ce bon de livraison n''est pas encore confirmé. Veuillez le confirmer.';
        Text023: Label 'Il existe déjà un BE %1 confirmé avec la Ref. BE Client %2';
        Text001Dates: Label 'is not within your range of allowed posting dates';
        GenCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text024: Label 'Groupe de livraison non présent sur la ligne %1 commande %2';
        Text025: Label 'La commande %1 existe déjà sur une tournée non validée : %2';
        Text026: Label 'Le code camion %1 existe déjà sur une tournée non validée : %2';
        Text027: Label 'Voulez-vous confirmer le bon ?';
        Text028: Label 'Confirmer l''enlèvement,Confirmer la livraison et facturer';
        Selection: Integer;
        Text029: Label 'Le Bon %1 a été créé';
        Text030: Label 'Bon %1';
        Text031: Label 'L''enlèvement a déjà été confirmé';
        Text032: Label '&Confirmer la livraison sans facturer,&Confirmer la livraison et facturer';
        Text033: Label '&Confirm shipment and invoice';
        Text034: Label 'Le document à livrer semble être une ancienne commande livrée par l''ancien dispaching. Veuillez modifier le code magasin sur les lignes si ce n''est pas le cas.';
        Text035: Label 'Voulez-vous confirmer le bon d''enlèvement ?';
        Text036: Label 'Marquer le bon comme étant confirmé';
        Text037: Label 'La date de validité doit être postérieure à la date de création';
        Text038: Label 'La date de validité doit être postérieure à la date du BSL';

    procedure PostBE(var RemovalH: Record pro_enteteBE; HideMsg: Boolean)
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        QtyAjustement: Decimal;
        EnteteBL: Record pro_enteteBL;
        DocNum: Code[20];
        TouringEntry: Record "Touring Product Entry";
        Camion1: Record pro_moyentransport;
    begin

        if RemovalH.isconfirme then
            Error(Text031);

        if not HideMsg then
            if not Confirm(Text001) then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Removal Journal code");
        AddOnSetup.TestField(AddOnSetup."Shipment Location PBL");
        AddOnSetup.TestField(AddOnSetup."Cargo Enlevement");
        AddOnSetup.TestField(AddOnSetup."PBL Category Code");


        //RemovalH.TESTFIELD(RemovalH.codemoyentransport);
        RemovalH.TestField(RemovalH.dateBE);
        RemovalH.TestField(RemovalH.depot);
        RemovalH.TestField(RemovalH.numBSL);//141117
        RemovalH.TestField(RemovalH.codemoyentransport);//121119
        CheckNumBEClient(RemovalH."Customer BE");//050118

        if (RemovalH.datevalidite < RemovalH.dateBE) then Error(Text038);
        if (RemovalH.datevalidite < DT2Date(RemovalH.datecreation)) then Error(Text037);



        RemovalLine.Reset;
        RemovalLine.SetRange(RemovalLine.numBE, RemovalH.numBE);
        if RemovalLine.FindSet then
            repeat

                Item1.Get(RemovalLine.NavItemCode);
                Item1.CalcFields("Parent Category");
                Item1.TestField("Parent Category", AddOnSetup."PBL Category Code");//************************Added

                if RemovalLine.volumea15 = 0 then
                    Error(Text007, RemovalLine."Line No.");

                RemovalLine.Validate(RemovalLine.volumea15);

                QtyAjustement := RemovalLine.volumea15 - RemovalLine.volumeaenlever;

                //Dépot d'origine - Ajustement négatif ou négatif
                ItemJnlLine.Init;
                ItemJnlLine."Posting Date" := RemovalH.dateBE;
                ItemJnlLine."Document Date" := RemovalH.dateBE;

                ItemJnlLine."Document No." := StrSubstNo(Text017, RemovalH.numBE);
                if RemovalH.IsBon then
                    ItemJnlLine."Document No." := RemovalH.NumBU;

                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AdjBE;
                //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::;
                ItemJnlLine."Document Line No." := RemovalLine."Line No.";
                //ItemJnlLine."External Document No." := TransShptHeader2."External Document No.";
                if QtyAjustement > 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
                else
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                ItemJnlLine.Validate("Item No.", RemovalLine.NavItemCode);
                ItemJnlLine.Description := StrSubstNo(Text002, RemovalH.numBE);
                if RemovalH.IsBon then
                    ItemJnlLine.Description := StrSubstNo(Text002, RemovalH.NumBU);

                ItemJnlLine.Validate("Location Code", RemovalH.depot);
                ItemJnlLine.Validate(Quantity, Abs(QtyAjustement));

                ItemJnlLine.Validate("Unit of Measure Code", RemovalLine."Unit of Measure Code");
                //ItemJnlLine."Invoiced Quantity" := RemovalLine.volumea15;
                ItemJnlLine."Source Code" := AddOnSetup."Removal Journal code";
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
                ItemJnlLine.AFK_SetDimensionsItem(RemovalLine.NavItemCode);

                //ItemJnlLine.AFK_SetDimensions(RemovalLine.NavItemCode,

                if QtyAjustement > RemovalLine.volumeaenlever then
                    Error(Text014);

                if QtyAjustement <> 0 then
                    ItemJnlPostLine.RunWithCheck(ItemJnlLine);

                DocNum := ItemJnlLine."Document No.";
            /*
            TransferMgt.TransfertItemReclass(ItemJnlPostLine,DocNum,RemovalH.dateBE,RemovalLine.NavItemCode,
              RemovalH.depot,AddOnSetup."Shipment Location PBL",RemovalLine.volumeaenlever,RemovalLine."Unit of Measure Code",
                0,0,STRSUBSTNO(Text002, RemovalH.NumBU),ItemJnlLine."Adjustment Type"::BE,AddOnSetup."Cargo Enlevement");
            */




            until RemovalLine.Next = 0;


        //Si BE JIRAMA Confirmer le livraison aussi
        /*
        IF RemovalH.IsBEJIRAMA THEN BEGIN
          EnteteBL.RESET;
          EnteteBL.SETRANGE(numBE,RemovalH.numBE);
          IF EnteteBL.FINDFIRST THEN BEGIN
            EnteteBL.datelivraison := RemovalH.dateBE;
            EnteteBL.MODIFY;
            NoMessage := TRUE;
            PostBL(EnteteBL);
          END;
        END;
        */



        //Confirmer dans le dispaching (confirmer le chargement, la livraison sera confirmé sur le BL)
        if RemovalH.Source = RemovalH.Source::Dispaching then begin

            //Confirmer le chargement
            TouringEntry.Reset;
            TouringEntry.SetCurrentKey(IdTouring, Immatriculation);
            TouringEntry.SetRange(IdTouring, RemovalH.idtournee);
            TouringEntry.SetRange(Immatriculation, RemovalH.codemoyentransport);
            if TouringEntry.FindSet then
                repeat
                    ;
                    //TouringEntry.TouringStatus := TouringEntry.TouringStatus::Confirmed;
                    //TouringEntry.MODIFY;
                    UpdateProdLivresCompartiment(TouringEntry.Immatriculation, TouringEntry.ItemNo, TouringEntry.IdCompartment);
                until TouringEntry.Next = 0;

            //COMMIT;
            //SQLMgt.ConfirmBE(RemovalH.numBE);

            //JN230720 Liberation effectuee sur le BL
            //IF Camion1.GET(RemovalH.codemoyentransport) THEN BEGIN
            //  Camion1.entournee := FALSE;
            //  Camion1.MODIFY;
            //END;

        end;


        RemovalH."Validation Date" := CreateDateTime(Today, Time);
        RemovalH.isconfirme := true;
        RemovalH.Modify;


        CheckTourneeIsValidated(RemovalH.idtournee, RemovalH.numBE);


        if not HideMsg then
            Message(Text003);

    end;

    procedure PostBL(var DeliveryH: Record pro_enteteBL; HideMsg: Boolean; PostInvoice: Boolean)
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record pro_detailBL;
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
        EnteteBE: Record pro_enteteBE;
        QteALivrerUniteCde: Decimal;
        Item1: Record Item;
        Cust1: Record Customer;
        IsBL_JIRAMA_EcartPompe: Boolean;
        Camion1: Record pro_moyentransport;
        QtyALivrerGO: Decimal;
        QtyALivrerPL: Decimal;
        QtyALivrerFO: Decimal;
        QtyALivrerSC: Decimal;
        TouringEntry: Record "Touring Product Entry";
        AllLinesShip: Boolean;
        TouringSalesH: Record "Touring Sales Order";
        SalesPostCU: Codeunit "Sales-Post";
        PostedSalesShip: Record "Sales Shipment Header";
        PostShipExists: Boolean;
    begin

        if not HideMsg then
            if not Confirm(Text004) then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Shipment Location PBL");
        AddOnSetup.TestField(AddOnSetup."PBL Category Code");

        DeliveryH.TestField(DeliveryH."Delivery Site");//201218
        DeliveryH.TestField(DeliveryH.codemoyentransport);//121119

        //AFK004  Verifier si le BE est confirme (Commented on 080819)
        //IF EnteteBE.GET(DeliveryH.numBE) THEN
        //  IF NOT EnteteBE.isconfirme THEN
        //    ERROR(Text022,EnteteBE.numBE);

        if GenCheckLine.DateNotAllowed(DeliveryH.datelivraison) then
            Error(Text001Dates);

        DeliveryH.TestField(DeliveryH.NavOrderNo);
        if Camion1.Get(DeliveryH.codemoyentransport) then;


        if SalesOrder.Get(SalesOrder."Document Type"::Order, DeliveryH.NavOrderNo) then begin

            IsBL_JIRAMA_EcartPompe := false;
            if Cust1.Get(SalesOrder."Sell-to Customer No.") then                //***
                if Cust1."Appliquer Ecart pompe JIR" then
                    IsBL_JIRAMA_EcartPompe := true;

            //SalesOrder.SetHideValidationDialog(TRUE);
            SalesRelease.Reopen(SalesOrder);

            SalesLine.Reset;
            SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
            SalesLine.SetRange(SalesLine."Document No.", SalesOrder."No.");
            if SalesLine.FindSet then
                repeat

                    SalesLine.SetHideValidationDialog(true);
                    //SalesLine.AFK_SetCanSetExpLocation(true);

                    if AddOnSetup."Dispaching Post Shipment" then
                        if DeliveryH.Source = DeliveryH.Source::Dispaching then begin
                            if SalesLine."Shipment Group" = SalesLine."Shipment Group"::" " then
                                Error(Text024, SalesLine."Line No.", SalesOrder."No.");
                            SalesLine.Validate(SalesLine."Qty. to Ship", 0);
                            SalesLine.Validate(SalesLine."Qty. to Invoice", 0);
                            SalesLine.Modify;
                        end;

                    DeliveryLine.Reset;
                    DeliveryLine.SetRange(DeliveryLine.numBL, DeliveryH.numBL);
                    if DeliveryLine.FindSet then
                        repeat
                            if (SalesLine."No." = DeliveryLine.NavItemCode) then begin
                                ItemExists := true;

                                Item1.Get(DeliveryLine.NavItemCode);//**************************************************Added
                                Item1.CalcFields("Parent Category");
                                Item1.TestField("Parent Category", AddOnSetup."PBL Category Code");//***********Added

                                if DeliveryLine.volumelivre = 0 then
                                    Error(Text021, DeliveryLine."Line No.");//*****

                                if SalesLine."Real Location" = '' then
                                    SalesLine."Real Location" := SalesLine."Location Code";

                                //IF SalesLine."Location Code"=AddOnSetup."Shipment Location PBL" THEN
                                //  ERROR(Text034);
                                if SalesLine."Location Code" <> DeliveryH.depot then
                                    SalesLine.Validate("Location Code", DeliveryH.depot);
                                //IF SalesLine."Location Code"<>AddOnSetup."Shipment Location PBL" THEN
                                //  SalesLine.VALIDATE("Location Code", AddOnSetup."Shipment Location PBL");

                                if ((AddOnSetup."Dispaching Post Shipment") and (DeliveryH.Source = DeliveryH.Source::Dispaching)) then begin
                                    QteLivreeUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                                       DeliveryLine."Unit of Measure Code", DeliveryLine.volumelivre, DeliveryLine.NavItemCode, SalesLine."Qty. per Unit of Measure");
                                    if SalesLine."Shipment Group" = SalesLine."Shipment Group"::GO then
                                        QtyALivrerGO := QteLivreeUniteCde;
                                    if SalesLine."Shipment Group" = SalesLine."Shipment Group"::PL then
                                        QtyALivrerPL := QteLivreeUniteCde;
                                    if SalesLine."Shipment Group" = SalesLine."Shipment Group"::FO then
                                        QtyALivrerFO := QteLivreeUniteCde;
                                    if SalesLine."Shipment Group" = SalesLine."Shipment Group"::SC then
                                        QtyALivrerSC := QteLivreeUniteCde;
                                end;

                                if IsBL_JIRAMA(DeliveryH) then begin
                                    QteLivreeUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                                      DeliveryLine."Unit of Measure Code", DeliveryLine.volumelivre, DeliveryLine.NavItemCode, SalesLine."Qty. per Unit of Measure");
                                    //**************
                                    if IsBL_JIRAMA_EcartPompe then begin
                                        /*//060717QteALivrerUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                                          DeliveryLine."Unit of Measure Code",DeliveryLine.volumealivrer,DeliveryLine.NavItemCode,SalesLine."Qty. per Unit of Measure");
                                        IF QteLivreeUniteCde<>QteALivrerUniteCde THEN
                                          SalesLine.VALIDATE(SalesLine.Quantity,SalesLine.Quantity + (QteLivreeUniteCde-QteALivrerUniteCde));
                                          */
                                    end;
                                    //**************
                                    SalesLine.Validate(SalesLine."Qty. to Ship", QteLivreeUniteCde);
                                    //IF DeliveryH.IsBon AND PostInvoice THEN
                                    //  SalesLine.VALIDATE(SalesLine."Qty. to Invoice",QteLivreeUniteCde);
                                end;

                                SalesLine.Modify;
                            end;//IF (SalesLine."No." = DeliveryLine.NavItemCode)

                            if ((DeliveryH.Source = DeliveryH.Source::Dispaching) and (not IsBL_JIRAMA_EcartPompe)) then
                                if DeliveryLine.volumelivre > DeliveryLine.volumealivrer then
                                    Error(Text015);

                        until DeliveryLine.Next = 0;

                    if ((AddOnSetup."Dispaching Post Shipment") and (DeliveryH.Source = DeliveryH.Source::Dispaching) and DeliveryH.IsBon) then begin
                        if SalesLine."Shipment Group" = SalesLine."Shipment Group"::GO then begin
                            SalesLine.Validate(SalesLine."Qty. to Ship", QtyALivrerGO);
                            if PostInvoice then
                                SalesLine.Validate(SalesLine."Qty. to Invoice", QtyALivrerGO);
                        end;

                        if SalesLine."Shipment Group" = SalesLine."Shipment Group"::PL then begin
                            SalesLine.Validate(SalesLine."Qty. to Ship", QtyALivrerPL);
                            if PostInvoice then
                                SalesLine.Validate(SalesLine."Qty. to Invoice", QtyALivrerPL);
                        end;

                        if SalesLine."Shipment Group" = SalesLine."Shipment Group"::SC then begin
                            SalesLine.Validate(SalesLine."Qty. to Ship", QtyALivrerSC);
                            if PostInvoice then
                                SalesLine.Validate(SalesLine."Qty. to Invoice", QtyALivrerSC);
                        end;

                        if SalesLine."Shipment Group" = SalesLine."Shipment Group"::FO then begin
                            SalesLine.Validate(SalesLine."Qty. to Ship", QtyALivrerFO);
                            if PostInvoice then
                                SalesLine.Validate(SalesLine."Qty. to Invoice", QtyALivrerFO);
                        end;

                        SalesLine.Modify;
                    end;

                until SalesLine.Next = 0;

            if not ItemExists then Error(Text005, SalesOrder."No.");

            SalesOrder.Validate("Posting Date", DeliveryH.datelivraison);


            SalesRelease.Run(SalesOrder);

            if IsBL_JIRAMA(DeliveryH) then begin
                SalesOrder.Ship := true;
                if DeliveryH.NumBU <> '' then
                    SalesOrder."Shipping No." := DeliveryH.NumBU;
                //SalesOrder.Invoice:=TRUE;
                if EnteteBE.Get(DeliveryH.numBE) then
                    SalesOrder."Your Reference" := EnteteBE."Customer BE";
            end;

            if ((AddOnSetup."Dispaching Post Shipment") and (DeliveryH.Source = DeliveryH.Source::Dispaching)) then begin
                if DeliveryH.IsBon then begin
                    SalesOrder.Ship := true;
                    if DeliveryH.NumBU <> '' then
                        SalesOrder."Shipping No." := DeliveryH.NumBU;
                    SalesOrder.Invoice := PostInvoice;
                end;
            end;

            SalesOrder.Modify;
        end; //end SalesOrder.GET



        if (DeliveryH.Source = DeliveryH.Source::Dispaching) then begin

            LibererCamion(DeliveryH, Camion1);

            //Confirmer la livraison (Dispaching)
            TouringEntry.Reset;
            TouringEntry.SetRange(IdTouring, DeliveryH.idtournee);
            TouringEntry.SetRange(OrderNo, SalesOrder."No.");
            TouringEntry.SetRange(Immatriculation, DeliveryH.codemoyentransport);
            if TouringEntry.FindSet then
                repeat
                    ;
                    TouringEntry.TouringStatus := TouringEntry.TouringStatus::Confirmed;
                    TouringEntry.Modify;
                until TouringEntry.Next = 0;
        end;


        CheckTourneeIsValidated(DeliveryH.idtournee, DeliveryH.numBL);

        if ((IsBL_JIRAMA(DeliveryH)) or (IsBL_JIRAMA_EcartPompe)) then begin
            LibererCamion(DeliveryH, Camion1);
        end;


        PostShipExists := PostedSalesShip.Get(DeliveryH.NumBU);

        if IsBL_JIRAMA(DeliveryH) then begin
            if SalesOrder."No." <> '' then begin

                if IsBL_JIRAMA_EcartPompe then                                  //*** Gestion écart BL
                    PostAdjBLJiramaMgt(DeliveryH, SalesOrder."Sell-to Customer No.");//***


                //CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesOrder);
                //CLEAR(SalesPostCU);
                if not (PostShipExists) then begin
                    //SalesPostCU.SetBUPosting(true);//**************
                    SalesPostCU.SetSuppressCommit(true);
                    SalesPostCU.Run(SalesOrder);//*****************
                    DeliveryH."Posted Shipment No" := SalesOrder."Last Shipping No.";
                    if DeliveryH.IsBon and PostInvoice then
                        DeliveryH."Posted Invoice No" := SalesOrder."Last Posting No.";
                end else begin
                    DeliveryH."Posted Shipment No" := PostedSalesShip."No.";
                end;
            end;
        end;

        if ((AddOnSetup."Dispaching Post Shipment") and (DeliveryH.Source = DeliveryH.Source::Dispaching)) then begin
            if SalesOrder."No." <> '' then begin
                if DeliveryH.IsBon then begin
                    //CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesOrder);
                    //CLEAR(SalesPostCU);
                    if not (PostShipExists) then begin
                        //SalesPostCU.SetBUPosting(true);//**************
                        SalesPostCU.SetSuppressCommit(true);
                        SalesPostCU.Run(SalesOrder);//*****************
                        DeliveryH."Posted Shipment No" := SalesOrder."Last Shipping No.";
                        if PostInvoice then
                            DeliveryH."Posted Invoice No" := SalesOrder."Last Posting No.";
                    end else begin
                        DeliveryH."Posted Shipment No" := PostedSalesShip."No.";
                    end;
                end;
            end;
        end;




        DeliveryH."Validation Date" := CreateDateTime(Today, Time);
        DeliveryH.isconfirme := true;
        DeliveryH.Modify;




        if not HideMsg then
            if not NoMessage then
                Message(Text003);

    end;

    procedure PostBon(var RemovalH: Record pro_enteteBE)
    var
        RelatedBL: Record pro_enteteBL;
        PostedSalesShip: Record "Sales Shipment Header";
        PostShipExists: Boolean;
    begin

        AddOnSetup.Get;

        RemovalH.CheckBonIsValidatedByManager();

        PostShipExists := PostedSalesShip.Get(RemovalH.NumBU);

        if ((RemovalH."Sales Channel Code" = AddOnSetup."Station Sales Channel") or (RemovalH.isconfirme)) then begin

            if ((PostShipExists) and (RemovalH.isconfirme)) then
                Selection := StrMenu(Text036, 1)
            else
                Selection := StrMenu(Text033, 1);
            if Selection = 0 then
                exit;

            if Selection = 1 then begin

                if not RemovalH.isconfirme then
                    PostBE(RemovalH, true);

                RelatedBL.Get(RemovalH.numBL);
                if not RelatedBL.isconfirme then
                    if (not PostShipExists) then
                        PostBL(RelatedBL, true, true);

                if RelatedBL."Posted Shipment No" = '' then
                    if PostedSalesShip.Get(RemovalH.NumBU) then begin
                        RelatedBL."Posted Shipment No" := RemovalH.NumBU;
                        RelatedBL.isconfirme := true;
                        RelatedBL."Validation Date" := CreateDateTime(Today, Time);
                        RelatedBL.Modify;
                    end;

                //RelatedBL.TESTFIELD("Posted Shipment No");
                RemovalH.BonIsConfirme := true;
                RemovalH.Modify;

            end;

        end else begin

            Selection := StrMenu(Text032, 1);
            if Selection = 0 then
                exit;

            if Selection = 1 then begin

                if not RemovalH.isconfirme then
                    PostBE(RemovalH, true);

                RelatedBL.Get(RemovalH.numBL);
                if not RelatedBL.isconfirme then
                    if (not PostShipExists) then
                        PostBL(RelatedBL, true, false);

                if RelatedBL."Posted Shipment No" = '' then
                    if PostedSalesShip.Get(RemovalH.NumBU) then begin
                        RelatedBL."Posted Shipment No" := RemovalH.NumBU;
                        RelatedBL.isconfirme := true;
                        RelatedBL."Validation Date" := CreateDateTime(Today, Time);
                        RelatedBL.Modify;
                    end;

                //RelatedBL.TESTFIELD("Posted Shipment No");
                RemovalH.BonIsConfirme := true;
                RemovalH.Modify;

            end;

            if Selection = 2 then begin

                //RemovalH.BonIsConfirme:=TRUE;
                //RemovalH.MODIFY;

                if not RemovalH.isconfirme then
                    PostBE(RemovalH, true);

                RelatedBL.Get(RemovalH.numBL);
                if not RelatedBL.isconfirme then
                    if (not PostShipExists) then
                        PostBL(RelatedBL, true, true);

                if RelatedBL."Posted Shipment No" = '' then
                    if PostedSalesShip.Get(RemovalH.NumBU) then begin
                        RelatedBL."Posted Shipment No" := RemovalH.NumBU;
                        RelatedBL.isconfirme := true;
                        RelatedBL."Validation Date" := CreateDateTime(Today, Time);
                        RelatedBL.Modify;
                    end;


                //RelatedBL.TESTFIELD("Posted Shipment No");
                RemovalH.BonIsConfirme := true;
                RemovalH.Modify;

            end;

        end;

        //IF NOT CONFIRM(Text028) THEN EXIT;

        Message(Text003);
    end;

    procedure PostBL_OLD(var DeliveryH: Record pro_enteteBL)
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record pro_detailBL;
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
    begin

        if not Confirm(Text004) then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Shipment Location PBL");

        DeliveryH.TestField(DeliveryH.NavOrderNo);

        SalesOrder.Get(SalesOrder."Document Type"::Order, DeliveryH.NavOrderNo);
        //SalesOrder.SetHideValidationDialog(TRUE);
        SalesRelease.Reopen(SalesOrder);


        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(SalesLine."Document No.", SalesOrder."No.");
        if SalesLine.FindSet then
            repeat

                SalesLine.SetHideValidationDialog(true);

                if (SalesLine.Type = SalesLine.Type::Item) then begin
                    SalesLine.Validate(SalesLine."Qty. to Ship", 0);
                    SalesLine.Modify;
                end;
                //ItemExists:=FALSE;

                DeliveryLine.Reset;
                DeliveryLine.SetRange(DeliveryLine.numBL, DeliveryH.numBL);
                if DeliveryLine.FindSet then
                    repeat
                        if (SalesLine."No." = DeliveryLine.NavItemCode) then begin
                            ItemExists := true;

                            if SalesLine."Real Location" = '' then
                                SalesLine."Real Location" := SalesLine."Location Code";

                            SalesLine.Validate("Location Code", AddOnSetup."Shipment Location PBL");

                            QteLivreeUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                              DeliveryLine."Unit of Measure Code", DeliveryLine.volumelivre, DeliveryLine.NavItemCode, SalesLine."Qty. per Unit of Measure");

                            SalesLine.Validate(SalesLine."Qty. to Ship", QteLivreeUniteCde);

                            //SalesLine.VALIDATE(SalesLine."Qty. to invoice",0);
                            SalesLine.Modify;
                        end;

                    until DeliveryLine.Next = 0;
            until SalesLine.Next = 0;



        if not ItemExists then Error(Text005, SalesOrder."No.");



        //ERROR('fin');
        SalesOrder.Validate("Posting Date", DeliveryH.datelivraison);
        SalesOrder.Ship := true;
        SalesOrder.Invoice := false;
        SalesOrder.Modify;
        CODEUNIT.Run(CODEUNIT::"Sales-Post", SalesOrder);




        DeliveryH."Posted Shipment No" := SalesOrder."Last Shipping No.";
        DeliveryH.isconfirme := true;
        DeliveryH.Modify;





        //Confirmer dans le dispaching
        if DeliveryH.Source = DeliveryH.Source::Dispaching then begin
            Commit;
            SQLMgt.ConfirmBL(DeliveryH.numBL);
        end;
    end;

    procedure CancelBE(var RemovalH: Record pro_enteteBE)
    var
        DeliveryH: Record pro_enteteBL;
        TouringEntry: Record "Touring Product Entry";
        Camion1: Record pro_moyentransport;
        TouringSalesH: Record "Touring Sales Order";
    begin



        //IF NOT CONFIRM(Text013) THEN EXIT;
        RemovalH.isAnnule := true;
        RemovalH."Cancelled By" := UserId;
        RemovalH."Cancelled Date" := CreateDateTime(Today, Time);
        RemovalH.Modify;

        //Cancel BL
        DeliveryH.Reset;
        DeliveryH.SetRange(DeliveryH.numBE, RemovalH.numBE);
        if DeliveryH.FindSet then
            repeat
                DeliveryH.isAnnule := true;
                DeliveryH."Cancelled By" := UserId;
                DeliveryH."Cancelled Date" := CreateDateTime(Today, Time);
                DeliveryH.Modify;
            until DeliveryH.Next = 0;

        //Supprimer le chargement
        TouringEntry.Reset;
        TouringEntry.SetCurrentKey(IdTouring, Immatriculation);
        TouringEntry.SetRange(IdTouring, RemovalH.idtournee);
        TouringEntry.SetRange(Immatriculation, RemovalH.codemoyentransport);
        TouringEntry.DeleteAll;

        //Confirmer sur le statut traitement cde
        TouringSalesH.Reset;
        TouringSalesH.SetRange(IdTouring, DeliveryH.idtournee);
        TouringSalesH.SetRange("Order No", RemovalH.NavOrderNo);
        TouringSalesH.ModifyAll("Touring Status", TouringSalesH."Touring Status"::Created);

        if Camion1.Get(RemovalH.codemoyentransport) then begin
            Camion1.entournee := false;
            Camion1.Modify;
        end;

        CheckTourneeIsValidated(RemovalH.idtournee, RemovalH.numBE);

        UpdateDispatchingStatus(RemovalH.NavOrderNo);
    end;

    procedure CancelBL(var DeliveryH: Record pro_enteteBL)
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record pro_detailBL;
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
        TouringEntry: Record "Touring Product Entry";
        Camion1: Record pro_moyentransport;
    begin

        //IF NOT CONFIRM(Text012) THEN EXIT;
        DeliveryH.isAnnule := true;
        DeliveryH."Cancelled By" := UserId;
        DeliveryH."Cancelled Date" := CreateDateTime(Today, Time);
        DeliveryH.Modify;

        //Supprimer le chargement
        TouringEntry.Reset;
        TouringEntry.SetRange(IdTouring, DeliveryH.idtournee);
        TouringEntry.SetRange(OrderNo, DeliveryH.NavOrderNo);
        TouringEntry.SetRange(Immatriculation, DeliveryH.codemoyentransport);
        TouringEntry.DeleteAll;

        if Camion1.Get(DeliveryH.codemoyentransport) then;
        LibererCamion(DeliveryH, Camion1);
        CheckTourneeIsValidated(DeliveryH.idtournee, DeliveryH.numBL);
    end;

    procedure CreateBLFromBE(RemovalH: Record pro_enteteBE)
    var
        RemovalLine: Record pro_detailBE;
        DeliveryH: Record pro_enteteBL;
        DeliveryLine: Record pro_detailBL;
        LineNum: Integer;
        PageBL: Page "Delivery Order";
    begin

        DeliveryH.datecreation := CreateDateTime(Today, Time);
        DeliveryLine.LockTable();
        DeliveryH.Insert(true);

        DeliveryH.datelivraison := RemovalH.dateBE;
        DeliveryH.numBE := RemovalH.numBE;
        //DeliveryH.numcommande := *******************************
        DeliveryH.nom := RemovalH.nom;
        DeliveryH.nomresponsable := RemovalH.nomresponsable;
        DeliveryH.codemoyentransport := RemovalH.codemoyentransport;
        DeliveryH.depot := RemovalH.depot;
        //DeliveryH.region:=RemovalH.re

        DeliveryH.Modify;

        LineNum := 0;
        RemovalLine.Reset;
        RemovalLine.SetRange(RemovalLine.numBE, RemovalH.numBE);
        if RemovalLine.FindSet then
            repeat

                DeliveryLine.NavItemCode := RemovalLine.NavItemCode;
                LineNum := LineNum + 10000;
                DeliveryLine."Line No." := LineNum;
                DeliveryLine.numBL := DeliveryH.numBL;
                DeliveryLine.volumealivrer := RemovalLine.volumeaenlever;
                DeliveryLine."Unit of Measure Code" := RemovalLine."Unit of Measure Code";
                DeliveryLine.Insert(true);

            until RemovalLine.Next = 0;

        Clear(PageBL);
        //SomePage.XXX; // Any user-defined function
        PageBL.SetTableView(DeliveryH);
        PageBL.SetRecord(DeliveryH);
        PageBL.Run;
    end;

    procedure CreateBEFromBE(RemovalH: Record pro_enteteBE)
    var
        RemovalLine: Record pro_detailBE;
        BE: Record pro_enteteBE;
        BELine: Record pro_detailBE;
        LineNum: Integer;
        PageBE: Page "Removal Order";
    begin

        BE.dateBE := RemovalH.dateBE;

        BELine.LockTable();
        BE.Insert(true);

        BE.codemoyentransport := RemovalH.codemoyentransport;

        BE.datecreation := CreateDateTime(Today, Time);
        BE.datevalidite := RemovalH.datevalidite;
        BE.densite := RemovalH.densite;
        //BE.depot
        BE.idtournee := RemovalH.idtournee;
        BE.nom := RemovalH.nom;
        BE.nomresponsable := RemovalH.nomresponsable;
        BE.temperature := RemovalH.temperature;
        BE.RegimeDouanier := RemovalH.RegimeDouanier;
        BE.observation := RemovalH.observation;
        BE.CreateFromBE := RemovalH.numBE;

        BE.Modify;

        LineNum := 0;
        RemovalLine.Reset;
        RemovalLine.SetRange(RemovalLine.numBE, RemovalH.numBE);
        if RemovalLine.FindSet then
            repeat

                BELine.NavItemCode := RemovalLine.NavItemCode;
                LineNum := LineNum + 10000;
                BELine."Line No." := LineNum;
                BELine.numBE := BE.numBE;
                BELine."Unit of Measure Code" := RemovalLine."Unit of Measure Code";
                //BELine.volumeaenlever := RemovalLine.volumeaenlever;
                BELine.Insert(true);

            until RemovalLine.Next = 0;

        Clear(PageBE);
        //SomePage.XXX; // Any user-defined function
        PageBE.SetTableView(BE);
        PageBE.SetRecord(BE);
        PageBE.Run;
        //IF SomePage.RUNMODAL = Action::LookupOK THEN
        //  SomePage.GETRECORD(MyRecord)...

        //PageBE.RUN(BE);
    end;

    procedure CreateBEFromBL(DeliveryH: Record pro_enteteBL)
    var
        DeliveryLine: Record pro_detailBL;
        RemovalH: Record pro_enteteBE;
        RemovalLine: Record pro_detailBE;
        LineNum: Integer;
    begin

        RemovalH.datecreation := CreateDateTime(Today, Time);
        RemovalLine.LockTable();
        RemovalH.Insert(true);

        RemovalH.dateBE := DeliveryH.datelivraison;

        RemovalH.nom := DeliveryH.nom;
        RemovalH.nomresponsable := DeliveryH.nomresponsable;
        RemovalH.codemoyentransport := DeliveryH.codemoyentransport;
        RemovalH.depot := DeliveryH.depot;
        //RemovalH.region:=DeliveryH.re

        RemovalH.Modify;

        LineNum := 0;
        DeliveryLine.Reset;
        DeliveryLine.SetRange(DeliveryLine.numBL, DeliveryH.numBL);
        if DeliveryLine.FindSet then
            repeat

                RemovalLine.NavItemCode := DeliveryLine.NavItemCode;
                LineNum := LineNum + 10000;
                RemovalLine."Line No." := LineNum;
                RemovalLine.numBE := RemovalH.numBE;
                RemovalLine.volumeaenlever := DeliveryLine.volumealivrer;
                RemovalLine."Unit of Measure Code" := DeliveryLine."Unit of Measure Code";
                RemovalLine.Insert(true);

            until DeliveryLine.Next = 0;
    end;

    local procedure getQtyALivrerUniteCde(CodeUniteCde: Code[10]; CodeUniteDispaching: Code[10]; QteDispaching: Decimal; CodeArticle: Code[20]; QtyPerUnitCde: Decimal): Decimal
    var
        QteBaseDispaching: Decimal;
        QtyPerUnitDispaching: Decimal;
        Item1: Record Item;
    begin
        Item1.Get(CodeArticle);
        QtyPerUnitDispaching := UOMgt.GetQtyPerUnitOfMeasure(Item1, CodeUniteDispaching);
        QteBaseDispaching := UOMgt.CalcBaseQty(QteDispaching, QtyPerUnitDispaching);
        if QtyPerUnitCde <> 0 then
            exit(UOMgt.RoundQty(QteBaseDispaching / QtyPerUnitCde))
        else
            Error(Text006);
    end;

    procedure CreateBLBEJIRAMA_FromOrder(SalesOrder: Record "Sales Header")
    var
        BE: Record pro_enteteBE;
        DeliveryH: Record pro_enteteBL;
        BELine: Record pro_detailBE;
        DeliveryLine: Record pro_detailBL;
        LineNum: Integer;
        SalesLine: Record "Sales Line";
        LineExists: Boolean;
        User: Record User;
        QtyRemoved: Decimal;
        Cust1: Record Customer;
        UserSetup: Record "User Setup";
    begin


        SalesProcess.CheckCanPostSalesOrder(SalesOrder);


        //Create BE
        BE.dateBE := WorkDate;
        BELine.LockTable();
        BE.Insert(true);

        BE.datecreation := CreateDateTime(Today, Time);
        BE.datevalidite := WorkDate;
        SalesOrder.TestField("Location Code");
        BE.depot := SalesOrder."Location Code";
        //BE.NumAfficheBE :='BE'+FORMAT(BE.numBE);
        BE.NumAfficheBE := '000';

        BE.observation := StrSubstNo(Text008, SalesOrder."No.");
        BE.CreatedFromDocNo := SalesOrder."No.";
        BE.datevalidite := CalcDate('<1D>', WorkDate);

        //User.SETRANGE(User."User Name",USERID);
        //IF User.FINDFIRST THEN BEGIN
        //  BE.nom := User."Full Name";
        //END;

        if UserSetup.Get(UserId) then begin
            BE.nom := UserSetup."Dispatching User Name";
            BE.nomresponsable := UserSetup."Dispatching Manager Name";
        end;
        if Cust1.Get(SalesOrder."Sell-to Customer No.") then
            if not Cust1."Remove JIR Ref on BE" then
                BE."Customer BE" := JIRAMAMgt.GetRefJIRAMA(BE);


        BE.datelivraison := WorkDate;
        BE.datevaliditeBL := CalcDate('<1D>', WorkDate);
        BE.AdrLivraisonBL := SalesOrder."Ship-to Code";
        BE.NavOrderNo := SalesOrder."No.";
        BE.region := SalesOrder."Responsibility Center";
        BE."Sales Channel Code" := Cust1."Sales Channel Code";
        BE."Customer No" := Cust1."No.";
        BE.IsBon := true;

        //Create BL
        DeliveryH.datecreation := CreateDateTime(Today, Time);
        DeliveryLine.LockTable();
        DeliveryH.Insert(true);

        DeliveryH.datelivraison := WorkDate;
        DeliveryH.numBE := BE.numBE;
        DeliveryH.NumBU := BE.NumBU;

        //DeliveryH.numcommande := *******************************
        //DeliveryH.nom := RemovalH.nom;
        //DeliveryH.nomresponsable := RemovalH.nomresponsable;
        //DeliveryH.codemoyentransport := RemovalH.codemoyentransport;
        DeliveryH.depot := BE.depot;
        DeliveryH.AdrLivraisonBL := SalesOrder."Ship-to Code";
        DeliveryH.NavOrderNo := SalesOrder."No.";
        DeliveryH.observationBL := StrSubstNo(Text009, SalesOrder."No.");
        //DeliveryH.region:=RemovalH.re
        DeliveryH.CreatedFromDocNo := SalesOrder."No.";
        DeliveryH.region := SalesOrder."Responsibility Center";
        DeliveryH.datevalidite := CalcDate('<1D>', WorkDate);
        DeliveryH.nomresponsable := BE.nomresponsable;
        DeliveryH.nom := BE.nom;
        DeliveryH.TestField(DeliveryH.depot);

        DeliveryH.IsBon := true;

        DeliveryH.Modify;


        BE.numBL := DeliveryH.numBL;
        BE.Modify;



        LineNum := 0;
        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document No.", SalesOrder."No.");
        if SalesLine.FindSet then
            repeat
                if ((SalesLine."Qty to remove" > 0) and (SalesLine.Type = SalesLine.Type::Item)) then begin

                    QtyRemoved := GetQteEnleve(SalesOrder."No.", BE.numBE);
                    if QtyRemoved + SalesLine."Qty to remove" > SalesLine.Quantity then Error(Text016, QtyRemoved);

                    LineExists := true;
                    LineNum := LineNum + 10000;

                    DeliveryLine.Init;
                    DeliveryLine."Line No." := LineNum;
                    DeliveryLine.numBL := DeliveryH.numBL;
                    DeliveryLine.volumealivrer := SalesLine."Qty to remove";
                    if not Cust1."Appliquer Ecart pompe JIR" then
                        DeliveryLine.volumelivre := SalesLine."Qty to remove";//Autres cas et Autres jirama
                    DeliveryLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                    DeliveryLine.NavItemCode := SalesLine."No.";
                    DeliveryLine.Insert(true);

                    BELine.Init;
                    BELine.NavItemCode := SalesLine."No.";
                    BELine."Line No." := LineNum;
                    BELine.numBE := BE.numBE;
                    BELine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
                    BELine.volumeaenlever := SalesLine."Qty to remove";
                    BELine.volumeenleve := SalesLine."Qty to remove";
                    BELine.volumealivrer := SalesLine."Qty to remove";
                    BELine.Insert(true);

                end;

                SalesLine."Qty to remove" := 0;
                SalesLine.Modify;

            until SalesLine.Next = 0;


        if not LineExists then
            Error(Text010)
        else
            Message(Text029, BE.NumBU);
    end;

    local procedure IsBL_JIRAMA(EnteteBL: Record pro_enteteBL): Boolean
    var
        SalesH: Record "Sales Header";
        Cust: Record Customer;
    begin
        AddOnSetup.Get;

        EnteteBL.TestField(EnteteBL.NavOrderNo);

        if SalesH.Get(SalesH."Document Type"::Order, EnteteBL.NavOrderNo) then
            if Cust.Get(SalesH."Sell-to Customer No.") then
                exit(Cust."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel");
    end;

    local procedure GetQteEnleve(OrderNo: Code[20]; ActualNumBE: Integer) QteEnleve: Decimal
    var
        EnteteBE: Record pro_enteteBE;
        LigneBE: Record pro_detailBE;
    begin
        QteEnleve := 0;
        EnteteBE.Reset;
        EnteteBE.SetCurrentKey(CreatedFromDocNo, isconfirme);
        EnteteBE.SetRange(CreatedFromDocNo, OrderNo);
        //EnteteBE.SETRANGE(isconfirme,TRUE);
        EnteteBE.SetFilter(EnteteBE.numBE, '<>%1', ActualNumBE);
        if EnteteBE.FindSet then
            repeat
                LigneBE.Reset;
                LigneBE.SetRange(numBE, EnteteBE.numBE);
                if LigneBE.FindSet then
                    repeat
                        //IF LigneBE.NavItemCode =JiramaForecast."JIRAMA Item No." THEN
                        if not EnteteBE.isAnnule then
                            QteEnleve := QteEnleve + LigneBE.volumeenleve;
                    until LigneBE.Next = 0;

            until EnteteBE.Next = 0;
    end;

    local procedure PostAdjBLJiramaMgt(EnteteBL: Record pro_enteteBL; CustNo: Code[20]): Boolean
    var
        DeliveryLine: Record pro_detailBL;
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        QtyAjustement: Decimal;
        DocNum: Code[20];
        DocumentNo: Code[20];
    begin

        AddOnSetup.Get;
        if not AddOnSetup."Jir Shipment Adj Mgt" then exit;


        DeliveryLine.Reset;
        DeliveryLine.SetRange(DeliveryLine.numBL, EnteteBL.numBL);
        if DeliveryLine.FindSet then
            repeat

                Item1.Get(DeliveryLine.NavItemCode);
                if DeliveryLine.volumelivre = 0 then
                    Error(Text019, DeliveryLine."Line No.");

                DeliveryLine.Validate(volumelivre);

                QtyAjustement := DeliveryLine.volumealivrer - DeliveryLine.volumelivre;

                //Dépot EXP - Ajustement négatif ou négatif
                ItemJnlLine.Init;
                ItemJnlLine."Posting Date" := EnteteBL.datelivraison;
                ItemJnlLine."Document Date" := EnteteBL.datelivraison;
                if EnteteBL.NumBU <> '' then
                    DocumentNo := EnteteBL.NumBU
                else
                    DocumentNo := 'BL' + Format(EnteteBL.numBL);
                ItemJnlLine."Document No." := DocumentNo;
                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AdjBL;
                //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::;
                ItemJnlLine."Document Line No." := DeliveryLine."Line No.";
                //ItemJnlLine."External Document No." := TransShptHeader2."External Document No.";
                if QtyAjustement > 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
                else
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                ItemJnlLine.Validate("Item No.", DeliveryLine.NavItemCode);
                ItemJnlLine.Description := StrSubstNo(Text020, EnteteBL.NumBU, EnteteBL.NavOrderNo, CustNo);

                ItemJnlLine.Validate("Location Code", EnteteBL.depot);
                ItemJnlLine.Validate(Quantity, Abs(QtyAjustement));

                ItemJnlLine.Validate("Unit of Measure Code", DeliveryLine."Unit of Measure Code");
                //ItemJnlLine."Invoiced Quantity" := RemovalLine.volumea15;
                ItemJnlLine."Reason Code" := AddOnSetup."Jir Shipment Adj Reason Code";
                ItemJnlLine."Source Code" := AddOnSetup."Removal Journal code";
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
                ItemJnlLine.AFK_SetDimensionsItem(DeliveryLine.NavItemCode);

                //ItemJnlLine.AFK_SetDimensions(RemovalLine.NavItemCode,

                if QtyAjustement > DeliveryLine.volumealivrer then
                    Error(Text014);

                if QtyAjustement <> 0 then
                    ItemJnlPostLine.RunWithCheck(ItemJnlLine);



            until DeliveryLine.Next = 0;
    end;

    local procedure LibererCamion(EnteteBL: Record pro_enteteBL; var Camion2: Record pro_moyentransport)
    var
        Camion: Record pro_moyentransport;
        BL: Record pro_enteteBL;
    begin

        if not CamionSurBLAutre(EnteteBL) then begin

            Camion2.entournee := false;
            Camion2.Modify;

        end;
    end;

    local procedure CamionSurBLAutre(EnteteBL: Record pro_enteteBL): Boolean
    var
        BL: Record pro_enteteBL;
        ExistsBLCamion: Boolean;
    begin
        BL.Reset;
        BL.SetRange(BL.codemoyentransport, EnteteBL.codemoyentransport);
        BL.SetRange(BL.isconfirme, false);
        BL.SetRange(BL.isAnnule, false);
        if BL.FindSet then
            repeat
                if BL.numBL <> EnteteBL.numBL then
                    exit(true);
            until BL.Next = 0;
    end;

    local procedure CheckNumBEClient(NumBEClient: Code[30])
    var
        proBE: Record pro_enteteBE;
    begin
        //Remove control on 07/12/2020 JN
        exit;
        if NumBEClient = '' then exit;

        proBE.Reset;
        proBE.SetRange("Customer BE", NumBEClient);
        proBE.SetRange(isconfirme, true);
        proBE.SetRange(isAnnule, false);
        if proBE.FindFirst then Error(Text023, proBE.numBE, NumBEClient);
    end;

    local procedure UpdateProdLivresCompartiment(Immatriculation: Code[20]; CodeProduit: Code[10]; IdCompart: Integer)
    var
        Camion: Record pro_moyentransport;
        Comp: Record Compartment;
    begin
        Comp.Reset;
        Comp.SetRange(Comp.immatriculation, Immatriculation);
        if not Comp.FindFirst then exit;
        //Comp.GET(Immatriculation);
        if IdCompart = 1 then
            Comp."Last Item1" := CodeProduit;
        if IdCompart = 2 then
            Comp."Last Item2" := CodeProduit;
        if IdCompart = 3 then
            Comp."Last Item3" := CodeProduit;
        if IdCompart = 4 then
            Comp."Last Item4" := CodeProduit;
        if IdCompart = 5 then
            Comp."Last Item5" := CodeProduit;
        if IdCompart = 6 then
            Comp."Last Item6" := CodeProduit;
        if IdCompart = 7 then
            Comp."Last Item7" := CodeProduit;
        if IdCompart = 8 then
            Comp."Last Item8" := CodeProduit;
        if IdCompart = 9 then
            Comp."Last Item9" := CodeProduit;
        if IdCompart = 10 then
            Comp."Last Item10" := CodeProduit;

        Comp.Modify;
    end;

    procedure SetVolumeRestantALivrerCde(OrderNo: Code[20]; var GO: Decimal; var SC: Decimal; var PL: Decimal; var FO: Decimal)
    var
        SO: Record "Sales Header";
        SOLine: Record "Sales Line";
        ResteALivrer: Decimal;
        Item: Record Item;
        QteDispach: Decimal;
        QteDispachBase: Decimal;
        ResteALivrerCdeUnit: Decimal;
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Dispaching Unit Code");
        SOLine.SetRange(SOLine."Document Type", SOLine."Document Type"::Order);
        SOLine.SetRange(SOLine."Document No.", OrderNo);
        if SOLine.FindSet then
            repeat

                if Item.Get(SOLine."No.") then
                    if ((Item."No. 2" = 'GO') or (Item."No. 2" = 'PL') or (Item."No. 2" = 'SC') or (Item."No. 2" = 'FO')) then begin

                        QteDispach := GetQtyEnTourneeCde(OrderNo, SOLine."No.",
                          SOLine."Unit of Measure Code", SOLine."Qty. per Unit of Measure");

                        QteDispachBase := Round(QteDispach * SOLine."Qty. per Unit of Measure", 0.00001);

                        ResteALivrerCdeUnit := SOLine."Quantity (Base)" - (SOLine."Qty. Shipped (Base)" + QteDispachBase);

                        ResteALivrer := GetQtyInDispachingUnit(ResteALivrerCdeUnit, SOLine."No.", AddOnSetup."Dispaching Unit Code");

                        if ItemIsGO(SOLine."No.") then
                            GO := GO + ResteALivrer;

                        if ItemIsPL(SOLine."No.") then
                            PL := PL + ResteALivrer;

                        if ItemIsFO(SOLine."No.") then
                            FO := FO + ResteALivrer;

                        if ItemIsSC(SOLine."No.") then
                            SC := SC + ResteALivrer;
                    end;
            until SOLine.Next = 0;
    end;

    local procedure ItemIsGO(ItemCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemCode) then
            if Item."No. 2" = 'GO' then
                exit(true);
    end;

    local procedure ItemIsPL(ItemCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemCode) then
            if Item."No. 2" = 'PL' then
                exit(true);
    end;

    local procedure ItemIsFO(ItemCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemCode) then
            if Item."No. 2" = 'FO' then
                exit(true);
    end;

    local procedure ItemIsSC(ItemCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.Get(ItemCode) then
            if Item."No. 2" = 'SC' then
                exit(true);
    end;

    local procedure GetQtyInDispachingUnit(QtyInBaseUnit: Decimal; ItemCode: Code[20]; DispachingBaseUnit: Code[10]): Decimal
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if ItemCode = '' then exit(0);
        ItemUOM.Get(ItemCode, DispachingBaseUnit);
        exit(Round(QtyInBaseUnit / ItemUOM."Qty. per Unit of Measure", 0.00001));
    end;

    procedure NbreVoyagesEncoursCamion(immatriculation: Code[30]) Rep: Integer
    var
        Tour: Record Touring;
        EnteteBL: Record pro_enteteBL;
        FindCamion: Boolean;
    begin
        Tour.Reset;
        Tour.SetCurrentKey(Status);
        Tour.SetRange(Status, Tour.Status::Posted);
        if Tour.FindSet then
            repeat
                //FindCamion:=FALSE;
                EnteteBL.Reset;
                EnteteBL.SetRange(EnteteBL.idtournee, Tour.IdTouring);
                EnteteBL.SetRange(EnteteBL.isconfirme, false);
                EnteteBL.SetRange(codemoyentransport, immatriculation);
                if EnteteBL.FindFirst then
                    Rep := Rep + 1;
                ;
            /*IF EnteteBL.FINDSET THEN
            REPEAT
              IF EnteteBL.codemoyentransport=immatriculation THEN BEGIN
                FindCamion := TRUE;
                Rep := Rep + 1;
              END;
            UNTIL ((EnteteBL.NEXT=0) AND (NOT FindCamion));*/

            until Tour.Next = 0;

    end;

    procedure RunDispach(IdTournee: Integer)
    var
    // cmdToRun: Text;
    // Process: DotNet BCProcess;
    // ret: Integer;
    // programm: Text;
    // param: Text;
    // WSHShell: Automation BC;
    // WaitForReturn: Boolean;
    // WshWindow: Text[10];
    // programPath: Text;
    begin
        // AddOnSetup.Get;
        // AddOnSetup.TestField(AddOnSetup."Dispaching Program Path");
        // //programPath := '"D:\GDP\Projet Dispaching\NavDispachingProject\NavDispaching\bin\Debug\NavDispaching.exe"';
        // //cmdToRun := '"D:\GDP\Projet Dispaching\Dispatching (Derniere Version)\AddOnsNavClient\TestAddOns\bin\Release\TestAddOns.exe"';
        // programPath := AddOnSetup."Dispaching Program Path";

        // cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7 %8','"'+programPath+'"',Format(IdTournee),
        //     AddOnSetup."SQL Server ID",AddOnSetup."SQL Server DB",AddOnSetup."SQL User",AddOnSetup."SQL Password",CompanyName,UserId);



        // //MESSAGE(cmdToRun);

        // if IsClear(WSHShell) then
        //   Create(WSHShell,false,true);

        // /* Window Styles:
        // 0 Hide the window and activate another window.
        // 1 Activate and display the window. (restore size and position) Specify this flag when displaying a window for the first time.
        // 2 Activate & minimize.
        // 3 Activate & maximize.
        // 4 Restore. The active window remains active.
        // 5 Activate & Restore.
        // 6 Minimize & activate the next top-level window in the Z order.
        // 7 Minimize. The active window remains active.
        // 8 Display the window in its current state. The active window remains active.
        // 9 Restore & Activate. Specify this flag when restoring a minimized window.
        // 10 Sets the show-state based on the state of the program that started the application.*/
        // WshWindow := '3'; //Windowsyle: minimized, maximized etc.

        // WaitForReturn := true; // modal run, receive ExitCode

        // WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);

        // Clear(WSHShell);

    end;

    procedure CheckNewOrderDispaching(idTouring: Integer; OrderNo: Code[20])
    var
        Tour: Record Touring;
        TourOrder: Record "Touring Sales Order";
    begin
        Tour.SetCurrentKey(Status);
        Tour.SetFilter(Tour.Status, '%1|%2', Tour.Status::Created, Tour.Status::Dispached);
        if Tour.FindSet then
            repeat
                if Tour.IdTouring <> idTouring then begin
                    TourOrder.Reset;
                    TourOrder.SetRange(IdTouring, Tour.IdTouring);
                    TourOrder.SetRange("Order No", OrderNo);
                    if TourOrder.FindFirst then
                        Error(Text025, OrderNo, Tour.IdTouring);
                end;
            until Tour.Next = 0;
    end;

    procedure GetQtyEnTourneeCde(OrderNo: Code[20]; CodeProduit: Code[20]; CodeUniteCde: Code[10]; QtyPerUnitCde: Decimal) QteLivreeEnUniteCde: Decimal
    var
        TourEntry: Record "Touring Product Entry";
        Item1: Record Item;
        Rep: Decimal;
    begin
        AddOnSetup.Get;

        Rep := 0;
        if not Item1.Get(CodeProduit) then exit(0);
        if Item1."No. 2" = '' then exit;

        TourEntry.Reset;
        TourEntry.SetCurrentKey(TouringStatus, OrderNo, ItemNo);
        TourEntry.SetRange(TouringStatus, TourEntry.TouringStatus::Posted);
        TourEntry.SetRange(OrderNo, OrderNo);
        TourEntry.SetRange(ItemNo, Item1."No. 2");
        if TourEntry.FindSet then
            repeat
                Rep := Rep + TourEntry.Volume;
            until TourEntry.Next = 0;


        QteLivreeEnUniteCde := getQtyALivrerUniteCde(CodeUniteCde,
                      AddOnSetup."Dispaching Unit Code", Rep, CodeProduit, QtyPerUnitCde);
    end;

    procedure CheckNewTruckDispaching(idTouring: Integer; immatriculation2: Code[30])
    var
        Tour: Record Touring;
        TourTruck: Record "Touring Truck";
    begin
        Tour.SetCurrentKey(Status);
        Tour.SetFilter(Tour.Status, '%1|%2', Tour.Status::Created, Tour.Status::Dispached);
        if Tour.FindSet then
            repeat
                if Tour.IdTouring <> idTouring then begin
                    TourTruck.Reset;
                    TourTruck.SetRange(IdTouring, Tour.IdTouring);
                    TourTruck.SetRange(immatriculation, immatriculation2);
                    if TourTruck.FindFirst then
                        Error(Text026, immatriculation2, Tour.IdTouring);
                end;
            until Tour.Next = 0;
    end;

    local procedure AllDocsValidated(IdTour: Integer; IdDoc: Integer): Boolean
    var
        Tour: Record Touring;
        BE: Record pro_enteteBE;
        BL: Record pro_enteteBL;
    begin
        //IF NOT Tour.GET(IdTour) THEN EXIT;

        BE.Reset;
        BE.SetCurrentKey(idtournee);
        BE.SetRange(idtournee, IdTour);
        if BE.FindSet then
            repeat
                if ((BE.isAnnule = false) and (BE.isconfirme = false) and (BE.numBE <> IdDoc)) then
                    exit(false);
            until BE.Next = 0;

        BL.Reset;
        BL.SetCurrentKey(idtournee);
        BL.SetRange(idtournee, IdTour);
        if BL.FindSet then
            repeat
                if ((not BL.isAnnule) and (not BL.isconfirme) and (BL.numBL <> IdDoc)) then
                    exit(false);
            until BL.Next = 0;

        exit(true);
    end;

    local procedure CheckTourneeIsValidated(IdTour: Integer; IdDoc: Integer)
    var
        Tour: Record Touring;
    begin
        if not Tour.Get(IdTour) then exit;
        if (AllDocsValidated(IdTour, IdDoc)) then begin
            Tour.Status := Tour.Status::Confirmed;
            Tour.Modify;
        end;
    end;

    procedure GetNbreLivrCamions(CodeImmatriculation: Code[30]; DateDeb: Date; DateFin: Date; var LivrNormales: Integer; var LivrAppoint: Integer; var LivrJIRAMA: Integer)
    var
        EnteteBL: Record pro_enteteBL;
        EnteteBE: Record pro_enteteBE;
    begin

        LivrNormales := 0;
        LivrAppoint := 0;
        LivrJIRAMA := 0;
        /*
        EnteteBL.RESET;
        EnteteBL.SETCURRENTKEY(codemoyentransport,isconfirme,isAnnule,datelivraison);
        EnteteBL.SETRANGE(codemoyentransport,CodeImmatriculation);
        EnteteBL.SETRANGE(EnteteBL.isconfirme,TRUE);
        EnteteBL.SETRANGE(EnteteBL.isAnnule,FALSE);
        EnteteBL.SETRANGE(EnteteBL.datelivraison,DateDeb,DateFin);
        IF EnteteBL.FINDSET THEN REPEAT
        
          IF IsBL_JIRAMA(EnteteBL) THEN
            LivrJIRAMA := LivrJIRAMA + 1
          ELSE
            LivrNormales := LivrNormales + 1;
        
        UNTIL EnteteBL.NEXT=0;
        */
        EnteteBE.Reset;
        EnteteBE.SetCurrentKey(codemoyentransport, isconfirme, isAnnule, dateBE);
        EnteteBE.SetRange(codemoyentransport, CodeImmatriculation);
        EnteteBE.SetRange(isconfirme, true);
        EnteteBE.SetRange(isAnnule, false);
        EnteteBE.SetRange(dateBE, DateDeb, DateFin);
        if EnteteBE.FindSet then
            repeat

                if EnteteBE.idtournee <= 0 then
                    LivrJIRAMA := LivrJIRAMA + 1
                else
                    LivrNormales := LivrNormales + 1;

            until EnteteBE.Next = 0;

    end;

    local procedure UpdateDispatchingStatus(OrderNo: Code[20])
    var
        QtyGO: Decimal;
        QtyPL: Decimal;
        QtyFO: Decimal;
        QtySC: Decimal;
        SalesH: Record "Sales Header";
    begin
        if SalesH.Get(SalesH."Document Type"::Order, OrderNo) then begin
            SalesH.CalcFields("Reliquat Number");

            SetVolumeRestantALivrerCde(OrderNo, QtyGO, QtySC, QtyPL, QtyFO);

            if SalesH."Reliquat Number" > 0 then begin
                if (QtyGO + QtySC + QtyPL + QtyFO = 0) then
                    SalesH."Dispatching Status" := SalesH."Dispatching Status"::Processed
                else
                    SalesH."Dispatching Status" := SalesH."Dispatching Status"::Reliquat;
            end else begin
                SalesH."Dispatching Status" := SalesH."Dispatching Status"::NonTraite
            end;
            SalesH.Modify;
        end;
    end;

    procedure PostOldBE(var RemovalH: Record pro_enteteBE; HideMsg: Boolean)
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        QtyAjustement: Decimal;
        EnteteBL: Record pro_enteteBL;
        DocNum: Code[20];
        TouringEntry: Record "Touring Product Entry";
        Camion1: Record pro_moyentransport;
    begin

        if RemovalH.isconfirme then
            Error(Text031);

        if not HideMsg then
            if not Confirm(Text035) then exit;

        AddOnSetup.Get;

        //RemovalH.TESTFIELD(RemovalH.codemoyentransport);
        RemovalH.TestField(RemovalH.dateBE);
        RemovalH.TestField(RemovalH.depot);
        RemovalH.TestField(RemovalH.numBSL);//141117
        RemovalH.TestField(RemovalH.codemoyentransport);//121119
        CheckNumBEClient(RemovalH."Customer BE");//050118

        RemovalH."Validation Date" := CreateDateTime(Today, Time);
        RemovalH.isconfirme := true;
        RemovalH.Modify;


        RemovalLine.Reset;
        RemovalLine.SetRange(RemovalLine.numBE, RemovalH.numBE);
        if RemovalLine.FindSet then
            repeat

                Item1.Get(RemovalLine.NavItemCode);
                //Item1.TestField(Item1."Item Category Code", AddOnSetup."PBL Category Code");//************************Added

                if RemovalLine.volumea15 = 0 then
                    Error(Text007, RemovalLine."Line No.");

                RemovalLine.Validate(RemovalLine.volumea15);

                QtyAjustement := RemovalLine.volumea15 - RemovalLine.volumeaenlever;

                //Dépot d'origine - Ajustement négatif ou négatif

                ItemJnlLine.Init;
                ItemJnlLine."Posting Date" := RemovalH.dateBE;
                ItemJnlLine."Document Date" := RemovalH.dateBE;

                ItemJnlLine."Document No." := StrSubstNo(Text017, RemovalH.numBE);
                if RemovalH.IsBon then
                    ItemJnlLine."Document No." := RemovalH.NumBU;

                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AdjBE;
                //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::;
                ItemJnlLine."Document Line No." := RemovalLine."Line No.";
                //ItemJnlLine."External Document No." := TransShptHeader2."External Document No.";
                if QtyAjustement > 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
                else
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                ItemJnlLine.Validate("Item No.", RemovalLine.NavItemCode);
                ItemJnlLine.Description := StrSubstNo(Text002, RemovalH.numBE);
                if RemovalH.IsBon then
                    ItemJnlLine.Description := StrSubstNo(Text002, RemovalH.NumBU);

                ItemJnlLine.Validate("Location Code", RemovalH.depot);
                ItemJnlLine.Validate(Quantity, Abs(QtyAjustement));

                ItemJnlLine.Validate("Unit of Measure Code", RemovalLine."Unit of Measure Code");
                //ItemJnlLine."Invoiced Quantity" := RemovalLine.volumea15;
                ItemJnlLine."Source Code" := AddOnSetup."Removal Journal code";
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
                ItemJnlLine.AFK_SetDimensionsItem(RemovalLine.NavItemCode);

                //ItemJnlLine.AFK_SetDimensions(RemovalLine.NavItemCode,

                if QtyAjustement > RemovalLine.volumeaenlever then
                    Error(Text014);

                if QtyAjustement <> 0 then
                    ItemJnlPostLine.RunWithCheck(ItemJnlLine);

                DocNum := ItemJnlLine."Document No.";
            /*
            TransferMgt.TransfertItemReclass(ItemJnlPostLine,DocNum,RemovalH.dateBE,RemovalLine.NavItemCode,
              RemovalH.depot,AddOnSetup."Shipment Location PBL",RemovalLine.volumeaenlever,RemovalLine."Unit of Measure Code",
                0,0,STRSUBSTNO(Text002, RemovalH.NumBU),ItemJnlLine."Adjustment Type"::BE,AddOnSetup."Cargo Enlevement");
            */


            until RemovalLine.Next = 0;


        //Si BE JIRAMA Confirmer le livraison aussi
        /*
        IF RemovalH.IsBEJIRAMA THEN BEGIN
          EnteteBL.RESET;
          EnteteBL.SETRANGE(numBE,RemovalH.numBE);
          IF EnteteBL.FINDFIRST THEN BEGIN
            EnteteBL.datelivraison := RemovalH.dateBE;
            EnteteBL.MODIFY;
            NoMessage := TRUE;
            PostBL(EnteteBL);
          END;
        END;
        */



        //Confirmer dans le dispaching (confirmer le chargement, la livraison sera confirmé sur le BL)
        /*
        IF RemovalH.Source=RemovalH.Source::Dispaching THEN BEGIN
        
          //Confirmer le chargement
          TouringEntry.RESET;
          TouringEntry.SETCURRENTKEY(IdTouring,Immatriculation);
          TouringEntry.SETRANGE(IdTouring,RemovalH.idtournee);
          TouringEntry.SETRANGE(Immatriculation,RemovalH.codemoyentransport);
          IF TouringEntry.FINDSET THEN REPEAT;
            //TouringEntry.TouringStatus := TouringEntry.TouringStatus::Confirmed;
            //TouringEntry.MODIFY;
            UpdateProdLivresCompartiment(TouringEntry.Immatriculation,TouringEntry.ItemNo,TouringEntry.IdCompartment);
          UNTIL TouringEntry.NEXT=0;
        
          //COMMIT;
          //SQLMgt.ConfirmBE(RemovalH.numBE);
        
          //JN230720 Liberation effectuee sur le BL
          //IF Camion1.GET(RemovalH.codemoyentransport) THEN BEGIN
          //  Camion1.entournee := FALSE;
          //  Camion1.MODIFY;
          //END;
        END;
        
        CheckTourneeIsValidated(RemovalH.idtournee,RemovalH.numBE);
        */


        if not HideMsg then
            Message(Text003);

    end;

    procedure PostOldBL(var DeliveryH: Record pro_enteteBL; HideMsg: Boolean)
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record pro_detailBL;
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
        EnteteBE: Record pro_enteteBE;
        QteALivrerUniteCde: Decimal;
        Item1: Record Item;
        Cust1: Record Customer;
        IsBL_JIRAMA_EcartPompe: Boolean;
        Camion1: Record pro_moyentransport;
        QtyALivrerGO: Decimal;
        QtyALivrerPL: Decimal;
        QtyALivrerFO: Decimal;
        QtyALivrerSC: Decimal;
        TouringEntry: Record "Touring Product Entry";
        AllLinesShip: Boolean;
        TouringSalesH: Record "Touring Sales Order";
    begin

        if not HideMsg then
            if not Confirm(Text004) then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Shipment Location PBL");
        AddOnSetup.TestField(AddOnSetup."PBL Category Code");

        DeliveryH.TestField(DeliveryH."Delivery Site");//201218
        DeliveryH.TestField(DeliveryH.codemoyentransport);//121119

        DeliveryH."Validation Date" := CreateDateTime(Today, Time);
        DeliveryH.isconfirme := true;
        DeliveryH.Modify;


        if ((IsBL_JIRAMA(DeliveryH)) or (IsBL_JIRAMA_EcartPompe)) then begin
            //COMMIT;
            LibererCamion(DeliveryH, Camion1);
        end;

        if not HideMsg then
            if not NoMessage then
                Message(Text003);
    end;

    procedure CancelOldBE(var RemovalH: Record pro_enteteBE)
    var
        DeliveryH: Record pro_enteteBL;
        TouringEntry: Record "Touring Product Entry";
        Camion1: Record pro_moyentransport;
        TouringSalesH: Record "Touring Sales Order";
    begin

        RemovalH.isAnnule := true;
        RemovalH."Cancelled By" := UserId;
        RemovalH."Cancelled Date" := CreateDateTime(Today, Time);
        RemovalH.Modify;

        //Cancel BL
        DeliveryH.Reset;
        DeliveryH.SetRange(DeliveryH.numBE, RemovalH.numBE);
        if DeliveryH.FindSet then
            repeat
                DeliveryH.isAnnule := true;
                DeliveryH."Cancelled By" := UserId;
                DeliveryH."Cancelled Date" := CreateDateTime(Today, Time);
                DeliveryH.Modify;
            until DeliveryH.Next = 0;

        if Camion1.Get(RemovalH.codemoyentransport) then begin
            Camion1.entournee := false;
            Camion1.Modify;
        end;
    end;

    procedure CancelOldBL(var DeliveryH: Record pro_enteteBL)
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record pro_detailBL;
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
        TouringEntry: Record "Touring Product Entry";
        Camion1: Record pro_moyentransport;
    begin

        DeliveryH.isAnnule := true;
        DeliveryH."Cancelled By" := UserId;
        DeliveryH."Cancelled Date" := CreateDateTime(Today, Time);
        DeliveryH.Modify;

        if Camion1.Get(DeliveryH.codemoyentransport) then;
        LibererCamion(DeliveryH, Camion1);
        //CheckTourneeIsValidated(DeliveryH.idtournee,DeliveryH.numBL);
    end;

    procedure PostBL_Old2(var DeliveryH: Record pro_enteteBL)
    var
        SalesOrder: Record "Sales Header";
        DeliveryLine: Record pro_detailBL;
        SalesLine: Record "Sales Line";
        ItemExists: Boolean;
        QteLivreeUniteCde: Decimal;
        EnteteBE: Record pro_enteteBE;
        QteALivrerUniteCde: Decimal;
        Item1: Record Item;
        Cust1: Record Customer;
        IsBL_JIRAMA_EcartPompe: Boolean;
        Camion1: Record pro_moyentransport;
        SalesPostCU: Codeunit "Sales-Post";
        PostedSalesShip: Record "Sales Shipment Header";
        PostShipExists: Boolean;
    begin

        if not Confirm(Text004) then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Shipment Location PBL");
        AddOnSetup.TestField(AddOnSetup."PBL Category Code");

        DeliveryH.TestField(DeliveryH."Delivery Site");//201218


        if GenCheckLine.DateNotAllowed(DeliveryH.datelivraison) then
            Error(Text001Dates);

        DeliveryH.TestField(DeliveryH.NavOrderNo);
        if Camion1.Get(DeliveryH.codemoyentransport) then;


        if SalesOrder.Get(SalesOrder."Document Type"::Order, DeliveryH.NavOrderNo) then begin

            IsBL_JIRAMA_EcartPompe := false;
            if Cust1.Get(SalesOrder."Sell-to Customer No.") then                //***
                if Cust1."Appliquer Ecart pompe JIR" then
                    IsBL_JIRAMA_EcartPompe := true;

            SalesRelease.Reopen(SalesOrder);

            SalesLine.Reset;
            SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
            SalesLine.SetRange(SalesLine."Document No.", SalesOrder."No.");
            if SalesLine.FindSet then
                repeat

                    SalesLine.SetHideValidationDialog(true);
                    //SalesLine.AFK_SetCanSetExpLocation(true);


                    DeliveryLine.Reset;
                    DeliveryLine.SetRange(DeliveryLine.numBL, DeliveryH.numBL);
                    if DeliveryLine.FindSet then
                        repeat
                            if (SalesLine."No." = DeliveryLine.NavItemCode) then begin
                                ItemExists := true;

                                Item1.Get(DeliveryLine.NavItemCode);//**************************************************Added
                                //Item1.TestField(Item1."Item Category Code", AddOnSetup."PBL Category Code");//***********Added

                                if DeliveryLine.volumelivre = 0 then
                                    Error(Text021, DeliveryLine."Line No.");//*****

                                if SalesLine."Real Location" = '' then
                                    SalesLine."Real Location" := SalesLine."Location Code";

                                if SalesLine."Location Code" <> DeliveryH.depot then
                                    SalesLine.Validate("Location Code", DeliveryH.depot);

                                //IF SalesLine."Location Code"<>AddOnSetup."Shipment Location PBL" THEN
                                //  SalesLine.VALIDATE("Location Code", AddOnSetup."Shipment Location PBL");

                                if IsBL_JIRAMA(DeliveryH) then begin

                                    QteLivreeUniteCde := getQtyALivrerUniteCde(SalesLine."Unit of Measure Code",
                                      DeliveryLine."Unit of Measure Code", DeliveryLine.volumelivre, DeliveryLine.NavItemCode, SalesLine."Qty. per Unit of Measure");

                                    SalesLine.Validate(SalesLine."Qty. to Ship", QteLivreeUniteCde);
                                end;

                                if IsBL_JIRAMA(DeliveryH) then
                                    SalesLine.Modify;

                            end;

                            if ((DeliveryH.Source = DeliveryH.Source::Dispaching) and (not IsBL_JIRAMA_EcartPompe)) then
                                if DeliveryLine.volumelivre > DeliveryLine.volumealivrer then
                                    Error(Text015);

                        until DeliveryLine.Next = 0;
                until SalesLine.Next = 0;

            if not ItemExists then Error(Text005, SalesOrder."No.");


            SalesOrder.Validate("Posting Date", DeliveryH.datelivraison);


            SalesRelease.Run(SalesOrder);

            if IsBL_JIRAMA(DeliveryH) then begin
                SalesOrder.Ship := true;
                SalesOrder.Invoice := false;
                if EnteteBE.Get(DeliveryH.numBE) then
                    SalesOrder."Your Reference" := EnteteBE."Customer BE";
            end;

            SalesOrder.Modify;
        end; //end SalesOrder.GET



        if IsBL_JIRAMA(DeliveryH) then begin

            //CODEUNIT.RUN(CODEUNIT::"Sales-Post",SalesOrder);
            //SalesPostCU.SetBUPosting(true);//**************
            SalesPostCU.SetSuppressCommit(true);
            SalesPostCU.Run(SalesOrder);//*****************
            DeliveryH."Posted Shipment No" := SalesOrder."Last Shipping No.";

            if IsBL_JIRAMA_EcartPompe then begin                                 //*** Gestion écart BL
                PostAdjBLJiramaMgt(DeliveryH, SalesOrder."Sell-to Customer No.");//***
                                                                                 //LibererCamion(DeliveryH,Camion1);
            end;

        end;


        DeliveryH."Validation Date" := CreateDateTime(Today, Time);
        DeliveryH.isconfirme := true;
        DeliveryH.Modify;



        if not NoMessage then
            Message(Text003);
    end;
}

