pageextension 50007 pageextension70000072 extends "Item Ledger Entries"
{
    layout
    {
        addafter("Source No.")
        {
            field("Adjustment Type"; Rec."Adjustment Type")
            {
                ApplicationArea = All;
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
            field("Transaction Date"; Rec."Transaction Date")
            {
                ApplicationArea = All;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
            field("Ref Cargo"; Rec."Ref Cargo")
            {
                ApplicationArea = All;
            }
            field("Num Doc Liaison PBL"; Rec."Num Doc Liaison PBL")
            {
                ApplicationArea = All;
            }
            field("Batch Number"; Rec."Batch Number")
            {
                ApplicationArea = All;
            }
            field("LUB Expiration Date"; Rec."LUB Expiration Date")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
            }
        }
    }
}

