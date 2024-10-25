pageextension 50071 pageextension70000138 extends "Sales Quotes"
{
    layout
    {
        addafter("Quote Valid Until Date")
        {
            field("User ID"; Rec."User ID")
            {
            }
        }
    }
}

