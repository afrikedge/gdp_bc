tableextension 70000123 tableextension70000123 extends "Reminder Level" 
{
    fields
    {
        field(50000;"Reminder Report ID";Integer)
        {
            Caption = 'Reminder Report ID';
            TableRelation = AllObj."Object ID" WHERE (Object Type=CONST(Report));
        }
        field(50001;"Reminder Report Name";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Report),
                                                                        Object ID=FIELD(Reminder Report ID)));
            Caption = 'Reminder Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

