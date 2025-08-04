pageextension 50017 pageextension70000016 extends "General Ledger Setup"
{
    layout
    {
        addlast("General")
        {
            field("Unit-Amount Decimal Places"; Rec."Unit-Amount Decimal Places")
            {
                ApplicationArea = All;
            }
            // field("Mark Cr. Memos as Corrections";Rec."Mark Cr. Memos as Corrections")
            // {
            // }
        }
    }
}

