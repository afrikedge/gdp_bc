tableextension 50066 "A02 Transfer Line" extends "Transfer Line"
{
    fields
    {
        modify("Quantity Shipped")
        {
            Caption = 'Quantity Shipped';
        }
        modify("Quantity Received")
        {
            Caption = 'Quantity Received';
        }

        //Unsupported feature: Code Modification on ""Qty. to Receive"(Field 7).OnValidate".

        //trigger  to Receive"(Field 7)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetLocation("Transfer-to Code");
        IF CurrFieldNo <> 0 THEN BEGIN
          IF Location."Require Receive" AND
        #4..17
            ELSE
              ERROR(Text009);
        "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..20

        //"Qty to receive Adj" := "Qty. to Receive";//*******************************************
        AFK_RefreshAdjustQty;//*******************************************
        */
        //end;
        field(50000; "Qty to receive Hypo"; Decimal)
        {
            Caption = 'Quantity to receive';

            trigger OnValidate()
            begin
                //****************************
                "Qty to receive Hypo Adj" := "Qty to receive Hypo";
            end;
        }
        field(50001; "Qty to receive Hypo Adj"; Decimal)
        {
            Caption = 'Quantity to received Adjusted';
        }
        field(50002; "Qty to receive Adj"; Decimal)
        {
            Caption = 'Qty to receive Adjusted';
            Editable = false;
        }
        field(50003; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(50004; "Qty received Hypo"; Decimal)
        {
            Caption = 'Quantity Received';
            Editable = false;
        }
        field(50050; "Qty Ambient Volume"; Decimal)
        {
            Caption = 'Qty Ambient Volume';
        }
    }

    procedure AFK_RefreshAdjustQty()
    var
        AdjReason: Record "50068";
        TotalAdjustQty: Decimal;
    begin
        AdjReason.RESET;
        AdjReason.SETRANGE(AdjReason."Document Type", AdjReason."Document Type"::Transfer);
        AdjReason.SETRANGE(AdjReason."Document No.", Rec."Document No.");
        AdjReason.SETRANGE(AdjReason."Line No.", Rec."Line No.");
        IF AdjReason.FINDSET THEN
            REPEAT
                TotalAdjustQty := TotalAdjustQty + AdjReason."Adjust Qty";
            UNTIL AdjReason.NEXT = 0;

        Rec."Qty to receive Adj" := Rec."Qty. to Receive" + TotalAdjustQty;
    end;
}

