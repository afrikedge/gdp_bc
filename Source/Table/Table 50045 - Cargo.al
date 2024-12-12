table 50045 Cargo
{
    Caption = 'Cargo';
    // LookupPageID = "Cargo List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Arrival Date"; Date)
        {
            Caption = 'Arrival Date';

            trigger OnValidate()
            begin
                if "Cargo Date" = 0D then
                    "Cargo Date" := "Arrival Date";
            end;
        }
        field(4; "Item No. Filter"; Code[20])
        {
            Caption = 'Item No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Item;
        }
        field(5; Quantity; Decimal)
        {
            CalcFormula = Sum("Item Cargo Entry".Quantity WHERE("Ref Cargo" = FIELD(Code),
                                                                 "Item No." = FIELD("Item No. Filter"),
                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                 Reversed = CONST(false)));
            Caption = 'Quantity';
            FieldClass = FlowField;
        }
        field(6; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(7; "Cargo Number"; Code[30])
        {
            Caption = 'Cargo Number';
        }
        field(8; "Cargo Date"; Date)
        {
            Caption = 'Cargo Date';
        }
        field(9; "Vessel Name"; Text[50])
        {
            Caption = 'Vessel Name';
        }
        field(10; "Unit Cost"; Decimal)
        {
            Caption = 'Last unit cost';
            Editable = false;
        }
        field(11; "Cost Updated"; Boolean)
        {
            Caption = 'Coût actualisé';
            Editable = false;
        }
        field(12; "Exchange Rate"; decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(80; "Cargo Type"; Option)
        {
            OptionCaption = ' ,JOVENNA,Confrere,Fictif,Enlevement,transfers';
            OptionMembers = " ",JOVENNA,Confrere,Fictif,Enlevement,Transfer;

            trigger OnValidate()
            begin
                if "Cargo Type" = Rec."Cargo Type"::Fictif then
                    Error(Text003);
                if "Cargo Type" = Rec."Cargo Type"::Confrere then
                    CheckTypeCargo("Cargo Type");
                if "Cargo Type" = Rec."Cargo Type"::Enlevement then
                    CheckTypeCargo("Cargo Type");
            end;
        }
        field(81; Closed; Boolean)
        {
            Caption = 'Closed';

            trigger OnValidate()
            begin
                //TODO Migration
                // if Closed=true then
                //   if not CargoMgt.CargoIsEmpty(Rec.Code) then
                //     Error(Text004);
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Cargo Type", "Cargo Date")
        {
        }
        key(Key3; Closed, "Cargo Type", "Cargo Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        CargoEntry.Reset;
        CargoEntry.SetRange(CargoEntry."Ref Cargo", Rec.Code);
        if CargoEntry.FindFirst then Error(Text001);
    end;

    var
        CargoEntry: Record "Item Cargo Entry";
        Text001: Label 'La cargaison a déjà été utilisée dans des transactions.';
        Text002: Label 'Le cargo %1 possède déjà le type choisi.';
        Text003: Label 'Vous ne devez pas utiliser ce type !';
        //CargoMgt: Codeunit "Item Value Cargo Mgt";
        Text004: Label 'Le cargo doit être vide pour pouvoir être cloturé';

    local procedure CheckTypeCargo(TypeCargo: Integer)
    var
        Cargo1: Record Cargo;
    begin
        Cargo1.Reset;
        Cargo1.SetRange(Cargo1."Cargo Type", TypeCargo);
        Cargo1.SetFilter(Cargo1.Code, '<>%1', Rec.Code);
        if Cargo1.FindFirst then
            Error(Text002, Cargo1.Code);
    end;
}

