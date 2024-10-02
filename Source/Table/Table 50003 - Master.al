table 50003 Master
{

    fields
    {
        field(1;Type;Option)
        {
            OptionCaption = 'Troncons,Avion,Imatriculation,Flight,CRCode,Nature de Prestation';
            OptionMembers = Troncons,Avion,Imatriculation,Flight,CRCode,"Nature Prestation";
        }
        field(2;"Code";Code[50])
        {
        }
        field(3;Description;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;Type,"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

