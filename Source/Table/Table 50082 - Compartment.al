table 50082 Compartment
{
    Caption = 'Compartment';

    fields
    {
        field(1; immatriculation; Code[30])
        {
            Caption = 'Registration';
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Capacity1; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 1';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(4; Capacity2; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 2';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(5; Capacity3; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 3';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(6; Capacity4; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 4';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(7; Capacity5; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 5';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(8; Capacity6; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 6';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(9; Capacity7; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 7';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(10; Capacity8; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 8';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(11; Capacity9; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 9';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(12; Capacity10; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 10';
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                CalcTotal;
            end;
        }
        field(13; "Last Item1"; Code[20])
        {
        }
        field(14; "Last Item2"; Code[20])
        {
        }
        field(15; "Last Item3"; Code[20])
        {
        }
        field(16; "Last Item4"; Code[20])
        {
        }
        field(17; "Last Item5"; Code[20])
        {
        }
        field(18; "Last Item6"; Code[20])
        {
        }
        field(19; "Last Item7"; Code[20])
        {
        }
        field(20; "Last Item8"; Code[20])
        {
        }
        field(21; "Last Item9"; Code[20])
        {
        }
        field(22; "Last Item10"; Code[20])
        {
        }
        field(23; "Total Capacity"; Decimal)
        {
            Caption = 'Total Capacity';
            Editable = false;
        }

        field(24; "Ordre1"; integer)
        {
            Caption = 'Ordre C1';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(25; "Ordre2"; integer)
        {
            Caption = 'Ordre C2';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(26; "Ordre3"; integer)
        {
            Caption = 'Ordre C3';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(27; "Ordre4"; integer)
        {
            Caption = 'Ordre C4';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(28; "Ordre5"; integer)
        {
            Caption = 'Ordre C5';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(29; "Ordre6"; integer)
        {
            Caption = 'Ordre C6';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(30; "Ordre7"; integer)
        {
            Caption = 'Ordre C7';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(31; "Ordre8"; integer)
        {
            Caption = 'Ordre C8';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(32; "Ordre9"; integer)
        {
            Caption = 'Ordre C9';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
        field(33; "Ordre10"; integer)
        {
            Caption = 'Ordre C10';
            BlankZero = true;
            MinValue = 1;
            MaxValue = 10;
        }
    }

    keys
    {
        key(Key1; immatriculation, "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcTotal;
    end;

    trigger OnInsert()
    begin
        CalcTotal;
    end;

    var
        Text001: Label 'Le compartiment précédent soit être renseigné avant l''actuel';

    local procedure CalcTotal()
    var
        Camion: Record pro_moyentransport;
        NbreCompart: Integer;
    begin
        "Total Capacity" := Capacity1 + Capacity2 + Capacity3 + Capacity4 + Capacity5
          + Capacity6 + Capacity7 + Capacity8 + Capacity9 + Capacity10;

        NbreCompart := 0;
        if (Capacity1 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity2 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity3 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity4 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity5 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity6 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity7 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity8 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity9 > 0) then NbreCompart := NbreCompart + 1;
        if (Capacity10 > 0) then NbreCompart := NbreCompart + 1;

        Camion.Get(immatriculation);
        Camion.capacite := "Total Capacity";
        Camion.compartiments := NbreCompart;
        Camion.Modify;

        if ((Capacity1 = 0) and (Capacity2 > 0)) then Error(Text001);
        if ((Capacity2 = 0) and (Capacity3 > 0)) then Error(Text001);
        if ((Capacity3 = 0) and (Capacity4 > 0)) then Error(Text001);
        if ((Capacity4 = 0) and (Capacity5 > 0)) then Error(Text001);
        if ((Capacity5 = 0) and (Capacity6 > 0)) then Error(Text001);
        if ((Capacity6 = 0) and (Capacity7 > 0)) then Error(Text001);
        if ((Capacity7 = 0) and (Capacity8 > 0)) then Error(Text001);
        if ((Capacity8 = 0) and (Capacity9 > 0)) then Error(Text001);
        if ((Capacity9 = 0) and (Capacity10 > 0)) then Error(Text001);
    end;
}

