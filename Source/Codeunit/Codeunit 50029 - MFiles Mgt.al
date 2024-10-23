codeunit 50029 "MFiles Mgt"
{

    trigger OnRun()
    var
        Purch: Record "Purchase Header";
    begin
    end;

    var
        Text001: Label 'Facture créée à partir du document importé MFiles %1';
        Text002: Label 'Une facture avec cette référence fournisseur existe déjà. Facture N° %1';
        Text003: Label 'Voulez-vous créer la facture fournisseur ?';
        Text004: Label 'Le montant de cette facture %1 ne correspond pas au montant du document MFiles %2 qui est %3';
        Text005: Label 'Il n''existe pas de facture MFiles avec ce code facture fournisseur : %1';
        AddOnSetup: Record "AddOn Setup";
        Text006: Label 'La ligne %1 - %2 du document MFiles est introuvable sur la facture';
        GLSetup: Record "General Ledger Setup";
        Text007: Label 'Le code budget de la ligne %1 ne correspond pas au document MFiles';
        Text008: Label 'Le code centre de cout de la ligne %1 ne correspond pas au document MFiles';
        Text009: Label 'Le code centre de profit de la ligne %1 ne correspond pas au document MFiles';
        Text010: Label 'Le code région de la ligne %1 ne correspond pas au document MFiles';
        Text011: Label 'Le code projet de la ligne %1 ne correspond pas au document MFiles';
        Text012: Label 'Le delai de paiement doit correspondre à celui du document MFiles %1';
        Text013: Label 'Le numéro de commande doit correspondre à celui du document MFiles %1';
        Text014: Label 'Le code centre de profit 2 de la ligne %1 ne correspond pas au document MFiles';
        Text015: Label 'Le code axe produit de la ligne %1 ne correspond pas au document MFiles';
        PayTolMgt: Codeunit "Payment Tolerance Management";
        CurrExchRate: Record "Currency Exchange Rate";

    procedure CreatePurchInvoice(tblFacture: Record tblFacture)
    var
        PurchInv: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchH: Record "Purchase Header";
        InvoiceCard: Page "Purchase Invoice";
        tblFactureLine: Record tblAxeAnalytique;
        numLine: Integer;
    begin

        AddOnSetup.Get;
        if not AddOnSetup."MFiles Mgt" then exit;

        //Controles
        tblFacture.TestField(FactureDirecte);
        tblFacture.TestField(NumeroFournisseur);
        tblFacture.TestField(DateNav);
        tblFacture.TestField(NumeroFacture);

        //Controler qu'il nexiste pas une facture avec le mm num fact fsseur
        PurchH.Reset;
        PurchH.SetRange("Buy-from Vendor No.", tblFacture.NumeroFournisseur);
        PurchH.SetRange("Vendor Invoice No.", tblFacture.NumeroFacture);
        if PurchH.FindFirst then
            Error(Text002, PurchH."No.");

        if not Confirm(Text003) then exit;

        Clear(PurchInv);
        PurchInv."Document Type" := PurchInv."Document Type"::Invoice;
        PurchInv."No." := '';
        PurchInv.Insert(true);

        PurchInv.Validate("Posting Date", tblFacture.DateNav);
        PurchInv.Validate("Buy-from Vendor No.", tblFacture.NumeroFournisseur);
        PurchInv.Validate("Payment Terms Code", tblFacture.NouveauDelaiPaiement);
        PurchInv.Observations := StrSubstNo(Text001, tblFacture.ID);
        PurchInv."Vendor Invoice No." := tblFacture.NumeroFacture;
        PurchInv.MFilesURL := tblFacture.MFilesURL;
        //PurchInv."MFiles Invoice" := TRUE;
        PurchInv.Modify;



        tblFactureLine.Reset;
        tblFactureLine.SetRange(IDFacture, tblFacture.ID);
        if tblFactureLine.FindSet then
            repeat

                tblFactureLine.TestField(CodeLigne);

                Clear(PurchLine);
                PurchLine."Document Type" := PurchInv."Document Type";
                PurchLine."Document No." := PurchInv."No.";
                numLine := numLine + 10000;
                PurchLine."Line No." := numLine;
                if tblFactureLine.TypeLigne = tblFactureLine.TypeLigne::"Charge (Item)" then
                    PurchLine.Type := PurchLine.Type::"Charge (Item)";
                if tblFactureLine.TypeLigne = tblFactureLine.TypeLigne::"Fixed Asset" then
                    PurchLine.Type := PurchLine.Type::"Fixed Asset";
                if tblFactureLine.TypeLigne = tblFactureLine.TypeLigne::"G/L Account" then
                    PurchLine.Type := PurchLine.Type::"G/L Account";
                if tblFactureLine.TypeLigne = tblFactureLine.TypeLigne::Item then
                    PurchLine.Type := PurchLine.Type::Item;
                PurchLine.Validate("No.", tblFactureLine.CodeLigne);
                PurchLine.Validate(Quantity, 1);
                PurchLine.Validate("Direct Unit Cost", tblFactureLine.MontantHTVA);

                PurchLine.ValidateShortcutDimCode(3, tblFactureLine.CodeBudget);
                PurchLine.ValidateShortcutDimCode(2, tblFactureLine.CodeCentreCout);
                PurchLine.ValidateShortcutDimCode(1, tblFactureLine.CodeCentreProfit);
                PurchLine.ValidateShortcutDimCode(4, tblFactureLine.CodeRegion);
                PurchLine.ValidateShortcutDimCode(5, tblFactureLine.CodeProjet);
                PurchLine.ValidateShortcutDimCode(7, tblFactureLine.CodeCentreProfit2);
                PurchLine.ValidateShortcutDimCode(8, tblFactureLine.CodeProduit);
                PurchLine."MFiles ID" := tblFactureLine.ID;

                PurchLine.Insert;

            until tblFactureLine.Next = 0;


        PurchInv."MFiles Invoice" := true;
        PurchInv.Modify;


        InvoiceCard.SetTableView(PurchInv);
        InvoiceCard.SetRecord(PurchInv);
        InvoiceCard.Run;
    end;

    procedure ConfirmMFilesInvoice(VendorInvoiceNo: Code[20]; VendorNo: Code[20])
    var
        tblFacture: Record tblFacture;
    begin
        tblFacture.Reset;
        tblFacture.SetRange(NumeroFournisseur, VendorNo);
        tblFacture.SetRange(NumeroFacture, VendorInvoiceNo);
        if tblFacture.FindFirst then begin
            tblFacture.Statut := tblFacture.Statut::Integrated;
            tblFacture.Modify;
        end;
    end;

    procedure CheckMFilesOrder(PurchOrder: Record "Purchase Header")
    var
        tblFacture: Record tblFacture;
        MontantFacture: Decimal;
        Curr: Record Currency;
        Tolerance: Decimal;
    begin


        if PurchOrder."Created By Doc Type" <> PurchOrder."Created By Doc Type"::" " then exit;

        AddOnSetup.Get;
        if not AddOnSetup."MFiles Mgt" then exit;

        PurchOrder.TestField("Vendor Invoice No.");

        tblFacture.Reset;
        tblFacture.SetRange(NumeroFournisseur, PurchOrder."Buy-from Vendor No.");
        tblFacture.SetRange(NumeroFacture, PurchOrder."Vendor Invoice No.");
        if tblFacture.FindFirst then begin

            MontantFacture := CalcMontantTotalHT(PurchOrder);

            if PurchOrder."Currency Code" = '' then
                Curr.InitRoundingPrecision
            else
                Curr.Get(PurchOrder."Currency Code");

            //IF (ROUND(tblFacture.MontantHTVA,Curr."Amount Rounding Precision") <> ROUND(MontantFacture,Curr."Amount Rounding Precision")) THEN
            //  ERROR(Text004,MontantFacture,PurchOrder."Vendor Invoice No.",tblFacture.MontantHTVA);
            Tolerance := GetPayTolerance(PurchOrder, MontantFacture);
            if Abs(MontantFacture - tblFacture.MontantHTVA) > Abs(Tolerance) then
                Error(Text004, MontantFacture, PurchOrder."Vendor Invoice No.", tblFacture.MontantHTVA);


            if PurchOrder."Document Type" = PurchOrder."Document Type"::Order then
                if tblFacture.NumeroBDC <> '' then
                    if tblFacture.NumeroBDC <> PurchOrder."No." then
                        Error(Text013, tblFacture.NumeroBDC);

            /*IF tblFacture.NouveauDelaiPaiement <> '' THEN
              IF tblFacture.NouveauDelaiPaiement <> PurchOrder."Payment Terms Code" THEN
                ERROR(Text012,tblFacture.NouveauDelaiPaiement);*/

            CheckLines(tblFacture, PurchOrder);

            tblFacture.Statut := tblFacture.Statut::Integrated;
            tblFacture.Modify;
        end else begin

            if not AddOnSetup."Remove MFiles Num Check" then
                Error(Text005, PurchOrder."Vendor Invoice No.");

        end;

    end;

    local procedure CalcMontantTotalHT(PurchOrder: Record "Purchase Header") Rep: Decimal
    var
        PurchLine: Record "Purchase Line";
    begin

        if PurchOrder."Document Type" = PurchOrder."Document Type"::Order then begin

            PurchLine.Reset;
            PurchLine.SetRange("Document Type", PurchOrder."Document Type");
            PurchLine.SetRange("Document No.", PurchOrder."No.");
            if PurchLine.FindSet then
                repeat

                    Rep := Rep + GetAmtToInvoiceHt(PurchLine, PurchOrder);
                until PurchLine.Next = 0;

        end else begin
            PurchOrder.CalcFields(PurchOrder.Amount);
            Rep := PurchOrder.Amount;
        end;
    end;

    procedure OpenCreatedInv(tblFacture: Record tblFacture)
    var
        InvoiceCard: Page "Purchase Invoice";
        PurchH: Record "Purchase Header";
    begin
        PurchH.Reset;
        PurchH.SetRange("Buy-from Vendor No.", tblFacture.NumeroFournisseur);
        PurchH.SetRange("Vendor Invoice No.", tblFacture.NumeroFacture);
        if PurchH.FindFirst then begin
            InvoiceCard.SetTableView(PurchH);
            InvoiceCard.SetRecord(PurchH);
            InvoiceCard.Run;
        end;
    end;

    procedure OpenPostedInv(tblFacture: Record tblFacture)
    var
        InvoiceCard: Page "Posted Purchase Invoice";
        PurchH: Record "Purch. Inv. Header";
    begin
        PurchH.Reset;
        PurchH.SetRange("Buy-from Vendor No.", tblFacture.NumeroFournisseur);
        PurchH.SetRange("Vendor Invoice No.", tblFacture.NumeroFacture);
        if PurchH.FindFirst then begin
            InvoiceCard.SetTableView(PurchH);
            InvoiceCard.SetRecord(PurchH);
            InvoiceCard.Run;
        end;
    end;

    local procedure CheckLines(tblFacture: Record tblFacture; PurchOrder: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        tblFactureLine: Record tblAxeAnalytique;
    begin

        GLSetup.Get;

        tblFactureLine.Reset;
        tblFactureLine.SetRange(IDFacture, tblFacture.ID);
        if tblFactureLine.FindSet then
            repeat

                PurchLine.Reset;
                PurchLine.SetRange("Document Type", PurchOrder."Document Type");
                PurchLine.SetRange("Document No.", PurchOrder."No.");
                PurchLine.SetRange(PurchLine."MFiles ID", tblFactureLine.ID);
                if PurchLine.FindFirst then begin

                    PurchLine.TestField(PurchLine."Direct Unit Cost", tblFactureLine.MontantHTVA);
                    PurchLine.TestField(PurchLine."No.", tblFactureLine.CodeLigne);
                    CheckDimCode(PurchLine, tblFactureLine);

                end else begin
                    Error(Text006, tblFactureLine.ID, tblFactureLine.CodeLigne);
                end;

            until tblFactureLine.Next = 0;
    end;

    local procedure CheckDimCode(PurchLine: Record "Purchase Line"; tblFactureLine: Record tblAxeAnalytique)
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin

        if DimSetEntry.Get(PurchLine."Dimension Set ID", GLSetup."Shortcut Dimension 3 Code") then
            if tblFactureLine.CodeBudget <> DimSetEntry."Dimension Value Code" then
                Error(Text007, PurchLine."Line No.");

        if DimSetEntry.Get(PurchLine."Dimension Set ID", GLSetup."Shortcut Dimension 2 Code") then
            if tblFactureLine.CodeCentreCout <> DimSetEntry."Dimension Value Code" then
                Error(Text008, PurchLine."Line No.");

        if DimSetEntry.Get(PurchLine."Dimension Set ID", GLSetup."Shortcut Dimension 1 Code") then
            if tblFactureLine.CodeCentreProfit <> DimSetEntry."Dimension Value Code" then
                Error(Text009, PurchLine."Line No.");

        if DimSetEntry.Get(PurchLine."Dimension Set ID", GLSetup."Shortcut Dimension 7 Code") then
            if tblFactureLine.CodeCentreProfit2 <> DimSetEntry."Dimension Value Code" then
                Error(Text014, PurchLine."Line No.");

        //IF DimSetEntry.GET(PurchLine."Dimension Set ID",GLSetup."Shortcut Dimension 8 Code") THEN
        //  IF tblFactureLine.CodeAxeProduit <> DimSetEntry."Dimension Value Code" THEN
        //    ERROR(Text015,PurchLine."Line No.");
    end;

    procedure GetMFilesURL(VendOrderNo: Code[20]; VendorNo: Code[20]): Text[100]
    var
        tblFacture: Record tblFacture;
    begin
        tblFacture.Reset;
        tblFacture.SetRange(NumeroFournisseur, VendorNo);
        tblFacture.SetRange(NumeroFacture, VendOrderNo);
        if tblFacture.FindFirst then begin
            exit(tblFacture.MFilesURL);
        end;
    end;

    local procedure GetAmtToInvoiceHt(PurchLine: Record "Purchase Line"; PurchOrder: Record "Purchase Header") LineAmount: Decimal
    var
        LineDiscount: Decimal;
        Curr: Record Currency;
    begin
        if PurchOrder."Currency Code" = '' then
            Curr.InitRoundingPrecision
        else
            Curr.Get(PurchOrder."Currency Code");

        LineDiscount :=
          Round(
            Round(PurchLine."Qty. to Invoice" * PurchLine."Direct Unit Cost", Curr."Amount Rounding Precision") *
            PurchLine."Line Discount %" / 100,
            Curr."Amount Rounding Precision");

        LineAmount :=
            Round(PurchLine."Qty. to Invoice" * PurchLine."Direct Unit Cost", Curr."Amount Rounding Precision") - LineDiscount;
    end;

    procedure GetPayTolerance(PurchOrder: Record "Purchase Header"; Amount: Decimal) Tolerance: Decimal
    var
        AmountLCY: Decimal;
        GenJrnLine: Record "Gen. Journal Line";
        Curr: Record Currency;
        CurrencyFactor: Decimal;
    begin

        if PurchOrder."Currency Code" = '' then
            AmountLCY := Amount
        else begin
            Curr.Get(PurchOrder."Currency Code");
            CurrencyFactor := CurrExchRate.ExchangeRate(PurchOrder."Posting Date", PurchOrder."Currency Code");
            AmountLCY := CurrExchRate.ExchangeAmtFCYToLCY(PurchOrder."Posting Date", PurchOrder."Currency Code", Amount, CurrencyFactor);
        end;

        PayTolMgt.CalcMaxPmtTolerance(GenJrnLine."Document Type"::Invoice, PurchOrder."Currency Code",
          Amount, AmountLCY, 1, Tolerance);
    end;



}

