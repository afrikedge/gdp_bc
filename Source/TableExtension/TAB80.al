tableextension 50017 "A02 Gen. Journal Template" extends "Gen. Journal Template"
{
    fields
    {
        field(50000; "AFK Cust. Receipt Report ID2"; Integer)
        {
            AccessByPermission = TableData 18 = R;
            Caption = 'Cust. Receipt Report ID2';
            Description = 'Traite et Cheque AFK';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
    }
}

