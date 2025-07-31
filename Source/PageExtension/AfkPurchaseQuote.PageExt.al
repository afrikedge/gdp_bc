pageextension 50102 "Afk Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        addlast("Foreign Trade")
        {
            field("Validity Offer"; Rec."Validity Offer") { ApplicationArea = All; }
            field(DelaiDeLivraison; Rec.DelaiDeLivraison) { ApplicationArea = All; }
            field("Offer Prepayment %"; Rec."Offer Prepayment %") { ApplicationArea = All; }
        }
    }
}
