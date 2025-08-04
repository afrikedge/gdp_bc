pageextension 50098 "Afk Item Card" extends "Item Card"
{
    Editable = false;
    layout
    {
        addafter("Application Wksh. User ID")
        {
            field("OMH Fees Price"; Rec."OMH Fees Price")
            {
                ApplicationArea = All;
            }
            field("FER Fees Price"; Rec."FER Fees Price")
            {
                ApplicationArea = All;
            }
            field("ENV Fees Price"; Rec."ENV Fees Price")
            {
                ApplicationArea = All;
            }
            field("RDS Fees Price"; Rec."RDS Fees Price")
            {
                ApplicationArea = All;
            }
            field("VAT Correction"; Rec."VAT Correction")
            {
                ApplicationArea = All;
            }
            field("ToCharge %"; Rec."ToCharge %")
            {
                ApplicationArea = All;
            }
            field("ToCharge Item"; Rec."ToCharge Item")
            {
                ApplicationArea = All;
            }
            field("Cargo Mgt"; Rec."Cargo Mgt")
            {
                ApplicationArea = All;
            }
            field("Validation Status"; Rec."Validation Status")
            {
                ApplicationArea = All;
            }
            field("Afk Default Transport Code"; Rec."Afk Default Transport Code")
            {
                ApplicationArea = All;
            }
            field("Afk Show on Market Place"; Rec."Afk Show on Market Place")
            {
                ApplicationArea = All;
            }
            field("Afk Code transport Hors-ville"; Rec."Afk Code transport Hors-ville")
            {
                ApplicationArea = All;
            }
        }
    }
}
