pageextension 50076 pageextension70000147 extends "Purchase Return Order List"
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

