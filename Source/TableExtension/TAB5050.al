tableextension 50055 "A02 Contact" extends Contact
{
    fields
    {
        field(50000; Signataire; Boolean)
        {
            //TODO Harmoniser avec le champ 50000 de la table Customer
            Caption = 'Signataire';
        }


        field(50001; "Disable Shipment Autorisation"; Boolean)
        {
            Caption = 'Disable Shipment Validation';
        }
        field(50034; "Appliquer Ecart pompe JIR"; Boolean)
        {
            Caption = 'Appliquer écart pompe Jirama';
        }


        field(50005; "Afk Risk Level"; Code[10])
        {
            Caption = 'Risk level';
            TableRelation = "Risk Level";
        }
        field(50006; "Afk Legal Status"; Code[10])
        {
            Caption = 'Legal status';
            TableRelation = "Legal Status";
        }
        field(50007; "Afk Industry Group"; Code[10])
        {
            Caption = 'Industry Group Code';
            TableRelation = "Industry Group";
        }
        field(50008; "Afk Related Vendor"; Code[20])
        {
            Caption = 'Related Supplier';
            FieldClass = Normal;
            TableRelation = Vendor;
        }
        field(50009; "Afk Sales Category Code"; Code[10])
        {
            Caption = 'Sales Category';
            TableRelation = "Sales Category";
        }
        field(50010; "Afk Sales Channel Code"; Code[10])
        {
            Caption = 'Sales Channel Code';
            TableRelation = "Sales Channel";
        }
        field(50015; "Afk Cash payment"; Boolean)
        {
            Caption = 'Cash payment';
        }
        field(50016; "Afk Check Set"; Boolean)
        {
            Caption = 'Check Set';
        }
        field(50017; "Afk Bank Transfer Bank Stamp"; Boolean)
        {
            Caption = 'Bank Transfer Bank Stamp';
        }
        field(50018; "Afk Traite"; Boolean)
        {
            Caption = 'Traite';
        }
        field(50019; "Afk Received Check"; Boolean)
        {
            Caption = 'Received Check';
        }
        field(50020; "Afk Credit Note"; Boolean)
        {
            Caption = 'Credit Note';
        }
        field(50025; "Afk GDP Partner"; Boolean)
        {
            Caption = 'GDP Partner';
        }
        field(50030; "Afk Automatic Debit"; Boolean)
        {
            Caption = 'Automatic Debit';
        }
        field(50033; "Afk Mobile Banking"; Boolean)
        {
            Caption = 'Mobile Banking';
        }
        field(50035; "Afk Category 1"; Option)
        {
            OptionCaption = ' ,B2B,CARTES,COMPTE INTERNE,CONTENTIEUX,GALLOIS,JIRAMA,NAPHTA,RESEAU,SOUTE,STATION GD,TRESOR,PRÉ-CONTENTIEUX';
            OptionMembers = " ",B2B,CARTES,"COMPTE INTERNE",CONTENTIEUX,GALLOIS,JIRAMA,NAPHTA,RESEAU,SOUTE,"STATION GD",TRESOR,"PRE-CONTENTIEUX";
        }
        field(50036; "Afk Category 2"; Option)
        {
            OptionCaption = ' ,Ancienne SS,Clients sains réseau,Clients sains B2B,ETS Gallois,Trésor,Naphta,Royalties,GD non bouclés,Contentieux,Précontentieux,Compte interne,Jirama,Gallois,Station en GD';
            OptionMembers = " ","Ancienne SS","Clients sains réseau","Clients sains B2B","ETS Gallois","Trésor",Naphta,Royalties,"GD non bouclés",Contentieux,"Précontentieux","Compte interne;Jirama",Gallois,"Station en GD";
        }
        field(50037; "Afk Other Legal Status"; Text[100])
        {
            Caption = 'Other Legal Status';
        }


        field(50038; "Afk Main Industry"; code[20])
        {
            Caption = 'Main Industry';
            TableRelation = "Afk Reference".Code where(TableType = const("Main Industry"));
        }
        field(50039; "Afk Parent Account No."; code[20])
        {
            Caption = 'Parent Account No.';
            //TableRelation = Customer;
        }
        field(50040; "Afk Customer Profile"; Enum "Afk Customer Profile")
        {
            Caption = 'Customer Profile';
        }
        field(50041; "Afk PNS ND"; Boolean)
        {
            Caption = 'PNS ND';
        }
        field(50042; "Afk PNS Orange Money"; Boolean)
        {
            Caption = 'PNS Orange Money';
        }
        field(50043; "Afk PNS SPE"; Boolean)
        {
            Caption = 'PNS SPE';
        }
        field(50044; "Afk PNS Airtel Money"; Boolean)
        {
            Caption = 'PNS Airtel Money';
        }
        field(50045; "Afk PNS MVOLA"; Boolean)
        {
            Caption = 'PNS MVOLA';
        }
        field(50046; "Afk PNS GPL"; Boolean)
        {
            Caption = 'PNS GPL';
        }
        field(50047; "Afk PNS Lubrifiants"; Boolean)
        {
            Caption = 'PNS Lubrifiants';
        }
        field(50048; "Afk PNS Carte"; Boolean)
        {
            Caption = 'PNS Carte';
        }
        field(50049; "Afk PNS Bornage"; Boolean)
        {
            Caption = 'PNS Bornage';
        }
        field(50050; "Afk PNS Soutes"; Boolean)
        {
            Caption = 'PNS Soutes';
        }
        field(50051; "Afk PNS PBL Terre"; Boolean)
        {
            Caption = 'PNS PBL Terre';
        }
        field(50052; "Afk Description"; Text[300])
        {
            Caption = 'Description';
        }
        field(50053; "Afk Warranty Status"; enum "Afk Warranty Status")
        {
            Caption = 'Warranty Status';
        }
        field(50054; "Afk Warranty Due Date"; Date)
        {
            Caption = 'Warranty Due Date';
        }
        field(50055; "Afk Warranty Pledge"; Boolean)
        {
            Caption = 'Warranty Pledge';
        }
        field(50056; "Afk Warranty Collateral"; Boolean)
        {
            Caption = 'Warranty Collateral';
        }
        field(50057; "Afk Warranty Mortgage"; Boolean)
        {
            Caption = 'Warranty Mortgage';
        }
        field(50058; "Afk Warranty Caution"; Boolean)
        {
            Caption = 'Warranty Caution';
        }
        field(50059; "Afk Warranty Object"; Text[150])
        {
            Caption = 'Warranty Object';
        }
        field(50060; "Afk Warranty Value"; Decimal)
        {
            Caption = 'Warranty Value';
        }
        field(50061; "Afk Warranty Validity"; Date)
        {
            Caption = 'Warranty Validity';
        }

        field(50062; "Afk Modified By"; Code[50])
        {
            Caption = 'Modified By';
            TableRelation = "Afk FrontDesk User";
        }
        field(50063; "Afk Approval Status"; enum "Afk CRM Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(50064; "Afk Disable Blocking"; Boolean)
        {
            Caption = 'Disable sales order blocking';
        }
        field(50065; "Afk Customer Level"; enum "Afk Customer Level")
        {
            Caption = 'Customer Level';
        }
        field(50066; "Remove JIR Ref on BE"; Boolean)
        {
            Caption = 'Remove JIR Ref on BE';
        }
        //**fin champs identiques avec client








        //**debut champs spécifiques contact
        field(61000; "Afk Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }




        // field(61004; "Afk Currency Code"; Code[20])
        // {
        //     Caption = 'Currency Code';
        //     TableRelation = Currency;
        // }
        // field(61005; "Afk Language Code"; Code[20])
        // {
        //     Caption = 'Language Code';
        //     TableRelation = Language;
        // }
        field(61006; "Afk Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(61007; "Afk Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(61008; "Afk Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Business Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(61009; "Afk VAT Bus_ Posting Group"; Code[20])
        {
            Caption = 'VAT Business Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(61010; "Afk Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = "Location";
        }
        field(61011; "Afk Ship-to Code"; Code[10])
        {
            //TODO lier au contact ?
            Caption = 'Ship-to Code';
            //TableRelation = "Ship-to Address";
        }
        field(61012; "Afk Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No';
            TableRelation = "Customer";
        }
        field(61013; "Afk Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = "Contact";
        }
        field(61014; "Afk Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(61015; "Afk Credit Limit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Credit Limit (LCY)';
        }
        field(61016; "Afk Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        // field(61017; "Afk Balance Amount"; Decimal)
        // {
        //     Caption = 'Balance Amount';
        // }
        // field(61018; "Afk Amount Due"; Decimal)
        // {
        //     Caption = 'Amount Due';
        // }
        field(61019; "Afk Reminder Terms Code"; Code[10])
        {
            Caption = 'Reminder Terms Code';
            TableRelation = "Reminder Terms";
        }
        field(61020; "Afk Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
        field(61021; "Afk Application Method"; Enum "Application Method")
        {
            Caption = 'Application Method';
        }

        field(61023; "Afk Contact Type"; Enum "Afk Contact Type")
        {
            Caption = 'Contact Type';
        }
        field(61024; "Afk Parent Account Type"; enum "Afk CRM Account Type")
        {
            Caption = 'Parent Account Type';
        }
        field(61025; "Afk Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(61026; "Afk Blocked"; Enum "Customer Blocked")
        {
            Caption = 'Blocked';
        }


    }
}

