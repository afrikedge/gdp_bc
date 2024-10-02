table 50025 "MoneyTech Billing Line"
{
    Caption = 'MoneyTech Billing Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line N°';
        }
        field(5;"Customer No.";Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(6;"Card Number";Code[10])
        {
            Caption = 'Card Number';
        }
        field(8;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(9;"Starting Date";Date)
        {
            Editable = true;
        }
        field(10;"Invoice No";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
        }
        key(Key2;"Document No.","Customer No.","Card Number")
        {
        }
    }

    fieldgroups
    {
    }
}

