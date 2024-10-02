tableextension 50008 "A02 Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "Vendor Name2"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;

        }
        field(50100; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            Editable = false;
        }
    }
}

