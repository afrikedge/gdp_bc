tableextension 50037 "A02 Gen. Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        field(50000; "Payment Class"; Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "Payment Class";
        }
    }
}

