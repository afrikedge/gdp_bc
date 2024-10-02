table 50023 "Posted Moneytech Import Line"
{
    Caption = 'Posted Moneytech Import Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;"Station Code";Code[20])
        {
            TableRelation = Customer;
        }
        field(5;"Debitor No.";Code[20])
        {
        }
        field(6;"Card Type";Option)
        {
            OptionCaption = 'Prepaid,Postpaid,GPRO';
            OptionMembers = Prepaid,Postpaid,GPRO;
        }
        field(7;"Transaction Type";Option)
        {
            OptionCaption = 'Recharge,Decharge';
            OptionMembers = Recharge,Decharge;
        }
        field(8;Amount;Decimal)
        {
        }
        field(9;"Starting Date";Date)
        {
            Editable = false;
        }
        field(10;"Card Number";Code[10])
        {
            Caption = 'Card Number';
        }
        field(11;TransmissionNo;Code[20])
        {
            Caption = 'Journal Code';
        }
        field(12;TransmissionDate;Text[30])
        {
            Caption = 'Transmission Date';
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
        }
        key(Key2;"Transaction Type","Debitor No.","Starting Date")
        {
            Enabled = false;
        }
        key(Key3;"Card Type","Transaction Type","Starting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

