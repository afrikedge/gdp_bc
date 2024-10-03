table 50074 "Contenu Cargo"
{
    Caption = 'Contenu Cargaison';
    // DrillDownPageID = "Contenu Cargo";
    // LookupPageID = "Contenu Cargo";

    fields
    {
        field(1; "Ref Cargo"; Code[20])
        {
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(5; Quantity; Decimal)
        {
            CalcFormula = Sum("Item Cargo Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                 "Ref Cargo" = FIELD("Ref Cargo"),
                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                 Reversed = CONST(false)));
            Caption = 'Quantity';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(7; "Purchased Quantity"; Decimal)
        {
            CalcFormula = Sum("Item Cargo Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                 "Ref Cargo" = FIELD("Ref Cargo"),
                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                 "Entry Type" = FILTER(Purchase | "Positive Adjmt.")));
            Caption = 'Initial Quantity';
            Editable = false;
            FieldClass = FlowField;
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
        field(12; "Last Unit Cost"; Decimal)
        {
            Caption = 'Previous unit cost';
            Editable = false;
        }
        field(13; "Last Updated Date"; Date)
        {
            Caption = 'Date dern. mise à jour';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Ref Cargo", "Item No.")
        {
        }
    }

    fieldgroups
    {
    }
}

