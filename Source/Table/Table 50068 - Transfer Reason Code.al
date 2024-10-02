table 50068 "Transfer Reason Code"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Transfer';
            OptionMembers = Transfer;
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Reason Code";Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";

            trigger OnValidate()
            begin
                if ReasonCode.Get("Reason Code") then
                  "Reason Description" := ReasonCode.Description;
            end;
        }
        field(5;Quantity;Decimal)
        {
            Caption = 'Quantity';
            MinValue = 0;

            trigger OnValidate()
            begin
                RefreshQty;
            end;
        }
        field(6;"Reason Description";Text[50])
        {
            Caption = 'Description';
        }
        field(7;"Adjustment Type";Option)
        {
            OptionCaption = 'Manquant,Surplus';
            OptionMembers = Perte,Gain;

            trigger OnValidate()
            begin
                RefreshQty;
            end;
        }
        field(8;"Adjust Qty";Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.","Reason Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //RefreshQty;
    end;

    var
        ReasonCode: Record "Reason Code";
        TransfertLine: Record "Transfer Line";

    local procedure RefreshQty()
    begin
        if "Adjustment Type"=Rec."Adjustment Type"::Gain then
          "Adjust Qty" := Quantity
        else
          "Adjust Qty" := -Quantity;

        //IF MODIFY THEN;
    end;
}

