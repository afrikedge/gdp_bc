pageextension 50094 "Afk Customer Card" extends "Customer Card"
{
    Editable = false;
    layout
    {
        addafter("Credit Limit (LCY)")
        {
            field("Risk Level"; Rec."Risk Level")
            {
                ApplicationArea = All;
            }
            field("Holding Code"; Rec."Holding Code")
            {
                ApplicationArea = All;
            }
            field("Holding Name"; Rec."Holding Name")
            {
                ApplicationArea = All;
            }
            field("Company Code"; Rec."Company Code")
            {
                ApplicationArea = All;
            }
            field("Company Name"; Rec."Company Name")
            {
                ApplicationArea = All;
            }
            field("Legal Status Code"; Rec."Legal Status Code")
            {
                ApplicationArea = All;
            }
            field("Industry Group"; Rec."Industry Group")
            {
                ApplicationArea = All;
            }
        }
        addafter("Last Date Modified")
        {
            field("Related Vendor"; Rec."Related Vendor")
            {
                ApplicationArea = All;
            }
            field("GDP Partner"; Rec."GDP Partner")
            {
                ApplicationArea = All;
            }
            field("Sales Category Code"; Rec."Sales Category Code")
            {
                ApplicationArea = All;
            }
            field("Sales Channel Code"; Rec."Sales Channel Code")
            {
                ApplicationArea = All;
            }
            field("Profit Center"; Rec."Profit Center")
            {

            }
            field("Customer Status"; Rec."Customer Status")
            {
                ApplicationArea = All;
            }
            field("Appliquer Ecart pompe JIR"; Rec."Appliquer Ecart pompe JIR")
            {
                ApplicationArea = All;
            }
            field("Remove JIR Ref on BE"; Rec."Remove JIR Ref on BE")
            {
                ApplicationArea = All;
            }
            field("Category 1"; Rec."Category 1")
            {
                ApplicationArea = All;
            }
            field("Category 2"; Rec."Category 2")
            {
                ApplicationArea = All;
            }
            field("Afk Type transport"; Rec."Afk Type transport")
            {
            }
        }

        addlast(Invoicing)
        {
            field("STAT Code"; Rec."STAT Code") { ApplicationArea = All; }
            field("CIF/CIS"; Rec."CIF/CIS") { ApplicationArea = All; }
            field("Trade Number"; Rec."Trade Number") { ApplicationArea = All; }
        }
        addlast(Payments)
        {
            field("Cash payment"; Rec."Cash payment")
            {
                ApplicationArea = All;
            }
            field("Check Set"; Rec."Check Set")
            {
                ApplicationArea = All;
            }
            field("Bank Transfer Bank Stamp"; Rec."Bank Transfer Bank Stamp")
            {
                ApplicationArea = All;
            }
            field(Traite; Rec.Traite)
            {
                ApplicationArea = All;
            }
            field("Received Check"; Rec."Received Check")
            {
                ApplicationArea = All;
            }
            field("Credit Note"; Rec."Credit Note")
            {
                ApplicationArea = All;
            }

        }
    }

}
