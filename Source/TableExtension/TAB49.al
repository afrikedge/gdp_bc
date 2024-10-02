tableextension 50015 "A02 Invoice Post. Buffer" extends "Invoice Post. Buffer"
{
    fields
    {
        field(50000; "Posting Description"; Text[100])
        {
        }
    }


    //Unsupported feature: Code Modification on "PrepareSales(PROCEDURE 1)".

    //procedure PrepareSales();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(Rec);
    Type := SalesLine.Type;
    "System-Created Entry" := TRUE;
    #4..18
      "Duplicate in Depreciation Book" := SalesLine."Duplicate in Depreciation Book";
      "Use Duplication List" := SalesLine."Use Duplication List";
    END;

    IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
      SetSalesTaxForSalesLine(SalesLine);
    #25..32
    END;

    OnAfterInvPostBufferPrepareSales(SalesLine,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..21
    //***********************************************************
    "Posting Description" := SalesLine.Description;
    //***********************************************************
    #22..35
    //The code has been merged but contained errors that could prevent import
    //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
    //CLEAR(Rec);
    //Type := SalesLine.Type;
    //"System-Created Entry" := TRUE;
    //"Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
    //"Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
    //"VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
    //"VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
    //"VAT Calculation Type" := SalesLine."VAT Calculation Type";
    //"Global Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
    //"Global Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
    //"Dimension Set ID" := SalesLine."Dimension Set ID";
    //"Job No." := SalesLine."Job No.";
    //"VAT %" := SalesLine."VAT %";
    //"VAT Difference" := SalesLine."VAT Difference";
    //IF Type = Type::"Fixed Asset" THEN BEGIN
    //  "FA Posting Date" := SalesLine."FA Posting Date";
    //  "Depreciation Book Code" := SalesLine."Depreciation Book Code";
    //  "Depr. until FA Posting Date" := SalesLine."Depr. until FA Posting Date";
    //  "Duplicate in Depreciation Book" := SalesLine."Duplicate in Depreciation Book";
    //  "Use Duplication List" := SalesLine."Use Duplication List";
    //END;
    //
    //{>>>>>>>} ORIGINAL
    //IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
    //  "Tax Area Code" := SalesLine."Tax Area Code";
    //  "Tax Group Code" := SalesLine."Tax Group Code";
    //  "Tax Liable" := SalesLine."Tax Liable";
    //  "Use Tax" := FALSE;
    //  Quantity := SalesLine."Qty. to Invoice (Base)";
    //{=======} MODIFIED
    ////***********************************************************
    ////***********************************************************
    //"Posting Description" := SalesLine.Description;
    ////***********************************************************
    ////***********************************************************
    //
    //IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
    //  "Tax Area Code" := SalesLine."Tax Area Code";
    //  "Tax Group Code" := SalesLine."Tax Group Code";
    //  "Tax Liable" := SalesLine."Tax Liable";
    //  "Use Tax" := FALSE;
    //  Quantity := SalesLine."Qty. to Invoice (Base)";
    //{=======} TARGET
    //IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
    //  SetSalesTaxForSalesLine(SalesLine);
    //
    //DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");
    //
    //IF SalesLine."Line Discount %" = 100 THEN BEGIN
    //  "VAT Base Amount" := 0;
    //  "VAT Base Amount (ACY)" := 0;
    //  "VAT Amount" := 0;
    //  "VAT Amount (ACY)" := 0;
    //{<<<<<<<}
    //END;
    //
    //OnAfterInvPostBufferPrepareSales(SalesLine,Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "PreparePurchase(PROCEDURE 6)".

    //procedure PreparePurchase();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(Rec);
    Type := PurchLine.Type;
    "System-Created Entry" := TRUE;
    #4..26
      "Budgeted FA No." := PurchLine."Budgeted FA No.";
    END;

    IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
      SetSalesTaxForPurchLine(PurchLine);

    #33..39
    END;

    OnAfterInvPostBufferPreparePurchase(PurchLine,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..29
    //***********************************************************
    "Posting Description" := PurchLine.Description;
    //***********************************************************


    #30..42

    //The code has been merged but contained errors that could prevent import
    //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
    //CLEAR(Rec);
    //Type := PurchLine.Type;
    //"System-Created Entry" := TRUE;
    //"Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
    //"Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
    //"VAT Bus. Posting Group" := PurchLine."VAT Bus. Posting Group";
    //"VAT Prod. Posting Group" := PurchLine."VAT Prod. Posting Group";
    //"VAT Calculation Type" := PurchLine."VAT Calculation Type";
    //"Global Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
    //"Global Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
    //"Dimension Set ID" := PurchLine."Dimension Set ID";
    //"Job No." := PurchLine."Job No.";
    //"VAT %" := PurchLine."VAT %";
    //"VAT Difference" := PurchLine."VAT Difference";
    //IF Type = Type::"Fixed Asset" THEN BEGIN
    //  "FA Posting Date" := PurchLine."FA Posting Date";
    //  "Depreciation Book Code" := PurchLine."Depreciation Book Code";
    //  "Depr. until FA Posting Date" := PurchLine."Depr. until FA Posting Date";
    //  "Duplicate in Depreciation Book" := PurchLine."Duplicate in Depreciation Book";
    //  "Use Duplication List" := PurchLine."Use Duplication List";
    //  "FA Posting Type" := PurchLine."FA Posting Type";
    //  "Depreciation Book Code" := PurchLine."Depreciation Book Code";
    //  "Salvage Value" := PurchLine."Salvage Value";
    //  "Depr. Acquisition Cost" := PurchLine."Depr. Acquisition Cost";
    //  "Maintenance Code" := PurchLine."Maintenance Code";
    //  "Insurance No." := PurchLine."Insurance No.";
    //  "Budgeted FA No." := PurchLine."Budgeted FA No.";
    //END;
    //
    //{>>>>>>>} ORIGINAL
    //IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
    //  "Tax Area Code" := PurchLine."Tax Area Code";
    //  "Tax Group Code" := PurchLine."Tax Group Code";
    //  "Tax Liable" := PurchLine."Tax Liable";
    //  "Use Tax" := FALSE;
    //  Quantity := PurchLine."Qty. to Invoice (Base)";
    //{=======} MODIFIED
    ////***********************************************************
    ////***********************************************************
    //"Posting Description" := PurchLine.Description;
    ////***********************************************************
    ////***********************************************************
    //
    //IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
    //  "Tax Area Code" := PurchLine."Tax Area Code";
    //  "Tax Group Code" := PurchLine."Tax Group Code";
    //  "Tax Liable" := PurchLine."Tax Liable";
    //  "Use Tax" := FALSE;
    //  Quantity := PurchLine."Qty. to Invoice (Base)";
    //{=======} TARGET
    //IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
    //  SetSalesTaxForPurchLine(PurchLine);
    //
    //DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");
    //
    //IF PurchLine."Line Discount %" = 100 THEN BEGIN
    //  "VAT Base Amount" := 0;
    //  "VAT Base Amount (ACY)" := 0;
    //  "VAT Amount" := 0;
    //  "VAT Amount (ACY)" := 0;
    //{<<<<<<<}
    //END;
    //
    //OnAfterInvPostBufferPreparePurchase(PurchLine,Rec);
    */
    //end;
}

