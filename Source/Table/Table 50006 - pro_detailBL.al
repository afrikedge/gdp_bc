table 50006 pro_detailBL
{
    Caption = 'Shipment Lines';

    fields
    {
        field(1;numBL;Integer)
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
        field(4;volumealivrer;Decimal)
        {
            Caption = 'Volume to ship';
            DecimalPlaces = 0:6;
        }
        field(5;volumelivre;Decimal)
        {
            Caption = 'Shipped volume';
            DecimalPlaces = 0:6;

            trigger OnValidate()
            var
                Marge: Decimal;
            begin
                AddOnSetup.Get;
                if AddOnSetup."BL Adjustement Margin %">0 then begin
                  Marge := Abs(volumelivre-volumealivrer);
                  if Marge>(volumelivre*(AddOnSetup."BL Adjustement Margin %"/100)) then
                    Error(Err001,Marge,AddOnSetup."BL Adjustement Margin %",volumelivre);
                end;
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
            Description = 'codeproduit';
            TableRelation = Item;
        }
        field(50001;"Item Name";Text[50])
        {
            CalcFormula = Min(Item.Description WHERE ("No."=FIELD(NavItemCode)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;numBL,"Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AddOnSetup: Record "AddOn Setup";
        Err001: Label 'La marge du volume livré (%1) ne doit pas excéder %2 (%) du volume à livrer (%3)';
        Err002: Label 'La marge du volume à 15 (%1) ne doit pas excéder %2 (%) du volume ambiant (%3)';
}

