tableextension 70000114 tableextension70000114 extends "Gen. Journal Batch" 
{
    fields
    {
        field(50000;"Payment Class";Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "Payment Class";
        }
    }
}

