table 50095 "Custom Workflow Config"
{

    fields
    {
        field(1;"Workflow Type";Option)
        {
            Caption = 'Type workflow';
            OptionCaption = 'Vendor invoice';
            OptionMembers = VendorInvoice;
        }
        field(2;"Workflow Code";Code[20])
        {
            Caption = 'Code';
        }
        field(3;"User 1";Code[50])
        {
            Caption = 'Vérificateur';
            TableRelation = "User Setup"."User ID";
        }
        field(4;"Interim User 1";Code[50])
        {
            Caption = 'Intérim Vérificateur';
            TableRelation = "User Setup"."User ID";
        }
        field(5;"Activate Interim 1";Boolean)
        {
            Caption = 'Intérim Vérificateur activé';
        }
        field(6;"User 2";Code[50])
        {
            Caption = 'Pré-validateur';
            TableRelation = "User Setup"."User ID";
        }
        field(7;"Interim User 2";Code[50])
        {
            Caption = 'Intérim Pré-validateur';
            TableRelation = "User Setup"."User ID";
        }
        field(8;"Activate Interim 2";Boolean)
        {
            Caption = 'Intérim Pré-validateur activé';
        }
        field(9;"User 3";Code[50])
        {
            Caption = 'Validateur final';
            TableRelation = "User Setup"."User ID";
        }
        field(10;"Interim User 3";Code[50])
        {
            Caption = 'Intérim validateur final';
            TableRelation = "User Setup"."User ID";
        }
        field(11;"Activate Interim 3";Boolean)
        {
            Caption = 'Intérim validateur final activé';
        }
        field(12;Description;Text[80])
        {
            Caption = 'Description';
        }
        field(13;"Invoice Type";Option)
        {
            OptionCaption = ' ,FF,OM';
            OptionMembers = " ",FF,OM;
        }
        field(14;"Department Code";Code[10])
        {
            Caption = 'Département/Direction';
            TableRelation = "Purchase Dept Workflow Code".Code;
        }
        field(15;Regularisation;Boolean)
        {
            Caption = 'Circuit hors paiement';
        }
    }

    keys
    {
        key(Key1;"Workflow Type","Workflow Code")
        {
        }
    }

    fieldgroups
    {
    }
}

