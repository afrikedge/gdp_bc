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
                ApplicationArea = All;
            }
            field(Transporter; Rec.Transporter)
            {
                ApplicationArea = All;
            }
            field(Statut; Rec.Statut)
            {
                ApplicationArea = All;
            }
            field("Activity Area"; Rec."Activity Area")
            {
                ApplicationArea = All;
            }
            field("Related Customer"; Rec."Related Customer")
            {
                ApplicationArea = All;
            }
            field("CIF/CIS"; Rec."CIF/CIS")
            {
                ApplicationArea = All;
            }
            field("STAT Code"; Rec."STAT Code")
            {
                ApplicationArea = All;
            }
            field("Trade Number"; Rec."Trade Number")
            {
                ApplicationArea = All;
            }
            field("Vendor Retention Posting Group"; Rec."Vendor Retention Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
