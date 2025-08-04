pageextension 50036 pageextension70000077 extends "Sales Order Statistics"
{
    layout
    {
        modify("InvDiscountAmount_General")
        {
            Editable = false;
            ApplicationArea = All;
        }
    }
}

