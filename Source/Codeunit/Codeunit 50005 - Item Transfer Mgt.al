codeunit 50005 "Item Transfer Mgt"
{
    // //JN120118 Récupérer les axes sur les lignes sauf pour les BE ou c'est nul


    trigger OnRun()
    begin
    end;

    var
        AddOnsSetup: Record "AddOn Setup";
        Text001: Label 'Voulez-vous valider une récepetion au dépôt %1?';
        Text002: Label 'La quantité à recevoir de la ligne %1 ne doit pas être supérieure à %2';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text003: Label 'Vous devez renseigner le magasin de destination !';
        SourceCodeSetup: Record "Source Code Setup";
        Text004: Label 'La quantité à recevoir ajustée doit avoir une valeur sur la ligne %1';
        Text005: Label 'La quantité à ajuster ne peut pas être nulle sur la ligne %1';
        Text006: Label 'Voulez-vous valider l''expédition ?';
        Text007: Label 'Expédition transfert %1';
        Text008: Label 'Réception transfert %1';
        Text009: Label 'Traitement terminé avec succès';
        Text010: Label 'Aucune ligne à valider !';
        Text011: Label 'Voulez-vous valider la réception vers le magasin %1 ?';
        Text012: Label 'Vous ne pouvez pas retourner une quantité supérieure à la quantité expédiée sur la ligne %1';
        Descr: Text[50];
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text013: Label 'Les codes magasin d''expédition et de réception ne peuvent pas être identiques';
        IsBatch: Boolean;
        Text014: Label 'La date de réception doit être postérieure à la date d''expédition';
        Text015: Label 'La quantité à recevoir est différente de la quantité à transférer sur le transfert %1';
        Text016: Label 'Voulez-vous annuler l''expédition à la date du %1 ?';
        Text017: Label 'Ce transfert ne peut plus être annulé car il a déjà subi une réception';
        Text018: Label 'Annulation Expédition transfert %1';
        Text019: Label 'Le numéro doc externe %1 a déjà été utilisé dans le transfert %2';

    procedure PostExpedition(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        LineExits: Boolean;
        ResteARemb: Decimal;
        ItemTransfer: Codeunit "Item Transfer Mgt";
        PostItemAdj1: Record "Posted Adjustment Header";
        ItemAdj1: Record "Adjustment Header";
    begin

        if not IsBatch then
            if not Confirm(Text006) then exit;

        ItemAdj.TestField(ItemAdj."Location Code");
        ItemAdj.TestField(ItemAdj."In-Transit Code");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status, ItemAdj.Status::Open);


        AddOnsSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."Partner Location");

        if ItemAdj."External Document No." <> '' then begin
            PostItemAdj1.Reset;
            PostItemAdj1.SetRange("Document Type", PostItemAdj1."Document Type"::Transfer);
            PostItemAdj1.SetRange("External Document No.", ItemAdj."External Document No.");
            if PostItemAdj1.FindSet then
                repeat
                    if PostItemAdj1."No." <> ItemAdj."No." then
                        Error(Text019, PostItemAdj1."External Document No.", PostItemAdj1."No.");
                until PostItemAdj1.Next = 0;

            ItemAdj1.Reset;
            ItemAdj1.SetRange("Document Type", ItemAdj1."Document Type"::Transfer);
            ItemAdj1.SetRange("External Document No.", ItemAdj."External Document No.");
            if ItemAdj1.FindSet then
                repeat
                    if ItemAdj1."No." <> ItemAdj."No." then
                        Error(Text019, ItemAdj1."External Document No.", ItemAdj1."No.");
                until ItemAdj1.Next = 0;
        end;

        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;

        Descr := StrSubstNo(Text007, ItemAdj."No.");

        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type", AdjustLine."Document Type"::Transfer);
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet(true, true) then
            repeat

                Item1.Get(AdjustLine."Item No.");

                //AdjustLine.TESTFIELD(AdjustLine."Location Code");
                //AdjustLine.TESTFIELD(AdjustLine."Item No.");
                AdjustLine.TestField(AdjustLine.Quantity);
                AdjustLine.Validate("Qty. in Transit", AdjustLine."Qty. in Transit" + (AdjustLine.Quantity - AdjustLine."Returned Qty"));
                AdjustLine."Transfer-from Code" := ItemAdj."Location Code";
                AdjustLine.Status := AdjustLine.Status::Released;
                AdjustLine.Modify;

                LineExits := true;

                //JN141021 : Modif transfert PBL afin de gerer les op sans valorisation (génération ecritures comptables)
                if (ItemAdj."Item Category Code" = AddOnsSetup."PBL Category Code") then
                    TransfertItemReclass(ItemJnlPostLine, ItemAdj."No.", ItemAdj."Posting Date", AdjustLine."Item No.",
                      ItemAdj."Location Code", ItemAdj."In-Transit Code", Abs(AdjustLine.Quantity), AdjustLine."Unit of Measure Code",
                      AdjustLine."Dimension Set ID", AdjustLine."Dimension Set ID", Descr, ItemJnlLine."Adjustment Type"::Shipment, '')
                else
                    TransfertItemReclassTransfert(ItemJnlPostLine, ItemAdj."No.", ItemAdj."Posting Date", AdjustLine."Item No.",
                      ItemAdj."Location Code", ItemAdj."In-Transit Code", Abs(AdjustLine.Quantity), AdjustLine."Unit of Measure Code",
                      AdjustLine."Dimension Set ID", AdjustLine."Dimension Set ID", Descr, ItemJnlLine."Adjustment Type"::Shipment, AdjustLine);


            until AdjustLine.Next = 0;

        if not IsBatch then begin
            if not LineExits then
                Error(Text010)
            else
                Message(Text009);
        end;
    end;

    procedure PostReception(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        CloseDocument: Boolean;
        LineExistsToReturn: Boolean;
        CodeRemb: Code[20];
        LigneTransfer: Record "Adjustment Line";
        ItemTransfer: Codeunit "Item Transfer Mgt";
        ListeMotifs: Record "Transfer Reason Code";
    begin

        AddOnsSetup.Get;
        ItemAdj.TestField(ItemAdj.Status, ItemAdj.Status::Released);

        if ItemAdj."Location Code" = ItemAdj."Transfer-to Code" then Error(Text013);


        if not IsBatch then
            if not Confirm(StrSubstNo(Text011, ItemAdj."Transfer-to Code")) then exit;

        ItemAdj.TestField(ItemAdj."Transfer-to Code");
        ItemAdj.TestField(ItemAdj."In-Transit Code");
        ItemAdj.TestField(ItemAdj."Receipt Date");

        if ItemAdj."Receipt Date" < ItemAdj."Posting Date" then Error(Text014);

        CloseDocument := true;

        Descr := StrSubstNo(Text008, ItemAdj."No.");

        LineExistsToReturn := false;
        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type", AdjustLine."Document Type"::Transfer);
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet then
            repeat
                if AdjustLine."Returned Qty" + AdjustLine."Qty to return" > AdjustLine.Quantity then
                    Error(Text012, AdjustLine."Line No.");
                if AdjustLine."Qty to return" <> 0 then LineExistsToReturn := true;
            until AdjustLine.Next = 0;


        if LineExistsToReturn then
            CodeRemb := AddNewReception(ItemAdj);


        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type", AdjustLine."Document Type"::Transfer);
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet(true, true) then
            repeat

                Item1.Get(AdjustLine."Item No.");

                LigneTransfer := AdjustLine;

                if AdjustLine."Returned Qty" + AdjustLine."Qty to return" <> AdjustLine.Quantity then
                    CloseDocument := false;


                if ItemAdj."Item Category Code" = AddOnsSetup."LUBS Item Category" then begin
                    AdjustLine.TestField("Batch Number");
                    AdjustLine.TestField("Expiration Date");
                end;

                //************************Added 230616 Controle reception PBL
                if IsBatch then
                    if AdjustLine.Quantity <> AdjustLine."Qty to return" then
                        Error(Text015, ItemAdj."No.");


                if AdjustLine."Qty to return" <> 0 then begin
                    LineExistsToReturn := true;

                    //JN141021 : Modif transfert PBL afin de gerer les op sans valorisation (génération ecritures comptables)
                    if (ItemAdj."Item Category Code" = AddOnsSetup."PBL Category Code") then
                        TransfertItemReclass(ItemJnlPostLine, CodeRemb, ItemAdj."Receipt Date", AdjustLine."Item No.",
                          ItemAdj."In-Transit Code", ItemAdj."Transfer-to Code", Abs(AdjustLine."Qty to return"), AdjustLine."Unit of Measure Code",
                          AdjustLine."Dimension Set ID", AdjustLine."Dimension Set ID", ItemAdj."Posting Description", ItemJnlLine."Adjustment Type"::Reception,
                          '')
                    else
                        TransfertItemReclassTransfert(ItemJnlPostLine, CodeRemb, ItemAdj."Receipt Date", AdjustLine."Item No.",
                          ItemAdj."In-Transit Code", ItemAdj."Transfer-to Code", Abs(AdjustLine."Qty to return"), AdjustLine."Unit of Measure Code",
                          AdjustLine."Dimension Set ID", AdjustLine."Dimension Set ID", ItemAdj."Posting Description", ItemJnlLine."Adjustment Type"::Reception,
                          AdjustLine);

                    PostAjustementLines(ItemAdj, AdjustLine, ItemJnlPostLine, CodeRemb);


                    LigneTransfer."Returned Qty" += AdjustLine."Qty to return";
                    LigneTransfer.Validate("Qty. in Transit", (LigneTransfer.Quantity - LigneTransfer."Returned Qty"));
                    LigneTransfer."Qty to return" := LigneTransfer.Quantity - (LigneTransfer."Returned Qty");
                    LigneTransfer."Qty to receive Adj" := LigneTransfer."Qty to return";
                    LigneTransfer.Modify;
                end;

            until AdjustLine.Next = 0;





        if LineExistsToReturn then begin

            //Vider la table des ajustements
            ListeMotifs.Reset;
            ListeMotifs.SetRange(ListeMotifs."Document Type", ListeMotifs."Document Type"::Transfer);
            ListeMotifs.SetRange(ListeMotifs."Document No.", ItemAdj."No.");
            ListeMotifs.DeleteAll;

            //Close Doc
            if CloseDocument then
                ArchiveDoc(ItemAdj);

            if not IsBatch then
                Message(Text009);
        end else begin
            if not IsBatch then
                Message(Text010);
        end;
    end;

    procedure CancelExpedition(var ItemAdj: Record "Adjustment Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        LineExits: Boolean;
        ResteARemb: Decimal;
        ItemTransfer: Codeunit "Item Transfer Mgt";
        ListeMotifs: Record "Transfer Reason Code";
    begin

        ItemAdj.TestField(ItemAdj.Status, ItemAdj.Status::Released);

        if ReceptionExists(ItemAdj) then Error(Text017);
        ItemAdj.TestField("Receipt Date");

        if not Confirm(StrSubstNo(Text016, ItemAdj."Receipt Date")) then exit;

        ItemAdj.TestField(ItemAdj."Location Code");
        ItemAdj.TestField(ItemAdj."In-Transit Code");
        ItemAdj.TestField("Posting Date");



        //AddOnSetup.GET;
        //AddOnSetup.TESTFIELD(AddOnSetup."Partner Location");

        ItemAdj.Status := ItemAdj.Status::Cancelled;
        ItemAdj."Cancellation Date" := Today;
        ItemAdj."Cancelled By" := UserId;
        ItemAdj.Modify;

        Descr := StrSubstNo(Text018, ItemAdj."No.");

        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type", AdjustLine."Document Type"::Transfer);
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet(true, true) then
            repeat

                Item1.Get(AdjustLine."Item No.");

                //AdjustLine.TESTFIELD(AdjustLine."Location Code");
                //AdjustLine.TESTFIELD(AdjustLine."Item No.");
                AdjustLine.TestField(AdjustLine.Quantity);

                LineExits := true;
                TransfertItemReclassTransfert(ItemJnlPostLine, ItemAdj."No.", ItemAdj."Receipt Date", AdjustLine."Item No.",
                  ItemAdj."In-Transit Code", ItemAdj."Location Code", Abs(AdjustLine.Quantity), AdjustLine."Unit of Measure Code",
                  AdjustLine."Dimension Set ID", AdjustLine."Dimension Set ID", Descr, ItemJnlLine."Adjustment Type"::Shipment, AdjustLine);


            until AdjustLine.Next = 0;



        //Vider la table des ajustements
        ListeMotifs.Reset;
        ListeMotifs.SetRange(ListeMotifs."Document Type", ListeMotifs."Document Type"::Transfer);
        ListeMotifs.SetRange(ListeMotifs."Document No.", ItemAdj."No.");
        ListeMotifs.DeleteAll;

        //Archive Doc
        ArchiveDoc(ItemAdj);


        Message(Text009);
    end;

    local procedure AddNewReception(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        ReturnHeader: Record "Item Return Header";
        ReturnLine: Record "Item Return Line";
        AdjLine: Record "Adjustment Line";
    begin

        AddOnsSetup.Get;
        AddOnsSetup.TestField("Transfer Receipt Nos.");

        ReturnHeader.Init;
        ReturnHeader.TransferFields(ItemAdj);
        ReturnHeader."Document Type" := ReturnHeader."Document Type"::Transfer;
        ReturnHeader."No." := NoSeriesMgt.GetNextNo(AddOnsSetup."Transfer Receipt Nos.", Today, true);
        ReturnHeader."Original Doc No" := ItemAdj."No.";
        ReturnHeader."Posting Date" := ItemAdj."Receipt Date";
        ReturnHeader."Transfer-to Code" := ItemAdj."Transfer-to Code";
        ReturnHeader."User ID" := UserId;
        ReturnHeader.Insert;

        AdjLine.Reset;
        AdjLine.SetRange("Document Type", AdjLine."Document Type"::Transfer);
        AdjLine.SetRange("Document No.", ItemAdj."No.");
        if AdjLine.FindSet then
            repeat
                ReturnLine.Init;
                ReturnLine.TransferFields(AdjLine);
                ReturnLine."Document Type" := ReturnLine."Document Type"::Transfer;
                ReturnLine."Document No." := ReturnHeader."No.";
                ReturnLine."Line No." := AdjLine."Line No.";
                ReturnLine.Quantity := AdjLine."Qty to return";
                if ReturnLine.Quantity > 0 then
                    ReturnLine.Insert;


            //Ajustement de la ligne

            until AdjLine.Next = 0;

        exit(ReturnHeader."No.");
    end;

    local procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    begin
        ItemAdjustMgt.ArchiveDoc(ItemAdj);
        ItemAdj.SetIsArchive(true);
        ItemAdj.Delete(true);
    end;

    procedure PostAjustementLines(AdjItem: Record "Adjustment Header"; var AdjustLine: Record "Adjustment Line"; var ItemJnlPostLine2: Codeunit "Item Jnl.-Post Line"; CodeRemb: Code[20])
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ListeMotifs: Record "Transfer Reason Code";
        PostedAdjustement: Record "Posted Transfer Reason Code";
    begin

        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup.Transfer;

        Descr := StrSubstNo(Text008, AdjItem."No.");

        Item1.Get(AdjustLine."Item No.");

        ListeMotifs.Reset;
        ListeMotifs.SetRange(ListeMotifs."Document Type", ListeMotifs."Document Type"::Transfer);
        ListeMotifs.SetRange(ListeMotifs."Document No.", AdjustLine."Document No.");
        ListeMotifs.SetRange(ListeMotifs."Line No.", AdjustLine."Line No.");
        if ListeMotifs.FindSet then
            repeat


                PostedAdjustement.Init;
                PostedAdjustement.TransferFields(ListeMotifs);
                PostedAdjustement."Document No." := CodeRemb;
                PostedAdjustement.Insert;


                AdjQty := ListeMotifs."Adjust Qty";
                if AdjQty = 0 then Error(Text005, ListeMotifs."Line No.");
                PositiveAdj := AdjQty > 0;

                //Dépot d'origine - Ajustement négatif
                ItemJnlLine.Init;
                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::Transfer;
                ItemJnlLine."Posting Date" := AdjItem."Receipt Date";
                ItemJnlLine."Document Date" := WorkDate;
                ItemJnlLine."Document No." := CodeRemb;
                //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
                //ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
                ItemJnlLine."External Document No." := AdjItem."No.";

                if PositiveAdj then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
                else
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

                ItemJnlLine.Validate("Item No.", AdjustLine."Item No.");
                ItemJnlLine.Description := Descr;
                ItemJnlLine."Shortcut Dimension 1 Code" := AdjustLine."Shortcut Dimension 1 Code";
                //ItemJnlLine."New Shortcut Dimension 1 Code" := AdjustLine."Shortcut Dimension 1 Code";
                ItemJnlLine."Shortcut Dimension 2 Code" := AdjustLine."Shortcut Dimension 2 Code";
                //ItemJnlLine."New Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
                ItemJnlLine."Dimension Set ID" := AdjustLine."Dimension Set ID";
                //ItemJnlLine."New Dimension Set ID" := TransRcptLine2."Dimension Set ID";
                ItemJnlLine.Validate("Location Code", AdjItem."Transfer-to Code");
                ItemJnlLine.Validate(Quantity, Abs(AdjQty));

                ItemJnlLine.Validate("Unit of Measure Code", AdjustLine."Unit of Measure Code");
                ItemJnlLine."Invoiced Quantity" := Abs(AdjQty);

                ItemJnlLine."LUB Expiration Date" := AdjustLine."Expiration Date";
                ItemJnlLine."Batch Number" := AdjustLine."Batch Number";

                ItemJnlLine."Source Code" := SourceCode;
                ItemJnlLine."Reason Code" := ListeMotifs."Reason Code";
                ItemJnlLine.AFK_SetDimensionsItem(AdjustLine."Item No.");

                //ItemJnlLine.Area := TransRcptHeader2.Area;
                //ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

                if AdjQty <> 0 then
                    ItemJnlPostLine2.RunWithCheck(ItemJnlLine);

            until ListeMotifs.Next = 0;
    end;

    procedure ProcessHypoReception(var TransHeader: Record "Transfer Header")
    var
        TransH: Record "Transfer Header";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransL: Record "Transfer Line";
        TransLine: Record "Transfer Line";
        CloseTransfer: Boolean;
        ResteARecevoir: Decimal;
    begin

        if not Confirm(StrSubstNo(Text001, TransHeader."Receive-to Code")) then exit;

        if TransHeader."Receive-to Code" = '' then Error(Text003);

        AddOnsSetup.Get;
        AddOnsSetup.TestField(AddOnsSetup."Transit Location Transfer");
        AddOnsSetup.TestField(AddOnsSetup."Hypo Transfer Receipt Nos.");

        TransH.Init;
        //TransH.TRANSFERFIELDS(TransHeader);
        TransH."Posting Date" := WorkDate;
        TransH."Shipment Date" := WorkDate;

        TransH."No." := NoSeriesMgt.GetNextNo(AddOnsSetup."Hypo Transfer Receipt Nos.", Today, true);

        TransH.Insert;


        TransH.Validate("Transfer-from Code", AddOnsSetup."Transit Location Transfer");
        TransH.Validate("Transfer-to Code", TransHeader."Receive-to Code");
        TransH.Validate("In-Transit Code", TransHeader."In-Transit Code");

        TransH."Transfer Doc Type" := TransH."Transfer Doc Type"::"Hypothetical Receipt";
        TransH."Transfer Type" := TransH."Transfer Type"::Hypothetical;
        TransH."Dimension Set ID" := TransHeader."Dimension Set ID";
        TransH."Original Transfer No" := TransHeader."No.";
        TransH.Modify;

        CloseTransfer := true;

        TransLine.Reset;
        TransLine.SetRange(TransLine."Document No.", TransHeader."No.");
        if TransLine.FindSet then
            repeat
                TransL.Init;
                //TransL.TRANSFERFIELDS(TransLine);
                TransL."Document No." := TransH."No.";
                TransL."Line No." := TransLine."Line No.";
                TransL.Validate(TransL."Item No.", TransLine."Item No.");
                TransL.Validate(Quantity, TransLine."Qty to receive Hypo");
                TransL.Validate("Unit of Measure Code", TransLine."Unit of Measure Code");
                TransL.Validate("Qty to receive Adj", TransLine."Qty to receive Hypo Adj");
                TransL."Reason Code" := TransLine."Reason Code";
                TransL."Qty to receive Hypo Adj" := TransLine."Qty to receive Hypo Adj";

                if TransLine."Qty to receive Hypo" <> 0 then
                    TransL.Insert;

                ResteARecevoir := TransLine.Quantity - TransLine."Qty received Hypo";
                if TransLine."Qty to receive Hypo" > ResteARecevoir then
                    Error(Text002, TransL."Line No.", ResteARecevoir);

                TransLine."Qty received Hypo" += TransLine."Qty to receive Hypo";
                TransLine.Modify;


                if TransLine."Qty received Hypo" <> TransLine.Quantity then
                    CloseTransfer := false;

            until TransLine.Next = 0;

        TransferPostShipment.SetHideValidationDialog(true);
        TransferPostReceipt.SetHideValidationDialog(true);
        TransferPostShipment.Run(TransH);
        TransferPostReceipt.Run(TransH);

        if CloseTransfer then begin
            TransHeader.SetHideValidationDialog(true);
            TransHeader.AFK_SetAllowDeletionHypo(true);
            TransHeader.DeleteOneTransferOrder(TransHeader, TransLine);
        end;
    end;

    procedure PostAjustementReception(var TransLine3: Record "Transfer Line"; TransRcptHeader2: Record "Transfer Receipt Header"; var TransRcptLine2: Record "Transfer Receipt Line"; var ItemJnlPostLine2: Codeunit "Item Jnl.-Post Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ListeMotifs: Record "Transfer Reason Code";
    begin

        // AddOnSetup.GET;
        // AddOnSetup.TESTFIELD(AddOnSetup."Removal Journal code");
        // AddOnSetup.TESTFIELD(AddOnSetup."Shipment Location");

        if TransRcptHeader2."Transfer Doc Type" = TransRcptHeader2."Transfer Doc Type"::"Hypothetical Shipment" then
            exit;

        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup.Transfer;

        //IF TransRcptHeader2."Transfer Type"=TransRcptHeader2."Transfer Type"::Hypothetical THEN BEGIN

        /*
        IF TransRcptHeader2."Transfer Doc Type"=TransRcptHeader2."Transfer Doc Type"::"Hypothetical Receipt" THEN BEGIN
        
          IF TransLine3."Qty to receive Hypo Adj"=0 THEN ERROR(Text004,TransLine3."Line No.");
          AdjQty := TransLine3."Qty to receive Hypo Adj" - TransLine3."Qty. to Receive";
        
        END ELSE BEGIN
        
          IF TransLine3."Qty to receive Adj"=0 THEN ERROR(Text004,TransLine3."Line No.");
          AdjQty := TransLine3."Qty to receive Adj" - TransLine3."Qty. to Receive";
        
        END;
        */



        Item1.Get(TransLine3."Item No.");
        //TransLine3.TESTFIELD(TransLine3."Reason Code");


        ListeMotifs.Reset;
        ListeMotifs.SetRange(ListeMotifs."Document Type", ListeMotifs."Document Type"::Transfer);
        ListeMotifs.SetRange(ListeMotifs."Document No.", TransLine3."Document No.");
        ListeMotifs.SetRange(ListeMotifs."Line No.", TransLine3."Line No.");
        if ListeMotifs.FindSet then
            repeat

                AdjQty := ListeMotifs."Adjust Qty";
                if AdjQty = 0 then Error(Text005, ListeMotifs."Line No.");
                PositiveAdj := AdjQty > 0;

                //Dépot d'origine - Ajustement négatif
                ItemJnlLine.Init;
                ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::Transfer;
                ItemJnlLine."Posting Date" := TransRcptHeader2."Posting Date";
                ItemJnlLine."Document Date" := TransRcptHeader2."Posting Date";
                ItemJnlLine."Document No." := TransRcptHeader2."No.";
                ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
                ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
                ItemJnlLine."External Document No." := TransRcptHeader2."External Document No.";

                if PositiveAdj then
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
                else
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

                ItemJnlLine.Validate("Item No.", TransRcptLine2."Item No.");
                ItemJnlLine.Description := TransRcptLine2.Description;
                ItemJnlLine."Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
                ItemJnlLine."New Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
                ItemJnlLine."Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
                ItemJnlLine."New Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
                ItemJnlLine."Dimension Set ID" := TransRcptLine2."Dimension Set ID";
                ItemJnlLine."New Dimension Set ID" := TransRcptLine2."Dimension Set ID";
                ItemJnlLine.Validate("Location Code", TransRcptHeader2."Transfer-to Code");
                ItemJnlLine.Validate(Quantity, Abs(AdjQty));

                ItemJnlLine.Validate("Unit of Measure Code", TransRcptLine2."Unit of Measure Code");
                ItemJnlLine."Invoiced Quantity" := Abs(AdjQty);

                ItemJnlLine."Source Code" := SourceCode;
                ItemJnlLine."Reason Code" := ListeMotifs."Reason Code";
                ItemJnlLine.Area := TransRcptHeader2.Area;
                ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
                ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

                if AdjQty <> 0 then
                    ItemJnlPostLine2.RunWithCheck(ItemJnlLine);

            until ListeMotifs.Next = 0;

    end;

    procedure ArchiveTransfer(var TransH: Record "Transfer Header")
    var
        TransArchive: Record "Transfer Header Archive";
        TransArchiveLine: Record "Transfer Line Archive";
        TransLine: Record "Transfer Line";
        LineNo: Integer;
    begin

        if TransH."Transfer Doc Type" = TransH."Transfer Doc Type"::"Hypothetical Receipt" then exit;

        if TransArchive.Get(TransH."No.") then exit;

        TransArchive.Init;
        TransArchive.TransferFields(TransH);
        TransArchive.Insert;

        LineNo := 0;

        TransLine.Reset;
        TransLine.SetRange("Document No.", TransH."No.");
        if TransLine.FindSet then
            repeat
                LineNo := LineNo + 1000;
                TransArchiveLine.Init;
                TransArchiveLine.TransferFields(TransLine);
                TransArchiveLine."Document No." := TransLine."Document No.";
                TransArchiveLine."Line No." := LineNo;
                TransArchiveLine.Insert;
            until TransLine.Next = 0;
    end;

    procedure TransfertItemReclass(var ItemJnlPostLine2: Codeunit "Item Jnl.-Post Line"; DocNo: Code[20]; PostingDate: Date; ItemNo: Code[20]; MagasinOr: Code[20]; MagasinDest: Code[20]; Qty: Decimal; Unite: Code[10]; DimSetIdOr: Integer; DimSetIdDest: Integer; Descr: Text[50]; AdjustType: Integer; CargoRef: Code[20])
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        PositiveAdj: Boolean;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin

        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup."Item Journal";

        if Qty = 0 then exit;

        Item1.Get(ItemNo);



        //Transfert - AJUSTEMENT NEG - MAGASIN ORIGINE
        ItemJnlLine.Init;
        ItemJnlLine."Adjustment Type" := AdjustType;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine."External Document No." := DocNo;
        ItemJnlLine."Ref Cargo" := CargoRef;

        ItemJnlLine.Validate("Item No.", Item1."No.");
        ItemJnlLine.Description := Descr;

        ItemJnlLine."Dimension Set ID" := DimSetIdOr;
        ItemJnlLine.Validate("Location Code", MagasinOr);

        ItemJnlLine.Validate(Quantity, Abs(Qty));
        ItemJnlLine.Validate("Unit of Measure Code", Unite);
        ItemJnlLine."Invoiced Quantity" := Abs(Qty);

        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

        if DimSetIdOr = 0 then
            ItemJnlLine.AFK_SetDimensionsItem(Item1."No."); //JN120118********************

        ItemJnlPostLine2.RunWithCheck(ItemJnlLine);








        //Transfert - AJUSTEMENT POS - MAGASIN DESTINATION
        ItemJnlLine.Init;
        ItemJnlLine."Adjustment Type" := AdjustType;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine."External Document No." := DocNo;
        ItemJnlLine."Ref Cargo" := CargoRef;

        ItemJnlLine.Validate("Item No.", Item1."No.");
        ItemJnlLine.Description := Descr;

        ItemJnlLine."Dimension Set ID" := DimSetIdDest;
        ItemJnlLine.Validate("Location Code", MagasinDest);

        ItemJnlLine.Validate(Quantity, Abs(Qty));
        ItemJnlLine.Validate("Unit of Measure Code", Unite);
        ItemJnlLine."Invoiced Quantity" := Abs(Qty);

        ItemJnlLine."Source Code" := SourceCode;
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

        if DimSetIdDest = 0 then
            ItemJnlLine.AFK_SetDimensionsItem(Item1."No.");//JN120118********************

        ItemJnlPostLine2.RunWithCheck(ItemJnlLine);
    end;

    procedure CanPostExpedition(var ItemAdj: Record "Adjustment Header"): Boolean
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        LineExits: Boolean;
        ResteARemb: Decimal;
        ItemTransfer: Codeunit "Item Transfer Mgt";
    begin

        if ItemAdj."User ID" <> UserId then exit(false);

        if ItemAdj."Location Code" = '' then exit(false);
        if ItemAdj."In-Transit Code" = '' then exit(false);
        if ItemAdj."Posting Date" = 0D then exit(false);
        if ItemAdj.Status <> ItemAdj.Status::Open then exit(false);

        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type", AdjustLine."Document Type"::Transfer);
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet then
            repeat

                if not Item1.Get(AdjustLine."Item No.") then exit(false);
                if AdjustLine.Quantity = 0 then exit(false);

            until AdjustLine.Next = 0;

        exit(true);
    end;

    procedure CanPostReception(var ItemAdj: Record "Adjustment Header"): Boolean
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
        CloseDocument: Boolean;
        LineExistsToReturn: Boolean;
        CodeRemb: Code[20];
        LigneTransfer: Record "Adjustment Line";
        ItemTransfer: Codeunit "Item Transfer Mgt";
        AdjReason: Record "Transfer Reason Code";
    begin

        if ItemAdj."User ID" <> UserId then exit(false);
        if ItemAdj.Status <> ItemAdj.Status::Released then exit(false);
        if ItemAdj."Location Code" = ItemAdj."Transfer-to Code" then exit(false);

        if ItemAdj."Transfer-to Code" = '' then exit(false);
        if ItemAdj."In-Transit Code" = '' then exit(false);
        if ItemAdj."Receipt Date" = 0D then exit(false);

        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type", AdjustLine."Document Type"::Transfer);
        AdjustLine.SetRange("Document No.", ItemAdj."No.");
        if AdjustLine.FindSet then
            repeat

                if not Item1.Get(AdjustLine."Item No.") then exit(false);
                if AdjustLine.Quantity = 0 then exit(false);

                AdjReason.Reset;
                AdjReason.SetRange(AdjReason."Document Type", AdjReason."Document Type"::Transfer);
                AdjReason.SetRange(AdjReason."Document No.", ItemAdj."No.");
                AdjReason.SetRange(AdjReason."Line No.", AdjustLine."Line No.");
                if not AdjReason.FindFirst then exit(false);

            until AdjustLine.Next = 0;

        exit(true);
    end;

    procedure SetIsBatch(batch: Boolean)
    begin
        IsBatch := batch;
    end;

    procedure TransfertItemReclassTransfert(var ItemJnlPostLine2: Codeunit "Item Jnl.-Post Line"; DocNo: Code[20]; PostingDate: Date; ItemNo: Code[20]; MagasinOr: Code[20]; MagasinDest: Code[20]; Qty: Decimal; Unite: Code[10]; DimSetIdOr: Integer; DimSetIdDest: Integer; Descr: Text[50]; AdjustType: Integer; AdjustLine1: Record "Adjustment Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        PositiveAdj: Boolean;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin

        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup.Transfer;

        if Qty = 0 then exit;

        Item1.Get(ItemNo);

        //Transfert
        ItemJnlLine.Init;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine."External Document No." := DocNo;

        ItemJnlLine.Validate("Item No.", Item1."No.");
        ItemJnlLine.Description := Descr;

        //ItemJnlLine."Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
        //ItemJnlLine."Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := DimSetIdOr;
        ItemJnlLine.Validate("Location Code", MagasinOr);

        //ItemJnlLine."New Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
        //ItemJnlLine."New Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
        ItemJnlLine."New Dimension Set ID" := DimSetIdDest;
        ItemJnlLine.Validate("New Location Code", MagasinDest);
        ItemJnlLine."Adjustment Type" := AdjustType;

        ItemJnlLine.Validate(Quantity, Abs(Qty));
        ItemJnlLine.Validate("Unit of Measure Code", Unite);
        ItemJnlLine."Invoiced Quantity" := Abs(Qty);

        ItemJnlLine."LUB Expiration Date" := AdjustLine1."Expiration Date";
        ItemJnlLine."Batch Number" := AdjustLine1."Batch Number";

        ItemJnlLine."Source Code" := SourceCode;
        //ItemJnlLine."Reason Code" := TransLine3."Reason Code";
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
        ItemJnlLine.AFK_SetDimensionsItem(Item1."No.");

        ItemJnlPostLine2.RunWithCheck(ItemJnlLine);
    end;

    local procedure ReceptionExists(ItemAdj: Record "Adjustment Header"): Boolean
    var
        ReturnHeader: Record "Item Return Header";
    begin
        ReturnHeader.Reset;
        ReturnHeader.SetRange("Document Type", ReturnHeader."Document Type"::Transfer);
        ReturnHeader.SetRange("Original Doc No", ItemAdj."No.");
        exit(ReturnHeader.FindFirst);
    end;

    procedure TransfertItemReclassTransfertLUBS(var ItemJnlPostLine2: Codeunit "Item Jnl.-Post Line"; DocNo: Code[20]; PostingDate: Date; ItemNo: Code[20]; MagasinOr: Code[20]; MagasinDest: Code[20]; Qty: Decimal; Unite: Code[10]; DimSetIdOr: Integer; DimSetIdDest: Integer; Descr: Text[50]; AdjustType: Integer; AdjustLine: Record "Adjustment Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        RemovalLine: Record pro_detailBE;
        Item1: Record Item;
        PositiveAdj: Boolean;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin

        SourceCodeSetup.Get;
        SourceCode := SourceCodeSetup.Transfer;

        if Qty = 0 then exit;

        Item1.Get(ItemNo);

        //Transfert
        ItemJnlLine.Init;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Transfer;
        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Document Date" := PostingDate;
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine."External Document No." := DocNo;

        ItemJnlLine.Validate("Item No.", Item1."No.");
        ItemJnlLine.Description := Descr;

        //ItemJnlLine."Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
        //ItemJnlLine."Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
        ItemJnlLine."Dimension Set ID" := DimSetIdOr;
        ItemJnlLine.Validate("Location Code", MagasinOr);

        //ItemJnlLine."New Shortcut Dimension 1 Code" := TransRcptLine2."Shortcut Dimension 1 Code";
        //ItemJnlLine."New Shortcut Dimension 2 Code" := TransRcptLine2."Shortcut Dimension 2 Code";
        ItemJnlLine."New Dimension Set ID" := DimSetIdDest;
        ItemJnlLine.Validate("New Location Code", MagasinDest);
        ItemJnlLine."Adjustment Type" := AdjustType;

        ItemJnlLine.Validate(Quantity, Abs(Qty));
        ItemJnlLine.Validate("Unit of Measure Code", Unite);
        ItemJnlLine."Invoiced Quantity" := Abs(Qty);

        ItemJnlLine."LUB Expiration Date" := AdjustLine."Expiration Date";
        ItemJnlLine."Batch Number" := AdjustLine."Batch Number";

        ItemJnlLine."Source Code" := SourceCode;
        //ItemJnlLine."Reason Code" := TransLine3."Reason Code";
        ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";

        if DimSetIdOr = 0 then
            ItemJnlLine.AFK_SetDimensionsItem(Item1."No.");

        //ItemJnlLine.AFK_SetDimensionsItem(Item1."No.");

        ItemJnlPostLine2.RunWithCheck(ItemJnlLine);
    end;
}

