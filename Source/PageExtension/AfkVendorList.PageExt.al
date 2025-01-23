pageextension 50097 "Afk Vendor List" extends "Vendor List"
{
    layout
    {
        modify("Name 2")
        {
            Caption = 'Nom Transporteur Dispaching';
        }
        addafter("Balance (LCY)")
        {
            field("GDP Partner"; Rec."GDP Partner")
            {

            }
            field(Transporter; Rec.Transporter)
            {

            }
            field(Statut; Rec.Statut)
            {

            }
            field("Activity Area"; Rec."Activity Area")
            {

            }
            field("Related Customer"; Rec."Related Customer")
            {

            }
            field("CIF/CIS"; Rec."CIF/CIS")
            {

            }
            field("STAT Code"; Rec."STAT Code")
            {

            }
            field("Trade Number"; Rec."Trade Number")
            {

            }
            field("Vendor Retention Posting Group"; Rec."Vendor Retention Posting Group")
            {

            }
        }
    }
}
