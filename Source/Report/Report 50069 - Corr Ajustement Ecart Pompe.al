report 50069 "Corr Ajustement Ecart Pompe"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(pro_enteteBL; pro_enteteBL)
        {
            DataItemTableView = WHERE(IsBon = CONST(false), Source = CONST(" "), isconfirme = CONST(true));
            RequestFilterFields = datelivraison;

            trigger OnAfterGetRecord()
            var
                EcrArticleId: Integer;
            begin
                EcrArticleId := FindItemLedgerEntry(pro_enteteBL);

                if TypeAjustement = TypeAjustement::Correction then
                    if EcrArticleId > 0 then
                        CreateEntryCorr(EcrArticleId, pro_enteteBL);

                if TypeAjustement = TypeAjustement::"Ajustements manquants" then
                    if EcrArticleId <= 0 then
                        CreateNewAjustements(pro_enteteBL, '');
            end;

            trigger OnPostDataItem()
            begin
                Message('TERMINE');
            end;

            trigger OnPreDataItem()
            begin
                LineNo := 100;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(TypeAjustement; TypeAjustement)
                {
                    Caption = 'Type ajustement';
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

    var
        Text001: Label 'Voulez-vous confirmer le bon d''enlèvement ?';
        Text002: Label 'Bon d''enlèvement %1';
        Text003: Label 'Le document a été confirmé avec succès';
        Text004: Label 'Voulez-vous confirmer le bon de livraison ?';
        Text005: Label 'Aucun article trouvé à livrer sur la commande %1';
        Text006: Label 'Quantity per unit of measure must be defined.';
        Text007: Label 'Veuillez saisir le volume à 15°C sur la ligne %1';
        Text008: Label 'Enlèvement généré à partir de la commande %1';
        Text009: Label 'Bon de livraison généré à partir de la commande %1';
        Text010: Label 'Veuillez entrer les quantités à enlever sur les lignes';
        Text011: Label 'Le Bon d''enlèvement %1 a été créé\Le Bon de livraison %2 a été créé';
        Text012: Label 'Voulez-vous annuler le bon de livraison ?';
        Text013: Label 'Voulez-vous annuler le bon d''enlèvement ?';
        Text014: Label 'Vérifiez si la quantité à 15°C a été saisie en LITRES ou en M3';
        Text015: Label 'Le volume livré ne doit pas être supérieur au volume à livrer';
        Text016: Label 'Vous ne pouvez pas enlever cette quantité. La quantité déjà enlevée est %1';
        Text017: Label 'BE%1';
        Text018: Label 'BL%1';
        Text019: Label 'Veuillez saisir le volume livré sur la ligne %1';
        Text020: Label '%1-%2-%3';
        Text021: Label 'Veuillez saisir le volume livré sur la ligne %1';
        Text022: Label 'Le Bon d''enlèvement %1 lié à ce bon de livraison n''est pas encore confirmé. Veuillez le confirmer.';
        Text023: Label 'Il existe déjà un BE %1 confirmé avec la Ref. BE Client %2';
        Text001Dates: Label 'is not within your range of allowed posting dates';
        Text024: Label 'Groupe de livraison non présent sur la ligne %1 commande %2';
        Text025: Label 'La commande %1 existe déjà sur une tournée non validée : %2';
        Text026: Label 'Le code camion %1 existe déjà sur une tournée non validée : %2';
        Text027: Label 'Voulez-vous confirmer le bon ?';
        Text028: Label 'Confirmer l''enlèvement,Confirmer la livraison et facturer';
        Text029: Label 'Le Bon %1 a été créé';
        Text030: Label 'Bon %1';
        Text031: Label 'L''enlèvement a déjà été confirmé';
        Text032: Label '&Confirmer la livraison sans facturer,&Confirmer la livraison et facturer';
        Text033: Label '&Confirm shipment and invoice';
        Text034: Label 'Le document à livrer semble être une ancienne commande livrée par l''ancien dispaching. Veuillez modifier le code magasin sur les lignes si ce n''est pas le cas.';
        Text035: Label 'Voulez-vous confirmer le bon d''enlèvement ?';
        AddOnSetup: Record "AddOn Setup";
        Text036: Label 'Correction écart pompe %1';
        TypeAjustement: Option Correction,"Ajustements manquants";
        LineNo: Integer;

    local procedure PostAdjBLJiramaMgt(EnteteBL: Record pro_enteteBL; CustNo: Code[20]): Boolean
    var
        DeliveryLine: Record pro_detailBL;
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        QtyAjustement: Decimal;
        DocNum: Code[20];
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
                ItemJnlLine."Document No." := EnteteBL.NumBU;
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

                //IF QtyAjustement<>0 THEN
                //  ItemJnlPostLine.RunWithCheck(ItemJnlLine);

                if QtyAjustement <> 0 then
                    ItemJnlLine.Insert(true);



            until DeliveryLine.Next = 0;
    end;

    local procedure FindItemLedgerEntry(EnteteBL: Record pro_enteteBL): Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange("Document No.", 'BL' + Format(EnteteBL.numBL));
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Location Code", 'EXP1PBF');
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Adjustment Type", ItemLedgerEntry."Adjustment Type"::AdjBL);
        ItemLedgerEntry.SetFilter(ItemLedgerEntry."Transaction Date", '>%1', 20201123D);
        if ItemLedgerEntry.FindFirst then
            exit(ItemLedgerEntry."Entry No.");
    end;

    local procedure CreateEntryCorr(ItemLedgerEntryNo: Integer; EnteteBL: Record pro_enteteBL)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        QtyAjustement: Decimal;
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        NumDoc: Code[20];
    begin

        //Annulation
        ItemLedgerEntry.Get(ItemLedgerEntryNo);

        QtyAjustement := ItemLedgerEntry.Quantity;
        Item1.Get(ItemLedgerEntry."Item No.");

        LineNo := LineNo + 10;

        //Dépot EXP - Ajustement négatif ou négatif
        ItemJnlLine.Init;
        ItemJnlLine."Journal Template Name" := 'ARTICLE';
        ItemJnlLine."Journal Batch Name" := 'MIGRATION';
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine."Posting Date" := ItemLedgerEntry."Posting Date";
        ItemJnlLine."Document Date" := ItemLedgerEntry."Document Date";
        ItemJnlLine."Document No." := ItemLedgerEntry."Document No.";
        ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AdjBL;
        ItemJnlLine."External Document No." := 'CORRAJUSTPOMPE';

        ItemJnlLine."Document Line No." := ItemLedgerEntry."Document Line No.";

        if QtyAjustement > 0 then
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
        else
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
        ItemJnlLine.Validate("Item No.", ItemLedgerEntry."Item No.");
        ItemJnlLine.Description := StrSubstNo(Text036, ItemLedgerEntry."Document No.");

        ItemJnlLine.Validate("Location Code", ItemLedgerEntry."Location Code");
        ItemJnlLine.Validate(Quantity, Abs(QtyAjustement));

        ItemJnlLine.Validate("Unit of Measure Code", ItemLedgerEntry."Unit of Measure Code");
        ItemJnlLine."Reason Code" := AddOnSetup."Jir Shipment Adj Reason Code";
        ItemJnlLine."Source Code" := AddOnSetup."Removal Journal code";
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
        ItemJnlLine.Validate("Dimension Set ID", ItemLedgerEntry."Dimension Set ID");

        if QtyAjustement <> 0 then
            ItemJnlLine.Insert(true);



        LineNo := LineNo + 10;

        //Nouvelle écriture sur le BE
        ItemJnlLine.Init;
        ItemJnlLine."Journal Template Name" := 'ARTICLE';
        ItemJnlLine."Journal Batch Name" := 'MIGRATION';
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine."Posting Date" := ItemLedgerEntry."Posting Date";
        ItemJnlLine."Document Date" := ItemLedgerEntry."Document Date";
        if EnteteBL.NumBU <> '' then
            NumDoc := Format(EnteteBL.NumBU)
        else
            NumDoc := 'BE' + Format(EnteteBL.numBE);

        ItemJnlLine."Document No." := NumDoc;
        ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AdjBL;
        ItemJnlLine."External Document No." := 'CORRAJUSTPOMPE';

        ItemJnlLine."Document Line No." := ItemLedgerEntry."Document Line No.";

        if QtyAjustement < 0 then
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
        else
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
        ItemJnlLine.Validate("Item No.", ItemLedgerEntry."Item No.");
        ItemJnlLine.Description := StrSubstNo(Text036, ItemLedgerEntry."Document No.");

        ItemJnlLine.Validate("Location Code", EnteteBL.depot);
        ItemJnlLine.Validate(Quantity, Abs(QtyAjustement));

        ItemJnlLine.Validate("Unit of Measure Code", ItemLedgerEntry."Unit of Measure Code");
        ItemJnlLine."Reason Code" := AddOnSetup."Jir Shipment Adj Reason Code";
        ItemJnlLine."Source Code" := AddOnSetup."Removal Journal code";
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
        ItemJnlLine.Validate("Dimension Set ID", ItemLedgerEntry."Dimension Set ID");

        if QtyAjustement <> 0 then
            ItemJnlLine.Insert(true);
    end;

    local procedure CreateNewAjustements(EnteteBL: Record pro_enteteBL; CustNo: Code[20]): Boolean
    var
        DeliveryLine: Record pro_detailBL;
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        QtyAjustement: Decimal;
        DocNum: Code[20];
        NumDoc: Code[20];
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

                LineNo := LineNo + 10;

                //Dépot EXP - Ajustement négatif ou négatif
                ItemJnlLine.Init;
                ItemJnlLine."Journal Template Name" := 'ARTICLE';
                ItemJnlLine."Journal Batch Name" := 'MIGRATION';
                ItemJnlLine."Line No." := LineNo;
                ItemJnlLine."Posting Date" := EnteteBL.datelivraison;
                ItemJnlLine."Document Date" := EnteteBL.datelivraison;
                if EnteteBL.NumBU <> '' then
                    NumDoc := Format(EnteteBL.NumBU)
                else
                    NumDoc := 'BE' + Format(EnteteBL.numBE);
                ItemJnlLine."Document No." := NumDoc;
                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::AdjBL;
                //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::;
                ItemJnlLine."Document Line No." := DeliveryLine."Line No.";
                ItemJnlLine."External Document No." := 'CORRAJUSTPOMPE';
                if QtyAjustement > 0 then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt."
                else
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                ItemJnlLine.Validate("Item No.", DeliveryLine.NavItemCode);
                //ItemJnlLine.Description := STRSUBSTNO(Text020, EnteteBL.NumBU,EnteteBL.NavOrderNo,CustNo);
                ItemJnlLine.Description := StrSubstNo(Text036, EnteteBL.numBE) + ' ' + Format(EnteteBL.NavOrderNo);

                ItemJnlLine.Validate("Location Code", EnteteBL.depot);
                ItemJnlLine.Validate(Quantity, Abs(QtyAjustement));

                ItemJnlLine.Validate("Unit of Measure Code", DeliveryLine."Unit of Measure Code");
                ItemJnlLine."Reason Code" := AddOnSetup."Jir Shipment Adj Reason Code";
                ItemJnlLine."Source Code" := AddOnSetup."Removal Journal code";
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
                ItemJnlLine.AFK_SetDimensionsItem(DeliveryLine.NavItemCode);


                if QtyAjustement > DeliveryLine.volumealivrer then
                    Error(Text014);

                //IF QtyAjustement<>0 THEN
                //  ItemJnlPostLine.RunWithCheck(ItemJnlLine);

                if QtyAjustement <> 0 then
                    ItemJnlLine.Insert(true);



            until DeliveryLine.Next = 0;
    end;
}

