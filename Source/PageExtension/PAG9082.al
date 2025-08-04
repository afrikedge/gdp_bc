pageextension 50069 pageextension70000136 extends "Customer Statistics FactBox"
{
    layout
    {
        addafter("LastPaymentReceiptDate")
        {
            field("Traite Amount"; Rec."Traite Amount")
            {
                ApplicationArea = All;
            }
            field("Traite UnPaid"; Rec."Traite UnPaid")
            {
                ApplicationArea = All;
            }
        }
    }
}

