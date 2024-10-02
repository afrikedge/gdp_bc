tableextension 50052 "A02 Cost Entry" extends "Cost Entry"
{
    fields
    {
        field(50000; "Cost Object Name"; Text[50])
        {
            CalcFormula = Lookup("Cost Object".Name WHERE(Code = FIELD("Cost Object Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

