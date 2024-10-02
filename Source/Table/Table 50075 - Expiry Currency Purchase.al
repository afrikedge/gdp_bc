table 50075 "Expiry Currency Purchase"
{
    Caption = 'Currency purchase for provisions';
    DrillDownPageID = "Currency Purchase provisions";
    LookupPageID = "Currency Purchase provisions";

    fields
    {
        field(1;"LC Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(2;"Expiry Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Purchase Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;"Purchase Amount";Decimal)
        {
            Caption = 'Purchased provisions';
        }
        field(6;"Currency Exchange";Decimal)
        {
            Caption = 'Currency Echange Rate';
        }
        field(7;"Purchase Amount (LCY)";Decimal)
        {
            Caption = 'Purchase Amount (LCY)';
        }
    }

    keys
    {
        key(Key1;"LC Document No.","Expiry Line No.","Purchase Line No.")
        {
            SumIndexFields = "Purchase Amount (LCY)";
        }
    }

    fieldgroups
    {
    }
}

