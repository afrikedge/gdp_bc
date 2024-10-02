tableextension 70000155 tableextension70000155 extends "Item Charge" 
{
    fields
    {
        field(50000;"Vendor No";Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
    }
}

