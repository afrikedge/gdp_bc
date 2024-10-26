pageextension 50006 pageextension70000064 extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("Closed at Date")
        {
            field("Vendor Name2"; Rec."Vendor Name2")
            {
            }
            field("Transaction Date"; Rec."Transaction Date")
            {
            }
            field("Recipient Bank Account"; Rec."Recipient Bank Account")
            {
            }
        }
    }
    actions
    {
        addafter(ReverseTransaction)
        {
            action(PrintDebitCreditNotes)
            {
                Caption = 'Print Debit/Credit Notes';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VLE: Record "Vendor Ledger Entry";
                begin

                    //*********************************************************
                    VLE.SETRANGE(VLE."Entry No.", Rec."Entry No.");
                    REPORT.RUN(50067, TRUE, FALSE, VLE);
                    //*********************************************************
                end;
            }
        }
    }
}

