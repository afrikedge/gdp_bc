table 50042 "LPSA Exchange Rate"
{
    Caption = 'LPSA Exchange Rate';
    DrillDownPageID = "LPSA Echange rates";
    LookupPageID = "LPSA Echange rates";

    fields
    {
        field(1;Date;Date)
        {
            Caption = 'Date';
        }
        field(2;"Exchange Rate";Decimal)
        {
            Caption = 'Excange Rate';
        }
        field(3;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1;"Currency Code",Date)
        {
        }
    }

    fieldgroups
    {
    }
}

