codeunit 50017 "Provisions Cde Mgt"
{
    // 180817 Remove Confirmation message
    // 181217 Mettre une souche special sur extourne facture provision frais annexes


    trigger OnRun()
    begin
    end;

    var
        GenJrnTemplate: Code[20];
        AddOnSetup: Record "AddOn Setup";
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
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
        Text010: Label 'Souhaitez-vous retourner ce chèque en garantie : %1  ?';
        Text011: Label 'Souhaitez-vous clôturer la lettre de crédit : %1  ?';
        PurchSetup: Record "Purchases & Payables Setup";
        Text012: Label 'Les factures de provisions de frais annexes seront créés pour ce document. Souhaitez-vous continuer ?';
        Text013: Label 'Traitement terminé : %1 factures de frais annexes créés';
        Text014: Label 'Provision Cde';
        Text015: Label 'Prov. frais annexes';
        Text016: Label 'Vous devez extourner les écritures provisions avant de facturer ce document';
        Text017: Label 'Le document de paiement n''a pas été configuré pour \le modèle %1\la feuille %2\le type %3';
        Text018: Label 'Achat de devise LC %1';
        GenJrnBatch: Code[20];
        GenJrnTable: Record "Gen. Journal Batch";
        GLMgt: Codeunit "GL Mgt";
        Text019: Label 'Prov. var stock';
        Text020: Label 'Les provisions de variation de stock ont déjà été validées pour ce document';
        GenPostingSetup: Record "General Posting Setup";
        InvPostingSetup: Record "Inventory Posting Setup";
        Item1: Record Item;
        Text021: Label 'Les provisions de variation de stock seront créés pour ce document. Souhaitez-vous continuer ?';
        Text022: Label 'Provision %1';
        Vend: Record Vendor;
        Text023: Label 'Provision anticipée %1';
        Text024: Label 'Prov. var stock';
        AddOnSetup2: Record "AddOn Setup2";

    procedure TraiterProvisionCdeVente(SalesH: Record "Sales Header";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer;DateDeb: Date;DateFin: Date): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneCde: Record "Sales Line";
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        QteProvisionNonFacturee: Decimal;
        QteAProvisionner: Decimal;
        QteLivreeNonFacturee: Decimal;
        QteCdeNonFacturee: Decimal;
    begin
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JIRAMA Sales Channel");
        
        if Cust2.Get(SalesH."Sell-to Customer No.") then;
        
        ResetProvisions(SalesH."No.");
        
        LigneCde.Reset();
        LigneCde.SetRange("Document Type",LigneCde."Document Type"::Order);
        LigneCde.SetRange("Document No.",SalesH."No.");
        LigneCde.SetFilter(LigneCde."No.",'<>%1','');
        LigneCde.SetFilter(LigneCde.Type,'<>%1',LigneCde.Type::" ");
        //LigneCde.SETFILTER(LigneCde."Shipped Not Invoiced",'<>%1',0);
        if LigneCde.FindSet then begin
          NbreTotalLignes:=LigneCde.Count;
            repeat
        
            Clear(GenJrnLine);
            GenJrnLine."Journal Template Name":= ModeleFeuille;
            GenJrnLine."Journal Batch Name" := CodeFeuille;
        
            LineNo := LineNo + 10;
            GenJrnLine."Line No." := LineNo;
            JrnTmplName.Get(GenJrnLine."Journal Template Name");
            JrnTmplName.TestField("Source Code");
            GenJrnLine."Source Code" := JrnTmplName."Source Code";
            GenJrnLine.Validate("Posting Date",PostingDate);
        
            GenJrnLine."Document No." := DocumentNo;
            GenJrnLine."External Document No." := SalesH."No.";
        
            GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
            GLAccNo := PurchReq.GetSalesAcc(LigneCde);
        
            GLMgt.CheckParamsGLAcc(GLAccNo);
            GenJrnLine.Validate("Account No.",GLAccNo);
            GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
            //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
            GenJrnLine.Description := BuildDescriptionProvision(SalesH."No.",SalesH."Sell-to Customer Name");
            GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Order;
        
            GenJrnLine.CodeArticleProvisions := LigneCde."No.";
        
            QteProvisionNonFacturee := LigneCde."Provision Qty" - LigneCde."Quantity Invoiced";
            QteProvisionNonFacturee := GetPosOrZero(QteProvisionNonFacturee);
        
            QteLivreeNonFacturee := GetQteLivreeNonFacturee_Ventes(DateDeb,DateFin,LigneCde);
            QteCdeNonFacturee := GetQteCdeeNonFacturee_Ventes(DateDeb,DateFin,SalesH, LigneCde);
        
            /*IF ((Cust2."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel") OR (SalesH.Anticipated)) THEN
              QteAProvisionner := QteCdeNonFacturee - QteProvisionNonFacturee
            ELSE
              QteAProvisionner := QteLivreeNonFacturee - QteProvisionNonFacturee;*/
        
            if (SalesH.Anticipated) then
              QteAProvisionner := QteCdeNonFacturee - QteProvisionNonFacturee
            else
              QteAProvisionner := QteLivreeNonFacturee - QteProvisionNonFacturee;
        
            QteAProvisionner := GetPosOrZero(QteAProvisionner);
            GenJrnLine.VolumeProvisions := QteAProvisionner;
            LineAmount := -LigneCde."Unit Price" * (QteAProvisionner);
        
        
            if LigneCde."Currency Code"<>'' then begin
              //Currency.GET(LigneCde."Currency Code");
              LineAmount := ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
            end;
        
            GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);
            GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
            GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
            GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
        
        
        
            GenJrnLine.Validate("Currency Code",'');
            if GenJrnLine.Amount<>0 then begin
              GenJrnLine.Insert(true);
              GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
              GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
              GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
              GenJrnLine.Modify;
        
              MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
            end;
        
          until LigneCde.Next=0
        end;
        
        
        //Contrepartie
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;
        
        LineNo := LineNo+10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);
        
        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := SalesH."No.";
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Unbilled Revenues Account";
        GLMgt.CheckParamsGLAcc(GLAccNo);
        
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
        GenJrnLine.Description := BuildDescriptionProvision(SalesH."No.",SalesH."Sell-to Customer Name");
        GenJrnLine.Validate(GenJrnLine.Amount, -MontantTotalCde);
        GenJrnLine.TypeProvision:=GenJrnLine.TypeProvision::Order;
        GenJrnLine."Gen. Posting Type":=GenJrnLine."Gen. Posting Type"::Sale;
        
        GenJrnLine.Validate("Currency Code",'');
        
        if GenJrnLine.Amount<>0 then begin
          GenJrnLine.Insert(true);
          exit(true);
        end;
        exit(false);

    end;

    procedure TraiterProvisionCdeAchat(PurchH: Record "Purchase Header";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer;DateDeb: Date;DateFin: Date): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneCde: Record "Purchase Line";
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        QteProvisionNonFacturee: Decimal;
        QteAProvisionner: Decimal;
        QteRecuNonFacturee: Decimal;
        QteCdeNonFacturee: Decimal;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField("Invoice To Receive Account");
        AddOnSetup.TestField("JOVENNA Vendor Code");
        AddOnSetup.TestField(AddOnSetup."Inv To Receive Acc JOVENNA");
        ResetProvisions(PurchH."No.");

        if Vend.Get(PurchH."Buy-from Vendor No.") then;

        LigneCde.Reset();
        LigneCde.SetRange("Document Type",LigneCde."Document Type"::Order);
        LigneCde.SetRange("Document No.",PurchH."No.");
        LigneCde.SetFilter(LigneCde.Type,'<>%1',LigneCde.Type::" ");
        LigneCde.SetFilter(LigneCde."No.",'<>%1','');
        //LigneCde.SETFILTER(LigneCde."Qty. Rcd. Not Invoiced",'<>%1',0);
        if LigneCde.FindSet then begin
            repeat

            Clear(GenJrnLine);
            GenJrnLine."Journal Template Name" := ModeleFeuille;
            GenJrnLine."Journal Batch Name" := CodeFeuille;

            LineNo := LineNo + 10;
            GenJrnLine."Line No." := LineNo;
            JrnTmplName.Get(GenJrnLine."Journal Template Name");
            JrnTmplName.TestField("Source Code");
            GenJrnLine."Source Code" := JrnTmplName."Source Code";
            GenJrnLine.Validate("Posting Date",PostingDate);

            GenJrnLine."Document No." := DocumentNo;
            GenJrnLine."External Document No." := PurchH."No.";

            GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
            GLAccNo := PurchReq.GetPurchAcc(LigneCde);
            GLMgt.CheckParamsGLAcc(GLAccNo);
            GenJrnLine.Validate("Account No.",GLAccNo);
            GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");

            if PurchH.Anticipated then
              GenJrnLine.Description := CopyStr(StrSubstNo(Text023,LigneCde.Description),1,49)
            else
              GenJrnLine.Description := CopyStr(StrSubstNo(Text022,LigneCde.Description),1,49);
            //GenJrnLine.Description := BuildDescriptionProvision(PurchH."No.",PurchH."Buy-from Vendor Name");

            GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Order;



            QteProvisionNonFacturee := LigneCde."Provision Qty" - LigneCde."Quantity Invoiced";
            if QteProvisionNonFacturee<0 then
              QteProvisionNonFacturee:=0;

            //QteRecuNonFacturee := LigneCde."Qty. Rcd. Not Invoiced";
            QteRecuNonFacturee := GetQteLivreeNonFacturee_Achats(DateDeb,DateFin,LigneCde);
            //QteCdeNonFacturee := LigneCde.Quantity - LigneCde."Quantity Invoiced";
            QteCdeNonFacturee := GetQteCdeeNonFacturee_Achats(DateDeb,DateFin,PurchH,LigneCde);

            if not PurchH.Anticipated then
              QteAProvisionner := QteRecuNonFacturee - QteProvisionNonFacturee
            else
              QteAProvisionner := QteCdeNonFacturee - QteProvisionNonFacturee;

            QteAProvisionner := GetPosOrZero(QteAProvisionner);

            GenJrnLine.VolumeProvisions := QteAProvisionner;
            LineAmount := LigneCde."Direct Unit Cost"*(QteAProvisionner);

            if LigneCde."Currency Code"<>'' then begin
              //Currency.GET(LigneCde."Currency Code");
              LineAmount:= ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
            end;

            GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

            GenJrnLine.VendorCodeProvisions := PurchH."Buy-from Vendor No.";



            GenJrnLine.Validate("Currency Code",'');

            GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";

            if (CopyStr(GLAccNo,1,1)<>'2') then begin
              if GenJrnLine.Amount<>0 then begin
                GenJrnLine.Insert(true);
                GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
                GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
                GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
                GenJrnLine.Modify;

                MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
              end;
            end;

          until LigneCde.Next=0
        end;


        //Contrepartie
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo+10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);

        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := PurchH."No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

        if AddOnSetup."JOVENNA Vendor Code"=PurchH."Buy-from Vendor No." then
          GLAccNo := AddOnSetup."Inv To Receive Acc JOVENNA"
        else
          GLAccNo := AddOnSetup."Invoice To Receive Account";

        GLMgt.CheckParamsGLAcc(GLAccNo);
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");

        GenJrnLine.Description := BuildDescriptionProvision(PurchH."No.",PurchH."Buy-from Vendor Name");
        GenJrnLine.Validate(GenJrnLine.Amount, -MontantTotalCde);
        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Order;
        GenJrnLine."Gen. Posting Type" := GenJrnLine."Gen. Posting Type"::Purchase;

        GenJrnLine.Validate("Currency Code",'');

        if GenJrnLine.Amount<>0 then begin
          GenJrnLine.Insert(true);
          exit(true);
        end;
        exit(false);
    end;

    procedure TraiterProvisionFraisAnnexes(var PurchH: Record "Purchase Header"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        LigneFraisAnn: Record "Purchase Order Tracking";
        NbreFact: Integer;
        CodeFact: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Charge Item Vendor");
        PurchSetup.Get;

        //IF PurchH.ProvisionValide THEN ERROR(Text007);

        if not Confirm(Text012) then exit;

        LigneFraisAnn.Reset();
        LigneFraisAnn.SetRange("Document Type",LigneFraisAnn."Document Type"::Order);
        LigneFraisAnn.SetRange("Document No.",PurchH."No.");
        LigneFraisAnn.SetRange(LigneFraisAnn."Data Type",LigneFraisAnn."Data Type"::FraisAnnexe);
        LigneFraisAnn.SetRange(LigneFraisAnn."Provision Invoice",'');
        if LigneFraisAnn.FindSet then begin
        repeat
          LigneFraisAnn.TestField(LigneFraisAnn."FA Amount");
          LigneFraisAnn.TestField(LigneFraisAnn."FA Code");
          CodeFact := CreatePurchInvoiceFraisAnn(PurchH,LigneFraisAnn);

          LigneFraisAnn."Provision Invoice" := CodeFact;
          LigneFraisAnn.Modify;

          NbreFact:=NbreFact+1;
        until LigneFraisAnn.Next=0
        end;



        //PurchH.ProvisionValide:=TRUE;
        //PurchH.MODIFY;

        Message(StrSubstNo( Text013,NbreFact));
    end;

    procedure TraiterProvisionCdeVenteVarStockJIRAMA(SalesH: Record "Sales Header";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneCde: Record "Sales Line";
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteProvisioneeNonLivree: Decimal;
        QteAProvisionner: Decimal;
        QteLivreeNonFacturee: Decimal;
        QteCdeNonLivree: Decimal;
    begin
        
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."JIRAMA Sales Channel");
        
        if SalesH.ProvisionValideVarStock then Error(Text020);
        
        if not Confirm(Text021) then exit;
        
        if Cust2.Get(SalesH."Sell-to Customer No.") then;
        
        //ResetProvisions(SalesH."No.");
        //DEBIT COMPTE DE VARIATION DE STOCK
        LigneCde.Reset();
        LigneCde.SetRange("Document Type",LigneCde."Document Type"::Order);
        LigneCde.SetRange("Document No.",SalesH."No.");
        LigneCde.SetFilter(LigneCde."No.",'<>%1','');
        LigneCde.SetRange(LigneCde.Type,LigneCde.Type::Item);
        //LigneCde.SETFILTER(LigneCde."Shipped Not Invoiced",'<>%1',0);
        if LigneCde.FindSet then begin
          NbreTotalLignes:=LigneCde.Count;
            repeat
        
            Item1.Get(LigneCde."No.");
            if (Item1.Type=Item1.Type::Inventory) then begin
        
                Clear(GenJrnLine);
                GenJrnLine."Journal Template Name":= ModeleFeuille;
                GenJrnLine."Journal Batch Name" := CodeFeuille;
        
                LineNo := LineNo + 10;
                GenJrnLine."Line No." := LineNo;
                JrnTmplName.Get(GenJrnLine."Journal Template Name");
                JrnTmplName.TestField("Source Code");
                GenJrnLine."Source Code" := JrnTmplName."Source Code";
                GenJrnLine.Validate("Posting Date",PostingDate);
        
                GenJrnLine."Document No." := DocumentNo;
                GenJrnLine."External Document No." := SalesH."No.";
        
                GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
                GLAccNo := GetCOGSAccount(LigneCde."Gen. Bus. Posting Group",LigneCde."Gen. Prod. Posting Group");
        
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.Validate("Account No.",GLAccNo);
                GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
                GenJrnLine.Description := BuildDescriptionProvisionVarStock(SalesH."No.",SalesH."Sell-to Customer Name");
                GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::VarStock;
        
                GenJrnLine.CodeArticleProvisions := LigneCde."No.";
        
                QteProvisioneeNonLivree := LigneCde."Provision Var Stock Qty" - LigneCde."Quantity Shipped";
                if QteProvisioneeNonLivree<0 then
                  QteProvisioneeNonLivree:=0;
        
                QteCdeNonLivree := LigneCde.Quantity - LigneCde."Quantity Shipped";
        
                QteAProvisionner := QteCdeNonLivree - QteProvisioneeNonLivree;
                QteAProvisionner := GetPosOrZero(QteAProvisionner);
        
                GenJrnLine.VolumeProvisions := QteAProvisionner;
                LineAmount := LigneCde."Unit Cost (LCY)" * (QteAProvisionner);
        
                /*IF LigneCde."Currency Code"<>'' THEN BEGIN
                  //Currency.GET(LigneCde."Currency Code");
                  LineAmount := ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
                END;*/
        
                GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);
        
        
                MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
                GenJrnLine.Validate("Currency Code",'');
        
        
        
                GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
                GLAccNo := GetInvAccount(LigneCde."Location Code",Item1."Inventory Posting Group");
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
                GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                if GenJrnLine.Amount<>0 then begin
                  GenJrnLine.Insert(true);
                  GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
                  GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
                  GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
                  GenJrnLine.Modify;
                end;
        
            end;
          until LigneCde.Next=0
        end;
        
        /*
        //Contrepartie
        CLEAR(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;
        
        LineNo := LineNo+10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.GET(GenJrnLine."Journal Template Name");
        JrnTmplName.TESTFIELD(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.VALIDATE("Posting Date",PostingDate);
        
        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := SalesH."No.";
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Unbilled Revenues Account";
        GLMgt.CheckParamsGLAcc(GLAccNo);
        
        GenJrnLine.VALIDATE("Account No.",GLAccNo);
        GenJrnLine.VALIDATE("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
        GenJrnLine.Description := BuildDescriptionProvision(SalesH."No.",SalesH."Sell-to Customer Name");
        GenJrnLine.VALIDATE(GenJrnLine.Amount, -MontantTotalCde);
        GenJrnLine.TypeProvision:=GenJrnLine.TypeProvision::Order;
        GenJrnLine."Gen. Posting Type":=GenJrnLine."Gen. Posting Type"::Sale;
        
        GenJrnLine.VALIDATE("Currency Code",'');
        */
        
        if MontantTotalCde<>0 then begin
          //GenJrnLine.INSERT(TRUE);
          exit(true);
        end;
        exit(false);

    end;

    procedure TraiterProvisionCdeVenteVarStock_CdeNormale(SalesH: Record "Sales Header";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer;DateDeb: Date;DateFin: Date): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneCde: Record "Sales Line";
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteProvisioneeNonLivree: Decimal;
        QteAProvisionner: Decimal;
        QteLivreeNonFacturee: Decimal;
        QteCdeNonLivree: Decimal;
        QteProvisionNonFacturee: Decimal;
        QteCdeNonFacturee: Decimal;
    begin
        
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."JIRAMA Sales Channel");
        
        //IF SalesH.ProvisionValideVarStock THEN ERROR(Text020);
        ResetProvisionsVarStock(SalesH."No.");
        
        //IF NOT CONFIRM(Text021) THEN EXIT; 180817
        
        if Cust2.Get(SalesH."Sell-to Customer No.") then;
        
        //ResetProvisions(SalesH."No.");
        //DEBIT COMPTE DE VARIATION DE STOCK
        LigneCde.Reset();
        LigneCde.SetRange("Document Type",LigneCde."Document Type"::Order);
        LigneCde.SetRange("Document No.",SalesH."No.");
        LigneCde.SetFilter(LigneCde."No.",'<>%1','');
        LigneCde.SetRange(LigneCde.Type,LigneCde.Type::Item);
        //LigneCde.SETFILTER(LigneCde."Shipped Not Invoiced",'<>%1',0);
        if LigneCde.FindSet then begin
          NbreTotalLignes:=LigneCde.Count;
            repeat
        
            Item1.Get(LigneCde."No.");
            if (Item1.Type=Item1.Type::Inventory) then begin
        
                Clear(GenJrnLine);
                GenJrnLine."Journal Template Name":= ModeleFeuille;
                GenJrnLine."Journal Batch Name" := CodeFeuille;
        
                LineNo := LineNo + 10;
                GenJrnLine."Line No." := LineNo;
                JrnTmplName.Get(GenJrnLine."Journal Template Name");
                JrnTmplName.TestField("Source Code");
                GenJrnLine."Source Code" := JrnTmplName."Source Code";
                GenJrnLine.Validate("Posting Date",PostingDate);
        
                GenJrnLine."Document No." := DocumentNo;
                GenJrnLine."External Document No." := SalesH."No.";
        
                GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
                GLAccNo := GetCOGSAccount(LigneCde."Gen. Bus. Posting Group",LigneCde."Gen. Prod. Posting Group");
        
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.Validate("Account No.",GLAccNo);
                GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
                GenJrnLine.Description := BuildDescriptionProvisionVarStock(SalesH."No.",SalesH."Sell-to Customer Name");
                GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::VarStock;
        
                GenJrnLine.CodeArticleProvisions := LigneCde."No.";
        
                QteProvisionNonFacturee := LigneCde."Provision Var Stock Qty" - LigneCde."Quantity Invoiced";
                QteProvisionNonFacturee := GetPosOrZero(QteProvisionNonFacturee);
        
                QteLivreeNonFacturee := GetQteLivreeNonFacturee_Ventes(DateDeb,DateFin,LigneCde);
                //QteCdeNonFacturee := GetQteCdeeNonFacturee_Ventes(DateDeb,DateFin,SalesH, LigneCde);
        
                QteAProvisionner := QteLivreeNonFacturee - QteProvisionNonFacturee;
                QteAProvisionner := GetPosOrZero(QteAProvisionner);
        
                GenJrnLine.VolumeProvisions := QteAProvisionner;
                LineAmount := LigneCde."Unit Cost (LCY)" * (QteAProvisionner);
        
                /*IF LigneCde."Currency Code"<>'' THEN BEGIN
                  //Currency.GET(LigneCde."Currency Code");
                  LineAmount := ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
                END;*/
        
                GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);
        
        
                MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
                GenJrnLine.Validate("Currency Code",'');
        
        
        
                GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
                GLAccNo := GetInvAccount(LigneCde."Location Code",Item1."Inventory Posting Group");
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
                GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                if GenJrnLine.Amount<>0 then begin
                  GenJrnLine.Insert(true);
                  GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
                  GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
                  GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
                  GenJrnLine.Modify;
                end;
        
            end;
          until LigneCde.Next=0
        end;
        
        /*
        //Contrepartie
        CLEAR(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;
        
        LineNo := LineNo+10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.GET(GenJrnLine."Journal Template Name");
        JrnTmplName.TESTFIELD(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.VALIDATE("Posting Date",PostingDate);
        
        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := SalesH."No.";
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Unbilled Revenues Account";
        GLMgt.CheckParamsGLAcc(GLAccNo);
        
        GenJrnLine.VALIDATE("Account No.",GLAccNo);
        GenJrnLine.VALIDATE("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
        GenJrnLine.Description := BuildDescriptionProvision(SalesH."No.",SalesH."Sell-to Customer Name");
        GenJrnLine.VALIDATE(GenJrnLine.Amount, -MontantTotalCde);
        GenJrnLine.TypeProvision:=GenJrnLine.TypeProvision::Order;
        GenJrnLine."Gen. Posting Type":=GenJrnLine."Gen. Posting Type"::Sale;
        
        GenJrnLine.VALIDATE("Currency Code",'');
        */
        
        if MontantTotalCde<>0 then begin
          //GenJrnLine.INSERT(TRUE);
          exit(true);
        end;
        exit(false);

    end;

    procedure TraiterProvisionCdeVenteVarStockCargo(SalesH: Record "Sales Header";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneCdeXX: Record "Sales Line";
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteProvisioneeNonLivree: Decimal;
        QteAProvisionner: Decimal;
        QteLivreeNonFacturee: Decimal;
        QteCdeNonLivree: Decimal;
        UnitPriceCargo: Decimal;
        CargoEntry: Record "Item Cargo Entry";
        LigneCde: Record "Sales Line";
    begin
        
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."JIRAMA Sales Channel");
        
        //IF SalesH.ProvisionValideVarStock THEN ERROR(Text020);
        
        if IsCommandeProvisionneeVarStock(SalesH."No.") then exit;
        
        //IF NOT CONFIRM(Text021) THEN EXIT;
        
        if Cust2.Get(SalesH."Sell-to Customer No.") then;
        
        
        CargoEntry.Reset;//TODO UPDATE HERE ***********************************************************************
        //CargoEntry.SETCURRENTKEY(Source,"Document No.");
        //CargoEntry.SETRANGE(CargoEntry.Source,CargoEntry.Source::Anticipated);
        CargoEntry.SetRange(CargoEntry."Document No.",SalesH."No.");
        if CargoEntry.FindSet then repeat
        
          Item1.Get(CargoEntry."Item No.");
          Clear(GenJrnLine);
            GenJrnLine."Journal Template Name":= ModeleFeuille;
            GenJrnLine."Journal Batch Name" := CodeFeuille;
        
            LineNo := LineNo + 10;
            GenJrnLine."Line No." := LineNo;
            JrnTmplName.Get(GenJrnLine."Journal Template Name");
            JrnTmplName.TestField("Source Code");
            GenJrnLine."Source Code" := JrnTmplName."Source Code";
            GenJrnLine.Validate("Posting Date",PostingDate);
        
            GenJrnLine."Document No." := DocumentNo;
            GenJrnLine."External Document No." := SalesH."No.";
        
            GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
            GLAccNo := GetCOGSAccount(Cust2."Gen. Bus. Posting Group",Item1."Gen. Prod. Posting Group");
        
            GLMgt.CheckParamsGLAcc(GLAccNo);
            GenJrnLine.Validate("Account No.",GLAccNo);
            GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
            //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
            GenJrnLine.Description := BuildDescriptionProvisionVarStock(SalesH."No.",SalesH."Sell-to Customer Name");
            GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::VarStock;
        
            GenJrnLine.CodeArticleProvisions := Item1."No.";
        
            //QteProvisioneeNonLivree := LigneCde."Provision Var Stock Qty" - LigneCde."Quantity Shipped";
            QteProvisioneeNonLivree := 0;
            if QteProvisioneeNonLivree<0 then
              QteProvisioneeNonLivree:=0;
        
            QteCdeNonLivree := Abs(CargoEntry.Quantity);
        
            QteAProvisionner := QteCdeNonLivree - QteProvisioneeNonLivree;
            QteAProvisionner := GetPosOrZero(QteAProvisionner);
        
            GenJrnLine.VolumeProvisions := QteAProvisionner;
            LineAmount := CargoEntry."Unit Cost" * (QteAProvisionner);
        
            /*IF LigneCde."Currency Code"<>'' THEN BEGIN
              //Currency.GET(LigneCde."Currency Code");
              LineAmount := ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
            END;*/
        
            GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);
        
        
            MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
            GenJrnLine.Validate("Currency Code",'');
        
        
        
            GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
            GLAccNo := GetInvAccount(AddOnSetup."GRT Location Code",Item1."Inventory Posting Group");
            GLMgt.CheckParamsGLAcc(GLAccNo);
            GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
            GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
            if GenJrnLine.Amount<>0 then begin
              GenJrnLine.Insert(true);
        
              LigneCde.Reset;
              LigneCde.SetRange(LigneCde."Document No.",SalesH."No.");
              LigneCde.SetRange(LigneCde."No.",CargoEntry."Item No.");
              if LigneCde.FindFirst then
                GenJrnLine.Validate("Dimension Set ID" , LigneCde."Dimension Set ID");
              //GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
              //GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
        
              GenJrnLine.Modify;
            end;
        
        
        until CargoEntry.Next=0;
        
        
        
        
        
        
        
        
        
        
        
        
        /*
        //ResetProvisions(SalesH."No.");
        //DEBIT COMPTE DE VARIATION DE STOCK
        LigneCde.RESET();
        LigneCde.SETRANGE("Document Type",LigneCde."Document Type"::Order);
        LigneCde.SETRANGE("Document No.",SalesH."No.");
        LigneCde.SETFILTER(LigneCde."No.",'<>%1','');
        LigneCde.SETRANGE(LigneCde.Type,LigneCde.Type::Item);
        //LigneCde.SETFILTER(LigneCde."Shipped Not Invoiced",'<>%1',0);
        IF LigneCde.FINDSET THEN BEGIN
          NbreTotalLignes:=LigneCde.COUNT;
            REPEAT
        
            Item1.GET(LigneCde."No.");
            IF (Item1.Type=Item1.Type::Inventory) THEN BEGIN
        
                CLEAR(GenJrnLine);
                GenJrnLine."Journal Template Name":= ModeleFeuille;
                GenJrnLine."Journal Batch Name" := CodeFeuille;
        
                LineNo := LineNo + 10;
                GenJrnLine."Line No." := LineNo;
                JrnTmplName.GET(GenJrnLine."Journal Template Name");
                JrnTmplName.TESTFIELD("Source Code");
                GenJrnLine."Source Code" := JrnTmplName."Source Code";
                GenJrnLine.VALIDATE("Posting Date",PostingDate);
        
                GenJrnLine."Document No." := DocumentNo;
                GenJrnLine."External Document No." := SalesH."No.";
        
                GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
                GLAccNo := GetCOGSAccount(LigneCde."Gen. Bus. Posting Group",LigneCde."Gen. Prod. Posting Group");
        
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.VALIDATE("Account No.",GLAccNo);
                GenJrnLine.VALIDATE("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
                GenJrnLine.Description := BuildDescriptionProvisionVarStock(SalesH."No.",SalesH."Sell-to Customer Name");
                GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::VarStock;
        
                GenJrnLine.CodeArticleProvisions := LigneCde."No.";
        
                QteProvisioneeNonLivree := LigneCde."Provision Var Stock Qty" - LigneCde."Quantity Shipped";
                IF QteProvisioneeNonLivree<0 THEN
                  QteProvisioneeNonLivree:=0;
        
                QteCdeNonLivree := LigneCde.Quantity - LigneCde."Quantity Shipped";
        
                QteAProvisionner := QteCdeNonLivree - QteProvisioneeNonLivree;
                QteAProvisionner := GetPosOrZero(QteAProvisionner);
        
                GenJrnLine.VolumeProvisions := QteAProvisionner;
                LineAmount := UnitPriceCargo * (QteAProvisionner);
        
                {IF LigneCde."Currency Code"<>'' THEN BEGIN
                  //Currency.GET(LigneCde."Currency Code");
                  LineAmount := ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
                END;}
        
                GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount);
        
        
                MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
                GenJrnLine.VALIDATE("Currency Code",'');
        
        
        
                GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
                GLAccNo := GetInvAccount(LigneCde."Location Code",Item1."Inventory Posting Group");
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.VALIDATE(GenJrnLine."Bal. Account No.",GLAccNo);
                GenJrnLine.VALIDATE("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                IF GenJrnLine.Amount<>0 THEN BEGIN
                  GenJrnLine.INSERT(TRUE);
                  GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
                  GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
                  GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
                  GenJrnLine.MODIFY;
                END;
        
            END;
          UNTIL LigneCde.NEXT=0
        END;
        
        */
        
        if MontantTotalCde<>0 then begin
          //GenJrnLine.INSERT(TRUE);
          exit(true);
        end;
        exit(false);

    end;

    procedure TraiterProvisionCdeAchatVarStockAnticipee(PurchH: Record "Purchase Header";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneCde: Record "Purchase Line";
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Vend2: Record Vendor;
        QteProvisioneeNonLivree: Decimal;
        QteAProvisionner: Decimal;
        QteLivreeNonFacturee: Decimal;
        QteCdeNonLivree: Decimal;
    begin
        
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."JIRAMA Sales Channel");
        
        //IF SalesH.ProvisionValideVarStock THEN ERROR(Text020);
        
        if IsCommandeProvisionneeVarStock(PurchH."No.") then exit;
        
        //IF NOT CONFIRM(Text021) THEN EXIT;
        
        if Vend2.Get(PurchH."Buy-from Vendor No.") then;
        
        //ResetProvisions(SalesH."No.");
        //CREDITER COMPTE DE VARIATION DE STOCK
        LigneCde.Reset();
        LigneCde.SetRange("Document Type",LigneCde."Document Type"::Order);
        LigneCde.SetRange("Document No.",PurchH."No.");
        LigneCde.SetFilter(LigneCde."No.",'<>%1','');
        LigneCde.SetRange(LigneCde.Type,LigneCde.Type::Item);
        //LigneCde.SETFILTER(LigneCde."Shipped Not Invoiced",'<>%1',0);
        if LigneCde.FindSet then begin
          NbreTotalLignes:=LigneCde.Count;
            repeat
        
            Item1.Get(LigneCde."No.");
            if (Item1.Type=Item1.Type::Inventory) then begin
        
                Clear(GenJrnLine);
                GenJrnLine."Journal Template Name":= ModeleFeuille;
                GenJrnLine."Journal Batch Name" := CodeFeuille;
        
                LineNo := LineNo + 10;
                GenJrnLine."Line No." := LineNo;
                JrnTmplName.Get(GenJrnLine."Journal Template Name");
                JrnTmplName.TestField("Source Code");
                GenJrnLine."Source Code" := JrnTmplName."Source Code";
                GenJrnLine.Validate("Posting Date",PostingDate);
        
                GenJrnLine."Document No." := DocumentNo;
                GenJrnLine."External Document No." := Vend2."No.";
        
                GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
                GLAccNo := GetCOGSAccount(LigneCde."Gen. Bus. Posting Group",LigneCde."Gen. Prod. Posting Group");
        
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.Validate("Account No.",GLAccNo);
                GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
                GenJrnLine.Description := BuildDescriptionProvisionVarStock(PurchH."No.",PurchH."Buy-from Vendor No.");
                GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::VarStock;
        
                GenJrnLine.CodeArticleProvisions := LigneCde."No.";
        
                QteProvisioneeNonLivree := LigneCde."Provision Var Stock Qty" - LigneCde."Quantity Invoiced";
                if QteProvisioneeNonLivree<0 then
                  QteProvisioneeNonLivree:=0;
        
                QteCdeNonLivree := LigneCde.Quantity - LigneCde."Quantity Invoiced";
        
                QteAProvisionner := QteCdeNonLivree - QteProvisioneeNonLivree;
                QteAProvisionner := GetPosOrZero(QteAProvisionner);
        
                GenJrnLine.VolumeProvisions := QteAProvisionner;
                LineAmount := LigneCde."Direct Unit Cost" * (QteAProvisionner);
        
                /*IF LigneCde."Currency Code"<>'' THEN BEGIN
                  //Currency.GET(LigneCde."Currency Code");
                  LineAmount := ConvertInLocalCurr(LigneCde."Currency Code",PostingDate,LineAmount);
                END;*/
        
                GenJrnLine.Validate(GenJrnLine.Amount, -LineAmount);
        
        
                MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
                GenJrnLine.Validate("Currency Code",'');
        
        
        
                GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
                GLAccNo := GetInvAccount(LigneCde."Location Code",Item1."Inventory Posting Group");
                GLMgt.CheckParamsGLAcc(GLAccNo);
                GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
                GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
                if GenJrnLine.Amount<>0 then begin
                  GenJrnLine.Insert(true);
                  GenJrnLine."Shortcut Dimension 1 Code" := LigneCde."Shortcut Dimension 1 Code";
                  GenJrnLine."Shortcut Dimension 2 Code" := LigneCde."Shortcut Dimension 2 Code";
                  GenJrnLine."Dimension Set ID" := LigneCde."Dimension Set ID";
                  GenJrnLine.Modify;
                end;
        
            end;
          until LigneCde.Next=0
        end;
        
        
        if MontantTotalCde<>0 then begin
          //GenJrnLine.INSERT(TRUE);
          exit(true);
        end;
        exit(false);

    end;

    procedure ConfirmProvisions(CodeCde: Code[20];QteAProvisionner: Decimal)
    var
        SalesL: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        Cust2: Record Customer;
    begin
        
        
        AddOnSetup.Get;
        
        SalesL.Reset;
        SalesL.SetRange("Document Type",SalesL."Document Type"::Order);
        SalesL.SetRange("Document No.",CodeCde);
        SalesL.SetFilter(Type,'<>%1',SalesL.Type::" ");
        if SalesL.FindSet(true,true) then repeat
          //Cust2.GET(SalesL."Sell-to Customer No.");
          /*IF (Cust2."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel") THEN
            SalesL."Provision Qty" := SalesL.Quantity - SalesL."Quantity Invoiced"
          ELSE
            SalesL."Provision Qty" := SalesL."Qty. Shipped Not Invoiced";*/
          SalesL."Provision Qty" := SalesL."Provision Qty" + QteAProvisionner;
          SalesL.Modify;
        until SalesL.Next=0;
        
        PurchLine.Reset;
        PurchLine.SetRange("Document Type",SalesL."Document Type"::Order);
        PurchLine.SetRange("Document No.",CodeCde);
        PurchLine.SetFilter(Type,'<>%1',PurchLine.Type::" ");
        if PurchLine.FindSet(true,true) then repeat
          //PurchLine."Provision Qty":=PurchLine."Qty. Rcd. Not Invoiced";
          PurchLine."Provision Qty" := PurchLine."Provision Qty" + QteAProvisionner;
          PurchLine.Modify;
        until PurchLine.Next=0;

    end;

    procedure ConfirmProvisionsVarStock(CodeCde: Code[20];QteAProvisionner: Decimal)
    var
        PurchH1: Record "Purchase Header";
        SalesH1: Record "Sales Header";
        SalesL: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        Cust2: Record Customer;
    begin

        AddOnSetup.Get;

        SalesL.Reset;
        SalesL.SetRange("Document Type",SalesL."Document Type"::Order);
        SalesL.SetRange("Document No.",CodeCde);
        SalesL.SetFilter(Type,'<>%1',SalesL.Type::" ");
        if SalesL.FindSet(true,true) then repeat
          //Cust2.GET(SalesL."Sell-to Customer No.");

          SalesL."Provision Var Stock Qty" := SalesL."Provision Var Stock Qty" + QteAProvisionner;
          SalesL.Modify;
        until SalesL.Next=0;
    end;

    procedure CheckEcrituresProvisions(CodeCde: Code[20])
    var
        GLEntry: Record "G/L Entry";
    begin

        AddOnSetup2.Get;
        if not AddOnSetup2."Desactivate Provisions Ctrl" then
          if IsCommandeProvisionnee(CodeCde) then
              Error(Text016);
    end;

    procedure ConvertInLocalCurr(CodeDevise: Code[20];PostingDate: Date;AmountToConvert: Decimal) Reponse: Decimal
    begin
        if CodeDevise='' then
          Reponse := AmountToConvert
        else
          Reponse :=
                Round(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    PostingDate,CodeDevise,AmountToConvert,
                    CurrExchRate.ExchangeRate(PostingDate,CodeDevise)));
    end;

    procedure CreatePurchInvoiceFraisAnn(var PurchOrder: Record "Purchase Header";LigneFraisAnn: Record "Purchase Order Tracking"): Code[20]
    var
        LineNum: Integer;
        PurchLine: Record "Purchase Line";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Facture Prov FA Nos.");

        PurchOrderHeader.Init;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Invoice;
        PurchOrderHeader."No." := '';

        PurchOrderLine.LockTable;
        PurchOrderHeader.Insert(true);

        PurchOrderHeader.Validate(PurchOrderHeader."Buy-from Vendor No.",AddOnSetup."Charge Item Vendor");
        PurchOrderHeader."Buy-from Vendor Name" := LigneFraisAnn."Vendor Name";
        PurchOrderHeader."Posting Description" := BuildDescriptionProvisionFraisAnn(PurchOrder."No.",LigneFraisAnn."Vendor Name");

        PurchOrderHeader."Order Date" := WorkDate;
        PurchOrderHeader."Created By Doc Type" := PurchOrderHeader."Created By Doc Type"::ProvisionsFA;
        PurchOrderHeader."Created By Doc No." := PurchOrder."No.";

        PurchOrderHeader.Validate(PurchOrderHeader."Posting No. Series",AddOnSetup."Facture Prov FA Nos.");

        //IF "Order Date" = 0D THEN
        //  SalesOrderHeader."Order Date" := WORKDATE
        //ELSE
        //  SalesOrderHeader."Order Date" := "Order Date";

        //IF "Posting Date" <> 0D THEN
        PurchOrderHeader."Posting Date" := 0D;
        PurchOrderHeader."Document Date" := WorkDate;
        PurchOrderHeader."Vendor Invoice No." := PurchOrderHeader."No."+'_'+Format(LigneFraisAnn."FA Code");
        //PurchOrderHeader."Shipment Date" := 0D;
        //SalesOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        //SalesOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        //SalesOrderHeader."Dimension Set ID" := "Dimension Set ID";

        //IF SalesOrderHeader."Posting Date" = 0D THEN
        //  SalesOrderHeader."Posting Date" := WORKDATE;

        if PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" then begin
          PurchOrderHeader."Posting Date" := 0D;
          //SalesOrderHeader.MODIFY;
        end;

        PurchOrderHeader.Modify;




        LineNum:=0;
        //PurchLine.RESET();
        //PurchLine.SETRANGE("Document No.",PurchOrder."No.");
        //IF PurchLine.FINDSET THEN REPEAT

          //Ligne
          PurchOrderLine.Init;
          PurchOrderLine."Document Type"  := PurchOrderLine."Document Type"::Invoice;
          PurchOrderLine."Document No." := PurchOrderHeader."No.";
          LineNum := LineNum + 10000;
          PurchOrderLine."Line No." := LineNum;
          PurchOrderLine.Insert(true);



          PurchOrderLine.Type := PurchOrderLine.Type::"Charge (Item)";
          PurchOrderLine.Validate(PurchOrderLine."No.",LigneFraisAnn."FA Code");
          PurchOrderLine.Validate(PurchOrderLine.Quantity,1);
          PurchOrderLine.Validate(PurchOrderLine."Direct Unit Cost",LigneFraisAnn."FA Amount");
          //IF Cust.GET(JiramaForecastLine."Sell-to Customer No.") THEN
          //  PurchOrderLine.VALIDATE(PurchOrderLine."Location Code",Cust."Location Code");

          PurchOrderLine.Modify;

          //JiramaForecastLine."Purchase Order No" := PurchOrderHeader."No.";
          //JiramaForecastLine."Purchase Order Line No" := LineNum;
          //JiramaForecastLine.MODIFY;

          //SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
          //SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
          //SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";

        //UNTIL PurchLine.NEXT=0;

        exit(PurchOrderHeader."No.");
    end;

    local procedure BuildDescriptionProvision(CodeCde: Code[20];NomClient: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := Text014+' '+CodeCde+'-'+NomClient;
        exit(CopyStr(rep,1,49));
    end;

    local procedure BuildDescriptionProvisionFraisAnn(CodeCde: Code[20];NomClient: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := Text015+' '+CodeCde+'-'+NomClient;
        exit(CopyStr(rep,1,49));
    end;

    local procedure BuildDescriptionProvisionVarStock(CodeCde: Code[20];NomClient: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := Text019+' '+CodeCde+'-'+NomClient;
        exit(CopyStr(rep,1,49));
    end;

    local procedure BuildDescriptionProvisionVarStockCargo(CodeCde: Code[20];NomClient: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := Text019+' '+CodeCde+'-'+NomClient;
        exit(CopyStr(rep,1,49));
    end;

    procedure GetPostingAllowedDatesOnGroupsUsers(var AllowPostingFrom: Date;var AllowPostingTo: Date)
    var
        UserGroupMember: Record "User Group Member";
        UserGroup: Record "User Group";
    begin
        AddOnSetup.Get;
        if not AddOnSetup."GL Security On Group Users" then exit;

        UserGroupMember.Reset;
        UserGroupMember.SetRange("User Name",UserId);
        //UserGroupMember.SETRANGE("Company Name",COMPANYNAME);
        if UserGroupMember.FindFirst then begin
          if UserGroup.Get(UserGroupMember."User Group Code") then begin
            AllowPostingFrom := UserGroup."Allow Posting From";
            AllowPostingTo := UserGroup."Allow Posting To";
          end;
        end;
    end;

    local procedure IsCommandeProvisionnee(CodeCde: Code[20]): Boolean
    var
        GLEntry: Record "G/L Entry";
        SommeMontant: Decimal;
    begin
        
        /*
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY(GLEntry."External Document No.");
        GLEntry.SETRANGE(GLEntry."External Document No.",CodeCde);
        IF GLEntry.FINDSET THEN REPEAT
          IF NOT GLEntry.Reversed THEN
            EXIT(TRUE);
        UNTIL GLEntry.NEXT = 0;
        */
        AddOnSetup.Get;
        
        GLEntry.Reset;
        GLEntry.SetCurrentKey(GLEntry."External Document No.");
        GLEntry.SetRange(GLEntry."External Document No.",CodeCde);
        if GLEntry.FindSet then repeat
         if ((GLEntry."G/L Account No."=AddOnSetup."Unbilled Revenues Account") or
         (GLEntry."G/L Account No."=AddOnSetup."Invoice To Receive Account")) then
          SommeMontant := SommeMontant + GLEntry.Amount;
        until GLEntry.Next = 0;
        
        exit(SommeMontant<>0)

    end;

    local procedure IsCommandeProvisionneeVarStock(CodeCde: Code[20]): Boolean
    var
        GLEntry: Record "G/L Entry";
        SommeMontant: Decimal;
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        SalesH: Record "Sales Header";
        PurchH: Record "Purchase Header";
        GLAccNo: Code[20];
        Item1: Record Item;
    begin
        
        /*
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY(GLEntry."External Document No.");
        GLEntry.SETRANGE(GLEntry."External Document No.",CodeCde);
        IF GLEntry.FINDSET THEN REPEAT
          IF NOT GLEntry.Reversed THEN
            EXIT(TRUE);
        UNTIL GLEntry.NEXT = 0;
        */
        //AddOnSetup.GET;
        
        SalesLine.Reset();
        SalesLine.SetRange("Document Type",SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.",CodeCde);
        SalesLine.SetFilter("No.",'<>%1','');
        SalesLine.SetRange(Type,SalesLine.Type::Item);
        if SalesLine.FindSet then
        repeat
          Item1.Get(SalesLine."No.");
          if Item1.Type = Item1.Type::Inventory then begin
            GLAccNo := GetCOGSAccount(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");
        
            GLEntry.Reset;
            GLEntry.SetCurrentKey(GLEntry."External Document No.");
            GLEntry.SetRange(GLEntry."External Document No.",CodeCde);
            if GLEntry.FindSet then repeat
             if ((GLEntry."G/L Account No."=GLAccNo)) then
              SommeMontant := SommeMontant + GLEntry.Amount;
            until GLEntry.Next = 0;
          end;
        until SalesLine.Next=0;
        
        
        PurchLine.Reset();
        PurchLine.SetRange("Document Type",PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.",CodeCde);
        PurchLine.SetFilter("No.",'<>%1','');
        PurchLine.SetRange(Type,PurchLine.Type::Item);
        if PurchLine.FindSet then
        repeat
          Item1.Get(PurchLine."No.");
          if Item1.Type = Item1.Type::Inventory then begin
            GLAccNo := GetCOGSAccount(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");
        
            GLEntry.Reset;
            GLEntry.SetCurrentKey(GLEntry."External Document No.");
            GLEntry.SetRange(GLEntry."External Document No.",CodeCde);
            if GLEntry.FindSet then repeat
             if ((GLEntry."G/L Account No." = GLAccNo)) then
              SommeMontant := SommeMontant + GLEntry.Amount;
            until GLEntry.Next = 0;
          end;
        until PurchLine.Next=0;
        
        exit(SommeMontant<>0)

    end;

    procedure ResetProvisions(CodeCde: Code[20])
    var
        SalesL: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        Cust2: Record Customer;
    begin


        AddOnSetup.Get;

        if IsCommandeProvisionnee(CodeCde) then exit;

        SalesL.Reset;
        SalesL.SetRange("Document Type",SalesL."Document Type"::Order);
        SalesL.SetRange("Document No.",CodeCde);
        if SalesL.FindSet(true,true) then repeat
          SalesL."Provision Qty" := 0;
          SalesL.Modify;
        until SalesL.Next=0;

        PurchLine.Reset;
        PurchLine.SetRange("Document Type",SalesL."Document Type"::Order);
        PurchLine.SetRange("Document No.",CodeCde);
        if PurchLine.FindSet(true,true) then repeat
          PurchLine."Provision Qty":=0;
          PurchLine.Modify;
        until PurchLine.Next=0;
    end;

    procedure ResetProvisionsVarStock(CodeCde: Code[20])
    var
        SalesL: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        Cust2: Record Customer;
    begin


        AddOnSetup.Get;

        if IsCommandeProvisionneeVarStock(CodeCde) then exit;

        SalesL.Reset;
        SalesL.SetRange("Document Type",SalesL."Document Type"::Order);
        SalesL.SetRange("Document No.",CodeCde);
        if SalesL.FindSet(true,true) then repeat
          SalesL."Provision Var Stock Qty" := 0;
          SalesL.Modify;
        until SalesL.Next=0;

        PurchLine.Reset;
        PurchLine.SetRange("Document Type",SalesL."Document Type"::Order);
        PurchLine.SetRange("Document No.",CodeCde);
        if PurchLine.FindSet(true,true) then repeat
          PurchLine."Provision Var Stock Qty":=0;
          PurchLine.Modify;
        until PurchLine.Next=0;
    end;

    local procedure GetCOGSAccount(GenBusPostingCode: Code[10];GenProdPostingCode: Code[10]): Code[20]
    begin
        GenPostingSetup.Get(GenBusPostingCode,GenProdPostingCode);
        GenPostingSetup.TestField(GenPostingSetup."COGS Account");
        exit(GenPostingSetup."COGS Account");
    end;

    local procedure GetInvAccount(LocationCode: Code[10];ItemInvPostingGroup: Code[10]): Code[20]
    begin
        InvPostingSetup.Get(LocationCode,ItemInvPostingGroup);
        InvPostingSetup.TestField(InvPostingSetup."Inventory Account");
        exit(InvPostingSetup."Inventory Account");
    end;

    procedure GetPurchAccFA(CodeFA: Code[20]): Code[20]
    var
        FAPostingGroup: Record "FA Posting Group";
        GenPostingSetup: Record "General Posting Setup";
        Immo: Record "Fixed Asset";
        FADepreciationGroup: Record "FA Depreciation Book";
        FA: Record "Item Charge";
    begin
        //IF PurchLine.Type=PurchLine.Type::"G/L Account" THEN
        //  EXIT(PurchLine."No.");

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Gen. Bus. Posting Group Def");

        FA.Get(CodeFA);

        GenPostingSetup.Get(AddOnSetup."Gen. Bus. Posting Group Def",FA."Gen. Prod. Posting Group");
        GenPostingSetup.TestField("Purch. Account");
        exit(GenPostingSetup."Purch. Account");
    end;

    procedure ConfirmProvisionsFA(CodeFacture: Code[20];CodeFactureEnreg: Code[20])
    var
        PurchH1: Record "Purchase Header";
        LigneFraisAnn: Record "Purchase Order Tracking";
    begin
        /*IF PurchH1.GET(PurchH1."Document Type"::Order,CodeCde) THEN BEGIN
          PurchH1.ProvisionValide:=TRUE;
          PurchH1.MODIFY;
        END;*/
        
        if not PurchH1.Get(PurchH1."Document Type"::Invoice,CodeFacture) then exit;
        
        if PurchH1."Created By Doc Type"<>PurchH1."Created By Doc Type"::ProvisionsFA then exit;
        
        LigneFraisAnn.Reset();
        LigneFraisAnn.SetRange("Document Type",LigneFraisAnn."Document Type"::Order);
        LigneFraisAnn.SetRange("Document No.",PurchH1."Created By Doc No.");
        LigneFraisAnn.SetRange(LigneFraisAnn."Data Type",LigneFraisAnn."Data Type"::FraisAnnexe);
        LigneFraisAnn.SetRange(LigneFraisAnn."Provision Invoice",CodeFacture);
        if LigneFraisAnn.FindSet then begin
        repeat
          LigneFraisAnn.Provisioned := true;
          LigneFraisAnn."Provision Posted Invoice" := CodeFactureEnreg;
          LigneFraisAnn.Modify;
        
        until LigneFraisAnn.Next=0
        end;

    end;

    procedure TraiterProvisionFraisAnnexesOld(PurchH: Record "Purchase Header";LigneFraisAnn: Record "Purchase Order Tracking";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];var LineNo: Integer): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
    begin

        AddOnSetup.Get;

        if PurchH.ProvisionValide then Error(Text007);

        //LigneFraisAnn.RESET();
        //LigneFraisAnn.SETRANGE("Document Type",LigneFraisAnn."Document Type"::Order);
        //LigneFraisAnn.SETRANGE("Document No.",PurchH."No.");
        //LigneFraisAnn.SETRANGE(LigneFraisAnn."Data Type",LigneFraisAnn."Data Type"::FraisAnnexe);
        //IF LigneFraisAnn.FINDSET THEN BEGIN
        //REPEAT

            Clear(GenJrnLine);
            GenJrnLine."Journal Template Name":= ModeleFeuille;
            GenJrnLine."Journal Batch Name" := CodeFeuille;

            LineNo := LineNo+10;
            GenJrnLine."Line No." := LineNo;
            JrnTmplName.Get(GenJrnLine."Journal Template Name");
            JrnTmplName.TestField("Source Code");
            GenJrnLine."Source Code" := JrnTmplName."Source Code";
            GenJrnLine.Validate("Posting Date",PostingDate);

            GenJrnLine."Document No." := DocumentNo;
            GenJrnLine."External Document No." := PurchH."No.";

            GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
            GLAccNo := GetPurchAccFA(LigneFraisAnn."FA Code");
            GenJrnLine.Validate("Account No.",GLAccNo);
            GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");

            GenJrnLine.Description := CopyStr(StrSubstNo(Text006,PurchH."No."),1,49);
            GenJrnLine.TypeProvision:=GenJrnLine.TypeProvision::FraisAnn;

            //LineAmount := LigneCde."Direct Unit Cost"*(LigneCde."Qty. Rcd. Not Invoiced"-LigneCde."Provision Qty");
            LigneFraisAnn.TestField(LigneFraisAnn."FA Amount");
            LineAmount := LigneFraisAnn."FA Amount";


            GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);


            MontantTotalCde := MontantTotalCde + GenJrnLine.Amount;
            GenJrnLine.Validate("Currency Code",'');
            if GenJrnLine.Amount<>0 then
              GenJrnLine.Insert(true);

        //UNTIL LigneFraisAnn.NEXT=0
        //END;


        //Contrepartie
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo+10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField(JrnTmplName."Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);

        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := PurchH."No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Invoice To Receive Account";
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");

        GenJrnLine.Description := CopyStr(StrSubstNo(Text006,PurchH."No."),1,49);
        GenJrnLine.Validate(GenJrnLine.Amount, -MontantTotalCde);
        GenJrnLine.TypeProvision:=GenJrnLine.TypeProvision::FraisAnn;
        GenJrnLine."Gen. Posting Type":=GenJrnLine."Gen. Posting Type"::Purchase;

        GenJrnLine.Validate("Currency Code",'');

        if GenJrnLine.Amount<>0 then begin
          GenJrnLine.Insert(true);
          exit(true);
        end;
        exit(false);
    end;

    local procedure GetPosOrZero(Qty: Decimal): Decimal
    begin
        if Qty>0 then
          exit(Qty)
        else
          exit(0);
    end;

    local procedure GetQteLivreeNonFacturee_Ventes(DateDeb: Date;DateFin: Date;LigneCde: Record "Sales Line") Rep: Decimal
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        SalesShipmentLine.Reset;
        SalesShipmentLine.SetCurrentKey("Order No.","Order Line No.");
        SalesShipmentLine.SetRange("Order No.",LigneCde."Document No.");
        SalesShipmentLine.SetRange("Order Line No.",LigneCde."Line No.");
        if SalesShipmentLine.FindSet then repeat
          if ((SalesShipmentLine."Posting Date">=DateDeb) and (SalesShipmentLine."Posting Date"<=DateFin)) then
            Rep := Rep + (SalesShipmentLine.Quantity-GetQteFactureeLivraison(SalesShipmentLine));
        until SalesShipmentLine.Next=0;
    end;

    local procedure GetQteFactureeLivraison(SalesShipmentLine: Record "Sales Shipment Line") Rep: Decimal
    var
        ShipmentInv: Record "Shipment Invoiced";
    begin
        ShipmentInv.Reset;
        ShipmentInv.SetCurrentKey("Shipment No.","Shipment Line No.");
        ShipmentInv.SetRange("Shipment No.",SalesShipmentLine."Document No.");
        ShipmentInv.SetRange("Shipment Line No.",SalesShipmentLine."Line No.");
        if ShipmentInv.FindSet then repeat
          Rep := Rep + ShipmentInv."Qty. to Invoice";
        until ShipmentInv.Next=0;
    end;

    local procedure GetQteCdeeNonFacturee_Ventes(DateDeb: Date;DateFin: Date;SalesH: Record "Sales Header";LigneCde: Record "Sales Line") Rep: Decimal
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin

        if ((SalesH."Order Date">=DateDeb) and (SalesH."Order Date"<=DateFin)) then
          Rep := LigneCde.Quantity - LigneCde."Quantity Invoiced";
    end;

    local procedure GetQteCdeeNonFacturee_Achats(DateDeb: Date;DateFin: Date;PurchH: Record "Purchase Header";LigneCde: Record "Purchase Line") Rep: Decimal
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    begin

        if ((PurchH."Order Date">=DateDeb) and (PurchH."Order Date"<=DateFin)) then
          Rep := LigneCde.Quantity - LigneCde."Quantity Invoiced";
    end;

    local procedure GetQteFactureeReception(PurchReptLine: Record "Purch. Rcpt. Line";SalesOrderNo: Code[20];ItemNo: Code[20]) Rep: Decimal
    var
        ShipmentInv: Record "Shipment Invoiced";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvH: Record "Purch. Inv. Header";
        MontantTotalFacture: Decimal;
    begin
        PurchInvH.Reset;
        PurchInvH.SetCurrentKey("Order No.");
        PurchInvH.SetRange("Order No.",SalesOrderNo);
        if PurchInvH.FindSet then repeat

          if PurchInvLine.Get(PurchInvH."No.",PurchReptLine."Line No.") then
            if PurchInvLine."No."=ItemNo then
              Rep := Rep + PurchInvLine.Quantity;

        until PurchInvH.Next=0;
    end;

    local procedure GetQteFactureeArticleCde_Reception(LigneCde: Record "Purchase Line") Rep: Decimal
    var
        ShipmentInv: Record "Shipment Invoiced";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchInvH: Record "Purch. Inv. Header";
        MontantTotalFacture: Decimal;
    begin
        PurchInvH.Reset;
        PurchInvH.SetCurrentKey("Order No.");
        PurchInvH.SetRange("Order No.",LigneCde."Document No.");
        if PurchInvH.FindSet then repeat

          if PurchInvLine.Get(PurchInvH."No.",LigneCde."Line No.") then
            if PurchInvLine."No."=LigneCde."No." then
              Rep := Rep + PurchInvLine.Quantity;

        until PurchInvH.Next=0;
    end;

    local procedure GetQteLivreeNonFacturee_Achats(DateDeb: Date;DateFin: Date;LigneCde: Record "Purchase Line") Rep: Decimal
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        PurchReptLine: Record "Purch. Rcpt. Line";
        ResteAAffecter: Decimal;
    begin

        ResteAAffecter := GetQteFactureeArticleCde_Reception(LigneCde);

        PurchReptLine.Reset;
        PurchReptLine.SetCurrentKey("Order No.","Order Line No.");
        PurchReptLine.SetRange("Order No.",LigneCde."Document No.");
        PurchReptLine.SetRange("Order Line No.",LigneCde."Line No.");
        if PurchReptLine.FindSet then repeat

            if ((PurchReptLine."Posting Date">=DateDeb) and (PurchReptLine."Posting Date"<=DateFin)) then begin
              if ResteAAffecter<PurchReptLine.Quantity then
                if ResteAAffecter>=0 then
                  Rep := Rep + (PurchReptLine.Quantity-ResteAAffecter)
                else
                  Rep := Rep + PurchReptLine.Quantity;
            end;

          ResteAAffecter := ResteAAffecter-PurchReptLine.Quantity;

        until PurchReptLine.Next=0;
    end;

    procedure SetSoucheExtourneProvisionFA(FromPostedFacture: Record "Purch. Inv. Header";var ToAvoir: Record "Purchase Header")
    begin
        if FromPostedFacture."Created By Doc Type"=FromPostedFacture."Created By Doc Type"::ProvisionsFA then begin
          if ToAvoir."Document Type"=ToAvoir."Document Type"::"Credit Memo" then begin
            AddOnSetup.Get;
            AddOnSetup.TestField(AddOnSetup."Extourne Facture Prov Nos.");
            ToAvoir.Validate("Posting No. Series",AddOnSetup."Extourne Facture Prov Nos.");
            ToAvoir.Modify;
          end;
        end;
    end;
}

