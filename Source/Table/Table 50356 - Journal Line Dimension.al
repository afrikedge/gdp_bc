table 50356 "Journal Line Dimension"
{

    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE ("Object Type"=CONST(Table));
        }
        field(2;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(3;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(4;"Journal Line No.";Integer)
        {
            Caption = 'Journal Line No.';
        }
        field(5;"Allocation Line No.";Integer)
        {
            Caption = 'Allocation Line No.';
        }
        field(6;"Dimension Code";Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(7;"Dimension Value Code";Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Dimension Code"));
        }
        field(8;"New Dimension Value Code";Code[20])
        {
            Caption = 'New Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=FIELD("Dimension Code"));
        }
    }

    keys
    {
        key(Key1;"Table ID","Journal Template Name","Journal Batch Name","Journal Line No.","Allocation Line No.","Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }
}

