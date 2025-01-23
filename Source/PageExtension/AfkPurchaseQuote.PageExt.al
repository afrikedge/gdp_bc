pageextension 50102 "Afk Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        addlast("Foreign Trade")
        {
            field("Validity Offer"; Rec."Validity Offer") { }
            field(DelaiDeLivraison; Rec.DelaiDeLivraison) { }
            field("Offer Prepayment %"; Rec."Offer Prepayment %") { }
        }
    }
}
