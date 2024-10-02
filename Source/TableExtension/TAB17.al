tableextension 50004 "A02 G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50100; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            Editable = false;
        }
        field(50101; "Purchase Invoice Doc"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Invoice Doc"."Reference Number" WHERE("Vendor Invoice No." = FIELD("External Document No.")));
            Caption = 'Puchase Invoice Doc';
            Editable = false;

        }
    }
}

