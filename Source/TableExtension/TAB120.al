tableextension 50030 "A02 Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50010; "Ref Cargo"; Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
    }
}

