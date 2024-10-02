table 50030 "Fuel Statement Line"
{
    Caption = 'Fuel Statement Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line N°';
        }
        field(3;"Source Appro";Option)
        {
            OptionCaption = 'Station,Tanker';
            OptionMembers = Station,Tanker;
        }
        field(4;"License plate number";Text[50])
        {
        }
        field(5;"Equipement ID number";Text[50])
        {
        }
        field(6;"Vehicule Description";Text[50])
        {
        }
        field(7;"Car Type";Text[50])
        {
        }
        field(8;BackCharge;Boolean)
        {
        }
        field(9;"Equipment Type";Option)
        {
            OptionCaption = 'Mobile,Fixed';
            OptionMembers = Mobile,"Fixed";
        }
        field(10;"Project Code";Code[20])
        {
        }
        field(11;"Cost Code";Code[20])
        {
        }
        field(12;"Cost Center";Text[50])
        {
        }
        field(13;Pump;Code[20])
        {
        }
        field(14;DateRefuel;Date)
        {
        }
        field(15;TimeRefuel;Text[30])
        {
        }
        field(16;"Total Counter";Decimal)
        {
        }
        field(17;"Vehicle Odometer";Text[30])
        {
        }
        field(18;Company;Code[30])
        {
        }
        field(19;Driver;Text[30])
        {
        }
        field(20;TagID;Code[20])
        {
        }
        field(21;Notes;Text[100])
        {
        }
        field(22;Process;Boolean)
        {
            Caption = 'Process';
        }
        field(23;Manufacturor;Text[30])
        {
        }
        field(24;"Departement name";Text[30])
        {
        }
        field(25;"Badge Number";Text[30])
        {
        }
        field(26;"Date of control";Date)
        {
        }
        field(27;"Validated by";Text[30])
        {
        }
        field(50;"Document Type";Option)
        {
            OptionCaption = 'FS,Main invoice,Invoice';
            OptionMembers = FS,"Main invoice",Invoice;
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

