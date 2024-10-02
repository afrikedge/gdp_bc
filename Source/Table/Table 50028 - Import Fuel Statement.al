table 50028 "Import Fuel Statement"
{

    fields
    {
        field(1;EntryNo;Integer)
        {
            AutoIncrement = true;
        }
        field(3;"Source Appro";Text[30])
        {
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
        field(8;BackCharge;Text[10])
        {
        }
        field(9;"Equipment Type";Text[30])
        {
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
        field(14;DateRefuel;Text[30])
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
        field(22;Process;Text[30])
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
        field(26;"Date of control";Text[30])
        {
        }
        field(27;"Validated by";Text[30])
        {
        }
        field(100;Qty1;Decimal)
        {
        }
        field(101;Qty2;Decimal)
        {
        }
        field(102;Qty3;Decimal)
        {
        }
        field(103;Qty4;Decimal)
        {
        }
        field(104;Qty5;Decimal)
        {
        }
        field(105;Valeur1;Code[20])
        {
        }
        field(106;Valeur2;Code[20])
        {
        }
        field(107;Valeur3;Code[20])
        {
        }
        field(108;Valeur4;Code[20])
        {
        }
        field(109;Valeur5;Code[20])
        {
        }
    }

    keys
    {
        key(Key1;EntryNo)
        {
        }
    }

    fieldgroups
    {
    }
}

