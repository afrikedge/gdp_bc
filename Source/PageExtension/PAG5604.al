pageextension 50052 pageextension70000109 extends "FA Ledger Entries"
{
    layout
    {
        addafter("Reversed")
        {
            field("Straight-Line %"; Rec."Straight-Line %")
            {
            }
            field("FA Posting Group"; Rec."FA Posting Group")
            {
            }
        }
    }
}

