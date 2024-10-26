pageextension 50048 pageextension70000013 extends "Cost Entries"
{
    layout
    {
        addafter("Credit Amount")
        {
            field("Cost Object Name"; Rec."Cost Object Name")
            {
            }
        }
    }
}

