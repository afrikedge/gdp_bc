table 50058 "Journal User"
{
    Caption = 'Journal User';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                // UserMgt.ValidateUserID("User ID");
            end;
        }
        field(2; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Gen. Journal Template";
        }
        field(3; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(4; Edit; Boolean)
        {
            Caption = 'Edit';
        }
        field(5; Validate; Boolean)
        {
            Caption = 'Validate';
        }
        field(6; Extourne; Boolean)
        {
            Caption = 'Extourne';
        }
    }

    keys
    {
        key(Key1; "User ID", "Journal Template Name", "Journal Batch Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //IF Default THEN
        //  CheckDefault;
    end;

    trigger OnModify()
    begin
        //IF Default THEN
        //  CheckDefault;
    end;

    var
        Text000: Label 'You can only have one default location per user ID.';
        Text001: Label 'You can only assign an ADCS user name once.';

    local procedure CheckDefault()
    var
        WhseEmployee: Record "Warehouse Employee";
    begin
        WhseEmployee.SetCurrentKey(Default);
        WhseEmployee.SetRange(Default, true);
        WhseEmployee.SetRange("User ID", "User ID");
        WhseEmployee.SetFilter("Location Code", '<>%1', "Journal Template Name");
        if WhseEmployee.FindFirst then
            Error(Text000);
    end;
}

