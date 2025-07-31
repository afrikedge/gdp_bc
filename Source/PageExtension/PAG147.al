pageextension 50028 pageextension70000045 extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Paid")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
        }
    }
}

