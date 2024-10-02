tableextension 50062 "A02 FA Posting Group" extends "FA Posting Group"
{
    DataCaptionFields = "Code", Name;
    fields
    {
        field(50000; "Groupe Immo Encours"; Boolean)
        {
            Caption = 'Groupe immo encours';
        }
        field(50001; Name; Text[100])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("Acquisition Cost Account")));
            Caption = 'Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    //Unsupported feature: Insertion (FieldGroupCollection) on "(FieldGroup: DropDown)".

}

