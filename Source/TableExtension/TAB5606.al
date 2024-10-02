tableextension 70000148 tableextension70000148 extends "FA Posting Group" 
{
    DataCaptionFields = "Code",Name;
    fields
    {
        field(50000;"Groupe Immo Encours";Boolean)
        {
            Caption = 'Groupe immo encours';
        }
        field(50001;Name;Text[50])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE (No.=FIELD(Acquisition Cost Account)));
            Caption = 'Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: Insertion (FieldGroupCollection) on "(FieldGroup: DropDown)".

}

