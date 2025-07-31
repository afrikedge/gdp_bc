pageextension 50074 pageextension70000145 extends "Purchase Invoices"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = All;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}

