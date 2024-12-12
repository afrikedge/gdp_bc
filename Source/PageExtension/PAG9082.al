pageextension 50069 pageextension70000136 extends "Customer Statistics FactBox"
{
    layout
    {
        addafter("LastPaymentReceiptDate")
        {
            field("Traite Amount"; Rec."Traite Amount")
            {
            }
            field("Traite UnPaid"; Rec."Traite UnPaid")
            {
            }
        }
    }
}

