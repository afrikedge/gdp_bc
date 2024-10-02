table 50046 "Cargo Allocation Config"
{
    Caption = 'Cargo allocation Setup';

    fields
    {
        field(1;"Operation Type";Option)
        {
            Caption = 'Operation Type';
            OptionCaption = 'Sale,Positive Adjmt.,Negative Adjmt.';
            OptionMembers = Sale,"Positive Adjmt.","Negative Adjmt.";
        }
        field(2;"Sales Channel Code";Code[10])
        {
            Caption = 'Sales Channel Code';
            TableRelation = "Sales Channel";
        }
        field(3;"Item Code";Code[20])
        {
            Caption = 'Item Code';
            TableRelation = Item;
        }
        field(4;"First Priority";Option)
        {
            Caption = '1st Priority';
            OptionCaption = 'M,M-1,M-2,M-3,None,FIFO';
            OptionMembers = M,"M-1","M-2","M-3","None",FIFO;
        }
        field(5;"Second Priority";Option)
        {
            Caption = '2nd priority';
            OptionCaption = 'M,M-1,M-2,M-3,None,FIFO';
            OptionMembers = M,"M-1","M-2","M-3","None",FIFO;
        }
        field(6;"Third Priority";Option)
        {
            Caption = '3rd priority';
            OptionCaption = 'M,M-1,M-2,M-3,None,FIFO';
            OptionMembers = M,"M-1","M-2","M-3","None",FIFO;
        }
        field(7;"Item Name";Text[50])
        {
            CalcFormula = Min(Item.Description WHERE ("No."=FIELD("Item Code")));
            Caption = 'Item Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Channel Name";Text[50])
        {
            CalcFormula = Min("Sales Channel".Description WHERE (Code=FIELD("Sales Channel Code")));
            Caption = 'Sales Channel';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Operation Type","Sales Channel Code","Item Code")
        {
        }
    }

    fieldgroups
    {
    }
}

