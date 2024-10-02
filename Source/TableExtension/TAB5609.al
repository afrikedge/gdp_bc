tableextension 70000149 tableextension70000149 extends "FA Location" 
{
    fields
    {
        field(50000;"Project Code";Code[20])
        {
            Caption = 'Project Code';
            TableRelation = "Dimension Value".Code WHERE (Dimension Code=CONST(PROJET));
        }
    }
}

