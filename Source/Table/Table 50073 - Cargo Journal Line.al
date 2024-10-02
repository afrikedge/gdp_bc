table 50073 "Cargo Journal Line"
{

    fields
    {
        field(1;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(2;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE ("Item Category Code"=CONST('PBL'));

            trigger OnValidate()
            begin
                if Item1.Get("Item No.") then
                  "Item Name" := Item1.Description;
            end;
        }
        field(3;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(4;"Entry Type";Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Positive Adjmt.,Negative Adjmt.';
            OptionMembers = "Positive Adjmt.","Negative Adjmt.";
        }
        field(5;"Ref Cargo";Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo WHERE ("Cargo Type"=FILTER(" "|JOVENNA),
                                         Closed=CONST(false));

            trigger OnValidate()
            begin
                if Cargo1.Get("Ref Cargo") then
                  "Cargo Type" := Cargo1."Cargo Type";
            end;
        }
        field(6;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(7;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(11;"Unit Cost";Decimal)
        {
            Caption = 'Unit Cost (Cargo)';
            DecimalPlaces = 0:9;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Cost Amount" := "Unit Cost"*Quantity;
            end;
        }
        field(12;"Cost Amount";Decimal)
        {
            Caption = 'Cost Amount (Cargo)';

            trigger OnValidate()
            begin
                TestField(Quantity);
                "Unit Cost" := "Cost Amount" / Quantity;
                //VALIDATE("Unit Amount");
                GLSetup.Get;
                "Unit Cost" := Round("Unit Cost",0.000000001);
            end;
        }
        field(13;Quantity;Decimal)
        {
            Caption = 'Quantity (Cargo)';
            MinValue = 0;

            trigger OnValidate()
            begin
                "Cost Amount" := "Unit Cost"*Quantity;
            end;
        }
        field(15;"Item Name";Text[50])
        {
            Caption = 'Item Name';
            Editable = false;
            FieldClass = Normal;
        }
        field(80;"Cargo Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,JOVENNA,Confrere,Fictif,Transfer';
            OptionMembers = " ",JOVENNA,Confrere,Fictif,Transfer;
        }
        field(85;"Sales Channel Code";Code[10])
        {
            Caption = 'Sales Channel Code';
            TableRelation = "Sales Channel";
        }
        field(89;"Customer No.";Code[20])
        {
            Caption = 'Code client';
            Editable = false;
            TableRelation = Customer;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions;
            end;
        }
        field(50069;"Ref Dossier Cargo";Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
    }

    keys
    {
        key(Key1;"Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Item1: Record Item;
        Cargo1: Record Cargo;
        GLSetup: Record "General Ledger Setup";
}

