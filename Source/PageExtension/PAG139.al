pageextension 50023 pageextension70000039 extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Units per Parcel")
        {
            field("Batch Number"; Rec."Batch Number")
            {
                Visible = false;
            }
        }
    }
}

