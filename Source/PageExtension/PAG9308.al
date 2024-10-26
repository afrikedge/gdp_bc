pageextension 50074 pageextension70000145 extends "Purchase Invoices"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
            }
            field("User ID"; Rec."User ID")
            {
            }
        }
    }
}

