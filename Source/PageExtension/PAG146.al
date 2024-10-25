pageextension 50027 pageextension70000044 extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("User ID"; Rec."User ID")
            {
            }
        }
    }
}

