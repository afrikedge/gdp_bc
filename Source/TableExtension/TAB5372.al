table 5372 "Service Connection Status"
{
    Caption = 'Service Connection Status';

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
        }
        field(2;"Server Address";Text[250])
        {
            Caption = 'Dynamics CRM URL';
            TableRelation = "CRM Connection Setup"."Server Address";
        }
        field(3;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Connected,Disabled,Error';
            OptionMembers = Connected,Disabled,Error;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

