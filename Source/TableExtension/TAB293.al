tableextension 50044 "A02 Reminder Level" extends "Reminder Level"
{
    fields
    {
        field(50000; "Reminder Report ID"; Integer)
        {
            Caption = 'Reminder Report ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(50001; "Reminder Report Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object Type" = CONST(Report),
                                                                        "Object ID" = FIELD("Reminder Report ID")));
            Caption = 'Reminder Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "AG1 Report Usage"; Enum "Report Selection Usage")
        {
            Caption = 'Report Usage';
            DataClassification = CustomerContent;
        }
    }
}

