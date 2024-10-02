tableextension 70000140 tableextension70000140 extends "Sales Line Archive" 
{
    fields
    {
        field(50000;"Card Number";Code[10])
        {
        }
        field(50001;"Consignation Line No.";Integer)
        {
            Editable = false;
        }
        field(50002;"Qty to remove";Decimal)
        {
            Caption = 'Qty to remove';
        }
        field(50003;"Qty to prepare";Decimal)
        {
            Caption = 'Qty to prepare';
        }
        field(50010;"OMH Fees Price";Decimal)
        {
        }
        field(50011;"FER Fees Price";Decimal)
        {
        }
        field(50012;"ENV Fees Price";Decimal)
        {
        }
        field(50030;"Initial Qty";Decimal)
        {
            Caption = 'Initial Qty';
            Editable = false;
        }
        field(50070;"AMSA Source Type";Option)
        {
            Caption = 'AMSA Source Type';
            OptionCaption = 'Station,Tanker';
            OptionMembers = Station,Tanker;
        }
        field(50072;"AMSA Cost Code";Code[20])
        {
        }
        field(50073;"AMSA BackCharge";Option)
        {
            Caption = 'Backcharge';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50074;"AMSA Equipment Type";Option)
        {
            Caption = 'Equipment Type';
            OptionCaption = 'Mobile,Fixed';
            OptionMembers = Mobile,"Fixed";
        }
        field(50075;"AMSA Company Code";Code[30])
        {
        }
        field(50076;"AMSA Process";Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50077;"AMSA Invoice No.";Code[20])
        {
        }
        field(50078;"AMSA Order No.";Code[20])
        {
        }
        field(50079;"Real Location";Code[10])
        {
        }
    }
}

