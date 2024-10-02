tableextension 70000156 tableextension70000156 extends "Value Entry" 
{
    fields
    {
        field(50010;"Ref Cargo";Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
        field(50011;"Unit Cost (Cargo)";Decimal)
        {
            Caption = 'Unit Cost (Cargo)';
            Editable = false;
        }
        field(50012;"Cost Amount (Cargo)";Decimal)
        {
            Caption = 'Cost Amount (Cargo)';
            Editable = false;
        }
        field(50013;"Ref Cargo 2";Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
        field(50014;"Unit Cost (Cargo) 2";Decimal)
        {
            Caption = 'Unit Cost (Cargo)';
            Editable = false;
        }
        field(50015;"Cost Amount (Cargo) 2";Decimal)
        {
            Caption = 'Cost Amount (Cargo)';
            Editable = false;
        }
        field(50016;"Quantity (Cargo)";Decimal)
        {
            Caption = 'Quantity (Cargo)';
        }
        field(50017;"Quantity (Cargo) 2";Decimal)
        {
            Caption = 'Quantity (Cargo) 2';
        }
    }
}

