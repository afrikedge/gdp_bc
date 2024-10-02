table 50355 "Ledger Entry Dimension"
{

    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" WHERE ("Object Type"=CONST(Table));
        }
        field(2;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(3;"Dimension Code";Code[20])
        {
            Caption = 'Dimension Code';
            NotBlank = true;
            TableRelation = Dimension;
        }
        field(4;"Dimension Value Code";Code[20])
        {
            Caption = 'Dimension Value Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                //"Dimension Value".Code WHERE (Dimension Code=FIELD(Dimension Code))
            end;
        }
        field(5;done;Boolean)
        {
        }
        field(6;"Posting Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Table ID","Entry No.","Dimension Code")
        {
        }
    }

    fieldgroups
    {
    }
}

