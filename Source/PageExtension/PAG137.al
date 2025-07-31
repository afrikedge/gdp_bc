pageextension 50022 pageextension70000037 extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Units per Parcel")
        {
            field("Batch Number"; Rec."Batch Number")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }
}

