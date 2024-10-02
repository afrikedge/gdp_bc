table 50067 "Posted AMSA Invoice Line"
{
    Caption = 'Posted AMSA Invoice Line';

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = 'FS,Main invoice,Invoice';
            OptionMembers = FS,"Main invoice",Invoice;
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line N°';
        }
        field(4;"Item No";Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
        }
        field(5;"Item Name";Text[50])
        {
            Caption = 'Item Name';
            Editable = false;
        }
        field(6;"Invoice Qty";Decimal)
        {
            Caption = 'Invoice Qty';
            Editable = false;
        }
        field(7;"Order Ref";Code[30])
        {
            Caption = 'Order No.';
        }
        field(8;"Invoice Ref";Code[20])
        {
            Caption = 'Invoice Ref.';
            Editable = false;
        }
        field(9;"Unit Price";Decimal)
        {
            Caption = 'Unit Price';
            Editable = false;
        }
        field(10;Amount;Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(11;"VAT Amount";Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
        }
        field(12;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(13;"Amount Incl. VAT";Decimal)
        {
            Caption = 'Amount Incl. VAT';
            Editable = false;
        }
        field(100;Process;Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(101;"Customer No";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

