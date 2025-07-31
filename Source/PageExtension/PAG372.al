pageextension 50033 pageextension70000070 extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field("Check No."; Rec."Check No.")
            {
                ApplicationArea = All;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("LC Number"; Rec."LC Number")
            {
                ApplicationArea = All;
            }
            field("CC Document Type"; Rec."CC Document Type")
            {
                ApplicationArea = All;
            }
            field("Check Date"; Rec."Check Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

