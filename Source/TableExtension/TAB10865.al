tableextension 50076 "A02 Payment Header" extends "Payment Header"
{
    fields
    {
        field(50000; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(50002; "Customer No."; Code[10])
        {
            Caption = 'Customer No.';
            Editable = false;
        }
        field(50003; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(50004; "Check Number"; Text[30])
        {
            Caption = 'Check Number';
            Editable = false;
        }
        field(50005; "Origin Document N°"; Code[20])
        {
            Caption = 'Origin Document N°';
            Editable = false;
        }
        field(50006; "Due Date"; Date)
        {
            CalcFormula = Min("Payment Line"."Due Date" WHERE("No." = FIELD("No.")));
            Caption = 'Due Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; PayDocType; Option)
        {
            OptionCaption = ' ,FromTreso';
            OptionMembers = " ",FromTreso;
        }
    }
    keys
    {
        key(Key1; "Customer No.", "Origin Document N°")
        {
        }
    }
}

