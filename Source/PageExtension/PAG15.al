pageextension 50002 "AG1 Location List" extends "Location List"
{
    layout
    {
        addafter("Name")
        {
            field(Depot; Rec.Depot)
            {
                ApplicationArea = All;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
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
            field("Transfer Item Transit"; Rec."Transfer Item Transit")
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

    //Unsupported feature: Property Deletion (Editable).
}