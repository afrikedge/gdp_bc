tableextension 70000112 tableextension70000112 extends "Ship-to Address" 
{
    fields
    {
        field(50000;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
    }
}

