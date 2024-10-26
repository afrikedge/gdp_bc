pageextension 50033 pageextension70000070 extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Check No."; Rec."Check No.")
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
            field("LC Number"; Rec."LC Number")
            {
            }
            field("CC Document Type"; Rec."CC Document Type")
            {
            }
            field("Check Date"; Rec."Check Date")
            {
            }
        }
    }
}

