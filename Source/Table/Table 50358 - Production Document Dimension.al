table 50358 "Production Document Dimension"
{

    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE ("Object Type"=CONST(Table));
        }
        field(2;"Document Status";Option)
        {
            Caption = 'Document Status';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(3;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(4;"Document Line No.";Integer)
        {
            Caption = 'Document Line No.';
        }
        field(5;"Line No.";Integer)
        {
            Caption = 'Line No.';
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

