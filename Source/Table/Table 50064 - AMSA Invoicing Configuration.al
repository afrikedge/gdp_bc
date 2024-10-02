table 50064 "AMSA Invoicing Configuration"
{

    fields
    {
        field(1;"Equipment Type";Option)
        {
            Caption = 'Equipment Type';
            OptionCaption = 'Mobile,Fixe';
            OptionMembers = Mobile,Fixe;
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
        field(4;"Per Company";Boolean)
        {
            Caption = 'Per Company';
        }
        field(5;"Per Process";Boolean)
        {
            Caption = 'Per Process';
        }
        field(6;"Per Cost Code";Boolean)
        {
            Caption = 'Per Cost Code';
        }
    }

    keys
    {
        key(Key1;"Equipment Type",Backcharge,"Cost Code")
        {
        }
    }

    fieldgroups
    {
    }
}

