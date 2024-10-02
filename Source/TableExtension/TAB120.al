tableextension 70000015 tableextension70000015 extends "Purch. Rcpt. Header" 
{
    fields
    {
        field(50010;"Ref Cargo";Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
    }
}

