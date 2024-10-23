codeunit 50038 "AG1 Master Files Mgt"
{
    procedure ResetVendorValidation(var Vend: record Vendor)
    var
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';
    begin
        if Vend."Validation Status" <> Vend."Validation Status"::Created then
            if not Confirm(ErrAfk001) then Error('');
        Vend."Validation Status" := Vend."Validation Status"::Created;
        Vend.Modify();
    end;

    procedure AFK_TestMFilesInvoice(PurchaseHeader: record "Purchase Header")
    var
        AddOnSetup: record "AddOn Setup";
        AFK_Text0001: Label 'Cette facture ne peut pas être modifiée car elle provient d''un document MFiles';
    begin
        //*******************************121017
        AddOnSetup.Get;
        if not AddOnSetup."MFiles Mgt" then exit;

        if PurchaseHeader."MFiles Invoice" then
            Error(AFK_Text0001);
    end;

    procedure AFKGetLongAccountNum(Rec: record "Vendor Bank Account"): Text
    begin
        EXIT(Rec."Bank Branch No." + Rec."Agency Code" + Rec."Bank Account No." + CONVERTSTR(FORMAT(Rec."RIB Key", 2), ' ', '0'));
    end;

    procedure CollectIBAN(Rec: record "Vendor Bank Account"): Code[50]
    begin
        EXIT(Rec."Bank Branch No." + Rec."Agency Code" + Rec."Bank Account No." + CONVERTSTR(FORMAT(Rec."RIB Key", 2), ' ', '0'));
    end;

    procedure ResetVendorValidation(Rec: record "Vendor Bank Account")
    var
        Vend1: Record "Vendor";
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur %1 au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';

    begin
        IF Vend1.GET(Rec."Vendor No.") THEN BEGIN
            IF Vend1."Validation Status" <> Vend1."Validation Status"::Created THEN
                IF NOT CONFIRM(STRSUBSTNO(ErrAfk001, Vend1.Name)) THEN ERROR('');
            Vend1."Validation Status" := Vend1."Validation Status"::Created;
            Vend1.MODIFY;
        END;
    end;



    procedure AFK_SalesHeaderShowWarning(SalesHeader: Record "Sales Header"): Boolean
    var
        Cust: record Customer;
        NewOrderAmountLCY: decimal;
        CurrExchRate: record "Currency Exchange Rate";
        DeltaAmount: decimal;
    begin
        if SalesHeader."Currency Code" = '' then
            NewOrderAmountLCY := SalesHeader."Amount Including VAT"
        else
            NewOrderAmountLCY :=
              Round(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  WorkDate, SalesHeader."Currency Code",
                  SalesHeader."Amount Including VAT", SalesHeader."Currency Factor"));

        if not (SalesHeader."Document Type" in
                [SalesHeader."Document Type"::Quote,
                 SalesHeader."Document Type"::Order,
                 SalesHeader."Document Type"::"Return Order"])
        then
            NewOrderAmountLCY := NewOrderAmountLCY + SalesLineAmount(SalesHeader."Document Type", SalesHeader."No.");
        DeltaAmount := NewOrderAmountLCY;
        Cust.get(SalesHeader."Bill-to Customer No.");
        exit(AFK_ShowWarning(Cust, SalesHeader."Bill-to Customer No.", NewOrderAmountLCY, 0, true, DeltaAmount));

    end;

    local procedure AFK_ShowWarning(Cust: record Customer; NewCustNo: Code[20];
    NewOrderAmountLCY2: Decimal; OldOrderAmountLCY2: Decimal; CheckOverDueBalance: Boolean; DeltaAmt: decimal): Boolean
    var
        Cust2: record Customer;
        ExitValue: Integer;
        traitesEchues: Decimal;
        CustCreditAmountLCY: decimal;
        NewOrderAmountLCY: decimal;
        OldOrderAmountLCY: decimal;
        CustNo: Code[20];
    begin
        //***************************************************************************************
        if NewCustNo = '' then
            exit;
        CustNo := NewCustNo;
        NewOrderAmountLCY := NewOrderAmountLCY2;
        OldOrderAmountLCY := OldOrderAmountLCY2;
        Cust.Get(CustNo);
        Cust.SetRange("No.", Cust."No.");
        Cust2.Copy(Cust);

        //En cas de dépassement de plafond sur le compte
        CustCreditAmountLCY := CalcCreditLimitLCY(CustNo, Cust, DeltaAmt, NewOrderAmountLCY);
        if (CustCreditAmountLCY > Cust."Credit Limit (LCY)") and (Cust."Credit Limit (LCY)" <> 0) then
            exit(true);


        //En cas de présence de traites échues dans un des comptes du même compte Société
        traitesEchues := AFK_GetMontantTraitesNonHonoreesEchues(CustNo);
        if traitesEchues > 0 then
            exit(true);


        //En cas de présence de facture ou de note de débit échue dans un des comptes du même compte Société
        if AFK_GetExistsFacturesEchues(CustNo) then
            exit(true);


        CalcOverdueBalanceLCY(Cust);
        if Cust."Balance Due (LCY)" > 0 then
            exit(true);
    end;

    local procedure CalcOverdueBalanceLCY(Cust: record Customer) Result: decimal;
    begin
        if Cust.GetFilter("Date Filter") = '' then
            Cust.SetFilter("Date Filter", '..%1', WorkDate);
        Cust.CalcFields("Balance Due (LCY)");
        exit(Cust."Balance Due (LCY)");
    end;

    local procedure CalcCreditLimitLCY(CustNo: Code[20]; Cust: record Customer; DeltaAmount: decimal; NewOrderAmountLCY: decimal) CustCreditAmountLCY: Decimal
    var
        OutstandingRetOrdersLCY: Decimal;
        RcdNotInvdRetOrdersLCY: Decimal;
        OrderAmountTotalLCY: Decimal;
        ShippedRetRcdNotIndLCY: Decimal;
        OrderAmountThisOrderLCY: Decimal;
    begin
        if Cust.GetFilter("Date Filter") = '' then
            Cust.SetFilter("Date Filter", '..%1', WorkDate);
        Cust.CalcFields("Balance (LCY)", "Shipped Not Invoiced (LCY)", "Serv Shipped Not Invoiced(LCY)");
        CalcReturnAmounts(Cust."No.", OutstandingRetOrdersLCY, RcdNotInvdRetOrdersLCY);

        OrderAmountTotalLCY := CalcTotalOutstandingAmt(Cust) - OutstandingRetOrdersLCY + DeltaAmount;
        ShippedRetRcdNotIndLCY := Cust."Shipped Not Invoiced (LCY)" + Cust."Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY;
        if Cust."No." = CustNo then
            OrderAmountThisOrderLCY := NewOrderAmountLCY
        else
            OrderAmountThisOrderLCY := 0;

        CustCreditAmountLCY :=
          Cust."Balance (LCY)" + Cust."Shipped Not Invoiced (LCY)" + Cust."Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY +
          OrderAmountTotalLCY - Cust.GetInvoicedPrepmtAmountLCY() + AFK_GetMontantTraitesNonHonorees(Cust."No.");

    end;

    local procedure CalcTotalOutstandingAmt(Cust: record Customer): Decimal
    var
        SalesLine: Record "Sales Line";
        ServLine: Record "Service Line";
        SalesOutstandingAmountFromShipment: Decimal;
        ServOutstandingAmountFromShipment: Decimal;
    begin
        Cust.CalcFields(
          "Outstanding Invoices (LCY)", "Outstanding Orders (LCY)", "Outstanding Serv.Invoices(LCY)", "Outstanding Serv. Orders (LCY)");
        SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment(Cust."No.");
        ServOutstandingAmountFromShipment := ServLine.OutstandingInvoiceAmountFromShipment(Cust."No.");

        exit(
          Cust."Outstanding Orders (LCY)" + Cust."Outstanding Invoices (LCY)" + Cust."Outstanding Serv. Orders (LCY)" +
          Cust."Outstanding Serv.Invoices(LCY)" - SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment);
    end;

    local procedure CalcReturnAmounts(CustNo: Code[20]; var OutstandingRetOrdersLCY2: Decimal; var RcdNotInvdRetOrdersLCY2: Decimal)
    var
        SalesLine: record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.SetCurrentKey("Document Type", "Bill-to Customer No.", "Currency Code");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Return Order");
        SalesLine.SetRange("Bill-to Customer No.", CustNo);
        SalesLine.CalcSums("Outstanding Amount (LCY)", "Return Rcd. Not Invd. (LCY)");
        OutstandingRetOrdersLCY2 := SalesLine."Outstanding Amount (LCY)";
        RcdNotInvdRetOrdersLCY2 := SalesLine."Return Rcd. Not Invd. (LCY)";
    end;

    local procedure AFK_GetMontantTraitesNonHonorees(CustNo: Code[20]) MontantTraitesNonHonorees: Decimal
    var
        PaymentLine: Record "Payment Line";
    begin
        //Traites non honorées
        //Sum("Payment Line".Amount WHERE (Account Type=CONST(Customer),Account No.=FIELD(No.),
        //Payment Class=CONST(TRTGDP),Status No.=FILTER(<>27500&<>28750&<>40000)))
        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."Account Type", PaymentLine."Account Type"::Customer);
        PaymentLine.SetRange(PaymentLine."Account No.", CustNo);
        PaymentLine.SetRange(PaymentLine."Payment Class", 'TRTGDP');
        PaymentLine.SetFilter(PaymentLine."Status No.", '<>%1&<>%2&<>%3', 27500, 28750, 40000);
        if PaymentLine.FindSet then
            repeat
                MontantTraitesNonHonorees := MontantTraitesNonHonorees + Abs(PaymentLine.Amount);
            until PaymentLine.Next = 0;
    end;

    local procedure AFK_GetMontantTraitesNonHonoreesEchues(CustNo: Code[20]) MontantTraitesNonHonoreesE: Decimal
    var
        PaymentLine: Record "Payment Line";
    begin
        PaymentLine.Reset;
        PaymentLine.SetRange(PaymentLine."Account Type", PaymentLine."Account Type"::Customer);
        PaymentLine.SetFilter(PaymentLine."Account No.", AFK_GetFilterClientGroupe(CustNo));
        PaymentLine.SetRange(PaymentLine."Payment Class", 'TRTGDP');
        PaymentLine.SetFilter(PaymentLine."Status No.", '<>%1&<>%2&<>%3', 27500, 28750, 40000);
        if PaymentLine.FindSet then
            repeat
                if PaymentLine."Due Date" < WorkDate then
                    MontantTraitesNonHonoreesE := MontantTraitesNonHonoreesE + Abs(PaymentLine.Amount);
            until PaymentLine.Next = 0;
    end;

    local procedure AFK_GetExistsFacturesEchues(CustNo: Code[20]): Boolean
    var
        CustLedgEntry3: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry3.Reset;
        CustLedgEntry3.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        CustLedgEntry3.SetFilter("Customer No.", AFK_GetFilterClientGroupe(CustNo));
        CustLedgEntry3.SetRange(CustLedgEntry3.Open, true);
        CustLedgEntry3.SetRange(CustLedgEntry3.Positive, true);
        CustLedgEntry3.SetFilter(CustLedgEntry3."Due Date", '..%1', WorkDate);
        exit(CustLedgEntry3.FindFirst);
    end;

    local procedure AFK_GetFilterClientGroupe(CustNo: Code[20]) Rep: Text[1024]
    var
        Cust1: Record Customer;
        CompanyCode: Code[20];
    begin
        Cust1.Get(CustNo);
        CompanyCode := Cust1."Company Code";
        if CompanyCode = '' then exit(CustNo);

        Cust1.Reset;
        Cust1.SetRange("Company Code", CompanyCode);
        if Cust1.FindSet then
            repeat

                if StrLen(Rep + Cust1."No.") > 1024 then exit('');
                if Rep = '' then
                    Rep := Cust1."No."
                else
                    Rep := Rep + '|' + Cust1."No.";

            until Cust1.Next = 0;

        if Rep = '' then Rep := '#K##+';
    end;

    local procedure SalesLineAmount(DocType: Integer; DocNo: Code[20]): Decimal
    var
        SalesLine: record "Sales line";
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", DocType);
        SalesLine.SetRange("Document No.", DocNo);
        SalesLine.CalcSums("Outstanding Amount (LCY)", "Shipped Not Invoiced (LCY)");
        exit(SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)");
    end;

    local procedure ServLineAmount(DocType: Integer; DocNo: Code[20]; var ServLine2: Record "Service Line"): Decimal
    begin
        ServLine2.Reset;
        ServLine2.SetRange("Document Type", DocType);
        ServLine2.SetRange("Document No.", DocNo);
        ServLine2.CalcSums("Outstanding Amount (LCY)", "Shipped Not Invoiced (LCY)");
        exit(ServLine2."Outstanding Amount (LCY)" + ServLine2."Shipped Not Invoiced (LCY)");
    end;
}
