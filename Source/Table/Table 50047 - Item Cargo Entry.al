table 50047 "Item Cargo Entry"
{
    Caption = 'Item Cargo Entry';
    // DrillDownPageID = "Item Cargo Entries";
    // LookupPageID = "Item Cargo Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        }
        field(5; "Ref Cargo"; Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(11; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost (Cargo)';
            Editable = false;
        }
        field(12; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount (Cargo)';
            Editable = false;
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity (Cargo)';
        }
        field(14; Positive; Boolean)
        {
        }
        field(15; "Item Name"; Text[50])
        {
            CalcFormula = Min(Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Name';
            FieldClass = FlowField;
        }
        field(16; Reversed; Boolean)
        {
            Caption = 'Reversed';
        }
        field(79; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly';
            OptionMembers = " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
        }
        field(80; "Cargo Type"; Option)
        {
            OptionCaption = ' ,JOVENNA,Confrere,Fictif,Enlevement,Transfer';
            OptionMembers = " ",JOVENNA,Confrere,Fictif,Enlevement,Transfer;
        }
        field(81; "Entry Date"; DateTime)
        {
            Caption = 'Entry Date';
        }
        field(82; "User ID"; Code[50])
        {
        }
        field(83; "Adjustment Type"; Option)
        {
            Caption = 'Adjustment Type';
            OptionCaption = ' ,BE,Transfer,Exchange,Loan,Loan Return,Consignation,Consignation Return,Borrow,Borrow Return,Invoiced Conso,FA Conso,LUB Shipment,Shipment,Reception,Ajustement BE,Ajustement Naphta,Ajustement BL';
            OptionMembers = " ",BE,Transfer,Exchange,Loan,"Loan Return",Consignation,"Consignation Return",Borrow,"Borrow Return","Invoiced Conso","FA Conso","LUB Ship",Shipment,Reception,AdjBE,AjustNaphta,AdjBL;
        }
        field(84; Journal; Boolean)
        {
            Caption = 'Journal';
        }
        field(85; "Sales Channel Code"; Code[10])
        {
            Caption = 'Sales Channel Code';
            TableRelation = "Sales Channel";
        }
        field(86; "System Entry"; Boolean)
        {
            Editable = false;
        }
        field(87; "Sales Channel Name"; Text[50])
        {
            CalcFormula = Lookup("Sales Channel".Description WHERE(Code = FIELD("Sales Channel Code")));
            Caption = 'Sales Channel';
            Editable = false;
            FieldClass = FlowField;
        }
        field(88; Source; Option)
        {
            OptionCaption = ' ,Anticipated,EcartJIRAMA,OD';
            OptionMembers = " ",Anticipated,EcartJIRAMA,OD;
        }
        field(89; "Customer No."; Code[20])
        {
            Caption = 'Code client';
            Editable = false;
            TableRelation = Customer;
        }
        field(90; "Cargo Name"; Text[50])
        {
            CalcFormula = Lookup(Cargo.Description WHERE(Code = FIELD("Ref Cargo")));
            Caption = 'Nom cargo';
            Editable = false;
            FieldClass = FlowField;
        }
        field(91; "Invoice No"; Code[20])
        {
            Caption = 'N° facture';
        }
        field(92; "Cargo Adjusted"; Boolean)
        {
            Caption = 'Ajusté en compta.';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(50069; "Ref Dossier Cargo"; Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
        field(50070; "Initial Qty"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; Source, "Posting Date")
        {
            Enabled = false;
        }
        key(Key3; "Ref Cargo", "Item No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key4; Source, "Cargo Adjusted", Reversed, "Posting Date")
        {
        }
        key(Key5; "Posting Date")
        {
        }
        key(Key6; Journal, "Entry Type", "Ref Cargo", "Item No.")
        {
        }
        key(Key7; Source, "Document No.")
        {
        }
        key(Key8; "Item No.", Reversed)
        {
        }
        key(Key9; Source, "Sales Channel Code", "Posting Date")
        {
        }
        key(Key10; "Document Type", "Document No.")
        {
        }
        key(Key11; "Entry Type", "Item No.", "Customer No.", "Posting Date")
        {
        }
        key(Key12; Source, "Entry Type", "Item No.", "Customer No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit DimensionManagement;

    procedure ShowDimensions()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "Entry No."));
    end;
}

