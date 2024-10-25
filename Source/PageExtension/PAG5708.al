pageextension 50059 pageextension70000116 extends "Get Shipment Lines"
{
    layout
    {
        addafter("OrderNo")
        {
            field("Your Reference"; Rec."Your Reference")
            {
            }
        }
    }
}

