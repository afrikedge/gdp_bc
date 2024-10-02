tableextension 50061 "A02 Fixed Asset" extends "Fixed Asset"
{
    fields
    {

        //Unsupported feature: Property Insertion (Editable) on ""FA Location Code"(Field 10)".

        modify(Inactive)
        {
            Caption = 'Inactive';
        }
        field(50000; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(50001; "FA Sub Location"; Code[10])
        {
            Caption = 'FA Sub Location';
            Editable = false;
            TableRelation = "FA SubLocation".Code WHERE("Location Code" = FIELD("FA Location Code"));
        }
        field(50002; "Startup Date"; Date)
        {
            Caption = 'Startup Date';
            Editable = false;
        }
        field(50003; Brand; Text[30])
        {
            Caption = 'Brand';
        }
        field(50004; "FA Owner"; Code[10])
        {
            Caption = 'Owner';
            TableRelation = "FA Owner";
        }
        field(50005; "FA Type"; Text[30])
        {
            Caption = 'Type';
        }
        field(50006; "FA Location Name"; Text[50])
        {
            CalcFormula = Min("FA Location".Name WHERE(Code = FIELD("FA Location Code")));
            Caption = 'Location Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "FA Sub Location Name"; Text[50])
        {
            CalcFormula = Min("FA SubLocation".Name WHERE("Location Code" = FIELD("FA Location Code"),
                                                           Code = FIELD("FA Sub Location")));
            Caption = 'Sub Location Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; MiseEnService; Boolean)
        {
            Caption = 'In of Service';
            Editable = false;
        }
        field(50009; State; Option)
        {
            Caption = 'State';
            OptionCaption = 'Good,Bad,Inactive';
            OptionMembers = Bon,Mauvais,Defectueux;
        }
        field(50010; Codification; Code[30])
        {
            Caption = 'Codification';
        }
        field(50011; "FA Status"; Option)
        {
            Caption = 'FA Status';
            OptionCaption = 'Used,Not Used';
            OptionMembers = Used,"Not Used";
        }
        field(50012; "Old Number"; Code[20])
        {
            Caption = 'Old Number';
            Editable = false;
        }
        field(50013; "Preserve Number"; Boolean)
        {
        }
        field(50014; "Printed Startup Reference"; Code[50])
        {
            Caption = 'Printed Startup Reference';
        }
        field(50015; "Printed Startup Date"; Date)
        {
            Caption = 'Printed Startup Date';
        }
        field(50016; "Startup Posting Date"; Date)
        {
            Caption = 'Startup Posting Date';
        }
    }
}

