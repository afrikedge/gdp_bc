codeunit 50022 "Provisions Item Mgt"
{
    // 141117 : Ajouter les frais de passage/stockage/transfert sur la feuille
    // 030718 : Figer les codes axes
    // 270818 : Ajout des regroupements et changement source frais de passage (prendre les BL pour pouvoir avoir le canal de vente)
    // 260219 : Ajout des frais de passage sur les transferts (depot origine)

    Permissions = TableData "Sales Invoice Header" = rm,
                  TableData pro_enteteBE = rm,
                  TableData "Posted Adjustment Header" = rm;

    trigger OnRun()
    begin
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Text001: Label 'Prov. Passage vte %1..%2 %3';
        ProvPricingMgt: Codeunit "Provisions Pricing Mgt";
        Text002: Label 'Prov. Transfert %1..%2 %3';
        Text003: Label 'Prov.  %1..%2 %3';
        DimMgt: Codeunit DimensionManagement;
        Text004: Label 'Prov. Passage transf %1..%2 %3';

    procedure TraiterProvisionFraisPassage(EnteteBE: Record pro_enteteBE; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneBL: Record pro_detailBL; EnteteBL: Record pro_enteteBL): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
        CanalVente: Code[30];
        CentreGestion: Code[30];
        CustNo: Code[20];
    begin

        //Comment isoler les enlevements JIRAMA ou par pipeline
        //IF EnteteBE.Source=EnteteBE.Source::" " THEN EXIT;

        if EnteteBE.Provisioned then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TestField(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TestField(AddOnSetup."GRT Location Code");

        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            Vend.Get(AddOnSetup."GRT Vendor Code")
        else
            Vend.Get(AddOnSetup."LPSA Vendor Code");

        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::Passage);


        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            GLAccNo := AddOnSetup."GRT Fees Storage Account"
        else
            GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.SetRange(GenJrnLine."Account No.", GLAccNo);

        GetCanalVteEnteteBL(CanalVente, EnteteBL, CustNo);

        //GenJrnLine.SETRANGE(GenJrnLine.TiersProvisionNo,Vend."No.");
        GenJrnLine.SetRange(GenJrnLine."External Document No.", CanalVente);

        GetCentreGestionEnteteBE(CentreGestion, EnteteBE);
        GenJrnLine.SetRange(GenJrnLine.CodeDepotProvisions, CentreGestion);//Centre de gestion

        //GenJrnLine.SETRANGE(GenJrnLine.NumDocProvisions,FORMAT(EnteteBE.numBE));
        //GenJrnLine.SETRANGE(GenJrnLine.CodeArticleProvisions,FORMAT(LigneBL.NavItemCode));


        if GenJrnLine.FindFirst then begin

            LineAmount := GetMontantProvisionsPassage(EnteteBE, LigneBL);
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                    ProvPricingMgt.CalcQtyM3(LigneBL.NavItemCode, LigneBL.volumelivre, LigneBL."Unit of Measure Code");
            GenJrnLine.Modify;

        end else begin

            AddLineProvisionFraisPassage(EnteteBE, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneBL, EnteteBL);

        end;
    end;

    procedure TraiterProvisionFraisPassageTransfert(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
        CentreGestion: Code[20];
    begin

        if EnteteTR.ProvisionedPassage then exit;

        AddOnSetup.Get;

        if EnteteTR."Transporter Code" = '' then
            Vend.Get(AddOnSetup."LPSA Vendor Code")
        else
            Vend.Get(EnteteTR."Transporter Code");

        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::PassageTransfer);

        if EnteteTR."Location Code" = AddOnSetup."GRT Location Code" then
            GLAccNo := AddOnSetup."GRT Fees Storage Account"
        else
            GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.SetRange(GenJrnLine."Account No.", GLAccNo);

        //GetCanalVteEnteteBL(CanalVente,EnteteBL,CustNo);
        //GenJrnLine.SETRANGE(GenJrnLine."External Document No.",CanalVente);

        GetCentreGestionEnteteTransfer(CentreGestion, EnteteTR);
        GenJrnLine.SetRange(GenJrnLine.CodeDepotProvisions, CentreGestion);//Centre de gestion


        if GenJrnLine.FindFirst then begin

            LineAmount := GetMontantProvisionsPassageTransfert(EnteteTR, LigneTR, EnteteTR."Transfer-to Code");
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                  ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
            GenJrnLine.Modify;

        end else begin
            AddLineProvisionFraisPassageTransfert
            (EnteteTR, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneTR);

        end;
    end;

    procedure TraiterProvisionFraisTransfert(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
    begin

        //Comment isoler les enlevements JIRAMA ou par pipeline
        //IF EnteteBE.Source=EnteteBE.Source::" " THEN EXIT;

        if EnteteTR.Provisioned then exit;


        AddOnSetup.Get;
        /*
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TESTFIELD(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Location Code");
        
        IF EnteteBE.depot=AddOnSetup."GRT Location Code" THEN
          Vend.GET(AddOnSetup."GRT Vendor Code")
        ELSE
          Vend.GET(AddOnSetup."LPSA Vendor Code");
          */

        if EnteteTR."Transporter Code" = '' then
            Vend.Get(AddOnSetup."LPSA Vendor Code")
        else
            Vend.Get(EnteteTR."Transporter Code");

        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::Transfer);

        //GenJrnLine.SETRANGE(GenJrnLine.TiersProvisionNo,Vend."No.");
        //GenJrnLine.SETRANGE(GenJrnLine.CodeDepotProvisions,EnteteTR."Transfer-to Code");

        //GenJrnLine.SETRANGE(GenJrnLine.NumDocProvisions,FORMAT(EnteteTR."No."));
        //GenJrnLine.SETRANGE(GenJrnLine.CodeArticleProvisions,FORMAT(LigneTR."Item No."));

        if GenJrnLine.FindFirst then begin

            LineAmount := GetMontantProvisionsTransfert(EnteteTR, LigneTR, EnteteTR."Transfer-to Code");
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                  ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
            GenJrnLine.Modify;

        end else begin

            AddLineProvisionFraisTransfert(EnteteTR, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneTR);

        end;

    end;

    procedure TraiterProvisionFraisTransfertJIRAMAAmbohimanambola(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
    begin

        //Comment isoler les enlevements JIRAMA ou par pipeline
        //IF EnteteBE.Source=EnteteBE.Source::" " THEN EXIT;

        if EnteteTR.Provisioned then exit;

        AddOnSetup.Get;

        if EnteteTR."Transporter Code" = '' then
            Vend.Get(AddOnSetup."LPSA Vendor Code")
        else
            Vend.Get(EnteteTR."Transporter Code");

        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::Transfer);
        GenJrnLine.SetRange(GenJrnLine.TiersProvisionNo, Vend."No.");
        //GenJrnLine.SETRANGE(GenJrnLine.CodeDepotProvisions,EnteteTR."Transfer-to Code");

        GenJrnLine.SetRange(GenJrnLine.NumDocProvisions, Format(EnteteTR."No."));
        GenJrnLine.SetRange(GenJrnLine.CodeArticleProvisions, Format(LigneTR."Item No."));

        if GenJrnLine.FindFirst then begin

            LineAmount := GetMontantProvisionsTransfert(EnteteTR, LigneTR, AddOnSetup."Ambohimanambola Fees Location");
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                  ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
            GenJrnLine.Modify;

        end else begin

            AddLineProvisionFraisTransportJIRAMAAmbohimanambola(EnteteTR, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneTR);

        end;
    end;

    procedure TraiterProvisionFraisTransfertToAmbatovy(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
    begin

        if EnteteTR.Provisioned then exit;
        if EnteteTR."Transporter Code" = '' then exit;

        AddOnSetup.Get;

        Vend.Get(EnteteTR."Transporter Code");

        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::Transfer);
        GenJrnLine.SetRange(GenJrnLine.TiersProvisionNo, Vend."No.");
        //GenJrnLine.SETRANGE(GenJrnLine.CodeDepotProvisions,EnteteTR."Transfer-to Code");

        GenJrnLine.SetRange(GenJrnLine.NumDocProvisions, Format(EnteteTR."No."));
        GenJrnLine.SetRange(GenJrnLine.CodeArticleProvisions, Format(LigneTR."Item No."));

        if GenJrnLine.FindFirst then begin

            LineAmount := GetMontantProvisionsTransfertToAmbatovy(EnteteTR, LigneTR, EnteteTR."Transfer-to Code");
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                  ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
            GenJrnLine.Modify;

        end else begin

            AddLineProvisionFraisTransfertToAmbatovy(EnteteTR, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneTR);

        end;
    end;

    procedure TraiterProvisionTransportVente(EnteteFV: Record "Sales Invoice Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneFV: Record "Sales Invoice Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
        CanalVente: Code[30];
        CodeTransPorteur: Code[30];
    begin

        //Comment isoler les enlevements JIRAMA ou par pipeline
        //IF EnteteBE.Source=EnteteBE.Source::" " THEN EXIT;

        if EnteteFV.Provisioned then exit;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Transport Item Category");


        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::TransportVente);
        //GenJrnLine.SETRANGE(GenJrnLine.TiersProvisionNo,Vend."No.");
        //GenJrnLine.SETRANGE(GenJrnLine.CodeDepotProvisions,EnteteBE.depot);

        GetCanalVteTransporteurFactureVente(CanalVente, CodeTransPorteur, EnteteFV);

        GenJrnLine.SetRange(GenJrnLine.NumDocProvisions, CanalVente);//Canal de vente
        GenJrnLine.SetRange(GenJrnLine.VendorCodeProvisions, CodeTransPorteur);//Code Transporteur


        if GenJrnLine.FindFirst then begin

            LineAmount := LigneFV.Amount;
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                    LigneFV.Quantity;
            GenJrnLine.Modify;

        end else begin

            AddLineProvisionTransportVente(EnteteFV, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneFV);

        end;
    end;

    procedure AddLineProvisionFraisPassage(EnteteBE: Record pro_enteteBE; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneBL: Record pro_detailBL; EnteteBL: Record pro_enteteBL): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
        Loc3: Record Location;
        CanalVente: Code[30];
        CentreGestion: Code[30];
        CustNo: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."LPSA Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TestField(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TestField(AddOnSetup."GRT Location Code");
        AddOnSetup.TestField(AddOnSetup."Provisions LPSA");

        //IF Cust2.GET(SalesH."Sell-to Customer No.") THEN;

        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            Vend.Get(AddOnSetup."GRT Vendor Code")
        else
            Vend.Get(AddOnSetup."LPSA Vendor Code");


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;

        //EnteteBL.GET(LigneBL.numBL);
        //IF(EnteteBL.c
        //TODO Renseigner le canal de vente ici

        //GenJrnLine."External Document No." := Vend."No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            GLAccNo := AddOnSetup."GRT Fees Storage Account"
        else
            GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.Validate("Account No.", GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        GetCanalVteEnteteBL(CanalVente, EnteteBL, CustNo);
        GenJrnLine."External Document No." := CanalVente;


        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        GenJrnLine.Description := BuildDescriptionProvisionPassage(DateDeb, DateFin, CanalVente);

        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Passage;
        //GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;

        GetCentreGestionEnteteBE(CentreGestion, EnteteBE);
        GenJrnLine.CodeDepotProvisions := CentreGestion; //Centre de gestion
        //GenJrnLine."External Document No." := EnteteBE.numBSL;



        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneBL.NavItemCode, LigneBL.volumelivre, LigneBL."Unit of Measure Code");
        //GenJrnLine.NumDocProvisions := FORMAT(EnteteBE.numBE);
        //GenJrnLine.CodeArticleProvisions := LigneBL.NavItemCode;

        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsPassageUnitPrice(LigneBL.NavItemCode, EnteteBE.depot, EnteteBE.dateBE);//141117

        LineAmount := GetMontantProvisionsPassage(EnteteBE, LigneBL);
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine.Validate("Currency Code", '');


        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Provisions LPSA";
        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;


        //Analytique region
        EnteteBE.TestField(EnteteBE.depot);
        if Loc3.Get(EnteteBE.depot) then begin
            Loc3.TestField(Loc3."Responsibility Center");
            //TODO
            // GenJrnLine.CreateDim(
            // DATABASE::Job,GenJrnLine."Job No.",                                           //*******JN150218 Analytique
            // DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
            // DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
            // DATABASE::Customer,CustNo,
            // DATABASE::"Responsibility Center",Loc3."Responsibility Center");
        end;

        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);
    end;

    procedure AddLineProvisionFraisPassageTransfert(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneBE: Record pro_detailBE;
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
        CentreGestion: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."LPSA Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."Provisions LPSA");
        AddOnSetup.TestField("JIRAMA Ambohimanambola Loc");


        if EnteteTR."Transfer-to Code" = AddOnSetup."JIRAMA Ambohimanambola Loc" then exit;


        if EnteteTR."Transporter Code" = '' then
            Vend.Get(AddOnSetup."LPSA Vendor Code")
        else
            Vend.Get(EnteteTR."Transporter Code");


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;
        //GenJrnLine."External Document No." := EnteteTR."BEX Number";
        GenJrnLine."External Document No." := LigneTR."Item No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

        //IF EnteteTR."Location Code"=AddOnSetup."GRT Location Code" THEN //Transport massif
        //  GLAccNo := AddOnSetup."Fees Massif Transfer Account"
        //ELSE
        //  GLAccNo := AddOnSetup."Fees Transfer Account";//Transfert
        if EnteteTR."Location Code" = AddOnSetup."GRT Location Code" then
            GLAccNo := AddOnSetup."GRT Fees Storage Account"
        else
            GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.Validate("Account No.", GLAccNo);

        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        GenJrnLine.Description := BuildDescriptionProvisionPassageTransfert(DateDeb, DateFin, '');

        GetCentreGestionEnteteTransfer(CentreGestion, EnteteTR);
        GenJrnLine.CodeDepotProvisions := CentreGestion; //Centre de gestion

        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::PassageTransfer;
        //GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;

        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
        GenJrnLine.NumDocProvisions := GLAccNo;//FORMAT(EnteteTR."No.");
        //GenJrnLine.CodeArticleProvisions := LigneTR."Item No.";
        //GenJrnLine.CodeDepotDestProv := EnteteTR."Transfer-to Code";

        LineAmount := GetMontantProvisionsPassageTransfert(EnteteTR, LigneTR, EnteteTR."Transfer-to Code");
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine.Validate("Currency Code", '');

        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsPassageUnitPrice(LigneTR."Item No.", EnteteTR."Location Code",
            EnteteTR."Posting Date");//141117

        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";

        //IF Vend."No."=AddOnSetup."LPSA Vendor Code" THEN
        GLAccNo := AddOnSetup."Provisions LPSA";
        //ELSE
        //  GLAccNo := AddOnSetup."Invoice To Receive Account";

        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;

        //*******JN150218 Analytique
        //TODO
        // GenJrnLine.CreateDim(
        // DATABASE::Campaign,GenJrnLine."Campaign No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
        // DATABASE::Item,LigneTR."Item No.",
        // DATABASE::Job,GenJrnLine."Job No.");
        //*******JN150218


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);
    end;

    procedure AddLineProvisionTransportVente(EnteteFV: Record "Sales Invoice Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneFV: Record "Sales Invoice Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        EnteteBL: Record pro_enteteBL;
        Vend: Record Vendor;
        Camion: Record pro_moyentransport;
    begin

        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."Prov Transport Vente");
        AddOnSetup.TestField(AddOnSetup."Transport Item Category");
        AddOnSetup.TestField(AddOnSetup."Provisions LPSA");

        if LigneFV."Item Category Code" <> AddOnSetup."Transport Item Category" then exit;


        Cust2.Get(EnteteFV."Sell-to Customer No.");

        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;


        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Fees Transport Account";
        GenJrnLine.Validate("Account No.", GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");


        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::TransportVente;
        GenJrnLine.TiersProvisionNo := Cust2."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;

        //GenJrnLine.CodeDepotProvisions := EnteteBE.depot;

        GenJrnLine.VolumeProvisions := LigneFV.Quantity;
        //GenJrnLine.NumDocProvisions := FORMAT(EnteteFV."No.");//Canal de vente
        GenJrnLine.NumDocProvisions := Cust2."Sales Channel Code";//Canal de vente
        //GenJrnLine.CodeArticleProvisions := LigneFV."No.";

        EnteteBL.Reset;
        EnteteBL.SetRange(EnteteBL.NavOrderNo, EnteteFV."Order No.");
        EnteteBL.SetRange(EnteteBL.isconfirme, true);
        if EnteteBL.FindFirst then begin
            if Camion.Get(EnteteBL.codemoyentransport) then begin
                GenJrnLine.VendorCodeProvisions := Camion.codetransporteur;//Code transporteur
                GenJrnLine."External Document No." := Camion.codetransporteur;
                if Vend.Get(Camion.codetransporteur) then
                    if Vend."Name 2" <> '' then
                        GenJrnLine.TransporterNameProvisions := Vend."Name 2"
                    else
                        GenJrnLine.TransporterNameProvisions := Vend.Name;
            end;
        end;

        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        //GenJrnLine.Description := BuildDescriptionProvisionTransportVente(DateDeb,DateFin,(EnteteFV."No."),LigneFV.Description);
        GenJrnLine.Description := BuildDescriptionProvisionTransportVente(DateDeb, DateFin, GenJrnLine.VendorCodeProvisions, Cust2."Sales Channel Code");




        LineAmount := LigneFV.Amount;
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine."Shortcut Dimension 1 Code" := LigneFV."Shortcut Dimension 1 Code";
        GenJrnLine."Shortcut Dimension 2 Code" := LigneFV."Shortcut Dimension 2 Code";
        GenJrnLine."Dimension Set ID" := LigneFV."Dimension Set ID";

        GenJrnLine.Validate("Currency Code", '');


        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Provisions LPSA";
        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;


        if GenJrnLine.Amount <> 0 then begin
            GenJrnLine.Insert(true);
            GenJrnLine."Dimension Set ID" := LigneFV."Dimension Set ID";
            GenJrnLine.Modify;
        end;

        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);
    end;

    procedure AddLineProvisionFraisTransfert(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneBE: Record pro_detailBE;
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Fees Transfer Account");
        AddOnSetup.TestField(AddOnSetup."Fees Massif Transfer Account");
        AddOnSetup.TestField(AddOnSetup."Provisions LPSA");
        AddOnSetup.TestField("JIRAMA Ambohimanambola Loc");


        if EnteteTR."Transfer-to Code" = AddOnSetup."JIRAMA Ambohimanambola Loc" then exit;

        //IF Cust2.GET(SalesH."Sell-to Customer No.") THEN;

        if EnteteTR."Transporter Code" = '' then
            Vend.Get(AddOnSetup."LPSA Vendor Code")
        else
            Vend.Get(EnteteTR."Transporter Code");
        /*
        IF EnteteBE.depot=AddOnSetup."GRT Location Code" THEN
          Vend.GET(AddOnSetup."GRT Vendor Code")
        ELSE
          Vend.GET(AddOnSetup."LPSA Vendor Code");
          */


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;
        //GenJrnLine."External Document No." := EnteteTR."BEX Number";
        GenJrnLine."External Document No." := LigneTR."Item No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

        if EnteteTR."Location Code" = AddOnSetup."GRT Location Code" then //Transport massif
            GLAccNo := AddOnSetup."Fees Massif Transfer Account"
        else
            GLAccNo := AddOnSetup."Fees Transfer Account";//Transfert


        GenJrnLine.Validate("Account No.", GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        GenJrnLine.Description := BuildDescriptionProvisionTransfert(DateDeb, DateFin, '');

        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Transfer;
        //GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        //GenJrnLine.CodeDepotProvisions := EnteteTR."Location Code";

        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
        GenJrnLine.NumDocProvisions := GLAccNo;//FORMAT(EnteteTR."No.");
                                               //GenJrnLine.CodeArticleProvisions := LigneTR."Item No.";
                                               //GenJrnLine.CodeDepotDestProv := EnteteTR."Transfer-to Code";

        LineAmount := GetMontantProvisionsTransfert(EnteteTR, LigneTR, EnteteTR."Transfer-to Code");
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine.Validate("Currency Code", '');

        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsTransfertUnitPrice(EnteteTR."Location Code",
            EnteteTR."Transfer-to Code", EnteteTR."Receipt Date", LigneTR."USD Unit Price", LigneTR."USD Rate");//141117

        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";

        //IF Vend."No."=AddOnSetup."LPSA Vendor Code" THEN
        GLAccNo := AddOnSetup."Provisions LPSA";
        //ELSE
        //  GLAccNo := AddOnSetup."Invoice To Receive Account";

        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;

        //*******JN150218 Analytique
        //TODO
        // GenJrnLine.CreateDim(
        // DATABASE::Campaign,GenJrnLine."Campaign No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
        // DATABASE::Item,LigneTR."Item No.",
        // DATABASE::Job,GenJrnLine."Job No.");
        //*******JN150218


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);

    end;

    procedure AddLineProvisionFraisTransportJIRAMAAmbohimanambola(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneBE: Record pro_detailBE;
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField("Fees Transport Account");
        AddOnSetup.TestField("Invoice To Receive Acc Station");
        AddOnSetup.TestField("Ambohimanambola Fees Location");
        AddOnSetup.TestField("JIRAMA Ambohimanambola Loc");

        EnteteTR.TestField(EnteteTR."Transfer-to Code", AddOnSetup."JIRAMA Ambohimanambola Loc");


        //IF EnteteTR."Transporter Code"='' THEN
        //  Vend.GET(AddOnSetup."LPSA Vendor Code")
        //ELSE
        if Vend.Get(EnteteTR."Transporter Code") then;


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := EnteteTR."BEX Number";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";


        GLAccNo := AddOnSetup."Fees Transport Account";//Transport


        GenJrnLine.Validate("Account No.", GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        GenJrnLine.Description := BuildDescriptionProvisionTransfert(DateDeb, DateFin, Vend.Name);

        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Transfer;
        GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        GenJrnLine.CodeDepotProvisions := EnteteTR."Location Code";

        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
        GenJrnLine.NumDocProvisions := Format(EnteteTR."No.");
        GenJrnLine.CodeArticleProvisions := LigneTR."Item No.";
        GenJrnLine.CodeDepotDestProv := AddOnSetup."Ambohimanambola Fees Location";

        LineAmount := GetMontantProvisionsTransfert(EnteteTR, LigneTR, AddOnSetup."Ambohimanambola Fees Location");
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine.Validate("Currency Code", '');

        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsTransfertUnitPrice(EnteteTR."Location Code",
            AddOnSetup."Ambohimanambola Fees Location", EnteteTR."Receipt Date", LigneTR."USD Unit Price", LigneTR."USD Rate");//141117

        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";

        //IF Vend."No."=AddOnSetup."LPSA Vendor Code" THEN
        // GLAccNo := AddOnSetup."Provisions LPSA";
        //ELSE
        GLAccNo := AddOnSetup."Invoice To Receive Acc Station";

        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;


        //*******JN150218 Analytique
        //TODO
        // GenJrnLine.CreateDim(
        // DATABASE::Campaign,GenJrnLine."Campaign No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
        // DATABASE::Item,LigneTR."Item No.",
        // DATABASE::Job,GenJrnLine."Job No.");
        //*******JN150218


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);
    end;

    procedure AddLineProvisionFraisTransfertToAmbatovy(EnteteTR: Record "Posted Adjustment Header"; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneTR: Record "Posted Adjustment Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        LigneBE: Record pro_detailBE;
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Fees Transfer Account");
        AddOnSetup.TestField(AddOnSetup."Provisions LPSA");

        if EnteteTR."Transfer-to Code" = '' then exit;


        Vend.Get(EnteteTR."Transporter Code");



        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;
        GenJrnLine."External Document No." := EnteteTR."BEX Number";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

        //IF EnteteTR."Location Code"=AddOnSetup."GRT Location Code" THEN //Transport massif
        //  GLAccNo := AddOnSetup."Fees Massif Transfer Account"
        //ELSE
        GLAccNo := AddOnSetup."Fees Transfer Account";//Transfert


        GenJrnLine.Validate("Account No.", GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        GenJrnLine.Description := BuildDescriptionProvisionTransfert(DateDeb, DateFin, Vend.Name);

        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Transfer;
        GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        GenJrnLine.CodeDepotProvisions := EnteteTR."Location Code";

        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneTR."Item No.", LigneTR.Quantity, LigneTR."Unit of Measure Code");
        GenJrnLine.NumDocProvisions := Format(EnteteTR."No.");
        GenJrnLine.CodeArticleProvisions := LigneTR."Item No.";
        GenJrnLine.CodeDepotDestProv := EnteteTR."Transfer-to Code";

        LineAmount := GetMontantProvisionsTransfertToAmbatovy(EnteteTR, LigneTR, EnteteTR."Transfer-to Code");
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine.Validate("Currency Code", '');

        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsTransfertToAmbatovyUnitPrice(EnteteTR."Location Code",
            EnteteTR."Transfer-to Code", EnteteTR."Receipt Date", LigneTR."USD Unit Price", LigneTR."USD Rate", EnteteTR."Transporter Code");//141117

        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";

        //IF Vend."No."=AddOnSetup."LPSA Vendor Code" THEN
        GLAccNo := AddOnSetup."Provisions LPSA";
        //ELSE
        //  GLAccNo := AddOnSetup."Invoice To Receive Account";

        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;

        //*******JN150218 Analytique
        //TODO
        // GenJrnLine.CreateDim(
        // DATABASE::Campaign,GenJrnLine."Campaign No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
        // DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
        // DATABASE::Item,LigneTR."Item No.",
        // DATABASE::Job,GenJrnLine."Job No.");
        //*******JN150218

        AddOnSetup.TestField(AddOnSetup."Prov Transfert Amba Region");
        AddOnSetup.TestField(AddOnSetup."Prov Transfert Amba Project");
        GenJrnLine.ValidateShortcutDimCode(4, AddOnSetup."Prov Transfert Amba Region");//Region
        GenJrnLine.ValidateShortcutDimCode(5, AddOnSetup."Prov Transfert Amba Project");//Projet


        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);
    end;

    local procedure BuildDescriptionProvisionPassage(DateDeb: Date; DateFin: Date; NomFsseur: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := StrSubstNo(Text001, DateDeb, DateFin, NomFsseur);
        exit(CopyStr(rep, 1, 49));
    end;

    local procedure BuildDescriptionProvisionPassageTransfert(DateDeb: Date; DateFin: Date; NomFsseur: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := StrSubstNo(Text004, DateDeb, DateFin, NomFsseur);
        exit(CopyStr(rep, 1, 49));
    end;

    local procedure BuildDescriptionProvisionTransfert(DateDeb: Date; DateFin: Date; NomFsseur: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := StrSubstNo(Text002, DateDeb, DateFin, NomFsseur);
        exit(CopyStr(rep, 1, 49));
    end;

    local procedure BuildDescriptionProvisionTransportVente(DateDeb: Date; DateFin: Date; NoFacture: Text[20]; CustName: Text[50]): Text[50]
    var
        rep: Text[100];
    begin
        rep := StrSubstNo(Text003, DateDeb, DateFin, NoFacture);
        exit(CopyStr(rep, 1, 49));
    end;

    local procedure GetMontantProvisionsPassage(EnteteBE: Record pro_enteteBE; LigneBL: Record pro_detailBL): Decimal
    var
        ReturnAmt: Decimal;
    begin

        exit(ProvPricingMgt.GetProvisionsPassage(EnteteBE, LigneBL));
    end;

    local procedure GetMontantProvisionsPassageTransfert(EnteteTR: Record "Posted Adjustment Header"; LigneTR: Record "Posted Adjustment Line"; TransferToCode: Code[20]): Decimal
    var
        ReturnAmt: Decimal;
    begin

        exit(ProvPricingMgt.GetProvisionsPassageTransfert(EnteteTR, LigneTR, TransferToCode));
    end;

    local procedure GetMontantProvisionsTransfert(EnteteTR: Record "Posted Adjustment Header"; LigneTR: Record "Posted Adjustment Line"; TransferToCode: Code[20]): Decimal
    var
        ReturnAmt: Decimal;
    begin

        exit(ProvPricingMgt.GetProvisionsTransfert(EnteteTR, LigneTR, TransferToCode));
    end;

    local procedure GetMontantProvisionsTransfertToAmbatovy(EnteteTR: Record "Posted Adjustment Header"; LigneTR: Record "Posted Adjustment Line"; TransferToCode: Code[20]): Decimal
    var
        ReturnAmt: Decimal;
    begin

        exit(ProvPricingMgt.GetProvisionsTransfertToAmbatovy(EnteteTR, LigneTR, TransferToCode));
    end;

    procedure ConfirmProvisionsPassage(DateDeb: Date; DateFin: Date)
    var
        PurchH1: Record "Purchase Header";
        EnteteBE: Record pro_enteteBE;
    begin

        /*IF EnteteBE.GET(NumBE) THEN BEGIN
          EnteteBE.Provisioned:=TRUE;
          EnteteBE.MODIFY;
        END;*/

        EnteteBE.Reset;
        EnteteBE.SetRange(dateBE, DateDeb, DateFin);
        EnteteBE.ModifyAll(Provisioned, true);

    end;

    procedure ConfirmProvisionsPassageTransfert(DateDeb: Date; DateFin: Date)
    var
        PurchH1: Record "Purchase Header";
        EnteteTR: Record "Posted Adjustment Header";
    begin

        EnteteTR.Reset;
        EnteteTR.SetRange("Document Type", EnteteTR."Document Type"::Transfer);
        EnteteTR.SetRange("Posting Date", DateDeb, DateFin);
        EnteteTR.ModifyAll(ProvisionedPassage, true);
    end;

    procedure ConfirmProvisionsTransfert(DateDeb: Date; DateFin: Date; GLAccNo: Code[20])
    var
        PurchH1: Record "Purchase Header";
        EnteteTR: Record "Posted Adjustment Header";
        IsMassif: Boolean;
    begin

        /*IF EnteteTR.GET(EnteteTR."Document Type"::Transfer, NumTR) THEN BEGIN
          EnteteTR.Provisioned:=TRUE;
          EnteteTR.MODIFY;
        END;*/
        AddOnSetup.Get;

        if GLAccNo = AddOnSetup."Fees Massif Transfer Account" then
            IsMassif := true;

        EnteteTR.Reset;
        EnteteTR.SetRange("Document Type", EnteteTR."Document Type"::Transfer);
        EnteteTR.SetRange("Receipt Date", DateDeb, DateFin);

        if IsMassif then
            EnteteTR.SetRange("Location Code", AddOnSetup."GRT Location Code")
        else
            EnteteTR.SetFilter("Location Code", '<>%1', AddOnSetup."GRT Location Code");

        EnteteTR.ModifyAll(Provisioned, true);

    end;

    procedure ConfirmProvisionsTransportVente(DateDeb: Date; DateFin: Date)
    var
        PurchH1: Record "Purchase Header";
        EnteteFV: Record "Sales Invoice Header";
    begin

        /*IF EnteteFV.GET(NumFacture) THEN BEGIN
          EnteteFV.Provisioned:=TRUE;
          EnteteFV.MODIFY;
        END;*/

        EnteteFV.Reset;
        EnteteFV.SetRange("Posting Date", DateDeb, DateFin);
        EnteteFV.ModifyAll(Provisioned, true);

    end;

    procedure TraiterProvisionFraisPassage_270818(EnteteBE: Record pro_enteteBE; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneBE: Record pro_detailBE): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
    begin

        //Comment isoler les enlevements JIRAMA ou par pipeline
        //IF EnteteBE.Source=EnteteBE.Source::" " THEN EXIT;
        /*
        IF EnteteBE.Provisioned THEN EXIT;
        
        AddOnSetup.GET;
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TESTFIELD(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Location Code");
        
        IF EnteteBE.depot=AddOnSetup."GRT Location Code" THEN
          Vend.GET(AddOnSetup."GRT Vendor Code")
        ELSE
          Vend.GET(AddOnSetup."LPSA Vendor Code");
        
        CLEAR(GenJrnLine);
        GenJrnLine.SETRANGE("Journal Template Name",ModeleFeuille);
        GenJrnLine.SETRANGE("Journal Batch Name", CodeFeuille);
        GenJrnLine.SETRANGE(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::Passage);
        GenJrnLine.SETRANGE(GenJrnLine.TiersProvisionNo,Vend."No.");
        GenJrnLine.SETRANGE(GenJrnLine.CodeDepotProvisions,EnteteBE.depot);
        
        GenJrnLine.SETRANGE(GenJrnLine.NumDocProvisions,FORMAT(EnteteBE.numBE));
        GenJrnLine.SETRANGE(GenJrnLine.CodeArticleProvisions,FORMAT(LigneBE.NavItemCode));
        
        
        IF GenJrnLine.FINDFIRST THEN BEGIN
        
          LineAmount := GetMontantProvisionsPassage(EnteteBE,LigneBL);
          GenJrnLine.VALIDATE("Debit Amount" , GenJrnLine."Debit Amount" + LineAmount);
          GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                  ProvPricingMgt.CalcQtyM3(LigneBE.NavItemCode,LigneBE.volumeenleve,LigneBE."Unit of Measure Code");
          GenJrnLine.MODIFY;
        
        END ELSE BEGIN
        
          AddLineProvisionFraisPassage(EnteteBE,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,
            DateDeb,DateFin,LineNo,LigneBE);
        
        END;
        */

    end;

    local procedure GetMontantProvisionsPassage_270818(EnteteBE: Record pro_enteteBE; LigneBE: Record pro_detailBE): Decimal
    var
        ReturnAmt: Decimal;
    begin
        /*
        EXIT(ProvPricingMgt.GetProvisionsPassage(EnteteBE,LigneBE));
        */

    end;

    procedure AddLineProvisionFraisPassage_270818(EnteteBE: Record pro_enteteBE; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneBE: Record pro_detailBE): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
        Loc3: Record Location;
    begin
        /*
        AddOnSetup.GET;
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TESTFIELD(AddOnSetup."LPSA Fees Storage Account");
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TESTFIELD(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TESTFIELD(AddOnSetup."GRT Location Code");
        AddOnSetup.TESTFIELD(AddOnSetup."Provisions LPSA");
        
        //IF Cust2.GET(SalesH."Sell-to Customer No.") THEN;
        
        IF EnteteBE.depot=AddOnSetup."GRT Location Code" THEN
          Vend.GET(AddOnSetup."GRT Vendor Code")
        ELSE
          Vend.GET(AddOnSetup."LPSA Vendor Code");
        
        
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
        GenJrnLine."External Document No." := Vend."No.";
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        
        IF EnteteBE.depot=AddOnSetup."GRT Location Code" THEN
          GLAccNo := AddOnSetup."GRT Fees Storage Account"
        ELSE
          GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.VALIDATE("Account No.",GLAccNo);
        GenJrnLine.VALIDATE("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        
        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        GenJrnLine.Description := BuildDescriptionProvisionPassage(DateDeb,DateFin,Vend.Name);
        
        GenJrnLine.TypeProvision:=GenJrnLine.TypeProvision::Passage;
        GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        GenJrnLine.CodeDepotProvisions := EnteteBE.depot;
        GenJrnLine."External Document No." := EnteteBE.numBSL;
        
        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneBE.NavItemCode,LigneBE.volumeenleve,LigneBE."Unit of Measure Code");
        GenJrnLine.NumDocProvisions := FORMAT(EnteteBE.numBE);
        GenJrnLine.CodeArticleProvisions := LigneBE.NavItemCode;
        
        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsPassageUnitPrice(LigneBE.NavItemCode,EnteteBE.depot,EnteteBE.dateBE);//141117
        
        LineAmount := GetMontantProvisionsPassage(EnteteBE,LigneBE);
        GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount);
        
        GenJrnLine.VALIDATE("Currency Code",'');
        
        
        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Provisions LPSA";
        GenJrnLine.VALIDATE(GenJrnLine."Bal. Account No.",GLAccNo);
        GenJrnLine.VALIDATE(GenJrnLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;
        
        
        //Analytique region
        EnteteBE.TESTFIELD(EnteteBE.depot);
        IF Loc3.GET(EnteteBE.depot) THEN BEGIN
          Loc3.TESTFIELD(Loc3."Responsibility Center");
          GenJrnLine.CreateDim(
          DATABASE::Item,LigneBE.NavItemCode,                                           //*******JN150218 Analytique
          DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
          DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
          DATABASE::Job,GenJrnLine."Job No.",
          DATABASE::"Responsibility Center",Loc3."Responsibility Center");
        END;
        
        IF GenJrnLine.Amount<>0 THEN
          GenJrnLine.INSERT(TRUE);
        
        
        IF GenJrnLine.Amount<>0 THEN
          EXIT(TRUE);
        EXIT(FALSE);
        */

    end;

    local procedure GetCanalVteTransporteurFactureVente(var CanalVente: Code[30]; var CodeTransporteur: Code[30]; EnteteFV: Record "Sales Invoice Header")
    var
        Cust2: Record Customer;
        Camion: Record pro_moyentransport;
        EnteteBL: Record pro_enteteBL;
    begin
        /*
        IF SalesH.GET(SalesH."Document Type"::Order,EnteteBL.NavOrderNo) THEN
          IF Cust2.GET(SalesH."Sell-to Customer No.") THEN
            CanalVente=Cust2."Sales Channel Code";
        
        IF CanalVente='' THEN BEGIN
         SalesHeaderArchive.RESET;
         SalesHeaderArchive.FINDFIRST(SalesHeaderArchive."Document Type",SalesHeaderArchive."Document Type"::Order);
         SalesHeaderArchive.SETRANGE(SalesHeaderArchive."No.",EnteteBL.NavOrderNo);
         IF SalesHeaderArchive.FINDFIRST THEN
           IF Cust2.GET(SalesHeaderArchive."Sell-to Customer No.") THEN
            CanalVente=Cust2."Sales Channel Code";
        END;
        */

        if Cust2.Get(EnteteFV."Sell-to Customer No.") then
            CanalVente := Cust2."Sales Channel Code";

        EnteteBL.Reset;
        EnteteBL.SetRange(EnteteBL.NavOrderNo, EnteteFV."Order No.");
        EnteteBL.SetRange(EnteteBL.isconfirme, true);
        if EnteteBL.FindFirst then begin
            if Camion.Get(EnteteBL.codemoyentransport) then begin
                CodeTransporteur := Camion.codetransporteur;
            end;
        end;

    end;

    local procedure GetCanalVteEnteteBL(var CanalVente: Code[30]; EnteteBL: Record pro_enteteBL; var CodeClient: Code[20])
    var
        Cust2: Record Customer;
        Camion: Record pro_moyentransport;
        SalesH: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin

        if SalesH.Get(SalesH."Document Type"::Order, EnteteBL.NavOrderNo) then
            if Cust2.Get(SalesH."Sell-to Customer No.") then begin
                CanalVente := Cust2."Sales Channel Code";
                CodeClient := Cust2."No.";
            end;

        if CanalVente = '' then begin
            SalesHeaderArchive.Reset;
            SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
            SalesHeaderArchive.SetRange("No.", EnteteBL.NavOrderNo);
            if SalesHeaderArchive.FindLast then
                if Cust2.Get(SalesHeaderArchive."Sell-to Customer No.") then begin
                    CanalVente := Cust2."Sales Channel Code";
                    CodeClient := Cust2."No.";
                end;
        end;
    end;

    local procedure GetCentreGestionEnteteBE(var CentreGestion: Code[30]; EnteteBE: Record pro_enteteBE)
    var
        Cust2: Record Customer;
        Camion: Record pro_moyentransport;
        SalesH: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        Loc3: Record Location;
    begin
        if Loc3.Get(EnteteBE.depot) then
            CentreGestion := Loc3."Responsibility Center";
    end;

    local procedure GetCentreGestionEnteteTransfer(var CentreGestion: Code[30]; EnteteTR: Record "Posted Adjustment Header")
    var
        Cust2: Record Customer;
        Camion: Record pro_moyentransport;
        SalesH: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        Loc3: Record Location;
    begin
        if Loc3.Get(EnteteTR."Location Code") then
            CentreGestion := Loc3."Responsibility Center";
    end;

    procedure TraiterProvisionFraisPassage_TEST(EnteteBE: Record pro_enteteBE; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneBL: Record pro_detailBL; EnteteBL: Record pro_enteteBL): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
        CanalVente: Code[30];
        CentreGestion: Code[30];
        CustNo: Code[20];
    begin

        //Comment isoler les enlevements JIRAMA ou par pipeline
        //IF EnteteBE.Source=EnteteBE.Source::" " THEN EXIT;

        //IF EnteteBE.Provisioned THEN EXIT;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TestField(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TestField(AddOnSetup."GRT Location Code");

        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            Vend.Get(AddOnSetup."GRT Vendor Code")
        else
            Vend.Get(AddOnSetup."LPSA Vendor Code");

        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine.TypeProvision, GenJrnLine.TypeProvision::Passage);


        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            GLAccNo := AddOnSetup."GRT Fees Storage Account"
        else
            GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.SetRange(GenJrnLine."Account No.", GLAccNo);

        GetCanalVteEnteteBL(CanalVente, EnteteBL, CustNo);

        //GenJrnLine.SETRANGE(GenJrnLine.TiersProvisionNo,Vend."No.");
        GenJrnLine.SetRange(GenJrnLine."External Document No.", CanalVente);

        GetCentreGestionEnteteBE(CentreGestion, EnteteBE);
        GenJrnLine.SetRange(GenJrnLine.CodeDepotProvisions, CentreGestion);//Centre de gestion

        GenJrnLine.SetRange(GenJrnLine.NumDocProvisions, Format(EnteteBE.numBE));
        //GenJrnLine.SETRANGE(GenJrnLine.CodeArticleProvisions,FORMAT(LigneBL.NavItemCode));


        if GenJrnLine.FindFirst then begin

            LineAmount := GetMontantProvisionsPassage(EnteteBE, LigneBL);
            GenJrnLine.Validate("Debit Amount", GenJrnLine."Debit Amount" + LineAmount);
            GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions +
                    ProvPricingMgt.CalcQtyM3(LigneBL.NavItemCode, LigneBL.volumelivre, LigneBL."Unit of Measure Code");
            GenJrnLine.Modify;

        end else begin

            AddLineProvisionFraisPassage_TEST(EnteteBE, ModeleFeuille, CodeFeuille, PostingDate, DocumentNo,
              DateDeb, DateFin, LineNo, LigneBL, EnteteBL);

        end;
    end;

    procedure AddLineProvisionFraisPassage_TEST(EnteteBE: Record pro_enteteBE; ModeleFeuille: Code[20]; CodeFeuille: Code[20]; PostingDate: Date; DocumentNo: Code[20]; DateDeb: Date; DateFin: Date; var LineNo: Integer; LigneBL: Record pro_detailBL; EnteteBL: Record pro_enteteBL): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        QteToInvoice: Decimal;
        Vend: Record Vendor;
        Loc3: Record Location;
        CanalVente: Code[30];
        CentreGestion: Code[30];
        CustNo: Code[20];
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."GRT Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."LPSA Fees Storage Account");
        AddOnSetup.TestField(AddOnSetup."GRT Vendor Code");
        AddOnSetup.TestField(AddOnSetup."LPSA Vendor Code");
        AddOnSetup.TestField(AddOnSetup."GRT Location Code");
        AddOnSetup.TestField(AddOnSetup."Provisions LPSA");

        //IF Cust2.GET(SalesH."Sell-to Customer No.") THEN;

        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            Vend.Get(AddOnSetup."GRT Vendor Code")
        else
            Vend.Get(AddOnSetup."LPSA Vendor Code");


        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name" := ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;

        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date", PostingDate);

        GenJrnLine."Document No." := DocumentNo;

        //EnteteBL.GET(LigneBL.numBL);
        //IF(EnteteBL.c
        //TODO Renseigner le canal de vente ici

        //GenJrnLine."External Document No." := Vend."No.";

        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";

        if EnteteBE.depot = AddOnSetup."GRT Location Code" then
            GLAccNo := AddOnSetup."GRT Fees Storage Account"
        else
            GLAccNo := AddOnSetup."LPSA Fees Storage Account";
        GenJrnLine.Validate("Account No.", GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");

        GetCanalVteEnteteBL(CanalVente, EnteteBL, CustNo);


        GenJrnLine."External Document No." := CanalVente;


        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);
        GenJrnLine.Description := BuildDescriptionProvisionPassage(DateDeb, DateFin, CanalVente);

        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Passage;
        //GenJrnLine.TiersProvisionNo := Vend."No.";
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;

        GetCentreGestionEnteteBE(CentreGestion, EnteteBE);
        GenJrnLine.CodeDepotProvisions := CentreGestion; //Centre de gestion
        //GenJrnLine."External Document No." := EnteteBE.numBSL;

        //GenJrnLine.TiersProvisionNo := EnteteBE.numBSL;
        GenJrnLine.CodeArticleProvisions := EnteteBE.numBSL;


        GenJrnLine.VolumeProvisions := ProvPricingMgt.CalcQtyM3(LigneBL.NavItemCode, LigneBL.volumelivre, LigneBL."Unit of Measure Code");
        GenJrnLine.NumDocProvisions := Format(EnteteBE.numBE);
        //GenJrnLine.CodeArticleProvisions := LigneBL.NavItemCode;

        GenJrnLine.FraisProvisions := ProvPricingMgt.GetProvisionsPassageUnitPrice(LigneBL.NavItemCode, EnteteBE.depot, EnteteBE.dateBE);//141117

        LineAmount := GetMontantProvisionsPassage(EnteteBE, LigneBL);
        GenJrnLine.Validate(GenJrnLine.Amount, LineAmount);

        GenJrnLine.Validate("Currency Code", '');


        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := AddOnSetup."Provisions LPSA";
        GenJrnLine.Validate(GenJrnLine."Bal. Account No.", GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;


        //Analytique region
        EnteteBE.TestField(EnteteBE.depot);
        if Loc3.Get(EnteteBE.depot) then begin
            Loc3.TestField(Loc3."Responsibility Center");
            //TODO
            // GenJrnLine.CreateDim(
            // DATABASE::Job,GenJrnLine."Job No.",                                           //*******JN150218 Analytique
            // DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
            // DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
            // DATABASE::Customer,CustNo,
            // DATABASE::"Responsibility Center",Loc3."Responsibility Center");
        end;

        if GenJrnLine.Amount <> 0 then
            GenJrnLine.Insert(true);


        if GenJrnLine.Amount <> 0 then
            exit(true);
        exit(false);
    end;
}

