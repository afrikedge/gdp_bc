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
                field("Frontdesk Reference"; Rec."Frontdesk Reference")
                {
                    Visible = false;
                }
                field("Frontdesk Pay Method"; Rec."Frontdesk Pay Method")
                {
                    Visible = false;
                }
                field("Frontdesk Pay Method Name"; Rec."Frontdesk Pay Method Name")
                {
                    Visible = false;
                }
                field("Frontdesk Amount"; Rec."Frontdesk Amount")
                {
                    Visible = false;
                }
                field("Frontdesk Observations"; Rec."Frontdesk Observations")
                {
                    Visible = false;
                }
            }

        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Sales Order Pay Doc"), "No." = field("Pay Document No."), "Line No." = field("Line No.");
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
