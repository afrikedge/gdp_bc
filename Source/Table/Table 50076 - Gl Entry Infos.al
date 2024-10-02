table 50076 "G/l Entry Infos"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;"Item No.";Code[20])
        {
        }
        field(3;"Vendor Code";Code[20])
        {
        }
        field(4;TypeProvision;Option)
        {
            OptionCaption = ' ,FraisAnn,Order,Transport,Passage,Transfer,VarStock,TransportVente';
            OptionMembers = " ",FraisAnn,"Order",Transport,Passage,Transfer,VarStock,TransportVente;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

