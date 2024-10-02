table 50359 "Posted Document Dimension"
{

    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" WHERE ("Object Type"=CONST(Table));
        }
        field(2;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Dimension Code";Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(5;"Dimension Value Code";Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Dimension Code"));
        }
    }

    keys
    {
        key(Key1;"Table ID","Document No.","Line No.","Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }
}

