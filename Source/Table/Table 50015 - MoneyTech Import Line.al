table 50015 "MoneyTech Import Line"
{
    Caption = 'MoneyTech Import Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line N°';
        }
        field(3;"Station Code";Code[20])
        {
            Caption = 'Station Code';
            TableRelation = Customer;
        }
        field(5;"Debitor No.";Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(6;"Card Type";Option)
        {
            Caption = 'Card Type';
            OptionCaption = 'Prepaid,Postpaid,GPRO';
            OptionMembers = Prepaid,Postpaid,GPRO;
        }
        field(7;"Transaction Type";Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Recharge,Decharge';
            OptionMembers = Recharge,Decharge;
        }
        field(8;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(9;"Starting Date";Date)
        {
            Editable = true;
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
        key(Key2;"Document No.",TransmissionNo,"Transaction Type","Debitor No.","Station Code","Card Type","Card Number")
        {
        }
        key(Key3;"Document No.","Transaction Type")
        {
            SumIndexFields = Amount;
        }
        key(Key4;"Document No.","Station Code")
        {
        }
    }

    fieldgroups
    {
    }
}

