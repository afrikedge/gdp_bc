codeunit 50014 "Treso Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        GenJrnTemplate: Code[20];
        AddOnSetup: Record "AddOn Setup";
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EmailMgt: Codeunit EmailMgt;
        SingleInstanceCU: Codeunit SingleInstance;
        HavePostMoneyTechTrans: Boolean;
        GenJrnTableND: Record "Gen. Journal Batch";
        GenJrnBatch_ND: Code[20];
        GenJrnBatch_NC: Code[20];
        GenJrnTableNC: Record "Gen. Journal Batch";
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text002: Label 'This account %1 does not exists !';
        Text003: Label 'The journal template model is required';
        Text004: Label 'The journal code is required';
        PurchReq: Codeunit "Purchase Requisition Mgt";
        Text005: Label 'Provisions commande de vente %1';
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Text006: Label 'Provisions frais annexes commande %1';
        Text007: Label 'Les provisions de frais annexes ont déjà été validées pour ce document';
        Text009: Label 'Provisions commande d''achat %1';
        Text010: Label 'Souhaitez-vous retourner ce chèque : %1  ?';
        Text011: Label 'Souhaitez-vous clôturer la lettre de crédit : %1  ?';
        PurchSetup: Record "Purchases & Payables Setup";
        Text012: Label 'Les factures de provisions de frais annexes seront créés pour ce document. Souhaitez-vous continuer ?';
        Text013: Label 'Traitement terminé : %1 factures de frais annexes créés';
        Text014: Label 'Provision Cde';
        Text015: Label 'Prov. frais annexes';
        Text016: Label 'Vous devez extourner les écritures provisions avant de facturer ce document';
        Text017: Label 'Le document de paiement n''a pas été configuré pour \le modèle %1\la feuille %2\le type %3';
        Text019: Label 'Souhaitez-vous confirmer ce chèque : %1  ?';
        Text018: Label 'Achat de devise LC %1';
        GenJrnBatch: Code[20];
        GenJrnTable: Record "Gen. Journal Batch";
        AdjustGenjrn: Codeunit "Adjust Gen. Journal Balance";
        Text020: Label 'Cet achat a déjà été comptabilisé';
        Text021: Label 'Paiement échéance LC %1';
        Text022: Label 'Le montant acheté %1 doit correspondre au montant de l''échéance : %2';
        Text023: Label 'Cette échéance a déjà été comptabilisée';
        Text024: Label 'Vous devez lancer le calcul pour mettre à jour les valeur sur le document';
        //SMTPSetup: Record "SMTP Mail Setup";
        FileMgt: Codeunit "File Management";
        Text025: Label 'Cette option n''est valide que pour les virements et les paiements par chèques';
        AddOnSetup2: Record "AddOn Setup2";
        Text026: Label 'Le fichier attaché est introuvable, le mail ne sera pas envoyé';
        Text027: Label 'Cette option n''est pas valide pour ce mode de paiement';
        Text028: Label 'Nouveau paiement par chèque de la part de GALANA';
        Text029: Label 'Nouveau virement de la part de GALANA';
        Text030: Label 'Nouveau paiement par espèces de la part de GALANA';
        Text031: Label 'Nouveau paiement par traite de la part de GALANA';
        Text032: Label 'Veuillez trouver en pièce jointe à ce mail votre paiement validé ce jour.';
        IncorrectEntryTypeErr: Label 'Incorrect Entry Type %1.';

    procedure ConvertInLocalCurr(CodeDevise: Code[20]; PostingDate: Date; AmountToConvert: Decimal) Reponse: Decimal
    begin
        if CodeDevise = '' then
            Reponse := AmountToConvert
        else
            Reponse :=
                  Round(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostingDate, CodeDevise, AmountToConvert,
                      CurrExchRate.ExchangeRate(PostingDate, CodeDevise)));
    end;

    procedure CloseCheckWarranty(var CheckWarranty: Record "Check Warranty")
    begin

        CheckWarranty.TestField(CheckWarranty."Check No.");
        CheckWarranty.TestField(CheckWarranty."Posting Date");
        CheckWarranty.TestField(CheckWarranty."Check Date");
        CheckWarranty.TestField(CheckWarranty."Customer No.");

        if not Confirm(StrSubstNo(Text010, CheckWarranty."Check No.")) then exit;

        CheckWarranty.Status := CheckWarranty.Status::Returned;
        CheckWarranty."Return Date" := Today;
        CheckWarranty.Modify;
    end;

    procedure CloseLetterOfCredit(var LC: Record "Letter of credit")
    begin

        LC.TestField(LC."Letter of Credit Ref");
        LC.TestField(LC."Document Date");
        //LC.TESTFIELD(LC."Check Date");
        LC.TestField(LC."Vendor No.");

        if not Confirm(StrSubstNo(Text011, LC."No.")) then exit;

        LC.Status := LC.Status::Closed;
        LC."Closed Date" := Today;
        LC.Modify;
    end;

    procedure CreateNewPaymentDoc(GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        Feuille: Record "Gen. Journal Batch";
        Cust: Record Customer;
        LineNum: Integer;
        PaymentCCConfig: Record "Payment CC Config";
        PaymentClass: Record "Payment Class";
    begin

        //Feuille.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
        //Feuille.TESTFIELD("Payment Class");

        if not PaymentCCConfig.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name",
          GenJnlLine."CC Document Type") then
            Error(StrSubstNo(Text017, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name",
            GenJnlLine."CC Document Type"));

        PaymentCCConfig.TestField("Payment Class");

        PaymentClass.Get(PaymentCCConfig."Payment Class");

        PaymentHeader.Init;

        PaymentClass.TestField("Header No. Series");
        //PaymentHeader."No." := NoSeriesMgt.GetNextNo(PaymentClass."Header No. Series",WORKDATE,TRUE);
        PaymentHeader."No." := GenJnlLine."Document No.";

        //NoSeriesMgt.InitSeries(PaymentClass."Header No. Series",xRec."No. Series",0D,"No.","No. Series");


        PaymentLine.LockTable;
        PaymentHeader.Insert(true);

        PaymentHeader.Validate("Payment Class", PaymentCCConfig."Payment Class");
        PaymentHeader.Validate("Currency Code", GenJnlLine."Currency Code");

        Cust.Get(GenJnlLine."Account No.");
        PaymentHeader."Check Number" := GenJnlLine."Check No.";
        PaymentHeader."Customer No." := Cust."No.";
        PaymentHeader."Customer Name" := Cust.Name;
        PaymentHeader.Description := GenJnlLine.Description;
        PaymentHeader.Validate("Posting Date", GenJnlLine."Posting Date");
        PaymentHeader."Origin Document N°" := GenJnlLine."Document No.";

        PaymentHeader.Modify;


        LineNum := 0;
        PaymentLine.Init;
        PaymentLine."Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", WorkDate, true);
        PaymentLine."No." := PaymentHeader."No.";
        PaymentLine."Payment Class" := PaymentHeader."Payment Class";
        LineNum := LineNum + 10000;
        PaymentLine."Line No." := LineNum;
        PaymentLine.Insert();


        PaymentLine."Account Type" := PaymentLine."Account Type"::Customer;
        PaymentLine.Validate(PaymentLine."Account No.", Cust."No.");
        PaymentLine."Currency Code" := GenJnlLine."Currency Code";
        PaymentLine."Currency Factor" := PaymentHeader."Currency Factor";
        PaymentLine.Validate(Amount, -Abs(GenJnlLine.Amount));

        if ((GenJnlLine."CC Document Type" = GenJnlLine."CC Document Type"::ChequeNormal)
          or (GenJnlLine."CC Document Type" = GenJnlLine."CC Document Type"::Traite)) then
            GenJnlLine.TestField("Check No.");

        PaymentLine."Drawee Reference" := CopyStr(GenJnlLine."Check No.", 1, 10);
        PaymentLine."Due Date" := GenJnlLine."Due Date";
        //PaymentLine.

        PaymentLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
        PaymentLine.Modify;
    end;

    procedure CreateNewPaymentDoc_VirementFromTreso(GenJnlLine: Record "Gen. Journal Line")
    var
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        Feuille: Record "Gen. Journal Batch";
        LineNum: Integer;
        PaymentCCConfig: Record "Payment CC Config";
        PaymentClass: Record "Payment Class";
    begin

        //Feuille.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
        //Feuille.TESTFIELD("Payment Class");
        GenJnlLine.TestField(GenJnlLine."Account Type", GenJnlLine."Account Type"::"Bank Account");
        GenJnlLine.TestField(GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");


        if not PaymentCCConfig.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name",
          GenJnlLine."CC Document Type") then
            Error(StrSubstNo(Text017, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name",
            GenJnlLine."CC Document Type"));

        PaymentCCConfig.TestField("Payment Class");

        PaymentClass.Get(PaymentCCConfig."Payment Class");

        PaymentHeader.Init;

        PaymentClass.TestField("Header No. Series");
        //PaymentHeader."No." := NoSeriesMgt.GetNextNo(PaymentClass."Header No. Series",WORKDATE,TRUE);
        PaymentHeader."No." := GenJnlLine."Document No.";

        //NoSeriesMgt.InitSeries(PaymentClass."Header No. Series",xRec."No. Series",0D,"No.","No. Series");
        PaymentHeader.PayDocType := PaymentHeader.PayDocType::FromTreso;

        PaymentLine.LockTable;
        PaymentHeader.Insert(true);

        PaymentHeader.Validate("Payment Class", PaymentCCConfig."Payment Class");
        PaymentHeader.Validate("Currency Code", GenJnlLine."Currency Code");

        //Cust.GET(GenJnlLine."Account No.");
        PaymentHeader."Check Number" := GenJnlLine."Check No.";
        //PaymentHeader."Customer No." := Cust."No.";
        //PaymentHeader."Customer Name" := Cust.Name;
        PaymentHeader.Description := GenJnlLine.Description;
        PaymentHeader.Validate("Posting Date", GenJnlLine."Posting Date");
        PaymentHeader."Origin Document N°" := GenJnlLine."Document No.";

        PaymentHeader.Validate("Account Type", PaymentHeader."Account Type"::"Bank Account");
        PaymentHeader.Validate(PaymentHeader."Account No.", GenJnlLine."Account No.");

        PaymentHeader.Modify;


        LineNum := 0;
        PaymentLine.Init;
        PaymentLine."Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", WorkDate, true);
        PaymentLine."No." := PaymentHeader."No.";
        PaymentLine."Payment Class" := PaymentHeader."Payment Class";
        LineNum := LineNum + 10000;
        PaymentLine."Line No." := LineNum;
        PaymentLine.Insert();


        PaymentLine."Account Type" := PaymentLine."Account Type"::Customer;
        //PaymentLine.VALIDATE(PaymentLine."Account No.",Cust."No.");
        PaymentLine."Currency Code" := GenJnlLine."Currency Code";
        PaymentLine."Currency Factor" := PaymentHeader."Currency Factor";
        PaymentLine.Validate(Amount, -Abs(GenJnlLine.Amount));


        PaymentLine."Drawee Reference" := CopyStr(GenJnlLine."Check No.", 1, 10);
        PaymentLine."Due Date" := GenJnlLine."Due Date";
        //PaymentLine.

        PaymentLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
        PaymentLine.Modify;
    end;

    procedure CreateDocumentReglement_Old(GenJnlLine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        /*
        
        //TRansféré dans codeunit 13
        IF GenJnlLine."CC Document Type"=GenJnlLine."CC Document Type"::" " THEN EXIT;
        
        IF GenJnlLine."CC Document Type"=GenJnlLine."CC Document Type"::ChequeCaution THEN BEGIN
          CreateNewPaymentDoc(GenJnlLine);
          CreateNDChequeGarantie(GenJnlLine,GenJnlPostLine);
        END;
        
        IF GenJnlLine."CC Document Type"=GenJnlLine."CC Document Type"::ChequeNormal THEN
          CreateNewPaymentDoc(GenJnlLine);
        
        IF GenJnlLine."CC Document Type"=GenJnlLine."CC Document Type"::Virement THEN
          CreateNewPaymentDoc(GenJnlLine);
        
        IF GenJnlLine."CC Document Type"=GenJnlLine."CC Document Type"::ChequeGarantie THEN
          CreateChequeGarantie(GenJnlLine);
        */

    end;

    procedure CreateChequeGarantie(GenJnlLine: Record "Gen. Journal Line")
    var
        ChequeGarantie: Record "Check Warranty";
        Cust: Record Customer;
    begin

        GenJnlLine.TestField("Check Date");
        GenJnlLine.TestField("Check No.");

        ChequeGarantie.Init;
        ChequeGarantie."No." := '';
        ChequeGarantie.Insert(true);

        ChequeGarantie.Amount := GenJnlLine."Credit Amount";
        ChequeGarantie."Check Date" := GenJnlLine."Check Date";
        ChequeGarantie."Check No." := GenJnlLine."Check No.";
        ChequeGarantie."Due Date" := GenJnlLine."Due Date";

        Cust.Get(GenJnlLine."Account No.");
        ChequeGarantie."Customer No." := GenJnlLine."Account No.";
        ChequeGarantie."Customer Name" := Cust.Name;

        ChequeGarantie.Description := GenJnlLine.Description;
        ChequeGarantie."Receipt Date" := Today;
        ChequeGarantie."Posting Date" := GenJnlLine."Posting Date";

        ChequeGarantie."CCL Tmpl" := GenJnlLine."Journal Template Name";
        ChequeGarantie."CCL Jrnal" := GenJnlLine."Journal Batch Name";

        ChequeGarantie.Modify;
    end;

    procedure CreateNDChequeGarantie_Old(GenJnlOrigine: Record "Gen. Journal Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin

        /*
        AddOnSetup.GET;
        AddOnSetup.TESTFIELD(AddOnSetup."Debit Notes Nos.");
        AddOnSetup.TESTFIELD("NoVAT Prod. Posting Group");
        AddOnSetup.TESTFIELD(AddOnSetup."ND Cheque Caution Account");
        
        //SourceCodeSetup.GET;
        
        //Item1.GET(LineItemAdj."Item No.");
        
        CLEAR(GenJnlLine);
        GenJnlLine."Document Type" := GenJnlOrigine."Document Type"::Invoice;
        GenJnlLine."Document Date":= GenJnlOrigine."Posting Date";
        GenJnlLine."Posting Date":= GenJnlOrigine."Posting Date";
        GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(AddOnSetup."Debit Notes Nos.",WORKDATE,TRUE);
        //GenJnlLine."Document No." := ItemAdj."No.";
        GenJnlLine."Account Type":= GenJnlLine."Account Type"::Customer;
        //GenJnlLine."Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Sale;
        GenJnlLine.VALIDATE(GenJnlLine."Account No.",GenJnlOrigine."Account No.");
        GenJnlLine.Description := GenJnlOrigine.Description;
        
        
        GenJnlLine.VALIDATE(Amount,ABS(GenJnlOrigine.Amount));
        //GenJnlLine."Shortcut Dimension 1 Code" := FA."Shortcut Dimension 1 Code";
        //GenJnlLine."Shortcut Dimension 2 Code" := FA."Shortcut Dimension 2 Code";
        //GenJnlLine."Dimension Set ID" := FA."Dimension Set ID";
        GenJnlLine."External Document No.":= GenJnlOrigine."Document No.";
        GenJnlLine."Source Code" := GenJnlOrigine."Source Code";
        GenJnlLine.SetHideValidation(TRUE);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        
        
        GenJnlLine.VALIDATE("Bal. Account No.",AddOnSetup."ND Cheque Caution Account");
        GenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Sale;
        //GenJnlLine.VALIDATE(GenJnlLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
        //ItemJnlPostLine.AFK_GetGenJnlPostLine(GenJnlPostLine);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        
        //EXIT(GenJnlLine."Document No.");
        */

    end;

    procedure RefreshLinesLettreCredit(DocNo: Code[20])
    var
        LCEcheance: Record "Letter of credit Expiry";
    begin
        Clear(LCEcheance);
        LCEcheance.SetRange(LCEcheance."Document No.", DocNo);
        if LCEcheance.FindSet then
            repeat
                LCEcheance.Validate("Provisions %");
                LCEcheance.Modify;
            until LCEcheance.Next = 0;
    end;

    procedure GenerateEcritureAchatDevise(LCNumber: Code[20]; LigneAchat: Record "Currency Purchase")
    var
        PostingDate: Date;
        GenJrnLine: Record "Gen. Journal Line";
        JrnTmplName: Record "Gen. Journal Template";
        LastAmountTotal: Decimal;
        GLAccNo: Code[20];
        BalGLAccountNo: Code[20];
        LineNo: Integer;
        LastDocNoDebit: Code[20];
        LC: Record "Letter of credit";
        DocNo: Code[20];
        MontantAR: Decimal;
    begin
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."Credit Bank Account");

        LC.Get(LCNumber);
        LC.TestField(LC."Currency Purchase Jrnal");
        LC.TestField(LC."Currency Purchase Tmpl");

        if LigneAchat.Posted then Error(Text020);
        //LigneAchat.TESTFIELD(LigneAchat.Posted,FALSE);

        GenJrnTemplate := LC."Currency Purchase Tmpl";
        GenJrnBatch := LC."Currency Purchase Jrnal";

        GenJrnTable.Get(GenJrnTemplate, GenJrnBatch);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch);
        if GenJrnLine.FindFirst then Error(Text001, GenJrnBatch);

        Clear(NoSeriesMgt);
        GenJrnTable.TestField("No. Series");
        DocNo := NoSeriesMgt.GetNextNo(GenJrnTable."No. Series", WorkDate, false);




        Clear(GenJrnLine);

        GenJrnLine.AFK_SetCanUpdateAchatDevise(true);
        SingleInstanceCU.Set_CanUpdateAchatDevise(true);

        GenJrnLine."Journal Template Name" := GenJrnTemplate;
        GenJrnLine."Journal Batch Name" := GenJrnBatch;
        LineNo := LineNo + 10000;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", LigneAchat."Posting Date");

        GenJrnLine."Document No." := DocNo;
        GenJrnLine."Document Type" := GenJrnLine."Document Type"::" ";
        GenJrnLine."External Document No." := LC."No.";
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"Bank Account";

        LC.TestField(LC."Accreditif Bank Account");
        GLAccNo := LC."Accreditif Bank Account";
        GenJrnLine.Validate("Account No.", GLAccNo);

        GenJrnLine."Origin Type" := GenJrnLine."Origin Type"::LC;
        GenJrnLine."Origin No." := LC."No.";
        GenJrnLine."Origin Line No." := LigneAchat."Line No.";
        GenJrnLine.Description := CopyStr(StrSubstNo(Text018, LC."Letter of Credit Ref"), 1, 49);

        //GenJrnLine.VALIDATE("Currency Code",LC."Currency Code");
        GenJrnLine.Validate(GenJrnLine.Amount, LigneAchat."Amount Currency");
        //GenJrnLine.VALIDATE("Currency Factor" , ROUND(1 / LigneAchat."Convertion Rate",0.000000000000001));
        GenJrnLine.Validate(GenJrnLine."Amount (LCY)", LigneAchat."Amount LCY");
        MontantAR := GenJrnLine."Amount (LCY)";

        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);




        Clear(GenJrnLine);

        GenJrnLine.AFK_SetCanUpdateAchatDevise(true);

        GenJrnLine."Journal Template Name" := GenJrnTemplate;
        GenJrnLine."Journal Batch Name" := GenJrnBatch;
        LineNo := LineNo + 10000;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        LigneAchat.TestField("Posting Date");
        GenJrnLine.Validate("Posting Date", LigneAchat."Posting Date");



        GenJrnLine."Document No." := DocNo;
        GenJrnLine."Document Type" := GenJrnLine."Document Type"::" ";
        GenJrnLine."External Document No." := LC."No.";
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"Bank Account";

        LC.TestField(LC."Bank Account");
        GLAccNo := LC."Bank Account";
        GenJrnLine.Validate("Account No.", GLAccNo);

        GenJrnLine."Origin Type" := GenJrnLine."Origin Type"::LC;
        GenJrnLine."Origin No." := LC."No.";
        GenJrnLine."Origin Line No." := LigneAchat."Line No.";
        GenJrnLine.Description := CopyStr(StrSubstNo(Text018, LC."Letter of Credit Ref"), 1, 49);

        //GenJrnLine.VALIDATE("Currency Code",LC."Currency Code");
        GenJrnLine.Validate("Currency Code", '');
        //GenJrnLine.VALIDATE(GenJrnLine.Amount, -LigneAchat."Amount Currency"*LigneAchat."Convertion Rate");
        GenJrnLine.Validate(GenJrnLine.Amount, -MontantAR);


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);












        //AdjustGenjrn.RUN(GenJrnLine);
        SingleInstanceCU.Set_CanUpdateAchatDevise(false);

        Message(TxtTraitementTerminé);
    end;

    procedure ConfirmAchatDevise(GenJnlLine: Record "Gen. Journal Line")
    var
        LC: Record "Letter of credit";
        CurrPurchase: Record "Currency Purchase";
        LastNo: Integer;
        LigneAchat: Record "Currency Purchase";
    begin
        //Le champ Posted est un flowfield calculé
        /*
        IF GenJnlLine."Origin Type"<>GenJnlLine."Origin Type"::LC THEN EXIT;
        
        IF LigneAchat.GET(GenJnlLine."Origin No.",GenJnlLine."Origin Line No.") THEN BEGIN
          LigneAchat.Posted:=TRUE;
          LigneAchat.MODIFY;
        END;
        */

    end;

    procedure GenerateEcriturePaiementEcheance(LCNumber: Code[20]; var LigneEch: Record "Letter of credit Expiry")
    var
        PostingDate: Date;
        GenJrnLine: Record "Gen. Journal Line";
        JrnTmplName: Record "Gen. Journal Template";
        LastAmountTotal: Decimal;
        GLAccNo: Code[20];
        BalGLAccountNo: Code[20];
        LineNo: Integer;
        LastDocNoDebit: Code[20];
        LC: Record "Letter of credit";
        DocNo: Code[20];
        TauxUtilise: Decimal;
        BAcc: Record "Bank Account";
    begin
        AddOnSetup.Get;


        if LigneEch.Updated = false then Error(Text024);

        //LigneEch.CALCFIELDS("Total Purchased Due (LCY)");
        if LigneEch."Total Purchased Due" <> LigneEch."Due Amount" then
            Error(Text022, LigneEch."Total Purchased Due", LigneEch."Due Amount");


        //LigneEch.VALIDATE(LigneEch."Provisions %");
        //LigneEch.MODIFY;

        LC.Get(LCNumber);
        LC.TestField(LC."Paiement Echeance Tmpl");
        LC.TestField(LC."Paiement Echeance Jrnal");

        if LigneEch.Posted then Error(Text020);
        //LigneAchat.TESTFIELD(LigneAchat.Posted,FALSE);

        GenJrnTemplate := LC."Paiement Echeance Tmpl";
        GenJrnBatch := LC."Paiement Echeance Jrnal";

        GenJrnTable.Get(GenJrnTemplate, GenJrnBatch);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch);
        if GenJrnLine.FindFirst then Error(Text001, GenJrnBatch);

        Clear(NoSeriesMgt);
        GenJrnTable.TestField("No. Series");
        DocNo := NoSeriesMgt.GetNextNo(GenJrnTable."No. Series", WorkDate, false);



        Clear(GenJrnLine);

        GenJrnLine.AFK_SetCanUpdateAchatDevise(true);
        SingleInstanceCU.Set_CanUpdateAchatDevise(true);

        GenJrnLine."Journal Template Name" := GenJrnTemplate;
        GenJrnLine."Journal Batch Name" := GenJrnBatch;
        LineNo := LineNo + 10000;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";

        LigneEch.TestField("Posting Date");
        GenJrnLine.Validate("Posting Date", LigneEch."Posting Date");



        GenJrnLine."Document No." := DocNo;
        GenJrnLine."Document Type" := GenJrnLine."Document Type"::Payment;
        GenJrnLine."External Document No." := LC."No.";
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::Vendor;

        LC.TestField(LC."Vendor No.");
        GLAccNo := LC."Vendor No.";
        GenJrnLine.Validate("Account No.", GLAccNo);

        GenJrnLine."Origin Type" := GenJrnLine."Origin Type"::EchPayment;
        GenJrnLine."Origin No." := LC."No.";
        GenJrnLine."Origin Line No." := LigneEch."Line No.";
        GenJrnLine.Description := CopyStr(StrSubstNo(Text021, LC."Letter of Credit Ref"), 1, 49);

        BAcc.Get(LC."Accreditif Bank Account");
        GenJrnLine.Validate("Currency Code", BAcc."Currency Code");
        //GenJrnLine.VALIDATE("Currency Code",'');
        GenJrnLine.Validate(GenJrnLine.Amount, LigneEch."Due Amount");

        TauxUtilise := LigneEch."Total Purchased LCY" / LigneEch."Due Amount";
        GenJrnLine.Validate("Currency Factor", Round(1 / TauxUtilise, 0.000000000000001));

        GenJrnLine.Validate(GenJrnLine."Payment Method Code", AddOnSetup."LC Payment Method");

        if LC."Vendor Invoice Number" <> '' then begin
            GenJrnLine."Applies-to Doc. Type" := GenJrnLine."Applies-to Doc. Type"::Invoice;
            GenJrnLine.Validate(GenJrnLine."Applies-to Doc. No.", LC."Vendor Invoice Number");
        end;

        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"Bank Account";
        GenJrnLine.Validate("Bal. Account No.", LC."Accreditif Bank Account");


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);

        SingleInstanceCU.Set_CanUpdateAchatDevise(false);
        Message(TxtTraitementTerminé);

    end;

    procedure ConfirmCheckCaution(var Check: Record "Check Warranty")
    var
        PostingDate: Date;
        GenJrnLine: Record "Gen. Journal Line";
        JrnTmplName: Record "Gen. Journal Template";
        LastAmountTotal: Decimal;
        GLAccNo: Code[20];
        BalGLAccountNo: Code[20];
        LineNo: Integer;
        LastDocNoDebit: Code[20];
        LC: Record "Letter of credit";
    begin
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."Credit Bank Account");

        if not Confirm(StrSubstNo(Text019, Check."Check No.")) then exit;




        Check.TestField(Check."CCL Jrnal");

        GenJrnTemplate := Check."CCL Tmpl";
        GenJrnBatch := Check."CCL Jrnal";

        GenJrnTable.Get(GenJrnTemplate, GenJrnBatch);

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", GenJrnTemplate);
        GenJrnLine.SetRange("Journal Batch Name", GenJrnBatch);
        if GenJrnLine.FindFirst then Error(Text001, GenJrnBatch);


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := GenJrnTemplate;
        GenJrnLine."Journal Batch Name" := GenJrnBatch;
        LineNo := LineNo + 10000;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", WorkDate);

        GenJrnTable.TestField("No. Series");
        Clear(NoSeriesMgt);

        if LastDocNoDebit = '' then begin
            GenJrnLine."Document No." := NoSeriesMgt.GetNextNo(GenJrnTable."No. Series", GenJrnLine."Posting Date", false);
            LastDocNoDebit := GenJrnLine."Document No.";
        end else begin
            GenJrnLine."Document No." := IncStr(LastDocNoDebit);
            LastDocNoDebit := GenJrnLine."Document No.";
        end;


        GenJrnLine."Document Type" := GenJrnLine."Document Type"::Payment;
        GenJrnLine."CC Document Type" := GenJrnLine."CC Document Type"::ChequeNormal;
        GenJrnLine."External Document No." := Check."No.";
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::Customer;

        Check.TestField(Check."Customer No.");
        GLAccNo := Check."Customer No.";
        GenJrnLine.Validate("Account No.", GLAccNo);

        GenJrnLine."Check Date" := Check."Check Date";
        GenJrnLine."Check No." := Check."Check No.";

        //GenJrnLine."MoneyTech Import No." := LC."No.";
        GenJrnLine.Description := CopyStr(StrSubstNo(Check.Description), 1, 49);
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
        GenJrnLine.Validate("Currency Code", '');

        GenJrnTable.TestField("Bal. Account No.");
        BalGLAccountNo := GenJrnTable."Bal. Account No.";
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"Bank Account";
        GenJrnLine.Validate("Bal. Account No.", BalGLAccountNo);

        GenJrnLine.Validate(Amount, -Check.Amount);

        LastAmountTotal := LastAmountTotal + GenJrnLine.Amount;


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        Check.Status := Check.Status::Confirmed;
        Check."Confirmed Date" := Today;
        Check.Modify;


        Message(TxtTraitementTerminé);
    end;

    procedure CreateNewPaymentDocVendor(GenJnlLine: Record "Gen. Journal Line"): Code[20]
    var
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        Feuille: Record "Gen. Journal Batch";
        Vend: Record Vendor;
        LineNum: Integer;
        PaymentCCConfig: Record "Payment CC Config";
        PaymentClass: Record "Payment Class";
        PaymentMethod: Record "Payment Method";
    begin

        //Feuille.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
        //Feuille.TESTFIELD("Payment Class");

        GenJnlLine.TestField(GenJnlLine."Payment Method Code");
        PaymentMethod.Get(GenJnlLine."Payment Method Code");
        if PaymentMethod."CC Document Type" = PaymentMethod."CC Document Type"::" " then exit;


        if not PaymentCCConfig.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name",
          PaymentMethod."CC Document Type") then
            Error(StrSubstNo(Text017, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name",
            PaymentMethod."CC Document Type"));

        PaymentCCConfig.TestField("Payment Class");

        PaymentClass.Get(PaymentCCConfig."Payment Class");

        PaymentHeader.Init;

        PaymentClass.TestField("Header No. Series");
        PaymentHeader."No." := NoSeriesMgt.GetNextNo(PaymentClass."Header No. Series", WorkDate, true);

        //NoSeriesMgt.InitSeries(PaymentClass."Header No. Series",xRec."No. Series",0D,"No.","No. Series");


        PaymentLine.LockTable;
        PaymentHeader.Insert(true);

        PaymentHeader.Validate("Payment Class", PaymentCCConfig."Payment Class");
        PaymentHeader.Validate("Currency Code", GenJnlLine."Currency Code");

        Vend.Get(GenJnlLine."Account No.");
        PaymentHeader."Check Number" := GenJnlLine."Check No.";
        PaymentHeader."Customer No." := Vend."No.";
        PaymentHeader."Customer Name" := Vend.Name;
        PaymentHeader.Description := GenJnlLine.Description;
        PaymentHeader.Validate("Posting Date", GenJnlLine."Posting Date");
        PaymentHeader."Origin Document N°" := GenJnlLine."Document No.";

        PaymentHeader.Modify;


        LineNum := 0;
        PaymentLine.Init;
        PaymentLine."Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", WorkDate, true);
        PaymentLine."No." := PaymentHeader."No.";
        PaymentLine."Payment Class" := PaymentHeader."Payment Class";
        LineNum := LineNum + 10000;
        PaymentLine."Line No." := LineNum;
        PaymentLine.Insert();


        PaymentLine."Account Type" := PaymentLine."Account Type"::Vendor;
        PaymentLine.Validate(PaymentLine."Account No.", Vend."No.");
        PaymentLine."Currency Code" := GenJnlLine."Currency Code";
        PaymentLine."Currency Factor" := PaymentHeader."Currency Factor";
        PaymentLine.Validate(Amount, Abs(GenJnlLine.Amount));
        PaymentLine."Drawee Reference" := CopyStr(GenJnlLine."Check No.", 1, 10);
        PaymentLine."Due Date" := GenJnlLine."Due Date";
        //PaymentLine.

        PaymentLine."Dimension Set ID" := GenJnlLine."Dimension Set ID";
        PaymentLine.Modify;


        exit(PaymentHeader."No.");
    end;

    procedure AffecterProvisionsLC(LC: Record "Letter of credit")
    var
        CurrPurchExpiry: Record "Expiry Currency Purchase";
        CurrPurch: Record "Currency Purchase";
        LCExpiry: Record "Letter of credit Expiry";
    begin

        CurrPurchExpiry.Reset;
        CurrPurchExpiry.SetRange("LC Document No.", LC."No.");
        CurrPurchExpiry.DeleteAll;

        CurrPurch.Reset;
        CurrPurch.SetCurrentKey("Document No.", "Posting Date");
        CurrPurch.SetRange("Document No.", LC."No.");
        CurrPurch.SetRange(CurrPurch."Due Line", 0);
        if CurrPurch.FindSet then
            repeat

                CurrPurch.CalcFields(Posted);
                if CurrPurch.Posted then
                    AffecterProvisionsAchat(CurrPurch, LC);

            until CurrPurch.Next = 0;
    end;

    procedure AffecterProvisionsAchat(CurrPurch: Record "Currency Purchase"; LC: Record "Letter of credit")
    var
        CurrPurchExpiry: Record "Expiry Currency Purchase";
        LCExpiry: Record "Letter of credit Expiry";
        MontantAchete: Decimal;
        ProvisionsEcheance: Decimal;
        ResteAAffecter: Decimal;
        MontantAAffecter: Decimal;
    begin

        CurrPurch.CalcFields("Affected Provisions");
        ResteAAffecter := CurrPurch."Amount Currency" - CurrPurch."Affected Provisions";

        if (ResteAAffecter <= 0) then exit;

        LCExpiry.Reset;
        LCExpiry.SetRange("Document No.", LC."No.");
        if LCExpiry.FindSet then
            repeat

                LCExpiry.CalcFields("Affected Provisions");
                ProvisionsEcheance := Round(LCExpiry."Provisions %" * LC."Provisions Amount" / 100) - LCExpiry."Affected Provisions";
                if ProvisionsEcheance > 0 then begin

                    if ResteAAffecter > ProvisionsEcheance then
                        MontantAAffecter := ProvisionsEcheance
                    else
                        MontantAAffecter := ResteAAffecter;

                    CurrPurchExpiry.Init;
                    CurrPurchExpiry."LC Document No." := LC."No.";
                    CurrPurchExpiry."Expiry Line No." := LCExpiry."Line No.";
                    CurrPurchExpiry."Purchase Line No." := CurrPurch."Line No.";
                    CurrPurchExpiry."Currency Exchange" := CurrPurch."Convertion Rate";
                    CurrPurchExpiry."Purchase Amount" := MontantAAffecter;
                    CurrPurchExpiry."Purchase Amount (LCY)" := MontantAAffecter * CurrPurchExpiry."Currency Exchange";
                    CurrPurchExpiry.Insert;

                    CurrPurch.CalcFields("Affected Provisions");
                    ResteAAffecter := CurrPurch."Amount Currency" - CurrPurch."Affected Provisions";

                end;

            until ((LCExpiry.Next = 0) or (ResteAAffecter <= 0));
    end;

    procedure SendEmailVendorTransfer(GenJnlLine: Record "Gen. Journal Line")
    var
        Vend1: Record Vendor;
        FileName: Text;
        Emplacement: Text;
        RefFile: Integer;
        //_mail: Codeunit "SMTP Mail";
        GenJnlLine3: Record "Gen. Journal Line";
        EmailObject: Text[250];
    begin

        // if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor then exit;
        // if GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Payment then exit;
        // GenJnlLine.TestField("Payment Method Code", 'VIREMENT');
        // GenJnlLine.TestField(GenJnlLine."Document No.");

        // Vend1.Get(GenJnlLine."Account No.");
        // Vend1.TestField(Vend1."E-Mail");

        // AddOnSetup.Get;
        // SMTPSetup.Get;
        // //AddOnSetup.TESTFIELD(AddOnSetup."Print Directory Setup");

        // EmailObject := GetVendorEmailObject(GenJnlLine."Payment Method Code");

        // _mail.CreateMessage(SMTPSetup."From Name", SMTPSetup."From Adress",
        //     Vend1."E-Mail", EmailObject, Text032, false);

        // Emplacement := GetEmplacementFichierVirement(GenJnlLine);

        // if not Exists(Emplacement) then exit;
        // //IF ERASE(Emplacement) THEN;



        // _mail.AddAttachment(Emplacement, FileName);
        // _mail.Send();

    end;

    procedure CreateDocEmailVendorTransfer(GenJnlLine: Record "Gen. Journal Line")
    var
        Vend1: Record Vendor;

        FileName: Text;
        Emplacement: Text;
        RefFile: Integer;
        //_mail: Codeunit "SMTP Mail";
        EmailToSend: Record "Tampon Payment Vendor Email";
        VendTransferReport: report "Avis Paiement Fournisseur";
        GenJnlLine3: Record "Gen. Journal Line";
        TmpPath: Text;
        PaymentMethod: Record "Payment Method";
        TempBlob: Codeunit "Temp Blob";
        RecordRef1: RecordRef;
        OutStream: OutStream;
        InStream: InStream;
        PDFStream: OutStream;
    begin

        exit;

        if PaymentMethod.Get(GenJnlLine."Payment Method Code") then;

        GenJnlLine.TestField("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.TestField("Document Type", GenJnlLine."Document Type"::Payment);

        if not PaymentMethod."Allow vendor email" then Error(Text027);//041023 JN

        GenJnlLine.TestField(GenJnlLine."Document No.");

        Vend1.Get(GenJnlLine."Account No.");

        AddOnSetup.Get;

        GenJnlLine3.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
        GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine3.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJnlLine3.SetRange("Posting Date", GenJnlLine."Posting Date");
        GenJnlLine3.SetRange("Document No.", GenJnlLine."Document No.");
        GenJnlLine3.SetRange("Account No.", GenJnlLine."Account No.");
        //REPORT.SaveAsPdf(50185, Emplacement, GenJnlLine3);


        EmailToSend.Init();
        EmailToSend.EntryID := EmailMgt.GetNextEntryNoInEmailRec();
        EmailToSend.EmailObject := GetVendorEmailObject(PaymentMethod.Code);

        // Create email body
        EmailToSend.BodyAsHTML := CreateEmailBody(Text032);

        EmailToSend.SendTo := Vend1."E-Mail";

        // Generate PDF report for the customer

        VendTransferReport.SetTableView(GenJnlLine3);
        EmailToSend.AttachmentFile.CreateOutStream(PDFStream);
        VendTransferReport.SaveAs('', ReportFormat::Pdf, PDFStream);



        EmailToSend.EmailType := EmailToSend.EmailType::VendorTransfer;
        EmailToSend."User ID" := UserId;
        EmailToSend."Vendor No." := Vend1."No.";
        EmailToSend."Entry Date" := Today;
        EmailToSend."Document No." := GenJnlLine3."Document No.";
        EmailToSend."Payment Method Code" := GenJnlLine3."Payment Method Code";
        EmailToSend.Amount := Abs(GenJnlLine3.Amount);
        EmailToSend.Attachment := FileMgt.GetSafeFileName(GenJnlLine."Document No." + GenJnlLine."Account No.") + '.PDF';
        if (AddOnSetup2."Email Avis Paiement" <> '') then
            EmailToSend.SendToCC := AddOnSetup2."Email Avis Paiement";

        EmailToSend.Insert(true);
    end;

    local procedure CreateEmailBody(TextContent: Text): Text
    var
        BodyText: Text;
    begin
        BodyText := '<html><body>';
        BodyText += '<p>' + TextContent + '</p>';
        // BodyText += '<p>Please find attached your detailed trial balance report.</p>';
        // BodyText += '<p>If you have any questions regarding this report, please contact your account manager.</p>';
        // BodyText += '<p>Best regards,<br>Your Company Name</p>';
        BodyText += '</body></html>';

        exit(BodyText);
    end;

    local procedure GetEmplacementFichierVirement(GenJnlLine: Record "Gen. Journal Line"): Text
    var
        TmpPath: Text;
        FileName: Text;
    begin
        // FileName := FileMgt.AFK_GetSafeFileName(GenJnlLine."Document No." + GenJnlLine."Account No.") + '.PDF';
        // TmpPath := FileMgt.AFK_GetClientTempSubDirectory();
        // //EXIT( TmpPath + '\' + FileName);
        // exit(TemporaryPath + FileName);
    end;



    procedure SendEmailVendorTransferOne(var TmpVendEmail: Record "Tampon Payment Vendor Email")
    var
    // Vend1: Record Vendor;
    // FileName: Text[250];
    // Emplacement: Text[250];
    // RefFile: Integer;
    // _mail: Codeunit "SMTP Mail";
    // GenJnlLine3: Record "Gen. Journal Line";
    // EmailObject: Text[250];
    begin
        // Vend1.Get(TmpVendEmail."Vendor No.");
        // Vend1.TestField(Vend1."E-Mail");

        // AddOnSetup.Get;
        // AddOnSetup2.Get;
        // SMTPSetup.Get;
        // //AddOnSetup.TESTFIELD(AddOnSetup."Print Directory Setup");

        // EmailObject := GetVendorEmailObject(TmpVendEmail."Payment Method Code");

        // Clear(_mail);
        // _mail.CreateMessage(SMTPSetup."From Name", SMTPSetup."From Adress",
        //     Vend1."E-Mail", EmailObject, Text032, false);

        // Emplacement := TmpVendEmail.Attachment;

        // if not Exists(Emplacement) then begin
        //     Message(Text026);
        //     exit;
        // end;

        // _mail.AddAttachment(Emplacement, FileName);

        // if (AddOnSetup2."Email Avis Paiement" <> '') then
        //     _mail.AddCC(AddOnSetup2."Email Avis Paiement");

        // //MESSAGE('%1',Vend1."E-Mail");
        // _mail.Send();

        // TmpVendEmail.Delete;
    end;

    procedure SendEmailVendorTransferAll()
    var
    // Vend1: Record Vendor;
    // FileName: Text[250];
    // Emplacement: Text[250];
    // RefFile: Integer;
    // _mail: Codeunit "SMTP Mail";
    // GenJnlLine3: Record "Gen. Journal Line";
    // TmpVendEmail: Record "Tampon Payment Vendor Email";
    // EmailObject: Text[250];
    begin

        // TmpVendEmail.Reset;
        // TmpVendEmail.SetRange(TmpVendEmail."User ID", UserId);
        // if TmpVendEmail.FindSet then
        //     repeat
        //         Vend1.Get(TmpVendEmail."Vendor No.");
        //         Vend1.TestField(Vend1."E-Mail");
        //     until TmpVendEmail.Next = 0;


        // AddOnSetup.Get;
        // AddOnSetup2.Get;
        // SMTPSetup.Get;
        // //AddOnSetup.TESTFIELD(AddOnSetup."Print Directory Setup");

        // TmpVendEmail.Reset;
        // TmpVendEmail.SetRange(TmpVendEmail."User ID", UserId);
        // if TmpVendEmail.FindSet then
        //     repeat

        //         Vend1.Get(TmpVendEmail."Vendor No.");

        //         EmailObject := GetVendorEmailObject(TmpVendEmail."Payment Method Code");

        //         Clear(_mail);
        //         _mail.CreateMessage(SMTPSetup."From Name", SMTPSetup."From Adress",
        //         Vend1."E-Mail", EmailObject, Text032, false);

        //         Emplacement := TmpVendEmail.Attachment;

        //         if (AddOnSetup2."Email Avis Paiement" <> '') then
        //             _mail.AddCC(AddOnSetup2."Email Avis Paiement");

        //         if Exists(Emplacement) then begin
        //             _mail.AddAttachment(Emplacement, FileName);
        //             _mail.Send();
        //             TmpVendEmail.Delete;
        //         end;

        //     until TmpVendEmail.Next = 0;
    end;

    local procedure GetVendorEmailObject(PaymentMethodCode: Code[10]): Text[250]
    begin
        if PaymentMethodCode = 'CHEQUES' then
            exit(Text028);

        if PaymentMethodCode = 'ESPECES' then
            exit(Text030);

        if PaymentMethodCode = 'TRAITES' then
            exit(Text031);

        if PaymentMethodCode = 'VIREMENT' then
            exit(Text029);

        exit(Text029);
    end;


    procedure GetGainLossAccount_PROGAL(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"): Code[20]
    begin
        AddOnSetup.Get;
        case DtldCVLedgEntryBuf."Entry Type" of
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss":
                begin
                    AddOnSetup.TestField("PROGAL Unrealized Losses Acc.");
                    exit(AddOnSetup."PROGAL Unrealized Losses Acc.");
                end;
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain":
                begin
                    AddOnSetup.TestField("PROGAL Unrealized Gains Acc.");
                    exit(AddOnSetup."PROGAL Unrealized Gains Acc.");
                end;
            DtldCVLedgEntryBuf."Entry Type"::"Realized Loss":
                begin
                    AddOnSetup.TestField("PROGAL Realized Losses Acc.");
                    exit(AddOnSetup."PROGAL Realized Losses Acc.");
                end;
            DtldCVLedgEntryBuf."Entry Type"::"Realized Gain":
                begin
                    AddOnSetup.TestField("PROGAL Realized Gains Acc.");
                    exit(AddOnSetup."PROGAL Realized Gains Acc.");
                end;
            else
                Error(IncorrectEntryTypeErr, DtldCVLedgEntryBuf."Entry Type");
        end;
    end;


    procedure AFK_ProcessFeuilleReglementCCL(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine3: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        AFK_GLMgt: codeunit "Treso Mgt";
        DocNo: Code[20];
        TextAFKErr002: label 'Cette option n''est plus disponible !';
    begin

        //**********************************************************
        //**********************************************************
        //**********************************************************
        //**********************************************************

        // if TempGenJnlLine.Find('-') then
        //     repeat

        //IF TempGenJnlLine."CC Document Type"=TempGenJnlLine."CC Document Type"::" " THEN EXIT;
        GenJnlLine3 := GenJnlLine;
        GenJournalLine2.Copy(GenJnlLine3);

        if GenJnlLine3."CC Document Type" = GenJnlLine3."CC Document Type"::ChequeCaution then begin
            Error(TextAFKErr002);
            //   AFK_GLMgt.CreateNewPaymentDoc(GenJnlLine3);
            //   AFK_CreateNDChequeGarantie(GenJournalLine2);
        end;

        if GenJnlLine3."CC Document Type" = GenJnlLine3."CC Document Type"::ChequeNormal then
            AFK_GLMgt.CreateNewPaymentDoc(GenJnlLine3);

        if GenJnlLine3."CC Document Type" = GenJnlLine3."CC Document Type"::Traite then
            AFK_GLMgt.CreateNewPaymentDoc(GenJnlLine3);

        if GenJnlLine3."CC Document Type" = GenJnlLine3."CC Document Type"::Virement then begin
            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::Customer then
                AFK_GLMgt.CreateNewPaymentDoc(GenJnlLine3);
            if GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::"Bank Account" then //JN231019 Vir from Treso
                AFK_GLMgt.CreateNewPaymentDoc_VirementFromTreso(GenJnlLine3);//***
        end;

        if GenJnlLine3."CC Document Type" = GenJnlLine3."CC Document Type"::Especes then
            AFK_GLMgt.CreateNewPaymentDoc(GenJnlLine3);

        if GenJnlLine3."CC Document Type" = GenJnlLine3."CC Document Type"::ChequeGarantie then
            AFK_GLMgt.CreateChequeGarantie(GenJnlLine3);



        //Traite fournisseur
        if (GenJnlLine3."Account Type" = GenJnlLine3."Account Type"::Vendor) and (GenJnlLine3."Payment Method Code" <> '') then begin
            AFK_GLMgt.CreateNewPaymentDocVendor(GenJnlLine3);
            //IF SendVendorEmails_AFK THEN
            //  AFKTresoMgt.SendEmailVendorTransfer(GenJnlLine3);//Envoi manuel
        end;

        //until TempGenJnlLine.Next = 0;

    end;



}

