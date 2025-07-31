pageextension 50058 pageextension70000115 extends "Location Card"
{
    layout
    {
        addafter("Use ADCS")
        {
            field("Transfer Item Transit"; Rec."Transfer Item Transit")
            {
                ApplicationArea = All;
            }
            field(Depot; Rec.Depot)
            {
                ApplicationArea = All;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }
            field("Allow Negative Stock"; Rec."Allow Negative Stock")
            {
                ApplicationArea = All;
            }
            field("Virtual Location"; Rec."Virtual Location")
            {
                ApplicationArea = All;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
            }
            field("Code JIRAMA"; Rec."Code JIRAMA")
            {
                ApplicationArea = All;
            }
            field("Location Type"; Rec."Location Type")
            {
                ApplicationArea = All;
            }
            field("GDP Location"; Rec."GDP Location")
            {
                ApplicationArea = All;
            }
            field("Printed Location"; Rec."Printed Location")
            {
                ApplicationArea = All;
            }
        }
    }
}

