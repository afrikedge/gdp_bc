table 50088 "Dispaching Event Type"
{
    Caption = 'Type évènement Dispaching';

    fields
    {
        field(1;"Event Group";Option)
        {
            Caption = 'Group';
            OptionCaption = 'Matériel roulant,Préposé';
            OptionMembers = Camion,Prepose;
        }
        field(2;"Event Type";Option)
        {
            Caption = 'Type';
            OptionCaption = 'Problème CC,Absence,Infraction,Incident/Accident,Note,Contrôle';
            OptionMembers = ProblemeCC,Absence,Infraction,Accident,Note,Controle;
        }
        field(3;"Event Code";Code[10])
        {
            Caption = 'Code';
        }
        field(4;Description;Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Event Code")
        {
        }
        key(Key2;"Event Group","Event Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Event Type","Event Code",Description)
        {
        }
    }
}

