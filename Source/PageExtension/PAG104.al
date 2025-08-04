pageextension 50015 pageextension70000002 extends "Account Schedule"
{
    layout
    {
        addafter("HideCurrencySymbol")
        {
            field("Debitor Balance"; Rec."Debitor Balance")
            {
                ApplicationArea = All;
            }
            field("Creditor Balance"; Rec."Creditor Balance")
            {
                ApplicationArea = All;
            }
        }
    }
}

