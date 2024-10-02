tableextension 70000005 tableextension70000005 extends "Payment Header Archive" 
{
    fields
    {
        field(50000;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(50002;"Customer No.";Code[10])
        {
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(50003;"Customer Name";Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(50004;"Check Number";Text[30])
        {
            Caption = 'Check Number';
            Editable = false;
        }
        field(50005;"Origin Document N°";Code[20])
        {
            Caption = 'Origin Document N°';
            Editable = false;
        }
    }
}

