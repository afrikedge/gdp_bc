tableextension 50005 "A02 Customer" extends Customer
{
    fields
    {
        modify("VAT Registration No.")
        {
            Caption = 'VAT Registration No.';
        }
        modify("Responsibility Center")
        {
            Caption = 'Responsibility Center';
        }
        field(50000; "Disable Blocking"; Boolean)
        {
            Caption = 'Disable sales order blocking';
        }
        field(50001; "Disable Shipment Autorisation"; Boolean)
        {
            Caption = 'Disable Shipment Validation';
        }
        field(50002; "Holding Code"; Code[20])
        {
            Caption = 'Holding Code';
        }
        field(50003; "Company Code"; Code[20])
        {
            Caption = 'Company Code';
        }
        field(50004; "Town Code"; Code[10])
        {
            Caption = 'Town';
            TableRelation = Town.Code;
        }
        field(50005; "Risk Level"; Code[10])
        {
            Caption = 'Risk level';
            TableRelation = "Risk Level";
        }
        field(50006; "Legal Status Code"; Code[10])
        {
            Caption = 'Legal status';
            TableRelation = "Legal Status";
        }
        field(50007; "Industry Group"; Code[10])
        {
            Caption = 'Industry Group Code';
            TableRelation = "Industry Group";
        }
        field(50008; "Related Vendor"; Code[20])
        {
            Caption = 'Related Supplier';
            FieldClass = Normal;
            TableRelation = Vendor;
        }
        field(50009; "Sales Category Code"; Code[10])
        {
            Caption = 'Sales Category';
            TableRelation = "Sales Category";
        }
        field(50010; "Sales Channel Code"; Code[10])
        {
            Caption = 'Sales Channel Code';
            TableRelation = "Sales Channel";
        }
        field(50011; "Profit Center"; Code[10])
        {
            Caption = 'Profit Center';
            TableRelation = "Profit Center";
        }
        field(50012; "STAT Code"; Code[50])
        {
            Caption = 'STAT';
        }
        field(50013; "CIF/CIS"; Code[50])
        {
        }
        field(50014; "Trade Number"; Code[50])
        {
            Caption = 'Trade Number';
        }
        field(50015; "Cash payment"; Boolean)
        {
            Caption = 'Cash payment';
        }
        field(50016; "Check Set"; Boolean)
        {
            Caption = 'Check Set';
        }
        field(50017; "Bank Transfer Bank Stamp"; Boolean)
        {
            Caption = 'Bank Transfer Bank Stamp';
        }
        field(50018; Traite; Boolean)
        {
            Caption = 'Traite';
        }
        field(50019; "Received Check"; Boolean)
        {
            Caption = 'Received Check';
        }
        field(50020; "Credit Note"; Boolean)
        {
            Caption = 'Credit Note';
        }
        field(50021; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
        }
        field(50022; "Bank Account"; Text[50])
        {
            Caption = 'Bank Account';
        }
        field(50023; "Bank Agency"; Text[50])
        {
            Caption = 'Bank Agency';
        }
        field(50024; "Ship-to Code2"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("No."));
        }
        field(50025; "GDP Partner"; Boolean)
        {
            Caption = 'GDP Partner';
        }
        field(50026; "AMSA Invoice Type"; Option)
        {
            Caption = 'AMSA Invoicing Type';
            OptionCaption = ' ,Fuel Statement,Group Invoices';
            OptionMembers = " ",FS,Group;
        }
        field(50027; "Customer Status"; Option)
        {
            Caption = 'Customer Status';
            Editable = false;
            OptionCaption = 'Actif,Inactif,Pré-contentieux,Contentieux';
            OptionMembers = Actif,Inactif,Precontentieux,Contentieux;
        }
        field(50028; "Holding Name"; Text[50])
        {
            Caption = 'Holding Name';
        }
        field(50029; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
        }
        field(50030; "Automatic Debit"; Boolean)
        {
            Caption = 'Automatic Debit';
        }
        field(50033; "Mobile Banking"; Boolean)
        {
            Caption = 'Mobile Banking';
        }
        field(50034; "Appliquer Ecart pompe JIR"; Boolean)
        {
            Caption = 'Appliquer écart pompe Jirama';
        }
        field(50035; "Category 1"; Option)
        {
            OptionCaption = ' ,B2B,CARTES,COMPTE INTERNE,CONTENTIEUX,GALLOIS,JIRAMA,NAPHTA,RESEAU,SOUTE,STATION GD,TRESOR,PRÉ-CONTENTIEUX';
            OptionMembers = " ",B2B,CARTES,"COMPTE INTERNE",CONTENTIEUX,GALLOIS,JIRAMA,NAPHTA,RESEAU,SOUTE,"STATION GD",TRESOR,"PRE-CONTENTIEUX";
        }
        field(50036; "Category 2"; Option)
        {
            OptionCaption = ' ,Ancienne SS,Clients sains réseau,Clients sains B2B,ETS Gallois,Trésor,Naphta,Royalties,GD non bouclés,Contentieux,Précontentieux,Compte interne,Jirama,Gallois,Station en GD';
            OptionMembers = " ","Ancienne SS","Clients sains réseau","Clients sains B2B","ETS Gallois","Trésor",Naphta,Royalties,"GD non bouclés",Contentieux,"Précontentieux","Compte interne;Jirama",Gallois,"Station en GD";
        }
        field(60000; "Traite Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Line".Amount WHERE("Account Type" = CONST(Customer),
                                                           "Account No." = FIELD("No."),
                                                           "Payment Class" = CONST('TRTGDP'),
                                                           "Status No." = FILTER(<> 27500 & <> 28750 & <> 40000)));
            Caption = 'Traites non honorées';
            Editable = false;

        }
        field(60001; "AMSA Invoice Model"; Option)
        {
            Caption = 'Modèle impression AMSA';
            OptionCaption = 'Fixe,Mobile';
            OptionMembers = Fixe,Mobile;
        }
        field(60002; "Remove JIR Ref on BE"; Boolean)
        {
            Caption = 'Remove JIR Ref on BE';
        }
    }
    keys
    {
        key(Key1; "Sales Channel Code")
        {
        }
    }


    //Unsupported feature: Code Modification on "ShowContact(PROCEDURE 1)".

    //procedure ShowContact();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF OfficeMgt.GetContact(OfficeContact,"No.") AND (OfficeContact.COUNT = 1) THEN
      PAGE.RUN(PAGE::"Contact Card",OfficeContact)
    ELSE BEGIN
    #4..16

      Cont.FILTERGROUP(2);
      Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
      IF Cont.ISEMPTY THEN BEGIN
        Cont.SETRANGE("Company No.");
        Cont.SETRANGE("No.",ContBusRel."Contact No.");
      END;
      PAGE.RUN(PAGE::"Contact List",Cont);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..19
      //*********************
      Cont.SETRANGE(Cont.Signataire,TRUE);
      //*********************
    #20..25
    */
    //end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".

}

