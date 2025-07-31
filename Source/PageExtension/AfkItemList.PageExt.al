pageextension 50099 "Afk Item List" extends "Item List"
{
    layout
    {
        addafter(GTIN)
        {
            field("Validation Status"; Rec."Validation Status")
            {
                ApplicationArea = All;
            }
            field("Sales Category Code"; Rec."Sales Category Code")
            {
                ApplicationArea = All;
            }
        }
    }
}
