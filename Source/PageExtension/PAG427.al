pageextension 50037 pageextension70000082 extends "Payment Methods"
{
    layout
    {
        addafter("Direct Debit")
        {
            field("CC Document Type"; Rec."CC Document Type")
            {
                ApplicationArea = All;
            }
            field("Allow vendor email"; Rec."Allow vendor email")
            {
                ApplicationArea = All;
            }
        }
    }
}

