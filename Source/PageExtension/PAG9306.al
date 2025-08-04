pageextension 50073 pageextension70000143 extends "Purchase Quotes"
{
    layout
    {
        addafter("Status")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
            field("Code Demande"; Rec."Code Demande")
            {
                ApplicationArea = All;
            }
        }
    }
}

