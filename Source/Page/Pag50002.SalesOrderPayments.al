page 50002 "Sales Order Payments"
{
    ApplicationArea = All;
    Caption = 'Sales Order Payments';
    PageType = List;
    SourceTable = "Sales Order Pay Doc";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Pay Document No."; Rec."Pay Document No.")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        openAmt: Decimal;
                    begin
                        GD1LookupCreditNotes(Text, Rec);
                        exit(true);
                    end;
                }
                field("Paid Amount"; Rec."Paid Amount")
                {

                }
            }
        }
    }
    local procedure GD1LookupCreditNotes(var Text: Text; var Rec: record "Sales Order Pay Doc")
    var
        CustLedgerEntry: record "Cust. Ledger Entry";
        CustLedgerEntries: page "Customer Ledger Entries";
    begin
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        CustLedgerEntry.SetRange("Customer No.", Rec."Customer No.");
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetRange(Positive, false);

        CustLedgerEntries.SetTableView(CustLedgerEntry);
        CustLedgerEntries.SetRecord(CustLedgerEntry);
        CustLedgerEntries.LookupMode(true);
        if (CustLedgerEntries.RunModal() = Action::LookupOK) then begin
            CustLedgerEntries.GetRecord(CustLedgerEntry);
            Text := CustLedgerEntry."Document No.";
            //Rec."Paid Amount" := CustLedgerEntry."Remaining Amt. (LCY)";
            // Rec.Modify();
        end;
    end;
}
