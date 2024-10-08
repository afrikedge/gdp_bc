codeunit 50006 "Item Exchange Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Les notes de débit et crédit seront créées pour les frais d''échange. Voulez-vous continuer ?';
        Text002: Label 'La facture de vente %1 a été créée\La facture d''achat %2 a été créée';
        Text003: Label 'Les quantités cédées doivent etre égales aux quantités reçues.';
        ItemAdjustMgt: Codeunit "Item Adjustment Mgt";
        Text004: Label 'Echange de produits %1';
        Text005: Label 'Voulez-vous valider l''échange de produits ?';
        Text006: Label 'Voulez-vous clôturer l''échange de produits ?';
        GenJrnTemplate: Code[20];
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJrnTableND: Record "Gen. Journal Batch";
        GenJrnBatch_ND: Code[20];
        GenJrnBatch_NC: Code[20];
        GenJrnTableNC: Record "Gen. Journal Batch";
        LineNo: Integer;
        Text007: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text009: Label 'The journal code is required';
        Text010: Label 'Les écritures de stock ont déjà été validées pour la cession.';
        Text011: Label 'Les écritures de stock ont déjà été validées pour la réception.';
        Text012: Label 'Voulez-vous valider la cession de produits ?';
        Text013: Label 'Voulez-vous valider la réception de produits ?';
        ItemTransfer: Codeunit "Item Transfer Mgt";
        CalcPrices: Codeunit "Provisions Pricing Mgt";

    procedure CreateExchangeInvoices(var ItemAdj: Record "Adjustment Header")
    var
        NumFactVente: Code[20];
        NumFactAchat: Code[20];
    begin
        if not Confirm(Text001) then exit;

        //NumFactAchat := AddNewPurchExchangeInvoice(ItemAdj);
        //NumFactVente := AddNewSalesExchangeInvoice(ItemAdj);

        CreateJournalEntries(ItemAdj);
        //MESSAGE(Text002,NumFactVente,NumFactAchat);
        Message(TxtTraitementTerminé);
    end;

    local procedure AddNewSalesExchangeInvoice(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        CreatedLine: Record "Adjustment Line";
        LineNum: Integer;
    begin
        
        
        SalesOrderHeader.Init;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Invoice;
        SalesOrderHeader."No." := '';
        
        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);
        
        SalesOrderHeader.Validate(SalesOrderHeader."Sell-to Customer No.",ItemAdj."Customer No.");
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;
        
        SalesOrderHeader."Created By Doc No." := ItemAdj."No.";
        SalesOrderHeader."Created By Doc Type" := SalesOrderHeader."Created By Doc Type"::Exchange;
        
        //IF "Order Date" = 0D THEN
        SalesOrderHeader.Validate("Posting Date" , ItemAdj."Posting Date");
        //ELSE
        //  SalesOrderHeader."Order Date" := ;
        //IF "Posting Date" <> 0D THEN
        //SalesOrderHeader."Posting Date" := 0D;
        SalesOrderHeader."Document Date" := WorkDate;
        //SalesOrderHeader."Shipment Date" := 0D;
        //SalesOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        //SalesOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        //SalesOrderHeader."Dimension Set ID" := "Dimension Set ID";
        
        //IF SalesOrderHeader."Posting Date" = 0D THEN
        //  SalesOrderHeader."Posting Date" := WORKDATE;
        
        /*
        IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN BEGIN
          SalesOrderHeader."Posting Date" := 0D;
          //SalesOrderHeader.MODIFY;
        END;
        */
        
        SalesOrderHeader.Modify;
        
        
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Sales Exchange Fees Acc");
        
        
        
        //Ligne
        LineNum:=0;
        CreatedLine.Reset;
        //CreatedLine.SETCURRENTKEY("Document No.","Customer No.","Card Number");
        CreatedLine.SetRange("Document No.",ItemAdj."No.");
        CreatedLine.SetRange(CreatedLine."Exchange Type",CreatedLine."Exchange Type"::Ship);
        if CreatedLine.FindSet then repeat
        
          //CreatedLine.TESTFIELD("Customer No.");
          //Revoir ce code
          //CreatedLine.TESTFIELD(CreatedLine.);
          //CreatedLine."Invoice No" := SalesOrderHeader."No.";
          //CreatedLine.MODIFY;
        
          SalesOrderLine.Init;
          SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Invoice;
          SalesOrderLine."Document No.":=SalesOrderHeader."No.";
          LineNum:=LineNum+10;
          SalesOrderLine."Line No.":=LineNum;
          SalesOrderLine.Insert(true);
        
          SalesOrderLine.Type:=SalesOrderLine.Type::"G/L Account";
          SalesOrderLine.Validate(SalesOrderLine."No.",AddOnSetup."Sales Exchange Fees Acc");
          SalesOrderLine.Validate(SalesOrderLine.Quantity,1);
          SalesOrderLine.Validate(SalesOrderLine."Unit Price",CreatedLine."Transfer Fees");
          //SalesOrderLine."Card Number" := CreatedLine."Card Number";
          SalesOrderLine.Modify;
        
        until CreatedLine.Next=0;
        
        
        //SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
        //SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
        //SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";
        
        exit(SalesOrderHeader."No.");

    end;

    local procedure AddNewPurchExchangeInvoice(var ItemAdj: Record "Adjustment Header"): Code[20]
    var
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        CreatedLine: Record "Adjustment Line";
        LineNum: Integer;
    begin
        
        PurchOrderHeader.Init;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Invoice;
        PurchOrderHeader."No." := '';
        
        PurchOrderLine.LockTable;
        PurchOrderHeader.Insert(true);
        
        PurchOrderHeader.Validate(PurchOrderHeader."Buy-from Vendor No.",ItemAdj."Vendor No.");
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;
        
        
        PurchOrderHeader."Created By Doc No." := ItemAdj."No.";
        PurchOrderHeader."Created By Doc Type" := PurchOrderHeader."Created By Doc Type"::Exchange;
        
        //IF "Order Date" = 0D THEN
        PurchOrderHeader.Validate("Posting Date" , ItemAdj."Posting Date");
        //ELSE
        //  SalesOrderHeader."Order Date" := ;
        //IF "Posting Date" <> 0D THEN
        //SalesOrderHeader."Posting Date" := 0D;
        PurchOrderHeader."Document Date" := WorkDate;
        //SalesOrderHeader."Shipment Date" := 0D;
        //SalesOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        //SalesOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        //SalesOrderHeader."Dimension Set ID" := "Dimension Set ID";
        
        //IF SalesOrderHeader."Posting Date" = 0D THEN
        //  SalesOrderHeader."Posting Date" := WORKDATE;
        
        /*
        IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN BEGIN
          SalesOrderHeader."Posting Date" := 0D;
          //SalesOrderHeader.MODIFY;
        END;
        */
        
        PurchOrderHeader.Modify;
        
        
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Purchase Exchange Fees Acc");
        
        
        
        //Ligne
        LineNum:=0;
        CreatedLine.Reset;
        //CreatedLine.SETCURRENTKEY("Document No.","Customer No.","Card Number");
        CreatedLine.SetRange("Document No.",ItemAdj."No.");
        CreatedLine.SetRange(CreatedLine."Exchange Type",CreatedLine."Exchange Type"::Receive);
        if CreatedLine.FindSet then repeat
        
          //CreatedLine.TESTFIELD("Customer No.");
          //Revoir ce code
        //   CreatedLine.TESTFIELD(Amount);
        //   CreatedLine."Invoice No" := SalesOrderHeader."No.";
        //   CreatedLine.MODIFY;
        
          PurchOrderLine.Init;
          PurchOrderLine."Document Type" := PurchOrderHeader."Document Type"::Invoice;
          PurchOrderLine."Document No.":=PurchOrderHeader."No.";
          LineNum:=LineNum+10;
          PurchOrderLine."Line No.":=LineNum;
          PurchOrderLine.Insert(true);
        
          PurchOrderLine.Type:=PurchOrderLine.Type::"G/L Account";
          PurchOrderLine.Validate("No.",AddOnSetup."Purchase Exchange Fees Acc");
          PurchOrderLine.Validate(Quantity,1);
          PurchOrderLine.Validate(PurchOrderLine."Direct Unit Cost",CreatedLine."Transfer Fees");
          //SalesOrderLine."Card Number" := CreatedLine."Card Number";
          PurchOrderLine.Modify;
        
        until CreatedLine.Next=0;
        
        
        exit(PurchOrderHeader."No.");
        
        //SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
        //SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
        //SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";

    end;

    procedure PostAjustementEchange(var ItemAdj: Record "Adjustment Header";Cession: Boolean)
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
    begin

         AddOnSetup.Get;
         AddOnSetup.TestField(AddOnSetup."Cargo Confreres");
        // AddOnSetup.TESTFIELD(AddOnSetup."Shipment Location");

        if Cession then
          if ItemAdj."Cession Validated" then Error(Text010);

        if not Cession then
          if ItemAdj."Reception Validated" then Error(Text011);

        if Cession then
          if not Confirm(Text012) then exit;

        if not Cession then
          if not Confirm(Text013) then exit;

        ControlQty:=0;
        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if Cession then
          AdjustLine.SetRange("Exchange Type",AdjustLine."Exchange Type"::Ship)
        else
          AdjustLine.SetRange("Exchange Type",AdjustLine."Exchange Type"::Receive);
        if AdjustLine.FindSet then repeat

          Item1.Get(AdjustLine."Item No.");

          //Dépot d'origine - Ajustement négatif
          ItemJnlLine.Init;
          ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::Exchange;
          if Cession then begin
            ItemAdj.TestField(ItemAdj."Cession Date");
            ItemJnlLine."Posting Date" := ItemAdj."Cession Date";
          end else begin
            ItemAdj.TestField(ItemAdj."Receipt Date");
            ItemJnlLine."Posting Date" := ItemAdj."Receipt Date";
          end;

          ItemJnlLine."Ref Cargo" := AddOnSetup."Cargo Confreres";


          ItemJnlLine."Document Date" := ItemAdj."Document Date";
          ItemJnlLine."Document No." := ItemAdj."No.";
          //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
          //ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
          //ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
          //ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
          //ItemJnlLine."Order Line No." := TransLine3."Line No.";
          ItemJnlLine."External Document No." := ItemAdj."External Document No.";

          if AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive then
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
          else
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

          if AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive then
            ControlQty := ControlQty + AdjustLine."Quantity (Base)"
          else
            ControlQty := ControlQty - AdjustLine."Quantity (Base)";


          ItemJnlLine.Validate("Item No." , AdjustLine."Item No.");
          ItemJnlLine.Description := StrSubstNo(Text004,ItemAdj."No.");
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

          ItemJnlPostLine.RunWithCheck(ItemJnlLine);

        until AdjustLine.Next=0;

        if Cession then begin
          ItemAdj."Cession Validated":=true;
          //ItemAdj."Cession Date":=TODAY;
        end else begin
          ItemAdj."Reception Validated":=true;
          //ItemAdj."Receipt Date" := TODAY;
        end;
        ItemAdj.Status:=ItemAdj.Status::Released;
        ItemAdj.Modify;



        //IF ControlQty<>0 THEN ERROR(Text003);
        Message(TxtTraitementTerminé);
    end;

    procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    begin

        if not Confirm(Text006) then exit;

        ItemAdjustMgt.ArchiveDoc(ItemAdj);
        ItemAdj.SetIsArchive(true);
        ItemAdj.Delete(true);
    end;

    local procedure CreateJournalEntries(var ItemAdj: Record "Adjustment Header")
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        AdjLine: Record "Adjustment Line";
        isNoteDebit: Boolean;
        LastDocNoCredit: Code[20];
        LastDocNoDebit: Code[20];
        isCustomer: Boolean;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Sales Exchange Fees Acc");
        AddOnSetup.TestField(AddOnSetup."Purchase Exchange Fees Acc");
        //AddOnSetup.TESTFIELD(AddOnSetup."Debit Notes Nos.");
        //AddOnSetup.TESTFIELD(AddOnSetup."Credit Notes Nos.");

        ItemAdj.TestField(ItemAdj."Sales by Cards Import Tmpl");
        //ItemAdj.TESTFIELD(ItemAdj."Credit Notes Import Jrnal");
        ItemAdj.TestField(ItemAdj."Debit Notes Import Jrnal");

        GenJrnTemplate := ItemAdj."Sales by Cards Import Tmpl";
        //GenJrnBatch_NC := ItemAdj."Credit Notes Import Jrnal";
        GenJrnBatch_ND := ItemAdj."Debit Notes Import Jrnal";

        GenJrnTableND.Get(GenJrnTemplate,GenJrnBatch_ND);
        //GenJrnTableNC.GET(GenJrnTemplate,GenJrnBatch_NC);

        //GenJrnLine.RESET;
        //GenJrnLine.SETRANGE("Journal Template Name",GenJrnTemplate);
        //GenJrnLine.SETRANGE("Journal Batch Name",GenJrnBatch_NC);
        //IF GenJrnLine.FINDFIRST THEN ERROR(Text007,GenJrnBatch_NC);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name",GenJrnBatch_ND);
        if GenJrnLine.FindFirst then Error(Text007,GenJrnBatch_ND);

        LineNo := 0;

        BesoinNo :=0;

        Window.Open(Text008);




        AdjLine.Reset();
        AdjLine.SetRange("Document No.",ItemAdj."No.");
        if AdjLine.FindSet then begin
          NbreTotalLignes:=AdjLine.Count;
            repeat

            BesoinNo := BesoinNo + 1;
            Window.Update(1,
            Round(BesoinNo / NbreTotalLignes * 10000,1));


            isNoteDebit := true;// (AdjLine."Exchange Type"=AdjLine."Exchange Type"::Ship);
            isCustomer :=  (AdjLine."Exchange Type"=AdjLine."Exchange Type"::Ship);

            Clear(GenJrnLine);

            GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);

            //IF isNoteDebit THEN
              GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch_ND);
            //ELSE
            //  GenJrnLine.SETRANGE("Journal Batch Name", GenJrnBatch_NC);

            if isCustomer then
              GenJrnLine.SetRange("Account No.",ItemAdj."Customer No.")
            else
              GenJrnLine.SetRange("Account No.",ItemAdj."Vendor No.");

            if isCustomer then
              GenJrnLine.SetFilter("Debit Amount",'>0',0)
            else
              GenJrnLine.SetFilter("Credit Amount",'>0',0);

            if GenJrnLine.FindFirst then begin

              if isCustomer then
                GenJrnLine.Validate("Debit Amount" ,GenJrnLine."Debit Amount" + AdjLine."Transfer Fees")
              else
                GenJrnLine.Validate("Credit Amount" ,GenJrnLine."Credit Amount" + AdjLine."Transfer Fees");
              GenJrnLine.Modify;

            end else begin

              AddNewJournalLineNDNC(AdjLine,ItemAdj,LastDocNoCredit,LastDocNoDebit);

           end;


          until AdjLine.Next=0
        end;




        Window.Close;
        //MESSAGE(TxtTraitementTerminé);
    end;

    local procedure AddNewJournalLineNDNC(ItemAdjLine: Record "Adjustment Line";ItemAdj: Record "Adjustment Header";var LastDocNoCredit: Code[20];var LastDocNoDebit: Code[20])
    var
        PostingDate: Date;
        GenJrnLine: Record "Gen. Journal Line";
        JrnTmplName: Record "Gen. Journal Template";
        LastAmountTotal: Decimal;
        GLAccNo: Code[20];
        BalGLAccountNo: Code[20];
        isNoteDebit: Boolean;
        isCustomer: Boolean;
    begin
        
        
        isCustomer :=  (ItemAdjLine."Exchange Type"=ItemAdjLine."Exchange Type"::Ship);
        isNoteDebit:=true;
        
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= GenJrnTemplate;
        if isNoteDebit then
          GenJrnLine."Journal Batch Name" := GenJrnBatch_ND
        else
          GenJrnLine."Journal Batch Name" := GenJrnBatch_NC;
        LineNo := LineNo + 10000;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        
        if isCustomer then
          GenJrnLine.Validate("Posting Date",ItemAdj."Cession Date")
        else
          GenJrnLine.Validate("Posting Date",ItemAdj."Receipt Date");
        
        GenJrnLine."Document No." := ItemAdj."No.";
        
        
        /*
        IF isNoteDebit THEN
          GenJrnTableND.TESTFIELD("No. Series")
        ELSE
          GenJrnTableNC.TESTFIELD("No. Series");
        
        
        //IF GenJrnTable."No. Series" <> '' THEN BEGIN
          //CLEAR(NoSeriesMgt);
        
        
            IF isNoteDebit THEN BEGIN
        
              IF LastDocNoDebit='' THEN BEGIN
                  GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",FALSE);
                  LastDocNoDebit := GenJrnLine."Document No.";
              END ELSE BEGIN
                  GenJrnLine."Document No." :=INCSTR(LastDocNoDebit);
                  LastDocNoDebit := GenJrnLine."Document No.";
              END;
        
            END ELSE BEGIN
        
              IF LastDocNoCredit='' THEN BEGIN
                  GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTableNC."No. Series",GenJrnLine."Posting Date",FALSE);
                  LastDocNoCredit := GenJrnLine."Document No.";
              END ELSE BEGIN
                  GenJrnLine."Document No." :=INCSTR(LastDocNoCredit);
                  LastDocNoCredit := GenJrnLine."Document No.";
              END;
        
            END;
              */
        
        if isCustomer then begin
          GenJrnLine."Document Type":=GenJrnLine."Document Type"::Invoice;
          GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;
        end else begin
          GenJrnLine."Document Type":=GenJrnLine."Document Type"::Invoice;
          GenJrnLine."Account Type" := GenJrnLine."Account Type"::Vendor;
        end;
        
        GenJrnLine."External Document No." := ItemAdj."No.";
        
        
        
        
        
        //Station service
        if isCustomer then
          GLAccNo := ItemAdj."Customer No."
        else
          GLAccNo := ItemAdj."Vendor No.";
        GenJrnLine.Validate("Account No.",GLAccNo);
        
        //GLAcc2.GET(GLAccNo);
        //GenJrnLine.VALIDATE("Shortcut Dimension 1 Code",GLAcc2."Global Dimension 1 Code");
        
        //Cust2.GET(AddOnSetup."Default Customer");
        //Vend2.CheckBlockedVendOnJnls(Vend2,"Document Type",FALSE);
        //GenJrnLine."MoneyTech Import No." := ItemAdj."No.";
        GenJrnLine.Description := CopyStr(StrSubstNo(Text004,ItemAdj."No."),1,49);
        //GenJrnLine.Description := COPYSTR("Import Data".Description,1,37)+' - '+COPYSTR("Import Data".InvoiceNo,1,10);
        
        //GenJrnLine."Posting Group" := Cust2."Customer Posting Group";
        //GenJrnLine."Salespers./Purch. Code" := Cust2."Salesperson Code";
        //"Payment Terms Code" := Vend2."Payment Terms Code";
        //GenJrnLine."Due Date" := "Monthly Invoice Data".DueDate;
        //GenJrnLine.VALIDATE("Bill-to/Pay-to No.","Monthly Invoice Data".CustomerNo);
        //GenJrnLine.VALIDATE("Sell-to/Buy-from No.","Monthly Invoice Data".CustomerNo);
        //GenJrnLine."Gen. Posting Type" := ;
        //GenJrnLine."Gen. Bus. Posting Group" := '';
        //GenJrnLine."Gen. Prod. Posting Group" := '';
        //GenJrnLine."VAT Bus. Posting Group" := '';
        //GenJrnLine."VAT Prod. Posting Group" := '';
        GenJrnLine.Validate("Currency Code",'');
        
        if isCustomer then
          BalGLAccountNo := AddOnSetup."Sales Exchange Fees Acc"
        else
          BalGLAccountNo := AddOnSetup."Purchase Exchange Fees Acc";
        GenJrnLine."Bal. Account Type" :=  GenJrnLine."Bal. Account Type"::"G/L Account";
        GenJrnLine.Validate("Bal. Account No.",BalGLAccountNo);
        
        if isCustomer then
            GenJrnLine.Validate(GenJrnLine.Amount, ItemAdjLine."Transfer Fees")
        else
            GenJrnLine.Validate(GenJrnLine.Amount, -ItemAdjLine."Transfer Fees");
        
        LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;
        
        //VAT
        
        
        if isCustomer then
          GenJrnLine."Bal. Gen. Posting Type":=GenJrnLine."Bal. Gen. Posting Type"::Sale
        else
          GenJrnLine."Bal. Gen. Posting Type":=GenJrnLine."Bal. Gen. Posting Type"::Purchase;
        /*
        AddOnSetup.TESTFIELD("No VAT Posting Group Code");
        //IF (AccountType1='GENERAL') THEN
        //  IF "Import Data".SeriesNo='' THEN
            IF ((BalGLAccountNo[1]='6') OR (BalGLAccountNo[1]='7')) THEN
              GenJrnLine.VALIDATE("VAT Bus. Posting Group",AddOnSetup."No VAT Posting Group Code");*/
        
        
        
        //GenJrnLine."Invoice No" := "Import Data".RefDoc2;
        //GenJrnLine."Applies-to Doc. Type" := GenJrnLine."Applies-to Doc. Type"::Invoice;
        //GenJrnLine."Applies-to Doc. No.":= "Import Data".RefDoc2;
        
        //IF GenJrnLine.Amount>0 THEN
        //GenJrnLine."Document Type":=GenJrnLine."Document Type"::Payment;
        
        if GenJrnLine.Amount<>0 then
          GenJrnLine.Insert(true);

    end;

    procedure PostAjustementEchangeOld(var ItemAdj: Record "Adjustment Header";Cession: Boolean)
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
    begin

        // AddOnSetup.GET;
        // AddOnSetup.TESTFIELD(AddOnSetup."Removal Journal code");
        // AddOnSetup.TESTFIELD(AddOnSetup."Shipment Location");

        if Cession then
          if ItemAdj."Cession Validated" then Error(Text010);

        if not Cession then
          if ItemAdj."Reception Validated" then Error(Text011);

        if Cession then
          if not Confirm(Text012) then exit;

        if not Cession then
          if not Confirm(Text013) then exit;

        ControlQty:=0;
        AdjustLine.Reset;
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if Cession then
          AdjustLine.SetRange("Exchange Type",AdjustLine."Exchange Type"::Ship)
        else
          AdjustLine.SetRange("Exchange Type",AdjustLine."Exchange Type"::Receive);
        if AdjustLine.FindSet then repeat

          Item1.Get(AdjustLine."Item No.");

          //Dépot d'origine - Ajustement négatif
          ItemJnlLine.Init;
          ItemJnlLine."Adjustment Type" := ItemJnlLine."Adjustment Type"::Exchange;
          if Cession then begin
            ItemAdj.TestField(ItemAdj."Cession Date");
            ItemJnlLine."Posting Date" := ItemAdj."Cession Date";
          end else begin
            ItemAdj.TestField(ItemAdj."Receipt Date");
            ItemJnlLine."Posting Date" := ItemAdj."Receipt Date";
          end;


          ItemJnlLine."Document Date" := ItemAdj."Document Date";
          ItemJnlLine."Document No." := ItemAdj."No.";
          //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Transfer Receipt";
          //ItemJnlLine."Document Line No." := TransRcptLine2."Line No.";
          //ItemJnlLine."Order Type" := ItemJnlLine."Order Type"::Transfer;
          //ItemJnlLine."Order No." := TransShptHeader2."Transfer Order No.";
          //ItemJnlLine."Order Line No." := TransLine3."Line No.";
          ItemJnlLine."External Document No." := ItemAdj."External Document No.";

          if AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive then
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."
          else
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

          if AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive then
            ControlQty := ControlQty + AdjustLine."Quantity (Base)"
          else
            ControlQty := ControlQty - AdjustLine."Quantity (Base)";


          ItemJnlLine.Validate("Item No." , AdjustLine."Item No.");
          ItemJnlLine.Description := StrSubstNo(Text004,ItemAdj."No.");
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

          ItemJnlPostLine.RunWithCheck(ItemJnlLine);

        until AdjustLine.Next=0;

        if Cession then begin
          ItemAdj."Cession Validated":=true;
          //ItemAdj."Cession Date":=TODAY;
        end else begin
          ItemAdj."Reception Validated":=true;
          //ItemAdj."Receipt Date" := TODAY;
        end;
        ItemAdj.Modify;



        //IF ControlQty<>0 THEN ERROR(Text003);
        Message(TxtTraitementTerminé);
    end;

    procedure CalculateExchangeFees(var ItemAdj: Record "Adjustment Header")
    var
        AdjustLine: Record "Adjustment Line";
    begin
        AdjustLine.Reset;
        AdjustLine.SetRange(AdjustLine."Document Type",AdjustLine."Document Type"::Exchange);
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat

          AdjustLine."Transfer Fees":=CalcPrices.GetProvisionsEchange(ItemAdj,AdjustLine,AdjustLine."USD Unit Price",
          AdjustLine."USD Rate",AdjustLine."USD Unit Price 2");
          if AdjustLine."Transfer Fees"=0 then begin
            AdjustLine."USD Unit Price":=0;
            AdjustLine."USD Unit Price 2":=0;
            AdjustLine."USD Rate":=0;
          end;

          AdjustLine.Modify;

        until AdjustLine.Next=0;
    end;

    procedure PostAjustementEchangeV2(var ItemAdj: Record "Adjustment Header";Cession: Boolean)
    var
        ItemJnlLine: Record "Item Journal Line";
        Item1: Record Item;
        PositiveAdj: Boolean;
        AdjQty: Decimal;
        SourceCode: Code[20];
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        AdjustLine: Record "Adjustment Line";
        ControlQty: Decimal;
    begin
        /*
        // AddOnSetup.GET;
        // AddOnSetup.TESTFIELD(AddOnSetup."Removal Journal code");
        // AddOnSetup.TESTFIELD(AddOnSetup."Shipment Location");
        
        AddOnSetup.GET;
        AddOnSetup.TESTFIELD(AddOnSetup."Partner Location");
        
        IF Cession THEN
          IF ItemAdj."Cession Validated" THEN ERROR(Text010);
        
        IF NOT Cession THEN
          IF ItemAdj."Reception Validated" THEN ERROR(Text011);
        
        IF Cession THEN
          IF NOT CONFIRM(Text012) THEN EXIT;
        
        IF NOT Cession THEN
          IF NOT CONFIRM(Text013) THEN EXIT;
        
        
        
        ControlQty:=0;
        AdjustLine.RESET;
        AdjustLine.SETRANGE(AdjustLine."Document Type",AdjustLine."Document Type"::Exchange);
        AdjustLine.SETRANGE("Document No.",ItemAdj."No.");
        IF AdjustLine.FINDSET THEN REPEAT
        
          IF AdjustLine."Exchange Type"=AdjustLine."Exchange Type"::Receive THEN
            ControlQty := ControlQty + AdjustLine."Quantity (Base)"
          ELSE
            ControlQty := ControlQty - AdjustLine."Quantity (Base)";
        
        UNTIL AdjustLine.NEXT=0;
        IF ControlQty<>0 THEN ERROR(Text003);
        
        
        
        
        
        AdjustLine.RESET;
        AdjustLine.SETRANGE(AdjustLine."Document Type",AdjustLine."Document Type"::Exchange);
        AdjustLine.SETRANGE("Document No.",ItemAdj."No.");
        IF Cession THEN
          AdjustLine.SETRANGE("Exchange Type",AdjustLine."Exchange Type"::Ship)
        ELSE
          AdjustLine.SETRANGE("Exchange Type",AdjustLine."Exchange Type"::Receive);
        IF AdjustLine.FINDSET THEN REPEAT
        
          Item1.GET(AdjustLine."Item No.");
        
          IF Cession THEN BEGIN
            ItemAdj.TESTFIELD(ItemAdj."Cession Date");
            ItemTransfer.TransfertItemReclass(ItemJnlPostLine,ItemAdj."No.",ItemAdj."Cession Date",AdjustLine."Item No.",
              AdjustLine."Location Code",AddOnSetup."Partner Location",ABS(AdjustLine.Quantity),AdjustLine."Unit of Measure Code",
              AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",STRSUBSTNO(Text004,ItemAdj."No."),ItemJnlLine."Adjustment Type"::Exchange);
        
          END ELSE BEGIN
            ItemAdj.TESTFIELD(ItemAdj."Receipt Date");
            ItemTransfer.TransfertItemReclass(ItemJnlPostLine,ItemAdj."No.",ItemAdj."Receipt Date",AdjustLine."Item No.",
              AddOnSetup."Partner Location",AdjustLine."Location Code",ABS(AdjustLine.Quantity),AdjustLine."Unit of Measure Code",
              AdjustLine."Dimension Set ID",AdjustLine."Dimension Set ID",STRSUBSTNO(Text004,ItemAdj."No."),ItemJnlLine."Adjustment Type"::Exchange);
          END;
        
        UNTIL AdjustLine.NEXT=0;
        
        
        
        
        
        IF Cession THEN BEGIN
          ItemAdj."Cession Validated":=TRUE;
        END ELSE BEGIN
          ItemAdj."Reception Validated":=TRUE;
        END;
        ItemAdj.Status := ItemAdj.Status::Released;
        ItemAdj.MODIFY;
        
        
        
        MESSAGE(TxtTraitementTerminé);
        */

    end;
}

