pageextension 50026 pageextension70000043 extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Shipment Method Code")
        {
            field("Order No."; Rec."Order No.")
            {
            }
            field("User ID"; Rec."User ID")
            {
            }
        }
    }
}

