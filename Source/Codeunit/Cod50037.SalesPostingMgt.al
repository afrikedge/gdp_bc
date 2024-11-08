codeunit 50037 SalesPostingMgt
{
    var
        AddOnSetup: Record "AddOn Setup";
        GLMgt: Codeunit "GL Mgt";

    // procedure UpdateLineTotalAmountExclVAT(SalesLine: record "Sales Line"; SalesLineACY: Record "Sales Line"; var TotalAmount: decimal; var TotalAmountACY: decimal)
    // var
    //     RDSFees: Decimal;
    //     FERFees: Decimal;
    //     OMHFees: Decimal;
    //     ENVFees: Decimal;
    //     OMHFeesACY: Decimal;
    //     FERFeesACY: Decimal;
    //     ENVFeesACY: Decimal;
    //     TotalFeesAmountACY: Decimal;
    //     TotalFeesAmount: Decimal;
    //     RDSFeesACY: Decimal;
    //     RDSUnitPrice: Decimal;
    // begin

    //     CalcSalesRetentionValues(SalesLine, SalesLineACY, RDSFees, FERFees, OMHFees, ENVFees, OMHFeesACY, FERFeesACY, ENVFeesACY, RDSFeesACY);

    //     TotalFeesAmount := OMHFees + FERFees + ENVFees + RDSFees;
    //     TotalFeesAmountACY := OMHFeesACY + FERFeesACY + ENVFeesACY + RDSFeesACY;

    //     TotalAmount := SalesLine.Amount - (TotalFeesAmount);
    //     TotalAmountACY := SalesLineACY.Amount - (TotalFeesAmountACY);
    // end;

    local procedure ActivateSalesInvoiceRetentions(SalesLine: record "Sales Line"): Boolean
    var
        Cust: record Customer;
        SalesHeader: record "Sales Header";
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        Cust.Get(SalesHeader."Sell-to Customer No.");
        AddOnSetup.GetRecordOnce();

        exit((not AddOnSetup."Cancel Fees Retention Posting")
            and (SalesLine.Type = SalesLine.Type::Item)
            and (not Cust."GDP Partner"));
    end;

    procedure AddGLPostingLinesForRetention(SalesLine: record "Sales Line"; SalesLineACY: Record "Sales Line";
    var InvoicePostBuffer: Record "Invoice Post. Buffer"; TotalVAT: decimal; TotalVATACY: decimal
    ; var TotalAmount: decimal; var TotalAmountACY: decimal; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary)
    var
        Item1: record Item;
        OMHAccNo: Code[20];
        FERAccNo: Code[20];
        ENVAccNo: Code[20];
        RDSAccNo: Code[20];
        RDSFees: Decimal;
        FERFees: Decimal;
        OMHFees: Decimal;
        ENVFees: Decimal;
        OMHFeesACY: Decimal;
        FERFeesACY: Decimal;
        ENVFeesACY: Decimal;
        TotalFeesAmountACY: Decimal;
        TotalFeesAmount: Decimal;
        RDSFeesACY: Decimal;
    begin
        AddOnSetup.GetRecordOnce();

        if Item1."Item Category Code" = AddOnSetup."Naphta Product Group" then begin
            AddOnSetup.TestField("OMH Fees Account - NAPHTA");
            OMHAccNo := AddOnSetup."OMH Fees Account - NAPHTA";
            FERAccNo := AddOnSetup."FER Fees Account - NAPHTA";
            ENVAccNo := AddOnSetup."ENV Fees Account - NAPHTA";
        end else begin
            OMHAccNo := AddOnSetup."OMH Fees Account";
            FERAccNo := AddOnSetup."FER Fees Account";
            ENVAccNo := AddOnSetup."ENV Fees Account";
            RDSAccNo := AddOnSetup."RDS Fees Account";//RDS Fees JN030918
        end;

        CalcSalesRetentionValues(SalesLine, SalesLineACY, RDSFees, FERFees, OMHFees, ENVFees, OMHFeesACY, FERFeesACY, ENVFeesACY, RDSFeesACY);
        TotalFeesAmount := OMHFees + FERFees + ENVFees + RDSFees;
        TotalFeesAmountACY := OMHFeesACY + FERFeesACY + ENVFeesACY + RDSFeesACY;

        //UpdateLineTotalAmountExclVAT
        TotalAmount := SalesLine.Amount - (TotalFeesAmount);
        TotalAmountACY := SalesLineACY.Amount - (TotalFeesAmountACY);


        //OMH Fees
        if (OMHFees <> 0) then begin
            AddOnSetup.TestField("OMH Fees Account");
            InvoicePostBuffer.SetAmountsNoVAT(
              OMHFees,
              OMHFeesACY,
              SalesLine."VAT Difference");

            InvoicePostBuffer.SetAccount(
              OMHAccNo,
              TotalVAT,
              TotalVATACY,
              OMHFees,
              OMHFeesACY);
            TempInvoicePostBuffer.Update(InvoicePostBuffer);
        end;

        //FER Fees
        if (FERFees <> 0) then begin
            AddOnSetup.TestField("FER Fees Account");
            InvoicePostBuffer.SetAmountsNoVAT(
              FERFees,
              FERFeesACY,
              SalesLine."VAT Difference");

            InvoicePostBuffer.SetAccount(
              FERAccNo,
              TotalVAT,
              TotalVATACY,
              FERFees,
              FERFeesACY);
            TempInvoicePostBuffer.Update(InvoicePostBuffer);
        end;


        //ENV Fees
        if (ENVFees <> 0) then begin
            AddOnSetup.TestField("ENV Fees Account");
            InvoicePostBuffer.SetAmountsNoVAT(
              ENVFees,
              ENVFeesACY,
              SalesLine."VAT Difference");

            InvoicePostBuffer.SetAccount(
              ENVAccNo,
              TotalVAT,
              TotalVATACY,
              ENVFees,
              ENVFeesACY);
            TempInvoicePostBuffer.Update(InvoicePostBuffer);
        end;


        //RDS Fees
        if (RDSFees <> 0) then begin
            AddOnSetup.TestField("RDS Fees Account");
            InvoicePostBuffer.SetAmountsNoVAT(
              RDSFees,
              RDSFeesACY,
              SalesLine."VAT Difference");

            InvoicePostBuffer.SetAccount(
              RDSAccNo,
              TotalVAT,
              TotalVATACY,
              RDSFees,
              RDSFeesACY);
            TempInvoicePostBuffer.Update(InvoicePostBuffer);
        end;

    end;

    local procedure CalcSalesRetentionValues(var SalesLine: record "Sales Line"; var SalesLineACY: Record "Sales Line"; var RDSFees: Decimal; var FERFees: Decimal; var OMHFees: Decimal; var ENVFees: Decimal; var OMHFeesACY: Decimal; var FERFeesACY: Decimal; var ENVFeesACY: Decimal; var RDSFeesACY: Decimal)
    var
        Item1: record Item;
        Cust2: record Customer;
        SalesHeader: record "Sales Header";
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) then
            exit;
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        Cust2.Get(SalesHeader."Sell-to Customer No.");
        Item1.Get(SalesLine."No.");

        if (not ActivateSalesInvoiceRetentions(SalesLine)) then exit;

        GLMgt.AfkCalculateFeesRetention(SalesLine, Item1, Cust2, FERFees, OMHFees, ENVFees, RDSFees);


        //MESSAGE('%1 - %2',OMHFees,SalesLine."No.");


        OMHFeesACY := (SalesLineACY.Amount / SalesLine.Amount) * OMHFees;
        FERFeesACY := (SalesLineACY.Amount / SalesLine.Amount) * FERFees;
        ENVFeesACY := (SalesLineACY.Amount / SalesLine.Amount) * ENVFees;
        RDSFeesACY := (SalesLineACY.Amount / SalesLine.Amount) * RDSFees;
    end;

}
