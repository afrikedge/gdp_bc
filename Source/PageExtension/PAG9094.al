pageextension 50070 pageextension70000137 extends "Vendor Statistics FactBox"
{
    layout
    {
        addafter("GetInvoicedPrepmtAmountLCY")
        {
            field("Traite Amount"; Rec."Traite Amount")
            {
                ApplicationArea = All;
            }
        }
    }
}

