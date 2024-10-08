codeunit 50012 "Item Invoiced Conso Mgt"
{
    // 040917 Le Prix de vente provient de la matrice des prix et non du cout unitaire


    trigger OnRun()
    begin
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Souhaitez vous valider l''octroi du prêt ?';
        Text002: Label 'La facture de vente %1 a été créée\La facture d''achat %2 a été créée';
        Text003: Label 'Les quantités cédées doivent etre égales aux quantités reçues.';
        NosSeriesMgt: Codeunit NoSeriesManagement;
        Text004: Label 'Vous ne pouvez pas retourner une quantité supérieure à la quantité prêtée sur la ligne %1';
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text005: Label 'Voulez-vous valider la sortie de produits ?';
        Text006: Label 'Voulez-vous créer un nouveau remboursement ?';
        Text007: Label 'Traitement terminé avec succès';
        Text008: Label 'Aucune ligne à valider !';
        GenJnlLine: Record "Gen. Journal Line";
        Text009: Label 'Sortie à refacturer %1';
        GenPostingSetup: Record "General Posting Setup";
        Currency: Record Currency;
        SourceCodeSetup: Record "Source Code Setup";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text010: Label 'Voulez-vous générer une note de débit pour la sortie de produits ?';
        Text011: Label 'La note de débit %1 existe déjà pour cette sortie';
        Text012: Label 'Il n''ya pas d''article à refacturer sur le document de sortie';
        Text013: Label 'La note de débit %1 a été créée. \Vous devez valider cette note de débit à partir de la liste des factures vente afin d''archiver votre document';
        Text014: Label 'Mise à jour terminée';

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

        ItemAdj.TestField(ItemAdj."Customer No.");
        ItemAdj.TestField("Posting Date");
        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Open);


        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.Modify;


        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat

          Item1.Get(AdjustLine."Item No.");

          AdjustLine.TestField(AdjustLine."Location Code");
          AdjustLine.TestField(AdjustLine."Item No.");
          AdjustLine.TestField(AdjustLine.Quantity);
          //AdjustLine.TESTFIELD(AdjustLine."Customer No.");

          //Dépot d'origine - Ajustement négatif
          ItemJnlLine.Init;
          ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::"Invoiced Conso";
          ItemJnlLine."Posting Date" := ItemAdj."Posting Date";
          ItemJnlLine."Document Date" := ItemAdj."Posting Date";
          ItemJnlLine."Document No." := ItemAdj."No.";
          //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
          //ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
          //ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
          //ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
          //ItemJnlLine."Order Line No." := TransLine3."Line No.";
          ItemJnlLine."External Document No." := ItemAdj."External Document No.";

          //IF AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive THEN
          //  ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
          //ELSE
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

          LineExits := true;


          ItemJnlLine.Validate("Item No." , AdjustLine."Item No.");
          //ItemJnlLine.Description := ItemAdj."Posting Description";
          ItemJnlLine.Description := AdjustLine.Description;
          ItemJnlLine."Shortcut Dimension 1 Code" := AdjustLine."Shortcut Dimension 1 Code";
          ItemJnlLine."Shortcut Dimension 2 Code" := AdjustLine."Shortcut Dimension 2 Code";
          ItemJnlLine."Dimension Set ID" := AdjustLine."Dimension Set ID";
          ItemJnlLine.Validate("Location Code", AdjustLine."Location Code");
          ItemJnlLine.Validate(Quantity , Abs(AdjustLine.Quantity));

          ItemJnlLine.Validate("Unit of Measure Code" , AdjustLine."Unit of Measure Code");
          ItemJnlLine."Invoiced Quantity" := Abs(AdjustLine.Quantity);
          //ItemJnlLine."Quantity (Base)" := RemovalLine.volumea15;
          //ItemJnlLine."Invoiced Qty. (Base)" := RemovalLine.volumea15;
          ItemJnlLine."Source Code" := SourceCode;
          //ItemJnlLine."Gen. Prod. Posting Group" := TransShptLine2."Gen. Prod. Posting Group";
          //ItemJnlLine."Inventory Posting Group" := TransShptLine2."Inventory Posting Group";

          //ItemJnlLine."Qty. per Unit of Measure" := 1;//TransShptLine2."Qty. per Unit of Measure";
          //ItemJnlLine."Variant Code" := TransShptLine2."Variant Code";
          //ItemJnlLine."Bin Code" := TransLine."Transfer-from Bin Code";
          //ItemJnlLine."Country/Region Code" := TransShptHeader2."Trsf.-from Country/Region Code";
          //ItemJnlLine."Transaction Type" := TransRcptHeader2."Transaction Type";
          //ItemJnlLine."Transport Method" := TransRcptHeader2."Transport Method";
          //ItemJnlLine."Entry/Exit Point" := TransShptHeader2."Entry/Exit Point";
          //ItemJnlLine.Area := TransRcptHeader2.Area;
          //ItemJnlLine."Transaction Specification" := TransRcptHeader2."Transaction Specification";
          //ItemJnlLine."Product Group Code" := Item1."Product Group Code";
          //ItemJnlLine."Item Category Code" := Item1."Item Category Code";
          //ItemJnlLine."Applies-to Entry" := TransLine."Appl.-to Item Entry";
          ItemJnlLine."Gen. Prod. Posting Group" := Item1."Gen. Prod. Posting Group";
          //ReserveTransLine.TransferTransferToItemJnlLine(TransLine3,
          //  ItemJnlLine,ItemJnlLine."Quantity (Base)",0);

          AmountToInvoice  := Round(ItemJnlLine.Amount*AdjustLine."ToCharge %"/100,0.01);
          AdjustLine.AmountToBeInvoice := AmountToInvoice;
          AdjustLine.Modify;

          ItemJnlPostLine.RunWithCheck(ItemJnlLine);


        //IF AmountToInvoice>0 THEN
        //  CreateNDEntry(ItemAdj,AdjustLine,AmountToInvoice);




        until AdjustLine.Next=0;



        //ArchiveDoc(ItemAdj);

        if not LineExits then
          Error(Text008)
        else
          Message(Text007);
    end;

    procedure PostNoteDebit(var ItemAdj: Record "Adjustment Header")
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
        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Released);
        
        
        
        AddNewSalesInvoice_Sortie(ItemAdj);
        /*
        AdjustLine.RESET;
        AdjustLine.SETRANGE("Document No.",ItemAdj."No.");
        IF AdjustLine.FINDSET THEN REPEAT
          LineExits := TRUE;
          IF AdjustLine.AmountToBeInvoice>0 THEN
            CreateNDEntry(ItemAdj,AdjustLine,AdjustLine.AmountToBeInvoice);
        
        UNTIL AdjustLine.NEXT=0;
        
        
        
        ArchiveDoc(ItemAdj);
        
        
        IF NOT LineExits THEN
          ERROR(Text008)
        ELSE
          MESSAGE(Text007);
          */

    end;

    local procedure CreateNDEntry(var ItemAdj: Record "Adjustment Header";LineItemAdj: Record "Adjustment Line";Amt: Decimal)
    var
        BalAccNo: Code[20];
        Item1: Record Item;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Cust1: Record Customer;
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Debit Notes Nos.");

        SourceCodeSetup.Get;

        Item1.Get(LineItemAdj."Item No.");
        Cust1.Get(ItemAdj."Customer No.");

        Clear(GenJnlLine);
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Document Date" := ItemAdj."Posting Date";
        GenJnlLine.Validate("Posting Date" , ItemAdj."Posting Date");
        GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."Debit Notes Nos.",GenJnlLine."Posting Date",true);
        //GenJnlLine."Document No." := ItemAdj."No.";
        GenJnlLine."Account Type" :=  GenJnlLine."Account Type"::Customer;
        GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
        GenJnlLine.Validate(GenJnlLine."Account No.",ItemAdj."Customer No.");
        GenJnlLine.Description := StrSubstNo(Text009,ItemAdj."No.");
        GenJnlLine.Validate(GenJnlLine.Amount,Amt);
        GenJnlLine."Shortcut Dimension 1 Code" := LineItemAdj."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := LineItemAdj."Shortcut Dimension 2 Code";
        GenJnlLine."Dimension Set ID" := LineItemAdj."Dimension Set ID";
        GenJnlLine."External Document No." := ItemAdj."No.";
        GenJnlLine."Source Code" := SourceCodeSetup.Sales;
        GenJnlLine.SetHideValidation(true);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine.Validate("Payment Terms Code",Cust1."Payment Terms Code");

        BalAccNo := getSalesAcc(Item1,Cust1);
        GenJnlLine.Validate("Bal. Account No.",BalAccNo);
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Sale;
        //GenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");


        //ItemJnlPostLine.AFK_GetGenJnlPostLine(GenJnlPostLine);
        GenJnlPostLine.RunWithCheck(GenJnlLine);

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
        GenPostingSetup.Get('',Item."Gen. Prod. Posting Group");
        GenPostingSetup.TestField("COGS Account");
        exit(GenPostingSetup."COGS Account");
    end;

    local procedure getSalesAcc(Item: Record Item;Cust: Record Customer): Code[20]
    begin
        GenPostingSetup.Get(Cust."Gen. Bus. Posting Group",Item."Gen. Prod. Posting Group");
        GenPostingSetup.TestField(GenPostingSetup."Sales Account");
        exit(GenPostingSetup."Sales Account");
    end;

    procedure AddNewSalesInvoice_Sortie(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        CreatedLine: Record "Adjustment Line";
        LineNum: Integer;
        LineExistsToReturn: Boolean;
        AdjustLine: Record "Adjustment Line";
        Item1: Record Item;
    begin

        if not Confirm(Text010) then exit;



        //CheckExistingInvoice
        SalesOrderHeader.Reset;
        SalesOrderHeader.SetRange(SalesOrderHeader."Document Type",SalesOrderHeader."Document Type"::Invoice);
        SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc Type",SalesOrderHeader."Created By Doc Type"::SortieARefacturer);
        SalesOrderHeader.SetRange(SalesOrderHeader."Created By Doc No.",ItemAdj."No.");
        if SalesOrderHeader.FindFirst then
          Error(Text011,SalesOrderHeader."No.");

        ItemAdj.TestField(ItemAdj.Status,ItemAdj.Status::Released);
        ItemAdj.TestField("Customer No.");
        ItemAdj.TestField(ItemAdj."Posting Date");



        LineExistsToReturn:=false;
        AdjustLine.Reset;
        AdjustLine.SetRange("Document Type",ItemAdj."Document Type");
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat

          if AdjustLine."ToCharge %" <>0 then LineExistsToReturn:=true;
        until AdjustLine.Next=0;

        if not LineExistsToReturn then
          Error(Text012);





        SalesOrderHeader.Init;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Invoice;
        SalesOrderHeader."No." := '';

        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        SalesOrderHeader.Validate(SalesOrderHeader."Sell-to Customer No.",ItemAdj."Customer No.");
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;

        SalesOrderHeader."Created By Doc No." := ItemAdj."No.";
        SalesOrderHeader."Created By Doc Type" := SalesOrderHeader."Created By Doc Type"::SortieARefacturer;


        SalesOrderHeader.Validate("Posting Date" , ItemAdj."Posting Date");
        SalesOrderHeader."Document Date" := WorkDate;
        //SalesOrderHeader."Shipment Date" := 0D;
        SalesOrderHeader."Shortcut Dimension 1 Code" := ItemAdj."Shortcut Dimension 1 Code";
        SalesOrderHeader."Shortcut Dimension 2 Code" := ItemAdj."Shortcut Dimension 2 Code";
        SalesOrderHeader."Dimension Set ID" := ItemAdj."Dimension Set ID";

        SalesOrderHeader.Modify;



        //AddOnSetup.GET;
        //AddOnSetup.TESTFIELD(AddOnSetup."Consignation Location");



        //Ligne
        LineNum:=0;
        CreatedLine.Reset;
        CreatedLine.SetRange("Document Type",CreatedLine."Document Type"::"Invoiced Consumption");
        CreatedLine.SetRange("Document No.",ItemAdj."No.");
        if CreatedLine.FindSet then repeat

          if CreatedLine."ToCharge %"<>0 then begin

            Item1.Get(CreatedLine."Item No.");
            Item1.TestField(Item1."ToCharge Item");

            SalesOrderLine.Init;
            SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Invoice;
            SalesOrderLine."Document No." := SalesOrderHeader."No.";
            LineNum := LineNum + 10;
            SalesOrderLine."Line No." := LineNum;
            SalesOrderLine.Insert(true);

            SalesOrderLine.Type := SalesOrderLine.Type::Item;

            SalesOrderLine.Validate(SalesOrderLine."No.",Item1."ToCharge Item");
            //SalesOrderLine.Description := CreatedLine.Description;
            //SalesOrderLine.VALIDATE(SalesOrderLine."Location Code",AddOnSetup."Consignation Location");
            SalesOrderLine.Validate(SalesOrderLine.Quantity,CreatedLine.Quantity);
            //SalesOrderLine.VALIDATE(SalesOrderLine."Unit Price",CreatedLine.AmountToBeInvoice);//040917
            SalesOrderLine.Validate(SalesOrderLine."Unit Price",GetUnitPrice(ItemAdj."Customer No.",Item1."No."));//The Up calculated auto


            //SalesOrderLine."Card Number" := CreatedLine."Card Number";
            SalesOrderLine."Shortcut Dimension 1 Code" := CreatedLine."Shortcut Dimension 1 Code";
            SalesOrderLine."Shortcut Dimension 2 Code" := CreatedLine."Shortcut Dimension 2 Code";
            SalesOrderLine."Dimension Set ID" := CreatedLine."Dimension Set ID";
            //SalesOrderLine."Consignation Line No." := CreatedLine."Line No.";
            SalesOrderLine.Modify;

          end;
        until CreatedLine.Next=0;



        Message(Text013,SalesOrderHeader."No.");
        exit(SalesOrderHeader."No.");
    end;

    procedure ConfirmSortieSalesInv(var SalesHeader: Record "Sales Invoice Header")
    var
        ReturnHeader: Record "Item Return Header";
        ReturnLine: Record "Item Return Line";
        AdjLine: Record "Adjustment Line";
        ItemAdj: Record "Adjustment Header";
        SalesLine: Record "Sales Invoice Line";
    begin

        if SalesHeader."Created By Doc Type"<>SalesHeader."Created By Doc Type"::SortieARefacturer then exit;

        if ItemAdj.Get(ItemAdj."Document Type"::"Invoiced Consumption",SalesHeader."Created By Doc No.") then
          begin
            ItemAdj."Posted Doc No" := SalesHeader."No.";
            ItemAdj.Modify;
            ArchiveDoc(ItemAdj);
          end;
    end;

    procedure GetUnitPrice(CustNo: Code[20];ItemNo: Code[20]): Decimal
    var
        SalesL: Record "Sales Line";
        SalesH: Record "Sales Header";
        PriceMgt: Codeunit "Sales Price Calc. Mgt.";
        Item2: Record Item;
        Cust2: Record Customer;
    begin
        Cust2.Get(CustNo);
        Item2.Get(ItemNo);

        SalesH.Init;
        SalesH."Document Type" := SalesH."Document Type"::Order;
        SalesH.Validate(SalesH."Bill-to Customer No.",CustNo);
        SalesH.Validate(SalesH."Posting Date",WorkDate);
        SalesH."No." := 'TEST';
        //SalesH.InitInsert;

        SalesL.Init;
        SalesL."Document Type":=SalesL."Document Type"::Order;
        SalesL."Document No.":=SalesH."No.";
        SalesL.Type := SalesL.Type::Item;
        SalesL."Bill-to Customer No." := CustNo;
        SalesL."Customer Price Group" := Cust2."Customer Price Group";
        SalesL."Unit of Measure Code":=Item2."Base Unit of Measure";
        //SalesL."Unit of Measure Code"
        SalesL."No.":=ItemNo;
        SalesL.Quantity:=1;
        PriceMgt.FindSalesLinePrice(SalesH,SalesL,0);
        //MESSAGE('%1',SalesL."Unit Price");
        exit(SalesL."Unit Price");
    end;

    procedure RefreshOutputPercentage(ItemAdj: Record "Adjustment Header")
    var
        AdjustLine: Record "Adjustment Line";
        Item1: Record Item;
    begin
        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
            Item1.Get(AdjustLine."Item No.");
            AdjustLine."ToCharge %" := Item1."ToCharge %";
            AdjustLine.Modify;
          until AdjustLine.Next=0;
        Message(Text014);
    end;
}

