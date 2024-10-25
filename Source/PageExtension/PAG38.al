pageextension 50007 pageextension70000072 extends "Item Ledger Entries"
{
    layout
    {
        addafter("Source No.")
        {
            field("Adjustment Type"; Rec."Adjustment Type")
            {
            }
            field("Reason Code"; Rec."Reason Code")
            {
            }
            field("Transaction Date"; Rec."Transaction Date")
            {
            }
            field("User ID"; Rec."User ID")
            {
            }
            field("Ref Cargo"; Rec."Ref Cargo")
            {
            }
            field("Num Doc Liaison PBL"; Rec."Num Doc Liaison PBL")
            {
            }
            field("Batch Number"; Rec."Batch Number")
            {
            }
            field("LUB Expiration Date"; Rec."LUB Expiration Date")
            {
            }
        }
    }
    actions
    {
        addafter("SetDimensionFilter")
        {
            action("Lettrages antérieures à date")
            {
                Caption = 'Lettrages antérieures à date';
                RunObject = Report 50066;
            }
        }
    }
}

