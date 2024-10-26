pageextension 50075 pageextension70000146 extends "Purchase Credit Memos"
{
    layout
    {
        addafter("Job Queue Status")
        {
            field("User ID"; Rec."User ID")
            {
            }
        }
    }
}

