pageextension 50099 "Afk Item List" extends "Item List"
{
    layout
    {
        addafter(GTIN)
        {
            field("Validation Status"; Rec."Validation Status")
            {

            }
            field("Sales Category Code"; Rec."Sales Category Code")
            {

            }
        }
    }
}
