table 50097 "Dispaching Incident Type"
{
    Caption = 'Motifs incident';

    fields
    {
        field(1;"Incident Type";Option)
        {
            Caption = 'Incident Type';
            OptionCaption = 'Camion,Chauffeur,Commande,Dispatcheur,Autres';
            OptionMembers = Camion,Chauffeur,Commande,Dispatcheur,Autres;
        }
        field(3;"Incident Code";Code[20])
        {
            Caption = 'Code';
        }
        field(4;Description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Incident Type","Incident Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;Field2,"Incident Code",Description)
        {
        }
    }
}

