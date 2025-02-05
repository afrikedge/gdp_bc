pageextension 50103 "Afk Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Ref Cargo"; Rec."Ref Cargo")
            {
                ApplicationArea = all;
            }
            field("Invoice Doc Ref"; Rec."Invoice Doc Ref")
            {
                ApplicationArea = all;
            }
        }
    }
}
