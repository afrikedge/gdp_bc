pageextension 50104 "Afk Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("Ref Cargo"; Rec."Ref Cargo")
            {
                ApplicationArea = All;
            }
        }
    }
}
