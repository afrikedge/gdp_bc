tableextension 50021 "A02 User Setup" extends "User Setup"
{
    fields
    {

        //Unsupported feature: Code Modification on ""Allow Posting From"(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckAllowedPostingDates(0);
        GLSetup.CheckPostingRange("Allow Posting From",FIELDCAPTION("Allow Posting From"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //CheckAllowedPostingDates(0);****************************************************************
        //GLSetup.CheckPostingRange("Allow Posting From",FIELDCAPTION("Allow Posting From"));*********
        */
        //end;


        //Unsupported feature: Code Modification on ""Allow Posting To"(Field 3).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckAllowedPostingDates(0);
        GLSetup.CheckPostingRange("Allow Posting To",FIELDCAPTION("Allow Posting To"));
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //CheckAllowedPostingDates(0);****************************************************************
        //GLSetup.CheckPostingRange("Allow Posting To",FIELDCAPTION("Allow Posting To"));*************
        */
        //end;
        field(50000; "PR Validator"; Code[50])
        {
            Caption = 'Purch Req Validator';
            TableRelation = "User Setup"."User ID";
        }
        field(50001; "PR Interim Validator"; Code[50])
        {
            Caption = 'Purch Req Validator 2';
            TableRelation = "User Setup"."User ID";
        }
        field(50002; "PR Type"; Option)
        {
            Caption = 'Purch Req Type';
            OptionCaption = ' ,DOP Travaux,DOP Maintenance,DOP Supply,DOP Logistique,HSE,DCM,IT,SGX,SGX Service,RH,DG,Reseau,Energie,Travaux&Maintenance,Comptabilite,Agence,B2B,DSP,CAP,RSE';
            OptionMembers = " ","DOP Travaux","DOP Maintenance","DOP Supply","DOP Logistique",HSE,DCM,IT,SGX,"SGX Service",RH,DG,Reseau,Energie,"Travaux&Maintenance",Comptabilite,Agence,B2B,DSP,CAP,RSE;
        }
        field(50003; "Direction Code"; Code[10])
        {
            Caption = 'Direction Name';
            //TableRelation = "Org. Direction";
        }
        field(50004; "Service Code"; Code[10])
        {
            Caption = 'Service Name';
            //TableRelation = "Org. Service";
        }
        field(50005; "Department Code"; Code[10])
        {
            Caption = 'Department Name';
            //TableRelation = Subdirection;
        }
        field(50006; "CDG Validator"; Code[50])
        {
            Caption = 'CDG Validator';
            TableRelation = "User Setup"."User ID";
        }
        field(50007; "CDG Interim Validator"; Code[50])
        {
            Caption = 'CDG Interim Validator';
            TableRelation = "User Setup"."User ID";
        }
        field(50008; "PO Type"; Option)
        {
            Caption = 'Purch Order Type';
            OptionCaption = ' ,Achats,SGX Services,RH,DG';
            OptionMembers = " ",Achats,"SGX Services",RH,DG;
        }
        field(50009; "Enlever Filtre Commande Achat"; Boolean)
        {
            Caption = 'Remove Filter on purchase orders';
        }
        field(50010; "User Full Name"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("User ID")));
            Caption = 'User full Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Can Update Prices"; Boolean)
        {
            Caption = 'Can Update Prices';
        }
        field(50012; "Can Unlock Order"; Boolean)
        {
            Caption = 'Can Unlock Order';
        }
        field(50013; "Mail acheteur"; Text[80])
        {
            Caption = 'Mail Alerte Acheteurs';
        }
        field(50014; "Enlever Filtre Demande Achat"; Boolean)
        {
            Caption = 'Remove Filter on purchase requisition';
        }
        field(50015; "Sales Resp. Ctr. Filter2"; Code[10])
        {
            Caption = 'Sales Resp. Ctr. Filter 2';
            TableRelation = "Responsibility Center".Code;
        }
        field(50016; "Sales Resp. Ctr. Filter3"; Code[10])
        {
            Caption = 'Sales Resp. Ctr. Filter 3';
            TableRelation = "Responsibility Center".Code;
        }
        field(50017; "Sales Resp. Ctr. Filter4"; Code[10])
        {
            Caption = 'Sales Resp. Ctr. Filter 4';
            TableRelation = "Responsibility Center".Code;
        }
        field(50018; "Sales Resp. Ctr. Filter5"; Code[10])
        {
            Caption = 'Sales Resp. Ctr. Filter 5';
            TableRelation = "Responsibility Center".Code;
        }
        field(50019; CanUpdateOrderAfterValidation; Boolean)
        {
            Caption = 'Can update sales orders after validation';
        }
        field(50020; "Profile Mgt"; Boolean)
        {
            Editable = false;
        }
        field(50021; CanUpdateLubOrderAfterVal; Boolean)
        {
            Caption = 'Can update sales LUBS orders after validation';
        }
        field(50022; "Can Validate Item"; Boolean)
        {
            Caption = 'Can validate items';
        }
        field(50023; "Can delete blocked Orders"; Boolean)
        {
            Caption = 'Can delete blocked Orders';
        }
        field(50024; "Can Reverse Transaction"; Boolean)
        {
            Caption = 'Can Reverse Transaction';
        }
        field(50025; "Can Reverse Reconciliation"; Boolean)
        {
            Caption = 'Can Reverse Reconciliation';
        }
        field(50026; "Can Cancel SO"; Boolean)
        {
            Caption = 'Can cancel sales orders';
        }
        field(50027; "Can Validate Vendor"; Boolean)
        {
            Caption = 'Can validate vendors';
        }
        field(50028; "Can Update JIRAMA Qty"; Boolean)
        {
            Caption = 'Can update Qty on JIRAMA orders';
        }
        field(50029; "Can Reverse BE/BL"; Boolean)
        {
            Caption = 'Can Reverse BE/BL';
        }
        field(50030; "Can Apply GLEntries"; Boolean)
        {
            Caption = 'Can Reconciliate GL Entries';
        }
        field(50031; "Dispatching Manager Name"; Text[50])
        {
            Caption = 'Dispatching Manager Name';
        }
        field(50032; "Dispatching User Name"; Text[50])
        {
            Caption = 'Dispatching User Name';
        }
        field(50033; IsVendorAccountant; Boolean)
        {
            Caption = 'Comptable fournisseur';
        }
        field(50034; CanPostDirectPurchInvoice; Boolean)
        {
            Caption = 'Peut valider les factures sans doc facture FF';
        }
        field(50035; "Reverse Amount Limit"; Decimal)
        {
            Caption = 'Reverse Amount Limit';
        }
        field(50036; "Item on sales invoice"; Boolean)
        {
            Caption = 'Saisie article sur facture de vente';
        }
        field(50037; CanPostDirectPurchInvNoControl; Boolean)
        {
            Caption = 'Peut valider les factures sans contrôle de montant FF';
        }
        field(50038; "GLAccount on Purchase Order"; Boolean)
        {
            Caption = 'Saisie compte général sur commande';
        }
        field(50039; "Dispaching Windows User"; Code[50])
        {
            Caption = 'Code utilisateur windows (Dispaching)';
        }
        field(50040; "Old Nav User"; Code[50])
        {
            Caption = 'Ancien code utilisateur';
        }
        // field(50041; "Afk Manager Name"; Code[70])
        // {
        //     Caption = 'Nom responsable (Logistique)';
        // }
        field(50042; "Afk Signature"; BLOB)
        {
            Caption = 'Signature';
            SubType = Bitmap;
        }
        field(50043; "Afk Function Name on PO"; Code[70])
        {
            Caption = 'Titre sur le bon de commande';
        }
        field(50044; "Afk Commercial Manager"; Boolean)
        {
            Caption = 'Directeur commercial';
            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                if "Afk Commercial Manager" then begin
                    UserSetup.SetRange("Afk Commercial Manager", true);
                    if not UserSetup.IsEmpty() then
                        FieldError("Afk Commercial Manager");
                end;
            end;
        }
    }

    //Unsupported feature: Property Deletion (LookupPageID).

}

