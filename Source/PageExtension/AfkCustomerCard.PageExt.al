pageextension 50094 "Afk Customer Card" extends "Customer Card"
{
    Editable = false;
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Risk Level"; Rec."Risk Level") { }
            field("Holding Code"; Rec."Holding Code") { }
            field("Holding Name"; Rec."Holding Name") { }
            field("Company Code"; Rec."Company Code") { }
            field("Company Name"; Rec."Company Name") { }
            field("Legal Status Code"; Rec."Legal Status Code")
            {
            }
            field("Industry Group"; Rec."Industry Group")
            {
            }
        }
        addafter("Last Date Modified")
        {
            field("Related Vendor"; Rec."Related Vendor")
            {

            }
            field("GDP Partner"; Rec."GDP Partner")
            {

            }
            field("Sales Category Code"; Rec."Sales Category Code")
            {

            }
            field("Sales Channel Code"; Rec."Sales Channel Code")
            {

            }
            field("Profit Center"; Rec."Profit Center")
            {

            }
            field("Customer Status"; Rec."Customer Status")
            {

            }
            field("Appliquer Ecart pompe JIR"; Rec."Appliquer Ecart pompe JIR")
            {

            }
            field("Remove JIR Ref on BE"; Rec."Remove JIR Ref on BE")
            {

            }
            field("Category 1"; Rec."Category 1")
            {

            }
            field("Category 2"; Rec."Category 2")
            {

            }
        }

        addlast(Invoicing)
        {
            field("STAT Code"; Rec."STAT Code") { }
            field("CIF/CIS"; Rec."CIF/CIS") { }
            field("Trade Number"; Rec."Trade Number") { }
        }
        addlast(Payments)
        {
            field("Cash payment"; Rec."Cash payment")
            {
            }
            field("Check Set"; Rec."Check Set")
            {
            }
            field("Bank Transfer Bank Stamp"; Rec."Bank Transfer Bank Stamp")
            {
            }
            field(Traite; Rec.Traite)
            {
            }
            field("Received Check"; Rec."Received Check")
            {
            }
            field("Credit Note"; Rec."Credit Note")
            {
            }

        }
    }

}
