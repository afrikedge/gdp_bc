table 50008 pro_detailBE
{

    fields
    {
        field(1;numBE;Integer)
        {
            Caption = 'Document No.';
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;NavItemCode;Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(4;volumeaenlever;Decimal)
        {
            Caption = 'Volume to remove';
            DecimalPlaces = 0:6;
        }
        field(5;volumeenleve;Decimal)
        {
            Caption = 'Removed Volume';
            DecimalPlaces = 0:6;
        }
        field(6;volumea15;Decimal)
        {
            Caption = 'Volume at 15';
            DecimalPlaces = 0:6;

            trigger OnValidate()
            var
                Marge: Decimal;
            begin
                AddOnSetup.Get;
                if AddOnSetup."BE Adjustement Margin %">0 then begin
                  Marge := Abs(volumeenleve-volumea15);
                  if Marge>(volumeenleve*(AddOnSetup."BE Adjustement Margin %"/100)) then
                    Error(Err001,Marge,AddOnSetup."BE Adjustement Margin %",volumeenleve);
                end;
            end;
        }
        field(100;volumealivrer;Decimal)
        {
            Caption = 'Volume to ship';
            DecimalPlaces = 0:6;
            Editable = false;

            trigger OnValidate()
            var
                LigneBL: Record pro_detailBL;
            begin
                EnteteBE.Get(numBE);
                LigneBL.Get(EnteteBE.numBL,"Line No.");
                LigneBL.Validate(volumealivrer,volumealivrer);
            end;
        }
        field(101;volumelivre;Decimal)
        {
            Caption = 'Shipped volume';
            DecimalPlaces = 0:6;

            trigger OnValidate()
            var
                Marge: Decimal;
                LigneBL: Record pro_detailBL;
            begin
                /*
                AddOnSetup.GET;
                IF AddOnSetup."BL Adjustement Margin %">0 THEN BEGIN
                  Marge := ABS(volumelivre-volumealivrer);
                  IF Marge>(volumelivre*(AddOnSetup."BL Adjustement Margin %"/100)) THEN
                    ERROR(Err001,Marge,AddOnSetup."BL Adjustement Margin %",volumelivre);
                END;
                */
                EnteteBE.Get(numBE);
                LigneBL.Get(EnteteBE.numBL,"Line No.");
                LigneBL.Validate(volumelivre,volumelivre);
                LigneBL.Modify;

            end;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE ("Item No."=FIELD(NavItemCode));

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "Unit of Measure Translation";
                ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
            end;
        }
        field(50000;codeproduit;Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(50001;"Item Name";Text[50])
        {
            CalcFormula = Min(Item.Description WHERE ("No."=FIELD(NavItemCode)));
            Caption = 'Item Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002;temperature;Decimal)
        {
            Caption = 'Temperature';
        }
        field(50003;densite;Decimal)
        {
            Caption = 'Density';
        }
    }

    keys
    {
        key(Key1;numBE,"Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Text002);
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        Err001: Label 'La marge du volume à 15 (%1) ne doit pas excéder %2 (%) du volume ambiant (%3)';
        RelatedBL: Record pro_enteteBL;
        EnteteBE: Record pro_enteteBE;
        Text002: Label 'Suppression impossible !';
}

