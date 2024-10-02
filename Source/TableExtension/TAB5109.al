tableextension 70000141 tableextension70000141 extends "Purchase Header Archive" 
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
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation;
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
        field(50023;"Validity Offer";Text[30])
        {
            Caption = 'Validity of Offer';
        }
        field(50024;"PR Type";Option)
        {
            Caption = 'Purch Req Type';
            OptionCaption = ' ,DOP Travaux,DOP Maintenance,DOP Supply,DOP Logistique,HSE,DCM,IT,SGX,SGX Service,RH,DG';
            OptionMembers = " ","DOP Travaux","DOP Maintenance","DOP Supply","DOP Logistique",HSE,DCM,IT,SGX,"SGX Service",RH,DG;
        }
        field(50025;"PO Type";Option)
        {
            Caption = 'Purch Order Type';
            OptionCaption = ' ,Achats,SGX Services,RH,DG';
            OptionMembers = " ",Achats,"SGX Services",RH,DG;
        }
        field(50050;ProvisionValide;Boolean)
        {
            Caption = 'Provision charge item generated';
            Editable = false;
        }
        field(50055;"Ref Cargo";Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
        field(50056;"Vendor Retention Posting Group";Code[10])
        {
            Caption = 'Source retention Group';
            TableRelation = "Vendor Posting Group";

            trigger OnLookup()
            var
                VendPostingGroup: Record "93";
            begin
            end;
        }
        field(50060;"User ID";Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "418";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50061;"Processing Status";Option)
        {
            Caption = 'Processing Status';
            OptionCaption = ' ,Soldee';
            OptionMembers = " ",Soldee;
        }
        field(50062;"Offer Prepayment %";Decimal)
        {
            Caption = 'Offer Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
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
        field(50066;Printed;Boolean)
        {
            Caption = 'Printed';
            Editable = false;
        }
        field(50067;"Printed Date";Date)
        {
            Caption = 'Printed Date';
            Editable = false;
        }
        field(50068;"Printed By";Code[50])
        {
            Caption = 'Printed By';
            Editable = false;
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
            Caption = 'URL';
            ExtendedDatatype = URL;
        }
        field(50072;"Skip Invoice Control";Boolean)
        {
            Caption = 'No Invoice linked';
        }
        field(50073;"Invoice Doc Ref";Code[20])
        {
            Caption = 'Invoice document';
            TableRelation = "Vendor Invoice Doc"."Reference Number" WHERE (Vendor No=FIELD(Buy-from Vendor No.),
                                                                           Status=CONST(Receptionee));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                InvoiceDoc: Record "50094";
            begin
            end;
        }
        field(50074;"GDP Deletion";Boolean)
        {
        }
        field(50075;Derogation;Boolean)
        {
        }
    }
}

