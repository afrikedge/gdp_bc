tableextension 70000017 tableextension70000017 extends "Purch. Inv. Header" 
{
    fields
    {
        field(50001;"Created By Doc No.";Code[20])
        {
            Caption = 'Created By Doc No.';
            Editable = false;
        }
        field(50002;"Created By Doc Type";Option)
        {
            Caption = 'Created By Doc Type';
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation,ProvisionsFA';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation,ProvisionsFA;
        }
        field(50010;DelaiDeLivraison;Text[50])
        {
            Caption = 'Delivery Terms';
        }
        field(50020;"Code Demande";Code[20])
        {
            Caption = 'Purchase Requiqition Code';
            Editable = false;
        }
        field(50021;"Code Budget";Code[10])
        {
            Editable = false;
            TableRelation = "G/L Budget Name";
        }
        field(50022;"Purchase Type";Option)
        {
            Caption = 'Purchase Type';
            ExtendedDatatype = Masked;
            OptionCaption = 'Purchase of goods,Others purchases,Purchase of FA';
            OptionMembers = AchatMarchandise,AchatAutre,AchatImmos;
        }
        field(50024;"PR Type";Option)
        {
            Caption = 'Purch Req Type';
            OptionCaption = ' ,DOP Travaux,DOP Maintenance,DOP Supply,DOP Logistique,HSE,DCM,IT,SGX,SGX Service,RH,DG';
            OptionMembers = " ","DOP Travaux","DOP Maintenance","DOP Supply","DOP Logistique",HSE,DCM,IT,SGX,"SGX Service",RH,DG;
        }
        field(50061;"Processing Status";Option)
        {
            Caption = 'Processing Status';
            OptionCaption = ' ,Soldee';
            OptionMembers = " ",Soldee;
        }
        field(50063;Observations;Text[150])
        {
            Caption = 'Description';
        }
        field(50064;ProvisionValideVarStock;Boolean)
        {
            Caption = 'Provision inventory generated';
            Editable = false;
        }
        field(50065;Anticipated;Boolean)
        {
            Caption = 'Anticipated';
        }
        field(50069;"Ref Dossier Cargo";Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
        field(50070;"MFiles Invoice";Boolean)
        {
        }
        field(50071;MFilesURL;Text[100])
        {
            Caption = 'URL Vendor Invoice';
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(50075;Derogation;Boolean)
        {
        }
    }

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    //Unsupported feature: Property Modification (Fields) on "Brick(FieldGroup 2)".

}

