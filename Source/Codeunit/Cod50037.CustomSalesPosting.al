codeunit 50037 CustomSalesPosting
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', false, false)]
    local procedure OnAfterPostSalesLines(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        GLEntry: Record "G/L Entry";
        TotalAmountExclVAT: Decimal;
        Amount1Percent: Decimal;
        Amount2Percent: Decimal;
        RemainingAmount: Decimal;
    begin
        if SalesInvoiceHeader."No." = '' then
            exit; // Exit if it's not an invoice posting

        // Calculate total amount excluding VAT
        TotalAmountExclVAT := CalculateTotalAmountExclVAT(SalesInvoiceHeader."No.");

        // Calculate amounts for redistribution
        Amount1Percent := TotalAmountExclVAT * 0.01;
        Amount2Percent := TotalAmountExclVAT * 0.02;
        RemainingAmount := TotalAmountExclVAT * 0.97;

        // Modify G/L Entries
        ModifyGLEntries(SalesInvoiceHeader."No.", TotalAmountExclVAT, Amount1Percent, Amount2Percent, RemainingAmount);
    end;

    local procedure CalculateTotalAmountExclVAT(DocumentNo: Code[20]): Decimal
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        TotalAmount: Decimal;
    begin
        SalesInvoiceLine.SetRange("Document No.", DocumentNo);
        SalesInvoiceLine.SetFilter(Type, '<>%1', SalesInvoiceLine.Type::"G/L Account");
        if SalesInvoiceLine.FindSet() then
            repeat
                TotalAmount += SalesInvoiceLine."Line Amount";
            until SalesInvoiceLine.Next() = 0;
        exit(TotalAmount);
    end;

    local procedure ModifyGLEntries(DocumentNo: Code[20]; TotalAmountExclVAT: Decimal; Amount1Percent: Decimal; Amount2Percent: Decimal; RemainingAmount: Decimal)
    var
        GLEntry: Record "G/L Entry";
        TempGLEntry: Record "G/L Entry" temporary;
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
    begin
        GLEntry.SetRange("Document No.", DocumentNo);
        GLEntry.SetRange("Document Type", GLEntry."Document Type"::Invoice);
        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
        if GLEntry.FindSet() then
            repeat
                TempGLEntry := GLEntry;
                TempGLEntry.Insert();
            until GLEntry.Next() = 0;

        if TempGLEntry.FindSet() then
            repeat
                GLAccount.Get(TempGLEntry."G/L Account No.");
                if GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" then begin
                    // Modify the original income entry
                    GLEntry.Get(TempGLEntry."Entry No.");
                    GLEntry.Amount := RemainingAmount;
                    GLEntry."Debit Amount" := 0;
                    GLEntry."Credit Amount" := RemainingAmount;
                    GLEntry.Modify();

                    // Create new entry for 1% account
                    EntryNo := GetLastGLEntryNo() + 1;
                    InsertNewGLEntry(GLEntry, EntryNo, GetGL1PercentAccount(), Amount1Percent, DocumentNo);

                    // Create new entry for 2% account
                    EntryNo += 1;
                    InsertNewGLEntry(GLEntry, EntryNo, GetGL2PercentAccount(), Amount2Percent, DocumentNo);
                end;
            until TempGLEntry.Next() = 0;
    end;

    local procedure InsertNewGLEntry(var OriginalGLEntry: Record "G/L Entry"; NewEntryNo: Integer; NewGLAccountNo: Code[20]; Amount: Decimal; DocumentNo: Code[20])
    var
        NewGLEntry: Record "G/L Entry";
    begin
        NewGLEntry := OriginalGLEntry;
        NewGLEntry."Entry No." := NewEntryNo;
        NewGLEntry."G/L Account No." := NewGLAccountNo;
        NewGLEntry.Amount := -Amount;
        NewGLEntry."Debit Amount" := Amount;
        NewGLEntry."Credit Amount" := 0;
        NewGLEntry.Insert();
    end;

    local procedure GetLastGLEntryNo(): Integer
    var
        GLEntry: Record "G/L Entry";
    begin
        if GLEntry.FindLast() then
            exit(GLEntry."Entry No.")
        else
            exit(0);
    end;

    local procedure GetGL1PercentAccount(): Code[20]
    begin
        // Return the G/L Account No. for the 1% account
        exit('55100'); // Replace with your actual G/L Account No.
    end;

    local procedure GetGL2PercentAccount(): Code[20]
    begin
        // Return the G/L Account No. for the 2% account
        exit('55200'); // Replace with your actual G/L Account No.
    end;
}
