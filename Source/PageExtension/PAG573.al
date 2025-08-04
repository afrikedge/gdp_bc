pageextension 50044 pageextension70000117 extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field("Application No."; Rec."Application No.")
            {
                ApplicationArea = All;
            }
            field("Initial Document Type"; Rec."Initial Document Type")
            {
                ApplicationArea = All;
            }
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
            }
            field("Applied Cust. Ledger Entry No."; Rec."Applied Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

