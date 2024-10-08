codeunit 50003 "Conso by Cards Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text002: Label 'This account %1 does not exists !';
        Text003: Label 'The journal template model is required';
        Text004: Label 'The journal code is required';
        GenJrnTemplate: Code[20];
        Cust2: Record Customer;
        AddOnSetup: Record "AddOn Setup";
        GLAcc2: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        Vend2: Record Vendor;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text005: Label 'Les écritures non validées seront supprimées de la feuille %1.\Voulez vous continuer ?';
        Text006: Label 'Traitement terminé.\%1 facture(s) créée(s)';
        Text007: Label 'Il n''ya rien à facturer';
        HavePostMoneyTechTrans: Boolean;
        GenJrnTableND: Record "Gen. Journal Batch";
        GenJrnBatch_ND: Code[20];
        GenJrnBatch_NC: Code[20];
        GenJrnTableNC: Record "Gen. Journal Batch";
        LineNo: Integer;
        Text009: Label 'Trans cartes : ';
        ListeJournaux: array [10] of Code[20];
        TailleJournaux: Integer;
        Text010: Label 'Import des transactions cartes %1';
        Text011: Label 'Le document d''import %1 existe déjà pour cette date et tranche horaire';

    procedure ImportFromDB()
    begin
    end;

    procedure CreateJournalEntries_2(var SalesByCardImport: Record "MoneyTech Import")
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNoCredit: Code[20];
        LastDocNoDebit: Code[20];
        StrCodeJrnal: Code[20];
        OldCodeStation: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Postpaid Cards Account");
        AddOnSetup.TestField(AddOnSetup."Prepaid Cards Account");
        //AddOnSetup.TESTFIELD(AddOnSetup."Debit Notes Nos.");
        //AddOnSetup.TESTFIELD(AddOnSetup."Credit Notes Nos.");

        SalesByCardImport.TestField(SalesByCardImport."Sales by Cards Import Tmpl");
        SalesByCardImport.TestField(SalesByCardImport."Credit Notes Import Jrnal");
        SalesByCardImport.TestField(SalesByCardImport."Debit Notes Import Jrnal");

        GenJrnTemplate := SalesByCardImport."Sales by Cards Import Tmpl";
        GenJrnBatch_NC := SalesByCardImport."Credit Notes Import Jrnal";
        GenJrnBatch_ND := SalesByCardImport."Debit Notes Import Jrnal";

        GenJrnTableND.Get(GenJrnTemplate,GenJrnBatch_ND);
        GenJrnTableNC.Get(GenJrnTemplate,GenJrnBatch_NC);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name",GenJrnBatch_NC);
        if GenJrnLine.FindFirst then Error(Text001,GenJrnBatch_NC);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name",GenJrnBatch_ND);
        if GenJrnLine.FindFirst then Error(Text001,GenJrnBatch_ND);

        LineNo := 0;

        BesoinNo :=0;

        Window.Open(Text008);

        SalesByCardLine.Reset();
        SalesByCardLine.SetCurrentKey("Document No.","Station Code");
        SalesByCardLine.SetRange(SalesByCardLine."Document No.",SalesByCardImport."No.");
        if SalesByCardLine.FindSet then begin
          NbreTotalLignes:=SalesByCardLine.Count;
            repeat

            BesoinNo := BesoinNo + 1;
            Window.Update(1,
            Round(BesoinNo / NbreTotalLignes * 10000,1));

            //isNoteDebit :=  (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Recharge);

            if OldCodeStation<>SalesByCardLine."Station Code" then begin
              GenerateEcrituresNDNCClient(SalesByCardImport,OldCodeStation,true,LastDocNoCredit,LastDocNoDebit);
              GenerateEcrituresNDNCClient(SalesByCardImport,OldCodeStation,false,LastDocNoCredit,LastDocNoDebit);
            end;

            OldCodeStation := SalesByCardLine."Station Code";

          until SalesByCardLine.Next=0
        end;




        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    procedure CreateJournalEntries(var SalesByCardImport: Record "MoneyTech Import")
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNoCredit: Code[20];
        LastDocNoDebit: Code[20];
        StrCodeJrnal: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Postpaid Cards Account");
        AddOnSetup.TestField(AddOnSetup."Prepaid Cards Account");
        //AddOnSetup.TESTFIELD(AddOnSetup."Debit Notes Nos.");
        //AddOnSetup.TESTFIELD(AddOnSetup."Credit Notes Nos.");

        SalesByCardImport.TestField(SalesByCardImport."Sales by Cards Import Tmpl");
        SalesByCardImport.TestField(SalesByCardImport."Credit Notes Import Jrnal");
        SalesByCardImport.TestField(SalesByCardImport."Debit Notes Import Jrnal");

        GenJrnTemplate := SalesByCardImport."Sales by Cards Import Tmpl";
        GenJrnBatch_NC := SalesByCardImport."Credit Notes Import Jrnal";
        GenJrnBatch_ND := SalesByCardImport."Debit Notes Import Jrnal";

        GenJrnTableND.Get(GenJrnTemplate,GenJrnBatch_ND);
        GenJrnTableNC.Get(GenJrnTemplate,GenJrnBatch_NC);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name",GenJrnBatch_NC);
        if GenJrnLine.FindFirst then Error(Text001,GenJrnBatch_NC);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name",GenJrnBatch_ND);
        if GenJrnLine.FindFirst then Error(Text001,GenJrnBatch_ND);

        LineNo := 0;

        BesoinNo :=0;

        Window.Open(Text008);




        SalesByCardLine.Reset();
        SalesByCardLine.SetRange(SalesByCardLine."Document No.",SalesByCardImport."No.");
        if SalesByCardLine.FindSet then begin
          NbreTotalLignes:=SalesByCardLine.Count;
            repeat

            BesoinNo := BesoinNo + 1;
            Window.Update(1,
            Round(BesoinNo / NbreTotalLignes * 10000,1));

            isNoteDebit :=  (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Recharge);

            Clear(GenJrnLine);

            GenJrnLine.SetRange("Journal Template Name",GenJrnTemplate);

            if isNoteDebit then
              GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch_ND)
            else
              GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch_NC);

            GenJrnLine.SetRange("Account No.",SalesByCardLine."Station Code");

            if isNoteDebit then
              GenJrnLine.SetFilter("Debit Amount",'>0',0)
            else
              GenJrnLine.SetFilter("Credit Amount",'>0',0);

            if GenJrnLine.FindFirst then begin

              if isNoteDebit then
                GenJrnLine.Validate("Debit Amount" , GenJrnLine."Debit Amount" + SalesByCardLine.Amount)
              else
                GenJrnLine.Validate("Credit Amount" , GenJrnLine."Credit Amount" + SalesByCardLine.Amount);

              //StrCodeJrnal := RemoveZeros(SalesByCardLine.TransmissionNo);
              //IF ((AddNewCodeJournal(StrCodeJrnal)) AND (STRLEN(GenJrnLine.Description + ' ' + StrCodeJrnal)<50)) THEN
              //  GenJrnLine.Description := GenJrnLine.Description + ' ' + StrCodeJrnal;


              GenJrnLine.Modify;

            end else begin

              AddNewJournalLineNDNC(SalesByCardLine,SalesByCardImport,LastDocNoCredit,LastDocNoDebit);

            end;


          until SalesByCardLine.Next=0
        end;




        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    procedure PostMoneyTechTrans(CodeImport: Code[20])
    var
        PostedMoneyTechTrans: Record "Posted Moneytech Import";
        PostedMoneyTechLine: Record "Posted Moneytech Import Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        SalesByCardImport: Record "MoneyTech Import";
    begin

        if HavePostMoneyTechTrans then exit;

        if not SalesByCardImport.Get(CodeImport) then exit;

        HavePostMoneyTechTrans:=true;


        if SalesByCardImport."Credit Notes Import Jrnal"<>SalesByCardImport."Debit Notes Import Jrnal" then begin

          if not SalesByCardImport."First Journal Validated" then begin
              SalesByCardImport."First Journal Validated":=true;
              SalesByCardImport.Modify;

              exit;
          end;
        end;


        //SalesByCardImport.SetDoNotDeleteJournalEntries(TRUE);
        SalesByCardImport.CalcFields(SalesByCardImport."Total Charge",SalesByCardImport."Total Decharge");

        //Transferer le document
        PostedMoneyTechLine.LockTable();
        PostedMoneyTechTrans.Init();
        PostedMoneyTechTrans.TransferFields(SalesByCardImport);
        PostedMoneyTechTrans.Status := PostedMoneyTechTrans.Status::Validated;
        PostedMoneyTechTrans.Insert;


        SalesByCardLine.Reset();
        SalesByCardLine.SetRange(SalesByCardLine."Document No.",SalesByCardImport."No.");
        if SalesByCardLine.FindSet then repeat

            PostedMoneyTechLine.Init();
            PostedMoneyTechLine.TransferFields(SalesByCardLine);
            PostedMoneyTechLine.Insert;

         until SalesByCardLine.Next=0;


        SalesByCardImport.SetDoNotDeleteJournalEntries(true);
        SalesByCardImport.Delete(true);
    end;

    procedure DeleteAllEntries(SalesByCardImport: Record "MoneyTech Import")
    var
        ImportEntry: Record "Gen. Journal Line";
    begin
        if not Confirm(StrSubstNo( Text005,SalesByCardImport."Credit Notes Import Jrnal")) then exit;
        ImportEntry.Reset;
        ImportEntry.SetRange("MoneyTech Import No.",SalesByCardImport."No.");
        ImportEntry.DeleteAll;

        //SalesByCardImport.CALCFIELDS(SalesByCardImport."Total Charge",SalesByCardImport."Total Decharge");

        Message(TxtTraitementTerminé);
    end;

    procedure InsertNewTransactionLine(DocumentNo: Code[20];CodeStation: Code[20];PrePaid: Code[10];CodeClient: Code[20];var LineNum: Integer;Montant: Decimal;CodeOperation: Code[10];DateOp: Date;CardNumber: Code[10];TransNo: Code[20];TransDate: Text[30])
    var
        MoneyTechImportLine: Record "MoneyTech Import Line";
    begin

        //Inserer par carte

          if ((PrePaid<>'1') and (PrePaid<>'0')) then
            exit;
          if CodeOperation='DT' then
            if CodeClient = '' then
              exit;
          if CodeStation ='' then
            exit;

          if CodeOperation='DT' then
            if not Cust2.Get(CodeClient) then exit;
          if not Cust2.Get(CodeStation) then exit;

        MoneyTechImportLine.Reset;
        MoneyTechImportLine.SetCurrentKey("Document No.",TransmissionNo,"Transaction Type","Debitor No.","Station Code","Card Type","Card Number");
        MoneyTechImportLine.SetRange("Document No.",DocumentNo);
        MoneyTechImportLine.SetRange(TransmissionNo,TransNo);
        if CodeOperation='CT' then
          MoneyTechImportLine.SetRange("Transaction Type",MoneyTechImportLine."Transaction Type"::Recharge)
        else
          MoneyTechImportLine.SetRange("Transaction Type",MoneyTechImportLine."Transaction Type"::Decharge);
        //MoneyTechImportLine.SETRANGE("Debitor Type",MoneyTechImportLine."Debitor Type"::"1");
        MoneyTechImportLine.SetRange("Debitor No.",CodeClient);
        MoneyTechImportLine.SetRange("Station Code",CodeStation);
        if PrePaid='0' then
          MoneyTechImportLine.SetRange("Card Type",MoneyTechImportLine."Card Type"::Postpaid);
        if PrePaid='1' then
          MoneyTechImportLine.SetRange("Card Type",MoneyTechImportLine."Card Type"::Prepaid);

        MoneyTechImportLine.SetRange(MoneyTechImportLine."Card Number",CardNumber);

        if MoneyTechImportLine.FindFirst then begin

          MoneyTechImportLine.Amount := MoneyTechImportLine.Amount + Montant;
          MoneyTechImportLine.Modify;

        end else begin

          MoneyTechImportLine.Init;
          if PrePaid='0' then
            MoneyTechImportLine."Card Type" := MoneyTechImportLine."Card Type"::Postpaid;
          if PrePaid='1' then
            MoneyTechImportLine."Card Type" := MoneyTechImportLine."Card Type"::Prepaid;

          MoneyTechImportLine.TransmissionNo := TransNo;
          MoneyTechImportLine.TransmissionDate := TransDate;
          //MoneyTechImportLine."Starting Date" := DateOp;
          //IF  LineNum =10 THEN MESSAGE('Carte %1',CardNumber);
          MoneyTechImportLine."Card Number" := CardNumber;
          //MoneyTechImportLine."Debitor Type":= MoneyTechImportLine."Debitor Type"::"1";
          MoneyTechImportLine."Debitor No." := CodeClient;
          MoneyTechImportLine."Document No." := DocumentNo;
          LineNum:=LineNum+10;
          MoneyTechImportLine."Line No." := LineNum;
          MoneyTechImportLine."Station Code" := CodeStation;
          MoneyTechImportLine.Amount := Montant;
          if CodeOperation='CT' then
            MoneyTechImportLine."Transaction Type" := MoneyTechImportLine."Transaction Type"::Recharge;
          if CodeOperation='DT' then
            MoneyTechImportLine."Transaction Type" := MoneyTechImportLine."Transaction Type"::Decharge;

          MoneyTechImportLine.Insert;

        end;
    end;

    procedure ProcessBilling(var MoneyTechBilling: Record "MoneyTech Billing")
    var
        MoneyTechBillingLine: Record "MoneyTech Billing Line";
        ImportedLine: Record "Posted Moneytech Import Line";
        LineNum: Integer;
    begin

        MoneyTechBilling.TestField(MoneyTechBilling."Starting Date");
        MoneyTechBilling.TestField(MoneyTechBilling."Ending Date");
        MoneyTechBilling.TestField(MoneyTechBilling."Posting Date");

        LineNum:=0;

        ImportedLine.Reset;
        ImportedLine.SetCurrentKey("Card Type","Transaction Type","Starting Date");
        ImportedLine.SetRange(ImportedLine."Card Type",ImportedLine."Card Type"::Postpaid);
        ImportedLine.SetRange(ImportedLine."Transaction Type",ImportedLine."Transaction Type"::Decharge);
        ImportedLine.SetRange(ImportedLine."Starting Date",MoneyTechBilling."Starting Date",MoneyTechBilling."Ending Date");
        if ImportedLine.FindSet then
        repeat
          MoneyTechBillingLine.Reset;
          MoneyTechBillingLine.SetCurrentKey("Document No.","Customer No.","Card Number");
          MoneyTechBillingLine.SetRange(MoneyTechBillingLine."Document No.",MoneyTechBilling."No.");
          MoneyTechBillingLine.SetRange(MoneyTechBillingLine."Customer No.",ImportedLine."Debitor No.");
          MoneyTechBillingLine.SetRange(MoneyTechBillingLine."Card Number",ImportedLine."Card Number");
          if MoneyTechBillingLine.FindFirst then begin

            MoneyTechBillingLine.Amount := MoneyTechBillingLine.Amount + ImportedLine.Amount;
            MoneyTechBillingLine.Modify;

          end else begin
            MoneyTechBillingLine.Init;
            MoneyTechBillingLine."Document No." := MoneyTechBilling."No.";
            MoneyTechBillingLine.Amount:=ImportedLine.Amount;
            MoneyTechBillingLine."Customer No." := ImportedLine."Debitor No.";
            //MESSAGE('%1',ImportedLine."Card Number");
            MoneyTechBillingLine."Card Number" := ImportedLine."Card Number";
            LineNum := LineNum+1;
            MoneyTechBillingLine."Line No." := LineNum;
            MoneyTechBillingLine.Insert;
          end;

        until ImportedLine.Next=0;

        Message(TxtTraitementTerminé);
    end;

    procedure CreateCardsInvoices(var MoneyTechBilling: Record "MoneyTech Billing")
    var
        MoneyTechBillingLine: Record "MoneyTech Billing Line";
        ImportedLine: Record "Posted Moneytech Import Line";
        LineNum: Integer;
        NbreLignes: Integer;
        CurrentCustomer: Code[20];
    begin

        MoneyTechBillingLine.Reset;
        MoneyTechBillingLine.SetCurrentKey("Document No.","Customer No.","Card Number");
        MoneyTechBillingLine.SetRange("Document No.",MoneyTechBilling."No.");
        if MoneyTechBillingLine.FindSet then
        //CurrentCustomer := MoneyTechBillingLine."Customer No.";
        repeat

          if CurrentCustomer<>MoneyTechBillingLine."Customer No." then begin
            AddNewCardInvoice(MoneyTechBilling,MoneyTechBillingLine."Customer No.");
            NbreLignes := NbreLignes + 1;
            CurrentCustomer := MoneyTechBillingLine."Customer No.";
          end;

        until MoneyTechBillingLine.Next=0;

        if NbreLignes=0 then Error(Text007);

        PostBillingHeader(MoneyTechBilling);

        Message(Text006,NbreLignes);
    end;

    local procedure AddNewCardInvoice(BillingHeader: Record "MoneyTech Billing";CustNo: Code[20])
    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        CreatedLine: Record "MoneyTech Billing Line";
        LineNum: Integer;
    begin
        
        
        
        SalesOrderHeader.Init;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Invoice;
        SalesOrderHeader."No." := '';
        
        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);
        
        SalesOrderHeader.Validate(SalesOrderHeader."Sell-to Customer No.",CustNo);
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;
        
        
        
        //IF "Order Date" = 0D THEN
        SalesOrderHeader.Validate("Posting Date" , BillingHeader."Posting Date");
        //ELSE
        //  SalesOrderHeader."Order Date" := ;
        //IF "Posting Date" <> 0D THEN
        //SalesOrderHeader."Posting Date" := 0D;
        SalesOrderHeader."Document Date" := WorkDate;
        SalesOrderHeader."Created By Doc No." := BillingHeader."No.";
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
        AddOnSetup.TestField(AddOnSetup."Postpaid Cards Account");
        
        
        
        //Ligne
        LineNum:=0;
        CreatedLine.Reset;
        CreatedLine.SetCurrentKey("Document No.","Customer No.","Card Number");
        CreatedLine.SetRange("Document No.",BillingHeader."No.");
        CreatedLine.SetRange("Customer No.",CustNo);
        if CreatedLine.FindSet then repeat
        
          //CreatedLine.TESTFIELD("Customer No.");
          //Revoir ce code
          CreatedLine.TestField(Amount);
          CreatedLine."Invoice No" := SalesOrderHeader."No.";
          CreatedLine.Modify;
        
          SalesOrderLine.Init;
          SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Invoice;
          SalesOrderLine."Document No.":=SalesOrderHeader."No.";
          LineNum:=LineNum+10;
          SalesOrderLine."Line No.":=LineNum;
          SalesOrderLine.Insert(true);
        
          SalesOrderLine.Type:=SalesOrderLine.Type::"G/L Account";
          SalesOrderLine.Validate(SalesOrderLine."No.",AddOnSetup."Postpaid Cards Account");
          SalesOrderLine.Validate(SalesOrderLine.Quantity,1);
          SalesOrderLine.Validate(SalesOrderLine."Unit Price",CreatedLine.Amount);
          SalesOrderLine."Card Number" := CreatedLine."Card Number";
          SalesOrderLine.Modify;
        
        until CreatedLine.Next=0;
        
        
        //SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
        //SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
        //SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";

    end;

    procedure PostBillingHeader(var BillingHeader: Record "MoneyTech Billing")
    var
        PostedBillingTrans: Record "Posted MoneyTech Billing";
        PostedBillingLine: Record "Posted MoneyTech Billing Line";
        BillingLine: Record "MoneyTech Billing Line";
    begin

        //IF NOT BillingHeader.GET(CodeImport) THEN EXIT;

        //SalesByCardImport.SetDoNotDeleteJournalEntries(TRUE);
        BillingHeader.CalcFields(BillingHeader."Total Decharge",BillingHeader."Total Decharge");

        //Transferer le document
        BillingLine.LockTable();
        PostedBillingTrans.Init();
        PostedBillingTrans.TransferFields(BillingHeader);
        PostedBillingTrans.Status:= PostedBillingTrans.Status::Validated;
        PostedBillingTrans.Insert;


        BillingLine.Reset();
        BillingLine.SetRange(BillingLine."Document No.",BillingHeader."No.");
        if BillingLine.FindSet then repeat

            PostedBillingLine.Init();
            PostedBillingLine.TransferFields(BillingLine);
            PostedBillingLine.Insert;

         until BillingLine.Next=0;

        //BillingHeader.SetDoNotDeleteJournalEntries(TRUE);
        BillingHeader.Delete(true);
    end;

    procedure SetHavePostMoneyTechTrans(posted: Boolean)
    begin
        HavePostMoneyTechTrans:=posted;
    end;

    procedure AddNewJournalLineNDNC(SalesByCardLine: Record "MoneyTech Import Line";SalesByCardImport: Record "MoneyTech Import";var LastDocNoCredit: Code[20];var LastDocNoDebit: Code[20])
    var
        PostingDate: Date;
        GenJrnLine: Record "Gen. Journal Line";
        JrnTmplName: Record "Gen. Journal Template";
        LastAmountTotal: Decimal;
        GLAccNo: Code[20];
        BalGLAccountNo: Code[20];
        isNoteDebit: Boolean;
        CodeJournalMoneytech: Code[20];
    begin
        
        
        InitListeJournaux;
        isNoteDebit :=  (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Recharge);
        
        
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= GenJrnTemplate;
        if isNoteDebit then
          GenJrnLine."Journal Batch Name" := GenJrnBatch_ND
        else
          GenJrnLine."Journal Batch Name" := GenJrnBatch_NC;
        LineNo := LineNo+10000;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",SalesByCardImport."Posting Date");
        
        if isNoteDebit then
          GenJrnTableND.TestField("No. Series")
        else
          GenJrnTableNC.TestField("No. Series");
        //IF GenJrnTable."No. Series" <> '' THEN BEGIN
          Clear(NoSeriesMgt);
        
          //Recharge = Note de débit à la station
          //IF (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Recharge)THEN BEGIN
        
                if isNoteDebit then begin
        
                  if LastDocNoDebit='' then begin
                      GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",false);
                      LastDocNoDebit := GenJrnLine."Document No.";
                  end else begin
                      GenJrnLine."Document No." :=IncStr(LastDocNoDebit);
                      LastDocNoDebit := GenJrnLine."Document No.";
                  end;
        
                end else begin
        
                  if LastDocNoCredit='' then begin
                      GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTableNC."No. Series",GenJrnLine."Posting Date",false);
                      LastDocNoCredit := GenJrnLine."Document No.";
                  end else begin
                      GenJrnLine."Document No." :=IncStr(LastDocNoCredit);
                      LastDocNoCredit := GenJrnLine."Document No.";
                  end;
        
                end;
              //END;
              //ELSE BEGIN
                //IF (LastAmountTotal<>0) THEN
                //  GenJrnLine."Document No." :=(LastDocNo)
                //ELSE
        
              //END;
        
          //END;
          /*
          //Decharge = Note de crédit à la station
          IF (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Decharge)THEN BEGIN
                IF LastDocNoCredit='' THEN BEGIN
                  GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(AddOnSetup."Credit Notes Nos.",GenJrnLine."Posting Date",FALSE);
                  LastDocNoCredit := GenJrnLine."Document No.";
                END ELSE BEGIN
                  //IF (LastAmountTotal<>0) THEN
                  //  GenJrnLine."Document No." :=(LastDocNo)
                  //ELSE
                    GenJrnLine."Document No." :=INCSTR(LastDocNoCredit);
                  LastDocNoCredit := GenJrnLine."Document No.";
                END;
        
          END;
          */
        
        //GenJrnLine."Document No." := "Import Data".InvoiceNo;
        
        //DocType1 := "Import Data".CodeTiers2;
        //AccountType1 := "Import Data".Area;
        
        if (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Recharge) then
          GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
        else
          GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";
        
        
        GenJrnLine."External Document No." := SalesByCardImport."No.";
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;
        
        //IF AccountType1='GENERAL' THEN GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
        
        //Station service
        GLAccNo := SalesByCardLine."Station Code";
        GenJrnLine.Validate("Account No.",GLAccNo);
        
        //GLAcc2.GET(GLAccNo);
        //GenJrnLine.VALIDATE("Shortcut Dimension 1 Code",GLAcc2."Global Dimension 1 Code");
        
        //Cust2.GET(AddOnSetup."Default Customer");
        //Vend2.CheckBlockedVendOnJnls(Vend2,"Document Type",FALSE);
        GenJrnLine."MoneyTech Import No." := SalesByCardImport."No.";
        
        //CodeJournalMoneytech := RemoveZeros(SalesByCardLine.TransmissionNo);
        GenJrnLine.Description := StrSubstNo(Text010, SalesByCardImport."Starting Date");
        //AddNewCodeJournal(CodeJournalMoneytech);
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
        
          if (SalesByCardLine."Card Type" = SalesByCardLine."Card Type"::Prepaid) then
          BalGLAccountNo := AddOnSetup."Prepaid Cards Account"
        else
          BalGLAccountNo := AddOnSetup."Postpaid Cards Account";
        GenJrnLine."Bal. Account Type" :=  GenJrnLine."Bal. Account Type"::"G/L Account";
        GenJrnLine.Validate("Bal. Account No.",BalGLAccountNo);
        
        if (SalesByCardLine."Transaction Type"=SalesByCardLine."Transaction Type"::Recharge) then
            GenJrnLine.Validate(GenJrnLine.Amount, SalesByCardLine.Amount)
        else
            GenJrnLine.Validate(GenJrnLine.Amount, -SalesByCardLine.Amount);
        
        LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;
        
        //VAT
        /*
        AddOnSetup.TESTFIELD("No VAT Posting Group Code");
        IF (AccountType1='GENERAL') THEN
          IF "Import Data".SeriesNo='' THEN
            IF ((GLAccNo[1]='6') OR (GLAccNo[1]='7')) THEN
              GenJrnLine.VALIDATE("VAT Bus. Posting Group",AddOnSetup."No VAT Posting Group Code");
              */
        
        
        //GenJrnLine."Invoice No" := "Import Data".RefDoc2;
        //GenJrnLine."Applies-to Doc. Type" := GenJrnLine."Applies-to Doc. Type"::Invoice;
        //GenJrnLine."Applies-to Doc. No.":= "Import Data".RefDoc2;
        
        //IF GenJrnLine.Amount>0 THEN
        //GenJrnLine."Document Type":=GenJrnLine."Document Type"::Payment;
        
        if GenJrnLine.Amount<>0 then
          GenJrnLine.Insert(true);

    end;

    local procedure RemoveZeros(No: Code[10]): Text[20]
    var
        StartPos: Integer;
        EndPos: Integer;
        i: Integer;
        IsDigit: Boolean;
    begin
        //GetIntegerPos(No,StartPos,EndPos);
        //IF StartPos <> 0 THEN
        //  EXIT(COPYSTR(No,StartPos,EndPos - StartPos + 1));

        repeat
          i := i + 1;
          IsDigit := No[i] <>'0';
          if IsDigit then begin
            exit(CopyStr(No,i));
          end;

        until ((i=StrLen(No)) or (IsDigit));
    end;

    local procedure GetNoText(No: Code[20]): Code[20]
    var
        StartPos: Integer;
        EndPos: Integer;
    begin
    end;

    local procedure GetIntegerPos(No: Code[20];var StartPos: Integer;var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
        
        
        
        /*StartPos := 0;
        EndPos := 0;
        IF No <> '' THEN BEGIN
          i := STRLEN(No);
          REPEAT
            IsDigit := No[i] IN ['1'..'9'];
            IF IsDigit THEN BEGIN
              IF EndPos = 0 THEN
                EndPos := i;
              StartPos := i;
            END;
            i := i - 1;
          UNTIL (i = 0) OR (StartPos <> 0) AND NOT IsDigit;
        END;*/

    end;

    local procedure InitListeJournaux()
    var
        i: Integer;
    begin
        Clear(ListeJournaux);
        //i := 1;
        //REPEAT
        //  ListeJournaux[i] := '';
        //UNTIL ((ListeJournaux[i]='') OR (i=10));
    end;

    local procedure AddNewCodeJournal(CodeJournal: Code[20]): Boolean
    var
        i: Integer;
        ToAdd: Boolean;
        Pos: Integer;
    begin
        i := 1;
        Pos := 0;
        ToAdd:=true;
        repeat
          if ListeJournaux[i]=CodeJournal then
            //ToAdd:=FALSE;
            exit(false)
          else
            Pos := Pos + 1;
          i := i + 1;
        until ((ListeJournaux[i]='') or (i=10));

        if ToAdd then begin
          ListeJournaux[Pos] := CodeJournal;
          exit(true);
        end;
    end;

    procedure GenerateEcrituresNDNCClient(SalesByCardImport: Record "MoneyTech Import";CodeStation: Code[20];IsDebit: Boolean;LastDocNoCredit: Code[20];LastDocNoDebit: Code[20])
    var
        PostingDate: Date;
        GenJrnLine: Record "Gen. Journal Line";
        JrnTmplName: Record "Gen. Journal Template";
        LastAmountTotal: Decimal;
        GLAccNo: Code[20];
        BalGLAccountNo: Code[20];
        LC: Record "Letter of credit";
        SalesByCardLine: Record "MoneyTech Import Line";
    begin

        SalesByCardLine.Reset();
        SalesByCardLine.SetRange("Document No.",SalesByCardImport."No.");
        SalesByCardLine.SetRange("Station Code",CodeStation);
        if IsDebit then
          SalesByCardLine.SetRange(SalesByCardLine."Transaction Type",SalesByCardLine."Transaction Type"::Recharge)
        else
          SalesByCardLine.SetRange(SalesByCardLine."Transaction Type",SalesByCardLine."Transaction Type"::Decharge);
        if not SalesByCardLine.FindFirst then exit;

        if IsDebit then begin
          GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series",GenJrnLine."Posting Date",false);
          LastDocNoDebit := GenJrnLine."Document No.";
        end else begin
          GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTableNC."No. Series",GenJrnLine."Posting Date",false);
          LastDocNoCredit := GenJrnLine."Document No.";
        end;

        if SalesByCardLine.FindSet then repeat

          Clear(GenJrnLine);

          GenJrnLine."Journal Template Name":= GenJrnTemplate;
          if IsDebit then
            GenJrnLine."Journal Batch Name" := GenJrnBatch_ND
          else
            GenJrnLine."Journal Batch Name" := GenJrnBatch_NC;
          LineNo := LineNo+100;
          GenJrnLine."Line No." := LineNo;
          JrnTmplName.Get(GenJrnLine."Journal Template Name");
          JrnTmplName.TestField(JrnTmplName."Source Code");
          GenJrnLine."Source Code" := JrnTmplName."Source Code";
          GenJrnLine.Validate("Posting Date",SalesByCardImport."Posting Date");

          if IsDebit then begin
            GenJrnLine."Document No.":=LastDocNoDebit;
          end else begin
            GenJrnLine."Document No.":=LastDocNoCredit;
          end;

          if (IsDebit) then
            GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
          else
            GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";

          GenJrnLine."External Document No." := SalesByCardImport."No.";
          GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
          if (SalesByCardLine."Card Type" = SalesByCardLine."Card Type"::Prepaid) then
            BalGLAccountNo := AddOnSetup."Prepaid Cards Account"
          else
            BalGLAccountNo := AddOnSetup."Postpaid Cards Account";
          //GLAccNo := SalesByCardLine."Station Code";
          GenJrnLine.Validate("Account No.",BalGLAccountNo);

          GenJrnLine."MoneyTech Import No." := SalesByCardImport."No.";
          GenJrnLine.Description := StrSubstNo(Text010, SalesByCardImport."Starting Date");
          GenJrnLine.Validate("Currency Code",'');

          //GenJrnLine."Bal. Account Type" :=  GenJrnLine."Bal. Account Type"::"G/L Account";
          //GenJrnLine.VALIDATE("Bal. Account No.",BalGLAccountNo);

          if (IsDebit) then
              GenJrnLine.Validate(GenJrnLine.Amount, -SalesByCardLine.Amount)
          else
              GenJrnLine.Validate(GenJrnLine.Amount, SalesByCardLine.Amount);

          LastAmountTotal := LastAmountTotal + Abs(GenJrnLine.Amount);

          if GenJrnLine.Amount<>0 then
            GenJrnLine.Insert(true);

        until SalesByCardLine.Next=0;


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= GenJrnTemplate;
        if IsDebit then
          GenJrnLine."Journal Batch Name" := GenJrnBatch_ND
        else
          GenJrnLine."Journal Batch Name" := GenJrnBatch_NC;
        LineNo := LineNo+100;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",SalesByCardImport."Posting Date");
        if IsDebit then
          GenJrnLine."Document No." := LastDocNoDebit
        else
          GenJrnLine."Document No." := LastDocNoCredit;

        if (IsDebit) then
          GenJrnLine."Document Type" := GenJrnLine."Document Type"::Invoice
        else
          GenJrnLine."Document Type" := GenJrnLine."Document Type"::"Credit Memo";

        GenJrnLine."External Document No." := SalesByCardImport."No.";
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;
        GLAccNo := SalesByCardLine."Station Code";
        GenJrnLine.Validate("Account No.",GLAccNo);

        GenJrnLine."MoneyTech Import No." := SalesByCardImport."No.";
        GenJrnLine.Description := StrSubstNo(Text010, SalesByCardImport."Starting Date");
        GenJrnLine.Validate("Currency Code",'');

        if (IsDebit) then
            GenJrnLine.Validate(GenJrnLine.Amount, LastAmountTotal)
        else
            GenJrnLine.Validate(GenJrnLine.Amount, -LastAmountTotal);

        //LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;

        if GenJrnLine.Amount<>0 then
          GenJrnLine.Insert(true);
    end;

    procedure CheckDatesInsertion(MnyHeader: Record "MoneyTech Import")
    var
        PostedRec: Record "Posted Moneytech Import";
        ImportRec: Record "MoneyTech Import";
    begin

        ImportRec.Reset;
        ImportRec.SetRange("Starting Date",MnyHeader."Starting Date");
        ImportRec.SetRange(ImportRec."Tranche Horaire",MnyHeader."Tranche Horaire");
        ImportRec.SetFilter(ImportRec."No.",'<>%1',MnyHeader."No.");
        if ImportRec.FindFirst then
          Error(Text011,ImportRec."No.");

        PostedRec.Reset;
        PostedRec.SetRange("Starting Date",MnyHeader."Starting Date");
        PostedRec.SetRange(PostedRec."Tranche Horaire",MnyHeader."Tranche Horaire");
        if PostedRec.FindFirst then
          Error(Text011,PostedRec."No.");
    end;
}

