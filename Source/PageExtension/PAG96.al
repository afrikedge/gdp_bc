pageextension 50083 pageextension70000150 extends "Sales Cr. Memo Subform"
{
    layout
    {
        modify("Invoice Discount Amount")
        {
            Editable = false;
            ApplicationArea = All;
        }
        modify("Gen. Prod. Posting Group")
        {
            Editable = false;
            ApplicationArea = All;
        }
    }
}

