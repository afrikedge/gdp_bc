table 50354 "Ledger Entry Dim All Combined"
{

    fields
    {
        field(1;"Table ID";Integer)
        {
        }
        field(2;"Entry No.";Integer)
        {
        }
        field(3;"CDC Code";Code[20])
        {
        }
        field(4;"Troncon Code";Code[20])
        {
        }
        field(5;"Immat code";Code[20])
        {
        }
        field(6;"Reseaux Code";Code[20])
        {
        }
        field(7;"Anal Flux Code";Code[20])
        {
        }
        field(8;Done;Boolean)
        {
        }
        field(9;Dated;Boolean)
        {
        }
        field(100;"Posting Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Table ID","Entry No.")
        {
        }
        key(Key2;"Posting Date",Done)
        {
            SQLIndex = "Posting Date",Done;
        }
    }

    fieldgroups
    {
    }
}

