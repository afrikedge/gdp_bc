table 50085 "Touring Truck"
{
    Caption = 'Touring Truck';

    fields
    {
        field(1; IdTouring; Integer)
        {
            Caption = 'Id Touring';
            Editable = false;
        }
        field(2; immatriculation; Code[30])
        {

            trigger OnValidate()
            var
                Camion1: Record pro_moyentransport;
                Compartiment: Record Compartment;
            begin
                AddOnSetup.Get;
                if Camion1.Get(immatriculation) then begin

                    //DispachMgt.CheckNewTruckDispaching(IdTouring,immatriculation);

                    //Camion1.TESTFIELD(Camion1.entournee,FALSE);
                    Camion1.TestField(Camion1.disponible, true);
                    Compartiment.SetRange(immatriculation, Camion1.immatriculation);
                    if Compartiment.FindFirst then begin
                        Capacity1 := Compartiment.Capacity1;
                        Capacity2 := Compartiment.Capacity2;
                        Capacity3 := Compartiment.Capacity3;
                        Capacity4 := Compartiment.Capacity4;
                        Capacity5 := Compartiment.Capacity5;
                        Capacity6 := Compartiment.Capacity6;
                        Capacity7 := Compartiment.Capacity7;
                        Capacity8 := Compartiment.Capacity8;
                        Capacity9 := Compartiment.Capacity9;
                        Capacity10 := Compartiment.Capacity10;
                        "Total Capacity" := Compartiment."Total Capacity";
                        //TODO Migration
                        //"Remaining Tours" :=AddOnSetup."Dispaching Maximum Tours" -  DispachMgt.NbreVoyagesEncoursCamion(immatriculation);
                        Pompe := Camion1.pompe;
                    end;

                end;
            end;
        }
        field(3; Capacity1; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 1';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(4; Capacity2; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 2';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(5; Capacity3; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 3';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(6; Capacity4; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 4';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(7; Capacity5; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 5';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(8; Capacity6; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 6';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(9; Capacity7; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 7';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(10; Capacity8; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 8';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(11; Capacity9; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 9';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(12; Capacity10; Decimal)
        {
            BlankZero = true;
            Caption = 'Compartment 10';
            DecimalPlaces = 0 : 1;
            Editable = false;
        }
        field(13; "Remaining Tours"; Integer)
        {
            Caption = 'Remaining Tours';
            Editable = false;
        }
        field(14; "Total Capacity"; Decimal)
        {
            Caption = 'Total Capacity';
            Editable = false;
        }
        field(15; Pompe; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; IdTouring, immatriculation)
        {
        }
    }

    fieldgroups
    {
    }

    var
        //DispachMgt: Codeunit "Logistique Mgt";
        AddOnSetup: Record "AddOn Setup";
}

