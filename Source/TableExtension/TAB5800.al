tableextension 50069 "A02 Item Charge" extends "Item Charge"
{
    fields
    {
        field(50000; "Vendor No"; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
    }
}

