pageextension 50032 pageextension70000067 extends "Check Credit Limit"
{
    // //JN0001 Check credit and overduebalance


    //Unsupported feature: Code Modification on "CalcCreditLimitLCY(PROCEDURE 6)".

    //procedure CalcCreditLimitLCY();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF GETFILTER("Date Filter") = '' THEN
      SETFILTER("Date Filter",'..%1',WORKDATE);
    CALCFIELDS("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");
    #4..9
    ELSE
      OrderAmountThisOrderLCY := 0;

    CustCreditAmountLCY :=
      "Balance (LCY)" + "Shipped Not Invoiced (LCY)" + "Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY +
      OrderAmountTotalLCY - GetInvoicedPrepmtAmountLCY;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
    //**************************************************************************
    //Traites non honorees
    {
    #13..15
    }
    CustCreditAmountLCY :=
      "Balance (LCY)" + "Shipped Not Invoiced (LCY)" + "Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY +
      OrderAmountTotalLCY - GetInvoicedPrepmtAmountLCY + AFK_GetMontantTraitesNonHonorees;
    */
    //end;

    // procedure AFK_SalesHeaderShowWarning(SalesHeader: Record "36"): Boolean
    // begin
    //     //***************************************************************
    //     // Used when additional lines are inserted
    //     /*
    //     SalesSetup.GET;
    //     IF SalesSetup."Credit Warnings"
    //        SalesSetup."Credit Warnings"::"No Warning"
    //     THEN
    //       EXIT(FALSE);
    //     */
    //     IF SalesHeader."Currency Code" = '' THEN
    //       NewOrderAmountLCY := SalesHeader."Amount Including VAT"
    //     ELSE
    //       NewOrderAmountLCY :=
    //         ROUND(
    //           CurrExchRate.ExchangeAmtFCYToLCY(
    //             WORKDATE,SalesHeader."Currency Code",
    //             SalesHeader."Amount Including VAT",SalesHeader."Currency Factor"));

    //     IF NOT (SalesHeader."Document Type" IN
    //             [SalesHeader."Document Type"::Quote,
    //              SalesHeader."Document Type"::Order,
    //              SalesHeader."Document Type"::"Return Order"])
    //     THEN
    //       NewOrderAmountLCY := NewOrderAmountLCY + SalesLineAmount(SalesHeader."Document Type",SalesHeader."No.");
    //     DeltaAmount := NewOrderAmountLCY;
    //     EXIT(AFK_ShowWarning(SalesHeader."Bill-to Customer No.",NewOrderAmountLCY,0,TRUE));

    // end;

    // local procedure AFK_ShowWarning(NewCustNo: Code[20];NewOrderAmountLCY2: Decimal;OldOrderAmountLCY2: Decimal;CheckOverDueBalance: Boolean): Boolean
    // var
    //     ExitValue: Integer;
    //     traitesEchues: Decimal;
    // begin
    //     //***************************************************************************************
    //     IF NewCustNo = '' THEN
    //       EXIT;
    //     CustNo := NewCustNo;
    //     NewOrderAmountLCY := NewOrderAmountLCY2;
    //     OldOrderAmountLCY := OldOrderAmountLCY2;
    //     GET(CustNo);
    //     SETRANGE("No.","No.");
    //     Cust2.COPY(Rec);

    //     //En cas de dépassement de plafond sur le compte
    //     CalcCreditLimitLCY;
    //     IF (CustCreditAmountLCY > "Credit Limit (LCY)") AND ("Credit Limit (LCY)" <> 0) THEN
    //       EXIT(TRUE);


    //     //En cas de présence de traites échues dans un des comptes du même compte Société
    //     traitesEchues := AFK_GetMontantTraitesNonHonoreesEchues();
    //     IF traitesEchues>0 THEN
    //       EXIT(TRUE);


    //     //En cas de présence de facture ou de note de débit échue dans un des comptes du même compte Société
    //     IF AFK_GetExistsFacturesEchues(CustNo) THEN
    //       EXIT(TRUE);


    //     CalcOverdueBalanceLCY;
    //     IF "Balance Due (LCY)" > 0 THEN
    //       EXIT(TRUE);
    // end;

    // local procedure AFK_GetMontantTraitesNonHonorees() MontantTraitesNonHonorees: Decimal
    // var
    //     PaymentLine: Record "10866";
    // begin
    //     //Traites non honorées
    //     //Sum("Payment Line".Amount WHERE (Account Type=CONST(Customer),Account No.=FIELD(No.),
    //     //Payment Class=CONST(TRTGDP),Status No.=FILTER(<>27500&<>28750&<>40000)))
    //     PaymentLine.RESET;
    //     PaymentLine.SETRANGE(PaymentLine."Account Type",PaymentLine."Account Type"::Customer);
    //     PaymentLine.SETRANGE(PaymentLine."Account No.",CustNo);
    //     PaymentLine.SETRANGE(PaymentLine."Payment Class",'TRTGDP');
    //     PaymentLine.SETFILTER(PaymentLine."Status No.",'<>%1&<>%2&<>%3',27500,28750,40000);
    //     IF PaymentLine.FINDSET THEN REPEAT
    //       MontantTraitesNonHonorees := MontantTraitesNonHonorees+ABS(PaymentLine.Amount);
    //     UNTIL PaymentLine.NEXT=0;
    // end;

    // local procedure AFK_GetMontantTraitesNonHonoreesEchues() MontantTraitesNonHonoreesE: Decimal
    // var
    //     PaymentLine: Record "10866";
    // begin
    //     PaymentLine.RESET;
    //     PaymentLine.SETRANGE(PaymentLine."Account Type",PaymentLine."Account Type"::Customer);
    //     PaymentLine.SETFILTER(PaymentLine."Account No.",AFK_GetFilterClientGroupe(CustNo));
    //     PaymentLine.SETRANGE(PaymentLine."Payment Class",'TRTGDP');
    //     PaymentLine.SETFILTER(PaymentLine."Status No.",'<>%1&<>%2&<>%3',27500,28750,40000);
    //     IF PaymentLine.FINDSET THEN REPEAT
    //       IF PaymentLine."Due Date"<WORKDATE THEN
    //         MontantTraitesNonHonoreesE := MontantTraitesNonHonoreesE+ABS(PaymentLine.Amount);
    //     UNTIL PaymentLine.NEXT=0;
    // end;

    // local procedure AFK_GetExistsFacturesEchues(CustNo: Code[20]): Boolean
    // var
    //     CustLedgEntry3: Record "21";
    // begin
    //     CustLedgEntry3.RESET;
    //     CustLedgEntry3.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
    //     CustLedgEntry3.SETFILTER("Customer No.",AFK_GetFilterClientGroupe(CustNo));
    //     CustLedgEntry3.SETRANGE(CustLedgEntry3.Open,TRUE);
    //     CustLedgEntry3.SETRANGE(CustLedgEntry3.Positive,TRUE);
    //     CustLedgEntry3.SETFILTER(CustLedgEntry3."Due Date",'..%1',WORKDATE);
    //     EXIT(CustLedgEntry3.FINDFIRST);
    // end;

    // local procedure AFK_GetFilterClientGroupe(CustNo: Code[20]) Rep: Text[1024]
    // var
    //     Cust1: Record "18";
    //     CompanyCode: Code[20];
    // begin
    //     Cust1.GET(CustNo);
    //     CompanyCode := Cust1."Company Code";
    //     IF CompanyCode='' THEN EXIT(CustNo);

    //     Cust1.RESET;
    //     Cust1.SETRANGE("Company Code",CompanyCode);
    //     IF Cust1.FINDSET THEN
    //       REPEAT

    //           IF STRLEN(Rep + Cust1."No.") > 1024 THEN EXIT('');
    //           IF Rep='' THEN
    //             Rep := Cust1."No."
    //           ELSE
    //             Rep := Rep + '|' + Cust1."No.";

    //       UNTIL Cust1.NEXT=0;

    //     IF Rep='' THEN Rep:='#K##+';
    // end;
}

