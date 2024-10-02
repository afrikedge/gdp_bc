table 8640 "Config. Text Transformation"
{
    Caption = 'Config. Text Transformation';

    fields
    {
        field(1;"Package Code";Code[20])
        {
            Caption = 'Package Code';
            NotBlank = true;
            TableRelation = "Config. Package";
        }
        field(2;"Table ID";Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE (Object Type=CONST(Table));

            trigger OnLookup()
            begin
                TableNameLookup;
            end;
        }
        field(3;"Field ID";Integer)
        {
            Caption = 'Field ID';
            TableRelation = "Config. Package Field"."Field ID" WHERE (Table ID=FIELD(Table ID));

            trigger OnLookup()
            begin
                FieldLookup;
            end;
        }
        field(4;"Transformation Type";Option)
        {
            Caption = 'Transformation Type';
            OptionCaption = 'Uppercase,Lowercase,Title Case,Trim,Substring,Replace,Regular Expression,Remove Non-Alphanumeric Characters,Date and Time Formatting';
            OptionMembers = Uppercase,Lowercase,"Title Case",Trim,Substring,Replace,"Regular Expression","Remove Non-Alphanumeric Characters","Date and Time Formatting";
        }
        field(5;"Processing Order";Integer)
        {
            Caption = 'Processing Order';
        }
        field(6;"Table Name";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Table),
                                                                        Object ID=FIELD(Table ID)));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Field Name";Text[30])
        {
            Caption = 'Field Name';
            TableRelation = Field.FieldName WHERE (TableNo=FIELD(Table ID));

            trigger OnLookup()
            begin
                FieldLookup;
            end;
        }
        field(10;"Current Value";Text[250])
        {
            Caption = 'Current Value';
        }
        field(11;"New Value";Text[250])
        {
            Caption = 'New Value';
        }
        field(15;"Start Position";Integer)
        {
            BlankZero = true;
            Caption = 'Start Position';

            trigger OnValidate()
            begin
                IF "Start Position" <= 0 THEN
                  ERROR(MustBeGreaterThanZeroErr);
            end;
        }
        field(16;Length;Integer)
        {
            BlankZero = true;
            Caption = 'Length';

            trigger OnValidate()
            begin
                IF Length < 0 THEN
                  ERROR(MustBeGreaterThanZeroErr);
            end;
        }
        field(18;Format;Text[30])
        {
            Caption = 'Format';
        }
        field(20;"Language ID";Integer)
        {
            BlankZero = true;
            Caption = 'Language ID';
            TableRelation = "Windows Language";
        }
        field(21;Enabled;Boolean)
        {
            Caption = 'Enabled';
        }
        field(50;"Last Used Field ID";Integer)
        {
            CalcFormula = Max("Config. Text Transformation"."Processing Order" WHERE (Package Code=FIELD(Package Code),
                                                                                      Table ID=FIELD(Table ID),
                                                                                      Field ID=FIELD(Field ID)));
            Caption = 'Last Used Field ID';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Package Code","Table ID","Field ID","Processing Order")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MustBeGreaterThanZeroErr: Label 'The Value entered must be greater than zero.';

    procedure GetLanguageID(): Integer
    begin
        IF "Language ID" > 0 THEN
          EXIT("Language ID");
        EXIT(GLOBALLANGUAGE);
    end;

    local procedure FieldLookup()
    var
        "Field": Record "2000000041";
        FieldList: Page "6218";
    begin
        CLEAR(FieldList);
        Field.SETRANGE(TableNo,"Table ID");
        FieldList.SETTABLEVIEW(Field);
        FieldList.LOOKUPMODE := TRUE;
        IF FieldList.RUNMODAL = ACTION::LookupOK THEN BEGIN
          FieldList.GETRECORD(Field);
          "Table ID" := Field.TableNo;
          VALIDATE("Field ID",Field."No.");
          VALIDATE("Field Name",Field.FieldName);
        END;
    end;

    local procedure TableNameLookup()
    var
        ConfigValidateManagement: Codeunit "8617";
    begin
        ConfigValidateManagement.LookupTable("Table ID");
        IF "Table ID" <> 0 THEN
          VALIDATE("Table ID");

        CALCFIELDS("Table Name");
    end;
}

