tableextension 50007 "A02 Vendor" extends Vendor
{
    fields
    {
        modify("Name 2")
        {
            Caption = 'Name 2';
        }
        modify("VAT Registration No.")
        {
            Caption = 'VAT Registration No.';
        }

        //Unsupported feature: Code Modification on ""No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." <> xRec."No." THEN BEGIN
          PurchSetup.GET;
          NoSeriesMgt.TestManual(PurchSetup."Vendor Nos.");
          "No. Series" := '';
        END;
        IF "Invoice Disc. Code" = '' THEN
          "Invoice Disc. Code" := "No.";
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Modification on "Name(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
          "Search Name" := Name;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
          "Search Name" := Name;

        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on ""Name 2"(Field 4)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on "Address(Field 5)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on ""Address 2"(Field 6)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on ""Vendor Posting Group"(Field 21)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Modification on ""Currency Code"(Field 22).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        UpdateCurrencyId;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //************************
        ResetValidation;
        //************************

        UpdateCurrencyId;
        */
        //end;


        //Unsupported feature: Code Modification on ""Payment Terms Code"(Field 27).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        UpdatePaymentTermsId;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //************************
        ResetValidation;
        //************************

        UpdatePaymentTermsId;
        */
        //end;


        //Unsupported feature: Code Modification on "Blocked(Field 39).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF (Blocked <> Blocked::All) AND "Privacy Blocked" THEN
          IF GUIALLOWED THEN
            IF CONFIRM(ConfirmBlockedPrivacyBlockedQst) THEN
              "Privacy Blocked" := FALSE
            ELSE
              ERROR('')
          ELSE
            ERROR(CanNotChangeBlockedDueToPrivacyBlockedErr);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //************************
        ResetValidation;
        //************************

        #1..8
        */
        //end;


        //Unsupported feature: Code Insertion on ""Pay-to Vendor No."(Field 45)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Modification on ""Payment Method Code"(Field 47).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        UpdatePaymentMethodId;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //************************
        ResetValidation;
        //************************

        UpdatePaymentMethodId;
        */
        //end;


        //Unsupported feature: Code Modification on ""Gen. Bus. Posting Group"(Field 88).OnValidate".

        //trigger  Bus()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
          IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
            VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        #1..3
        */
        //end;


        //Unsupported feature: Code Modification on ""E-Mail"(Field 102).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        MailManagement.ValidateEmailAddressField("E-Mail");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //************************
        ResetValidation;
        //************************

        MailManagement.ValidateEmailAddressField("E-Mail");
        */
        //end;


        //Unsupported feature: Code Insertion on ""VAT Bus. Posting Group"(Field 110)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on ""Block Payment Tolerance"(Field 116)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on ""Prepayment %"(Field 124)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;


        //Unsupported feature: Code Insertion on ""Preferred Bank Account Code"(Field 288)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //************************
        ResetValidation;
        //************************
        */
        //end;
        field(50000; Transporter; Boolean)
        {
            Caption = 'Carrier';

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50001; "Related Customer"; Code[20])
        {
            Caption = 'Related Customer';
            Editable = true;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50002; "Vendor Retention Posting Group"; Code[10])
        {
            Caption = 'Source retention Group';
            TableRelation = "Vendor Posting Group";

            trigger OnLookup()
            var
                VendPostingGroup: Record "93";
            begin
                IF PAGE.RUNMODAL(50139, VendPostingGroup) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("Vendor Retention Posting Group", VendPostingGroup.Code);
                END;
            end;

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50003; Statut; Option)
        {
            OptionCaption = ' ,BlackListe,RemisQuestion,Special,Agree,Inactif,Divers';
            OptionMembers = " ",BlackListe,RemisQuestion,Special,Agree,Inactif,Divers;
        }
        field(50005; "Validation Status"; Option)
        {
            Caption = 'Validation status';
            Editable = false;
            OptionCaption = 'Created,In Workflow,Validated';
            OptionMembers = Created,InWorkflow,Validated;
        }
        field(50012; "STAT Code"; Code[50])
        {
            Caption = 'STAT';

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50013; "CIF/CIS"; Code[50])
        {

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50014; "Trade Number"; Code[50])
        {
            Caption = 'Trade Number';

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50015; "Created By UserID"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(50016; "Created By Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(50017; "Validated By UserID"; Code[50])
        {
            Caption = 'Validated By';
            Editable = false;
        }
        field(50018; "Validated By Date"; Date)
        {
            Caption = 'Validation Date';
            Editable = false;
        }
        field(50025; "GDP Partner"; Boolean)
        {
            Caption = 'GDP Partner';

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(50026; "Activity Area"; Text[60])
        {
            Caption = 'Secteur d''activité';

            trigger OnValidate()
            begin
                //************************
                ResetValidation;
                //************************
            end;
        }
        field(60000; "Traite Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Line".Amount WHERE("Account Type" = CONST(Vendor),
                                                           "Account No." = FIELD("No."),
                                                           "Payment Class" = CONST('TRTFRS'),
                                                           "Status No." = FILTER(<> 10000)));
            Caption = 'Traites non honorées';
            Editable = false;

        }
    }


    //Unsupported feature: Code Modification on "CheckBlockedVendOnDocs(PROCEDURE 4)".

    //procedure CheckBlockedVendOnDocs();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Vend2."Privacy Blocked" THEN
      VendPrivacyBlockedErrorMessage(Vend2,Transaction);

    IF Vend2.Blocked = Vend2.Blocked::All THEN
      VendBlockedErrorMessage(Vend2,Transaction);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

    //************************************************************************
    Vend2.TESTFIELD("Validation Status",Vend2."Validation Status"::Validated);
    //************************************************************************
    */
    //end;


    //Unsupported feature: Code Modification on "CheckBlockedVendOnJnls(PROCEDURE 5)".

    //procedure CheckBlockedVendOnJnls();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH Vend2 DO BEGIN
      IF "Privacy Blocked" THEN
        VendPrivacyBlockedErrorMessage(Vend2,Transaction);

      IF (Blocked = Blocked::All) OR
         (Blocked = Blocked::Payment) AND (DocType = DocType::Payment)
      THEN
        VendBlockedErrorMessage(Vend2,Transaction);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8

      //************************************************************************
      Vend2.TESTFIELD("Validation Status",Vend2."Validation Status"::Validated);
      //************************************************************************
    END;
    */
    //end;

    local procedure ResetValidation()
    begin
        IF "Validation Status" <> Rec."Validation Status"::Created THEN
            IF NOT CONFIRM(ErrAfk001) THEN ERROR('');
        "Validation Status" := Rec."Validation Status"::Created;
    end;

    var
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';
}

