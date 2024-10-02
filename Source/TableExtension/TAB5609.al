tableextension 50063 "A02 FA Location" extends "FA Location"
{
    fields
    {
        field(50000; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('PROJET'));
        }
    }
}

