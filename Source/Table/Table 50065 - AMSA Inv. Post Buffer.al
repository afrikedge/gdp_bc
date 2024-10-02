table 50065 "AMSA Inv. Post Buffer"
{

    fields
    {
        field(1;"Equipment Type";Option)
        {
            Caption = 'Equipment Type';
            OptionCaption = 'Mobile,Fixed';
            OptionMembers = Mobile,"Fixed";
        }
        field(2;Backcharge;Option)
        {
            Caption = 'Backcharge';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(3;"Cost Code";Code[20])
        {
            Caption = 'Cost Code';
        }
        field(4;"Company Code";Code[30])
        {
        }
        field(5;Process;Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(7;"Source Appro";Option)
        {
            OptionCaption = 'Station,Tanker';
            OptionMembers = Station,Tanker;
        }
        field(8;"Invoice Qty";Decimal)
        {
            Caption = 'Invoice Qty';
        }
        field(9;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(10;FSNumber;Code[20])
        {
        }
        field(11;Amount;Decimal)
        {
        }
        field(12;"VAT Amount";Decimal)
        {
        }
        field(13;"Unit Price";Decimal)
        {
        }
        field(14;"Amount Incl. VAT";Decimal)
        {
        }
        field(15;"Order No";Code[30])
        {
        }
        field(16;"Invoice No";Code[20])
        {
        }
        field(17;LineNum;Integer)
        {
        }
    }

    keys
    {
        key(Key1;FSNumber,"Posting Date","Equipment Type",Backcharge,"Cost Code","Company Code",Process,"Source Appro",LineNum)
        {
        }
        key(Key2;FSNumber,"Equipment Type",Backcharge,"Cost Code","Company Code",Process)
        {
        }
    }

    fieldgroups
    {
    }
}

