codeunit 50020 "Purchase Requisition Mgt"
{
    // //JN241117 Ajouter un statut de traitement


    trigger OnRun()
    begin
    end;

    var
        ArchiveManagement: Codeunit ArchiveManagement;
        AddOnSetup: Record "AddOn Setup";
        Text002: Label 'Le document n''a aucune ligne';
        Text003: Label 'Souhaitez-vous clôturer le document d''achat ? Cliquez sur Oui s''il s''agit de la dernière offre retenue pour cet achat.';
        Text004: Label 'Vous devez créer un code affaire pour traiter cette commande';
        Text005: Label 'Le code affaire a été crée !';
        Selection: Integer;
        Text006: Label '&Envoyer en validation';
        Text007: Label '&Valider,&Renvoyer en saisie';
        UOMMgt: Codeunit "Unit of Measure Management";
        Text008: Label 'Groupes de comptabilisation non définis sur la ligne commande %1 - %2 - (%3 - %4)';
        Text009: Label 'Groupes de comptabilisation non définis sur la ligne requisition achat %1 - %2';
        Text010: Label 'Souhaitez-vous clôturer le document d''achat ?';
        FASetup: Record "FA Setup";
        Text011: Label 'Le compte d''achat est invalide sur la ligne %1';
        Text012: Label 'Code budget non renseigné sur la ligne %1';
        Text013: Label 'Vous ne pouvez pas solder cette commande car la quantité recue n''a pas été completement été facturée pour l''article %1';
        Text014: Label 'Souhaitez-vous solder cette commande d''achat : %1 ?';
        Text015: Label 'Veuillez saisir un motif pour le rejet !';
        SendMail: Codeunit EmailMgt;
        Text028: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text029: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text030: Label 'The dimensions used in %1 %2 are invalid. %3';
        Text031: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text032: Label 'Cette demande d''achat a déjà été complètement traitée.';
        Text001: Label 'is not within your range of allowed posting dates';
        AFKGLMgt: Codeunit "GL Mgt";
        SetupRecordID: RecordID;

    procedure TraiterDoc(var PurchReq: Record "Purchase Requisition")
    begin

        if PurchReq.Status=PurchReq.Status::Open then begin
          Selection := StrMenu(Text006,1);
          if Selection = 0 then exit;
          if Selection = 1 then EnvoyerValidationDoc(PurchReq);
          //IF Selection = 2 THEN SupprimerCde(PurchReq);
          exit;
        end;

        if PurchReq.Status=PurchReq.Status::CDG then begin
          Selection := StrMenu(Text007,1);
          if Selection = 0 then exit;
          if Selection = 1 then ValiderCDG(PurchReq);
          if Selection = 2 then RenvoyerDoc(PurchReq);
          exit;
        end;

        if PurchReq.Status=PurchReq.Status::Manager then begin
          Selection := StrMenu(Text007,1);
          if Selection = 0 then exit;
          if Selection = 1 then ValiderManager(PurchReq);
          if Selection = 2 then RenvoyerDoc(PurchReq);
          exit;
        end;
    end;

    local procedure ValiderCDG(var PurchReq: Record "Purchase Requisition")
    begin

        CheckDim(PurchReq);

        PurchReq.Status := PurchReq.Status::Manager;
        PurchReq."CDG Validation" := Today;
        PurchReq."CDG User" := UserId;
        PurchReq.Modify;


        Commit;
        SendMail.SendMailValidationCDG(PurchReq);
    end;

    local procedure ValiderManager(var PurchReq: Record "Purchase Requisition")
    begin

        PurchReq.Status := PurchReq.Status::Validated;
        PurchReq."Manager Validation" := Today;
        PurchReq."Manager User" := UserId;
        PurchReq.Modify;

        Commit;
        SendMail.SendMailValidationResp(PurchReq);
    end;

    local procedure EnvoyerValidationDoc(var PurchReq: Record "Purchase Requisition")
    var
        SRLine: Record "Purchase Requisition Line";
    begin


        //PurchReq.TESTFIELD("Direction Code");
        //PurchReq.TESTFIELD(PurchReq."Service Code");
        //PurchReq.TESTFIELD(PurchReq."Department Code");
        //PurchReq.TESTFIELD(PurchReq.Description);

        PurchReq.TestField(PurchReq."PR Type");
        PurchReq.TestField(PurchReq."PO Type");
        PurchReq.TestField(PurchReq."Requested Receipt Date");

        SRLine.Reset;
        SRLine.SetRange("Document No",PurchReq."No.");
        if SRLine.IsEmpty then Error(Text002);

        PurchReq.Status := PurchReq.Status::CDG;
        PurchReq."User Validation" := Today;
        PurchReq.Modify;

        Commit;
        SendMail.SendMailEnvoyerValidation(PurchReq);
    end;

    local procedure RenvoyerDoc(var PurchReq: Record "Purchase Requisition")
    begin
        //PurchReq.TESTFIELD(PurchReq."Return Reason");
        if PurchReq."Return Reason"='' then Error(Text015);
        PurchReq.Status := PurchReq.Status::Open;
        PurchReq.Modify;

        Commit;
        SendMail.SendRenvoi(PurchReq);
    end;

    procedure CreateOpenNewOffer(SRDoc: Record "Purchase Requisition")
    var
        PurchQuoteH: Record "Purchase Header";
        QuoteCard: Page "Purchase Quote";
        SRLine: Record "Purchase Requisition Line";
    begin

        //SRDoc.TESTFIELD("Code Projet");
        //IF SRDoc."Purchase Type"=SRDoc."Purchase Type"::AchatMarchandise THEN
        //  SRDoc.TESTFIELD(SRDoc."Shortcut Dimension 1 Code");

        SRDoc.TestField(SRDoc.Status,SRDoc.Status::Validated);

        SRLine.Reset;
        SRLine.SetRange(SRLine."Document No",SRDoc."No.");
        if SRLine.IsEmpty then Error(Text002);

        if DDATotalementFacturee(SRDoc) then
          Error(Text032);


        Clear(PurchQuoteH);
        PurchQuoteH."Document Type" := PurchQuoteH."Document Type"::Quote;
        PurchQuoteH."Code Demande" := SRDoc."No.";
        PurchQuoteH."Requested Receipt Date":=SRDoc."Requested Receipt Date";
        PurchQuoteH."PR Type":= SRDoc."PR Type";
        PurchQuoteH."PO Type" := SRDoc."PO Type";
        PurchQuoteH.Observations := SRDoc.Description;
        //PurchQuoteH."Sales Order Ref":=SRDoc."Origin Doc No";
        PurchQuoteH."No." := '';
        PurchQuoteH.Insert(true);

        //PurchQuoteH.MODIFY(TRUE);


        QuoteCard.SetTableView(PurchQuoteH);
        QuoteCard.SetRecord(PurchQuoteH);
        QuoteCard.Run;
    end;

    procedure CreateLinesOffer(var Devis: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        SRLine: Record "Purchase Requisition Line";
        LineNo: Integer;
        SRDoc: Record "Purchase Requisition";
        QteRestante: Decimal;
    begin
        if Devis."Document Type"<>Devis."Document Type"::Quote then exit;
        if Devis."Code Demande"='' then exit;

        SRDoc.Get(Devis."Code Demande");
        Devis."Code Budget" := SRDoc."Budget Code";
        Devis."Purchase Type" := SRDoc."Purchase Type";
        Devis."Purchaser Code" := SRDoc."Purchaser Code";

        if Devis."Purchaser Code"='' then
          Devis."Purchaser Code" := GetUserPurchaseCode(UserId);

        //Devis.Description := SRDoc.Description;
        Devis.Validate("Shortcut Dimension 1 Code" , SRDoc."Shortcut Dimension 1 Code");
        Devis.Validate("Shortcut Dimension 2 Code" , SRDoc."Shortcut Dimension 2 Code");
        Devis."Dimension Set ID" := SRDoc."Dimension Set ID";
        Devis.Validate("Expected Receipt Date",SRDoc."Requested Receipt Date");

        Devis.Modify(true);
        Devis.TestField(Devis."Buy-from Vendor No.");

        PurchLine.Reset;
        PurchLine.SetRange(PurchLine."Document Type",PurchLine."Document Type"::Quote);
        PurchLine.SetRange(PurchLine."Document No.", Devis."No.");
        if not PurchLine.IsEmpty then exit;

        LineNo:= 10000;
        SRLine.Reset;
        SRLine.SetRange(SRLine."Document No",Devis."Code Demande");
        if SRLine.FindSet then
        repeat
          PurchLine.Init;
          PurchLine."Document Type":=PurchLine."Document Type"::Quote;
          PurchLine."Document No.":=Devis."No.";
          PurchLine."Line No." := LineNo;
          LineNo:=LineNo+10000;

          //PurchLine.Type:=SRLine.Type;
          if SRLine.Type=SRLine.Type::" " then PurchLine.Type:=PurchLine.Type::" ";
          if SRLine.Type=SRLine.Type::Item then PurchLine.Type:=PurchLine.Type::Item;
          if SRLine.Type=SRLine.Type::"Fixed Asset" then PurchLine.Type:=PurchLine.Type::"Fixed Asset";
          if SRLine.Type=SRLine.Type::"G/L Account" then PurchLine.Type:=PurchLine.Type::"G/L Account";
          if SRLine.Type=SRLine.Type::"Item Charge" then PurchLine.Type:=PurchLine.Type::"Charge (Item)";

          if SRLine.Type<>SRLine.Type::" " then
            PurchLine.Validate("No.",SRLine."No.");
          PurchLine.Description:=SRLine.Description;
          PurchLine."Dimension Set ID" := SRLine."Dimension Set ID";

          PurchLine."Purch Req No." := SRLine."Document No";
          PurchLine."Purch Req Line No." := SRLine."Line No.";

          if SRLine.Type<>SRLine.Type::" " then begin
            QteRestante := UOMMgt.CalcQtyFromBase(SRLine."Quantity (Base)"-SRLine."Ordered Quantity (Base)",SRLine."Qty. per Unit of Measure");
            PurchLine.Validate(Quantity ,QteRestante);
            PurchLine.Validate("Unit of Measure Code",SRLine."Unit Code");
            PurchLine.Validate("Direct Unit Cost",0);
          end;
          //PurchLine.VALIDATE("Direct Unit Cost",SRLine."Prix Unitaire");
          //PurchLine."Code Nature":=SRLine."Nature code";
          //PurchLine."Code projet":=SRLine."Project Code";
          //PurchLine."Serial No." := SRLine."Serial No.";
          //PurchLine."Item Ref" := SRLine."Item Ref";
          if (SRLine.Type=SRLine.Type::" ") then
            PurchLine.Insert(true)
          else
            if QteRestante>0 then
              PurchLine.Insert(true);

        until SRLine.Next=0;

        //Devis.MODIFY;//Raffraichir le formulaire ?
    end;

    procedure CloturerDemande(var SRequisition: Record "Purchase Requisition";TypeDocCree: Option Commande,Contrat;CodeDocCree: Code[20];CodeOffreRetenue: Code[20])
    var
        EnteteOffre: Record "Purchase Header";
        SRLine: Record "Purchase Requisition Line";
        PostedServiceRequisition: Record "Posted Purchase Requisition";
        PurchQuoteLine: Record "Purchase Line";
        PostedLineServR: Record "Posted Purch Requisition Line";
    begin

        SRequisition.TestField(Status,SRequisition.Status::Validated);

        if not Confirm(Text010) then exit;

        //Archiver toutes les offres fournisseur

        EnteteOffre.Reset;
        EnteteOffre.SetRange(EnteteOffre."Document Type",EnteteOffre."Document Type"::Quote);
        EnteteOffre.SetRange(EnteteOffre."Code Demande",SRequisition."No.");
        if EnteteOffre.FindSet then
        repeat
          //IF (EnteteOffre."No."<>CodeOffreRetenue) THEN
          //  ArchiveMgt.StorePurchDocument(EnteteOffre,FALSE);
          ArchiveManagement.ArchPurchDocumentNoConfirm(EnteteOffre);

          //Supprimer les autres offres de service
          if (EnteteOffre."No."<>CodeOffreRetenue) then begin

              PurchQuoteLine.Reset;
              PurchQuoteLine.SetRange("Document Type",PurchQuoteLine."Document Type"::Quote);
              PurchQuoteLine.SetRange("Document No.",EnteteOffre."No.");
              PurchQuoteLine.DeleteAll;

              EnteteOffre.DeleteLinks;
              EnteteOffre.Delete(true);
          end;

        until EnteteOffre.Next=0;



        //Archiver la demande de service
        PostedServiceRequisition.Init;
        PostedServiceRequisition.TransferFields(SRequisition);

        PostedServiceRequisition."Created Doc Type":=PostedServiceRequisition."Created Doc Type"::Commande;
        PostedServiceRequisition."Created Doc Code" := CodeDocCree;
        PostedServiceRequisition.Status := PostedServiceRequisition.Status::Validated;
        PostedServiceRequisition."Closed Date" := Today;
        PostedServiceRequisition."Closed By" := UserId;

        PostedServiceRequisition.CopyLinks(SRequisition);
        PostedServiceRequisition.Insert;


        SRLine.Reset;
        SRLine.SetRange("Document No",SRequisition."No.");
        if SRLine.FindSet then repeat
          //IF SRLine."No."<>'' THEN
          //  SRLine.TESTFIELD(SRLine."Code Nature");
          PostedLineServR.TransferFields(SRLine);
          PostedLineServR.Insert;
        until SRLine.Next=0;



        SRLine.Reset;
        SRLine.SetRange(SRLine."Document No",SRequisition."No.");
        SRLine.DeleteAll;

        SRequisition.DeleteLinks;
        SRequisition.Delete(true);
    end;

    procedure GetPurchAcc(PurchLine: Record "Purchase Line"): Code[20]
    var
        FAPostingGroup: Record "FA Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        Immo: Record "Fixed Asset";
        FADepreciationGroup: Record "FA Depreciation Book";
    begin
        //IF PurchLine.Type=PurchLine.Type::" " THEN
        //  EXIT('');

        if PurchLine.Type=PurchLine.Type::"G/L Account" then
          exit(PurchLine."No.");

        if PurchLine.Type=PurchLine.Type::"Fixed Asset" then begin
          FADepreciationGroup.Get(PurchLine."No.",PurchLine."Depreciation Book Code");
          FADepreciationGroup.TestField("FA Posting Group");
          FAPostingGroup.Get(FADepreciationGroup."FA Posting Group");
          FAPostingGroup.TestField("Acquisition Cost Account");
          exit(FAPostingGroup."Acquisition Cost Account");
        end;

        if not GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group") then
           Error(Text008,PurchLine."Document No.",PurchLine."Line No.",PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");


        if PurchLine."Document Type" in [PurchLine."Document Type"::"Return Order",PurchLine."Document Type"::"Credit Memo"] then begin
          GenPostingSetup.TestField("Purch. Credit Memo Account");
          exit(GenPostingSetup."Purch. Credit Memo Account");
        end else begin
          GenPostingSetup.TestField("Purch. Account");
          exit(GenPostingSetup."Purch. Account");
        end;
    end;

    procedure GetPurchAccFromReq(PurchLine: Record "Purchase Requisition Line";PurchReqH: Record "Purchase Requisition"): Code[20]
    var
        FAPostingGroup: Record "FA Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        Immo: Record "Fixed Asset";
        FADepreciationGroup: Record "FA Depreciation Book";
        LoiAmort: Code[20];
    begin
        //IF PurchLine.Type=PurchLine.Type::" " THEN
        //  EXIT('');

        if PurchLine.Type=PurchLine.Type::"G/L Account" then
          exit(PurchLine."No.");

        if PurchLine.Type=PurchLine.Type::"Fixed Asset" then begin
          FASetup.Get;
          LoiAmort := FASetup."Default Depr. Book";
          FADepreciationGroup.Get(PurchLine."No.",LoiAmort);
          FADepreciationGroup.TestField("FA Posting Group");
          FAPostingGroup.Get(FADepreciationGroup."FA Posting Group");
          FAPostingGroup.TestField("Acquisition Cost Account");
          exit(FAPostingGroup."Acquisition Cost Account");
        end;

        PurchReqH.TestField("Gen. Bus. Posting Group");
        if not GenPostingSetup.Get(PurchReqH."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group") then
           Error(Text009,PurchLine."Document No",PurchLine."Line No.");


        //IF PurchLine."Document Type" IN [PurchLine."Document Type"::"Return Order",PurchLine."Document Type"::"Credit Memo"] THEN BEGIN
        //  GenPostingSetup.TESTFIELD("Purch. Credit Memo Account");
        //  EXIT(GenPostingSetup."Purch. Credit Memo Account");
        //END ELSE BEGIN
          GenPostingSetup.TestField("Purch. Account");
          exit(GenPostingSetup."Purch. Account");
        //END;
    end;

    procedure GetSalesAcc(SalesLine: Record "Sales Line"): Code[20]
    var
        FAPostingGroup: Record "FA Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        Immo: Record "Fixed Asset";
        FADepreciationGroup: Record "FA Depreciation Book";
    begin
        if SalesLine.Type=SalesLine.Type::" " then
          exit('');

        if SalesLine.Type=SalesLine.Type::"G/L Account" then
          exit(SalesLine."No.");

        if SalesLine.Type=SalesLine.Type::"Fixed Asset" then begin
          FADepreciationGroup.Get(SalesLine."No.",SalesLine."Depreciation Book Code");
          FADepreciationGroup.TestField("FA Posting Group");
          FAPostingGroup.Get(FADepreciationGroup."FA Posting Group");
          FAPostingGroup.TestField(FAPostingGroup."Book Val. Acc. on Disp. (Gain)");
          exit(FAPostingGroup."Acquisition Cost Account");
        end;



        if not GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group")
          then Error(Text008,SalesLine."Document No.",SalesLine."Line No.");

        if SalesLine."Document Type" in [SalesLine."Document Type"::"Return Order",SalesLine."Document Type"::"Credit Memo"] then begin
          GenPostingSetup.TestField(GenPostingSetup."Sales Credit Memo Account");
          exit(GenPostingSetup."Sales Credit Memo Account");
        end else begin
          GenPostingSetup.TestField(GenPostingSetup."Sales Account");
          exit(GenPostingSetup."Sales Account");
        end;
    end;

    procedure GetPrecommitmentAmt(GLAccNo: Code[20];CodeBudget: Code[20];CodeDocToExclude: Code[20];DateDeb: Date;DateFin: Date) ReturnAmt: Decimal
    var
        PurchHeader: Record "Purchase Header";
    begin

        PurchHeader.Reset;
        PurchHeader.SetFilter(PurchHeader.Status,'%1|%2',PurchHeader.Status::Released,PurchHeader.Status::"Pending Prepayment");
        if DateDeb<>0D then PurchHeader.SetRange("Posting Date",DateDeb,DateFin);
        if PurchHeader.FindSet then
        repeat
          if CodeDocToExclude<>'' then begin
            if PurchHeader."No."<>CodeDocToExclude then
              ReturnAmt:=ReturnAmt+GetDocAmount(GLAccNo,CodeBudget,PurchHeader);
          end else begin
            ReturnAmt:=ReturnAmt+GetDocAmount(GLAccNo,CodeBudget,PurchHeader);
          end;
        until PurchHeader.Next=0;
    end;

    procedure GetDocAmount(GLAccNo: Code[20];CodeBudget: Code[20];PurchHeader: Record "Purchase Header") ReturnAmt: Decimal
    var
        PurchLine: Record "Purchase Line";
        LineAmt: Decimal;
    begin

        PurchLine.Reset;
        PurchLine.SetRange("Document Type",PurchHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchHeader."No.");
        if PurchLine.FindSet then
        repeat
          if ((PurchLine."Purchase Account"=GLAccNo) and (PurchLine."Shortcut Dimension 1 Code"=CodeBudget)) then begin
              LineAmt := PurchLine."Direct Unit Cost"*(PurchLine.Quantity-PurchLine."Quantity Invoiced");
              ReturnAmt:=ReturnAmt + ConvertAmtLCY(PurchHeader."Document Date",LineAmt,PurchHeader."Currency Code");
          end;
        until PurchLine.Next=0;
    end;

    procedure CreatePurchaseBudgetLines(PurchaseH: Record "Purchase Header")
    var
        BudgetLine: Record "Purchase Budget Line";
        PurchLine: Record "Purchase Line";
        OldAcc: Code[20];
        OldAccAmt: Decimal;
        HaveLines: Boolean;
        NewAcc: Code[20];
        GLAcc: Record "G/L Account";
        DateDeb: Date;
        DateFin: Date;
        OldCodeBudget: Code[20];
        NewCodeBudget: Code[20];
    begin

        GetPeriod(PurchaseH."Document Date",DateDeb,DateFin);
        //MESSAGE('%1 - %2',DateDeb,DateFin);

        Clear(BudgetLine);
        BudgetLine.SetRange("Document Type",PurchaseH."Document Type");
        BudgetLine.SetRange("Document No.",PurchaseH."No.");
        BudgetLine.DeleteAll;

        PurchLine.Reset;
        PurchLine.SetCurrentKey("Purchase Account","Shortcut Dimension 1 Code");
        PurchLine.SetRange("Document Type",PurchaseH."Document Type");
        PurchLine.SetRange("Document No.",PurchaseH."No.");
        if PurchLine.FindSet then
          OldAcc := PurchLine."Purchase Account";
          OldCodeBudget := PurchLine."Shortcut Dimension 1 Code";
        repeat

          NewAcc := PurchLine."Purchase Account";
          NewCodeBudget := PurchLine."Shortcut Dimension 1 Code";
          CheckData(NewAcc,NewCodeBudget,PurchLine."Line No.");

          if ((OldAcc<>NewAcc) or (OldCodeBudget<>NewCodeBudget)) then begin
            Clear(BudgetLine);
            BudgetLine."Document Type" := PurchaseH."Document Type";
            BudgetLine."Document No." := PurchaseH."No.";
            BudgetLine."G/L Account No" := OldAcc;
            BudgetLine."Global Dimension 1" := OldCodeBudget;
            if GLAcc.Get(OldAcc) then BudgetLine."G/L Account Name":=GLAcc.Name;

            CalcValuesBudget(BudgetLine,PurchaseH."Document Date",PurchaseH."No.",OldAcc,OldCodeBudget);

            if OldAcc<>'' then BudgetLine.Insert;
            OldAcc := PurchLine."Purchase Account";
            OldCodeBudget := PurchLine."Shortcut Dimension 1 Code";
            OldAccAmt:=ConvertAmtLCY(PurchaseH."Document Date",PurchLine."Line Amount",PurchaseH."Currency Code");
          end else begin
            OldAccAmt := OldAccAmt + ConvertAmtLCY(PurchaseH."Document Date",PurchLine."Line Amount",PurchaseH."Currency Code");
          end;
          HaveLines:=true;
        until PurchLine.Next=0;

        //Derniere ligne
        if HaveLines then begin
          Clear(BudgetLine);
          BudgetLine."Document Type" := PurchaseH."Document Type";
          BudgetLine."Document No." := PurchaseH."No.";
          BudgetLine."G/L Account No" := OldAcc;

          if GLAcc.Get(OldAcc) then BudgetLine."G/L Account Name":=GLAcc.Name;
          BudgetLine."Global Dimension 1" := OldCodeBudget;
          BudgetLine."Document Amount" := OldAccAmt;

          CalcValuesBudget(BudgetLine,PurchaseH."Document Date",PurchaseH."No.",OldAcc,OldCodeBudget);

           //IF (BudgetLine."Remaining Amount"<0) THEN BudgetLine."Remaining Amount":=0;

          if OldAcc<>'' then BudgetLine.Insert;
        end;
    end;

    procedure CreatePurchaseBudgetLinesFromReq(PurchaseH: Record "Purchase Requisition")
    var
        BudgetLine: Record "Purchase Budget Line";
        PurchLine: Record "Purchase Requisition Line";
        OldAcc: Code[20];
        OldAccAmt: Decimal;
        HaveLines: Boolean;
        NewAcc: Code[20];
        GLAcc: Record "G/L Account";
        DateDeb: Date;
        DateFin: Date;
        OldCodeBudget: Code[20];
        NewCodeBudget: Code[20];
    begin

        GetPeriod(PurchaseH."Creation Date",DateDeb,DateFin);
        //MESSAGE('%1 - %2',DateDeb,DateFin);

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Code Budget Def");

        Clear(BudgetLine);
        BudgetLine.SetRange("Document Type",BudgetLine."Document Type"::Requisition);
        BudgetLine.SetRange("Document No.",PurchaseH."No.");
        BudgetLine.DeleteAll;

        PurchLine.Reset;
        PurchLine.SetCurrentKey("Purchase Account","Shortcut Dimension 1 Code");
        //PurchLine.SETRANGE("Document Type",BudgetLine."Document Type"::Requisition);
        PurchLine.SetRange("Document No",PurchaseH."No.");
        if PurchLine.FindSet then
          OldAcc := PurchLine."Purchase Account";
          OldCodeBudget := PurchLine."Shortcut Dimension 1 Code";
        repeat
          NewAcc := PurchLine."Purchase Account";
          NewCodeBudget := PurchLine."Shortcut Dimension 1 Code";
          CheckData(NewAcc,NewCodeBudget,PurchLine."Line No.");

          if ((OldAcc<>NewAcc) or (OldCodeBudget<>NewCodeBudget)) then begin
            Clear(BudgetLine);
            BudgetLine."Document Type" := BudgetLine."Document Type"::Requisition;
            BudgetLine."Document No." := PurchaseH."No.";
            BudgetLine."G/L Account No" := OldAcc;
            BudgetLine."Global Dimension 1" := OldCodeBudget;
            if GLAcc.Get(OldAcc) then BudgetLine."G/L Account Name":=GLAcc.Name;

            BudgetLine."Document Amount" := OldAccAmt;

            CalcValuesBudget(BudgetLine,PurchaseH."Creation Date",PurchaseH."No.",OldAcc,OldCodeBudget);


            if OldAcc<>'' then BudgetLine.Insert;
            OldAcc := PurchLine."Purchase Account";
            OldCodeBudget := PurchLine."Shortcut Dimension 1 Code";
            //OldAccAmt:=ConvertAmtLCY(PurchaseH."Creation Date",PurchLine."Line Amount",PurchaseH."Currency Code");
          end else begin
            //OldAccAmt := OldAccAmt + ConvertAmtLCY(PurchaseH."Document Date",PurchLine."Line Amount",PurchaseH."Currency Code");
          end;

          HaveLines:=true;
        until PurchLine.Next=0;


        //Derniere ligne
        if HaveLines then begin
          Clear(BudgetLine);
          BudgetLine."Document Type" := BudgetLine."Document Type"::Requisition;
          BudgetLine."Document No." := PurchaseH."No.";
          BudgetLine."G/L Account No" := OldAcc;

          if GLAcc.Get(OldAcc) then BudgetLine."G/L Account Name":=GLAcc.Name;
          BudgetLine."Global Dimension 1" := OldCodeBudget;
          BudgetLine."Commitment Amount" := GetPrecommitmentAmt(OldAcc,OldCodeBudget,PurchaseH."No.",DateDeb,DateFin);
          BudgetLine."Document Amount" := OldAccAmt;

          CalcValuesBudget(BudgetLine,PurchaseH."Creation Date",PurchaseH."No.",OldAcc,OldCodeBudget);

          if OldAcc<>'' then BudgetLine.Insert;
        end;
    end;

    procedure ConvertAmtLCY(PostingDate: Date;ForeignAmt: Decimal;CurrencyCode: Code[10]): Decimal
    var
        CurrencyFactor: Decimal;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if CurrencyCode<>'' then begin
           Currency.Get(CurrencyCode);
           CurrencyFactor := CurrExchRate.ExchangeRate(PostingDate,CurrencyCode);
        end;

        if CurrencyCode<>'' then begin
           exit(
             Round(CurrExchRate.ExchangeAmtFCYToLCY(PostingDate,CurrencyCode,ForeignAmt,CurrencyFactor)
             , Currency."Amount Rounding Precision"));
        end else begin
          exit(ForeignAmt);
        end;
    end;

    procedure GetPeriod(DateRef: Date;var DateDeb: Date;var DateFin: Date)
    begin
        AddOnSetup.Get;

        if AddOnSetup."Budget Period"=AddOnSetup."Budget Period"::None then begin
          DateDeb := 0D;
          DateFin := 0D;
        end;

        if AddOnSetup."Budget Period"=AddOnSetup."Budget Period"::Year then begin
          DateDeb := DMY2Date(1,1,Date2DMY(DateRef,3));
          DateFin := DMY2Date(31,12,Date2DMY(DateRef,3));
        end;

        if AddOnSetup."Budget Period"=AddOnSetup."Budget Period"::Month then begin
          DateDeb := DMY2Date(1,Date2DMY(DateRef,2),Date2DMY(DateRef,3));
          DateFin := CalcDate('<1M>',DateRef);
        end;
    end;

    procedure GetUserPurchaseCode(UserID: Code[50]): Code[20]
    begin
        /*
        UserSetup2.RESET;
        UserSetup2.SETRANGE(UserSetup2."User ID",UserID);
        IF UserSetup2.FINDSET THEN
        REPEAT
          IF UserSetup2."Salespers./Purch. Code"<>'' THEN
            EXIT(UserSetup2."Salespers./Purch. Code");
        UNTIL UserSetup2.NEXT=0;
        */

    end;

    local procedure CalcQtyUnite(QtyBase: Decimal;CodeUnite: Code[10])
    begin

        //UOMMgt.CalcQtyFromBase(
    end;

    procedure GetPeriodDates(DateRef: Date;Type: Integer;var DateDeb: Date;var DateFin: Date)
    var
        DebutMois: Date;
    begin

        //Month
        if Type=1 then begin
            DateDeb := DMY2Date(1,Date2DMY(DateRef,2),Date2DMY(DateRef,3));
            DateFin := CalcDate('<1M-1D>',DateDeb);
        end;

        //Acc
        if Type=2 then begin
          DateDeb := DMY2Date(1,1,Date2DMY(DateRef,3));
          DebutMois := DMY2Date(1,Date2DMY(DateRef,2),Date2DMY(DateRef,3));
          DateFin := CalcDate('<1M-1D>',DebutMois);
        end;

        //Year
        if Type=3 then begin
            DateDeb := DMY2Date(1,1,Date2DMY(DateRef,3));
            DateFin := DMY2Date(31,12,Date2DMY(DateRef,3));
        end;
    end;

    local procedure CalcValuesBudget(var BudgetLine: Record "Purchase Budget Line";DateRef: Date;CurrOrderNo: Code[20];GLAcc: Code[20];CodeBudget: Code[20])
    var
        DateDeb: Date;
        DateFin: Date;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Code Budget Def");

        //Month
        GetPeriodDates(DateRef,1,DateDeb,DateFin);
        if CodeBudget<>'' then
          BudgetLine.SetFilter("Global Dimension 1 Filter",'%1',CodeBudget);
        BudgetLine.SetFilter("Budget Filter",'%1', AddOnSetup."Code Budget Def");
        BudgetLine.SetFilter("Date Filter",'%1..%2',DateDeb,DateFin);
        BudgetLine.CalcFields("Net Change","Budgeted Amount");

        BudgetLine."Monthly Budgeted Amt" := BudgetLine."Budgeted Amount";
        BudgetLine."Monthly Commitment" := GetPrecommitmentAmt(GLAcc,CodeBudget,CurrOrderNo,DateDeb,DateFin);
        BudgetLine."Monthly Realized Amt" := BudgetLine."Net Change";
        BudgetLine."Monthly Available Amt" := (BudgetLine."Monthly Budgeted Amt")-
              (BudgetLine."Monthly Commitment"+BudgetLine."Monthly Realized Amt");


        //Acc
        GetPeriodDates(DateRef,2,DateDeb,DateFin);
        if CodeBudget<>'' then
          BudgetLine.SetFilter("Global Dimension 1 Filter",'%1',CodeBudget);
        BudgetLine.SetFilter("Budget Filter",'%1', AddOnSetup."Code Budget Def");
        BudgetLine.SetFilter("Date Filter",'%1..%2',DateDeb,DateFin);
        BudgetLine.CalcFields("Net Change","Budgeted Amount");

        BudgetLine."Acc Budgeted Amt" := BudgetLine."Budgeted Amount";
        BudgetLine."Acc Commitment" := GetPrecommitmentAmt(GLAcc,CodeBudget,CurrOrderNo,DateDeb,DateFin);
        BudgetLine."Acc Realized Amt" := BudgetLine."Net Change";
        BudgetLine."Acc Available Amt" := (BudgetLine."Acc Budgeted Amt")-
              (BudgetLine."Acc Commitment"+BudgetLine."Acc Realized Amt");


        //Year
        GetPeriodDates(DateRef,3,DateDeb,DateFin);
        if CodeBudget<>'' then
          BudgetLine.SetFilter("Global Dimension 1 Filter",'%1',CodeBudget);
        BudgetLine.SetFilter("Budget Filter",'%1', AddOnSetup."Code Budget Def");
        BudgetLine.SetFilter("Date Filter",'%1..%2',DateDeb,DateFin);
        BudgetLine.CalcFields("Net Change","Budgeted Amount");

        BudgetLine."Yearly Budgeted Amt" := BudgetLine."Budgeted Amount";
    end;

    local procedure CheckData(GLAcc: Code[20];CodeBudget: Code[20];LineNo: Integer)
    begin

        if GLAcc='' then Error(Text011,LineNo);
        if CodeBudget='' then Error(Text012,LineNo);
    end;

    procedure RefreshRemainingQtyReq(var PurchReq: Record "Purchase Requisition")
    var
        PurchReqLine: Record "Purchase Requisition Line";
        QtyInOrder: Decimal;
        QtyInvoiced: Decimal;
        PartiallyProcess: Boolean;
        TotallyProcess: Boolean;
    begin
        PartiallyProcess := false;
        TotallyProcess := true;

        PurchReqLine.Reset;
        PurchReqLine.SetRange(PurchReqLine."Document No",PurchReq."No.");
        if PurchReqLine.FindSet then repeat

          if PurchReqLine.Type<>PurchReqLine.Type::" " then begin

            PurchReqLine."Ordered Quantity (Base)" := GetInvoicedQtyReqLine(PurchReq."No.",PurchReqLine."Line No.")+
              GetInOrderQtyReqLine(PurchReq."No.",PurchReqLine."Line No.");

            PurchReqLine."Remaining Quantity (Base)" := PurchReqLine."Quantity (Base)"-PurchReqLine."Ordered Quantity (Base)";

            PurchReqLine.Modify;

            if PurchReqLine."Ordered Quantity (Base)"<>0 then
              PartiallyProcess :=true;

            if PurchReqLine."Remaining Quantity (Base)"<>0 then
              TotallyProcess := false;

          end;

        until PurchReqLine.Next=0;

        if TotallyProcess then begin
          PurchReq."Processing Status" := PurchReq."Processing Status"::"Totally processed";
          PurchReq.Modify;
        end else begin
          if PartiallyProcess then begin
            PurchReq."Processing Status" := PurchReq."Processing Status"::"Partially processed";
            PurchReq.Modify;
          end;
        end;
    end;

    procedure RefreshRemainingQtyReqByCode(PurchReqCode: Code[20])
    var
        PurchReqLine: Record "Purchase Requisition Line";
        QtyInOrder: Decimal;
        QtyInvoiced: Decimal;
        PartiallyProcess: Boolean;
        TotallyProcess: Boolean;
        PurchReq: Record "Purchase Requisition";
    begin

        if PurchReq.Get(PurchReqCode) then
          RefreshRemainingQtyReq(PurchReq);
    end;

    local procedure GetInvoicedQtyReqLine(DocNo: Code[20];LineNo: Integer): Decimal
    var
        PurchInvLine: Record "Purch. Inv. Line";
        ReturnQty: Decimal;
    begin

        PurchInvLine.Reset;
        PurchInvLine.SetCurrentKey("Purch Req No.","Purch Req Line No.");
        PurchInvLine.SetRange("Purch Req No.",DocNo);
        PurchInvLine.SetRange("Purch Req Line No.",LineNo);
        if PurchInvLine.FindSet then repeat
          ReturnQty := ReturnQty+PurchInvLine."Quantity (Base)";
        until PurchInvLine.Next=0;

        exit(ReturnQty);
    end;

    local procedure GetInOrderQtyReqLine(DocNo: Code[20];LineNo: Integer): Decimal
    var
        PurchLine1: Record "Purchase Line";
        ReturnQty: Decimal;
    begin

        PurchLine1.Reset;
        PurchLine1.SetCurrentKey("Purch Req No.","Purch Req Line No.");
        PurchLine1.SetRange(PurchLine1."Document Type",PurchLine1."Document Type"::Order);
        PurchLine1.SetRange("Purch Req No.",DocNo);
        PurchLine1.SetRange("Purch Req Line No.",LineNo);
        if PurchLine1.FindSet then repeat
          ReturnQty := ReturnQty+PurchLine1."Quantity (Base)"-PurchLine1."Qty. Invoiced (Base)";
        until PurchLine1.Next=0;

        exit(ReturnQty);
    end;

    procedure SolderCdeAchat(var PurchH: Record "Purchase Header")
    var
        ReleaseMgt: Codeunit "Release Purchase Document";
        PurchLine1: Record "Purchase Line";
    begin

        if not Confirm(StrSubstNo(Text014,PurchH."No.")) then exit;
        ReleaseMgt.PerformManualReopen(PurchH);



        PurchLine1.Reset;
        PurchLine1.SetRange("Document Type",PurchLine1."Document Type"::Order);
        PurchLine1.SetRange("Document No.",PurchH."No.");
        if PurchLine1.FindSet then repeat

          if PurchLine1."Quantity Invoiced"<>PurchLine1."Quantity Received" then
            Error(Text013,PurchLine1."No.");
          PurchLine1.AFK_SetIsSolderCommande(true);
          PurchLine1.Validate(PurchLine1.Quantity,PurchLine1."Quantity Received");
          PurchLine1.Modify;

        until PurchLine1.Next=0;


        PurchH."Processing Status":=PurchH."Processing Status"::Soldee;
        PurchH.Modify;
        ArchiveManagement.ArchPurchDocumentNoConfirm(PurchH);

        //PurchH.AFK_AllowDeletion(TRUE);
        PurchH.AFK_SetIsSolderCommande(true);
        PurchH.Delete(true);
    end;

    procedure GetFiltreDemandesCDG(pManager: Code[50]) Rep: Text[1024]
    var
        UserSetup1: Record "User Setup";
    begin

        if UserSetup1.FindSet then
        repeat

          if (
              (UserSetup1."CDG Validator"=pManager) or
              (UserSetup1."CDG Interim Validator"=pManager)
             ) then begin

              if StrLen(Rep + UserSetup1."User ID") > 1024 then exit('*');
              if Rep='' then
                Rep := UserSetup1."User ID"
              else
                Rep := Rep + '|' + UserSetup1."User ID";

            end;

        until UserSetup1.Next=0;

        if Rep='' then Rep:='###';
    end;

    procedure GetFiltreDemandesManager(pManager: Code[50]) Rep: Text[1024]
    var
        UserSetup1: Record "User Setup";
    begin

        if UserSetup1.FindSet then
        repeat

          if (
              (UserSetup1."PR Validator"=pManager) or
              (UserSetup1."PR Interim Validator"=pManager)
             ) then begin

              if StrLen(Rep + UserSetup1."User ID") > 1024 then exit('*');
              if Rep='' then
                Rep := UserSetup1."User ID"
              else
                Rep := Rep + '|' + UserSetup1."User ID";

            end;

        until UserSetup1.Next=0;


        if Rep='' then Rep:='###';
    end;

    procedure GetFiltreTypeDemandeAchat() Rep: Integer
    var
        UserSetup1: Record "User Setup";
    begin
        UserSetup1.Get(UserId);
        exit(UserSetup1."PR Type");
    end;

    procedure GetFiltreTypeCommandeAchat() Rep: Integer
    var
        UserSetup1: Record "User Setup";
    begin
        UserSetup1.Get(UserId);
        exit(UserSetup1."PO Type");
    end;

    procedure CheckPurchaseOrderInWflw(PurchOrder: Record "Purchase Header")
    var
        PurchL: Record "Purchase Line";
        Item1: Record Item;
    begin

        if PurchOrder."Document Type"<>PurchOrder."Document Type"::Order then
          exit;

        PurchOrder.TestField(PurchOrder."Buy-from Vendor No.");

        if DateNotAllowed(PurchOrder."Posting Date",SetupRecordID) then
            PurchOrder.FieldError("Posting Date",Text001);

        PurchL.Reset;
        PurchL.SetRange("Document Type",PurchOrder."Document Type");
        PurchL.SetRange("Document No.",PurchOrder."No.");
        if PurchL.FindSet then repeat
          if PurchL.Type<>PurchL.Type::" " then begin

            PurchL.TestField("No.");
            PurchL.TestField("Direct Unit Cost");
            if PurchL.Type=PurchL.Type::Item then
              if Item1.Get(PurchL."No.") then
                if Item1.Type=Item1.Type::Inventory then
                  PurchL.TestField(PurchL."Location Code");

          end;
        until PurchL.Next=0;
    end;

    local procedure CheckDim(PurchReq: Record "Purchase Requisition")
    var
        PurchReqLine2: Record "Purchase Requisition Line";
    begin
        /*PurchReqLine2."Line No." := 0;
        CheckDimValuePosting(PurchReqLine2,PurchReq);
        CheckDimComb(PurchReqLine2);*/
        
        //PurchReqLine2.SETRANGE("Document Type",SalesHeader."Document Type");
        PurchReqLine2.SetRange(PurchReqLine2."Document No",PurchReq."No.");
        PurchReqLine2.SetFilter(Type,'<>%1',PurchReqLine2.Type::" ");
        if PurchReqLine2.FindSet then
          repeat
            if (PurchReqLine2.Quantity<>0)
            then begin
              CheckDimComb(PurchReqLine2);
              CheckDimValuePosting(PurchReqLine2,PurchReq);
            end;
          until PurchReqLine2.Next = 0;

    end;

    local procedure CheckDimComb(PurchReqLine: Record "Purchase Requisition Line")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        if PurchReqLine."Line No." = 0 then
          if not DimMgt.CheckDimIDComb(PurchReqLine."Dimension Set ID") then
            Error(
              Text028,
              'Demande',PurchReqLine."Document No",DimMgt.GetDimCombErr);

        if PurchReqLine."Line No." <> 0 then
          if not DimMgt.CheckDimIDComb(PurchReqLine."Dimension Set ID") then
            Error(
              Text029,
              'Demande',PurchReqLine."Document No",PurchReqLine."Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var PurchReqLine: Record "Purchase Requisition Line";PurchReq: Record "Purchase Requisition")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        if PurchReqLine."Line No." = 0 then begin
          /*TableIDArr[1] := DATABASE::Customer;
          NumberArr[1] := PurchReq.c;
          TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
          NumberArr[2] := SalesHeader."Salesperson Code";
          TableIDArr[3] := DATABASE::Campaign;
          NumberArr[3] := SalesHeader."Campaign No.";
          TableIDArr[4] := DATABASE::"Responsibility Center";
          NumberArr[4] := SalesHeader."Responsibility Center";
          IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesHeader."Dimension Set ID") THEN
            ERROR(
              Text030,
              SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimValuePostingErr);*/
        end else begin
          TableIDArr[1] := TypeToTableID3(PurchReqLine.Type);
          NumberArr[1] := PurchReqLine."No.";
          //TableIDArr[2] := DATABASE::Job;
          //NumberArr[2] := PurchReqLine."Job No.";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,PurchReqLine."Dimension Set ID") then
            Error(
              Text031,
              'Demande',PurchReqLine."Document No",PurchReqLine."Line No.",DimMgt.GetDimValuePostingErr);
        end;

    end;

    procedure TypeToTableID3(Type: Option " ",Item,"G/L Account","Fixed Asset","Item Charge"): Integer
    begin
        case Type of
          Type::" ":
            exit(0);
          Type::"G/L Account":
            exit(DATABASE::"G/L Account");
          Type::Item:
            exit(DATABASE::Item);
          //Type::Resource:
          //  EXIT(DATABASE::Resource);
          Type::"Fixed Asset":
            exit(DATABASE::"Fixed Asset");
          Type::"Item Charge":
            exit(DATABASE::"Item Charge");
        end;
    end;

    local procedure DDATotalementFacturee(var SRequisition: Record "Purchase Requisition"): Boolean
    var
        SRLine: Record "Purchase Requisition Line";
        QteRestante: Decimal;
    begin

        RefreshRemainingQtyReq(SRequisition);

        SRLine.Reset;
        SRLine.SetRange(SRLine."Document No",SRequisition."No.");
        if SRLine.FindSet then
        repeat
          if SRLine.Type<>SRLine.Type::" " then begin

            QteRestante := QteRestante+UOMMgt.CalcQtyFromBase(SRLine."Quantity (Base)"-SRLine."Ordered Quantity (Base)",SRLine."Qty. per Unit of Measure");

          end;
        until SRLine.Next=0;
        exit(QteRestante=0);
    end;

    procedure DateNotAllowed(PostingDate: Date;var SetupRecordID: RecordID): Boolean
    var
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
    begin

        //**************************************************************
        //Posting Date Per User Group **********************************
        //**************************************************************
        AFKGLMgt.GetPostingAllowedDatesOnGroupsUsers(AllowPostingFrom,AllowPostingTo,SetupRecordID);

        exit((PostingDate < AllowPostingFrom) or (PostingDate > AllowPostingTo));
    end;
}

