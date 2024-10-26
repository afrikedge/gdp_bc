pageextension 50002 "AG1 Location List" extends "Location List"
{
    layout
    {
        addafter("Name")
        {
            field(Depot; Rec.Depot)
            {
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
            }
            field("Allow Negative Stock"; Rec."Allow Negative Stock")
            {
            }
            field("Virtual Location"; Rec."Virtual Location")
            {
            }
            field("Transfer Item Transit"; Rec."Transfer Item Transit")
            {
            }
            field("Location Type"; Rec."Location Type")
            {
            }
            field("GDP Location"; Rec."GDP Location")
            {
            }
            field("Printed Location"; Rec."Printed Location")
            {
            }
        }
    }

    //Unsupported feature: Property Deletion (Editable).

}

