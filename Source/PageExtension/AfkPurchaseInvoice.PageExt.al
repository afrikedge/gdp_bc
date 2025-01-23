pageextension 50103 "Afk Purchase Invoice" extends "Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Ref Cargo"; Rec."Ref Cargo")
            {

            }
        }
    }
}
