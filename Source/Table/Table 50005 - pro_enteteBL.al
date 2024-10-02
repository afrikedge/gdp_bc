table 50005 pro_enteteBL
{
    Caption = 'Delivery Order';

    fields
    {
        field(1; numBL; Integer)
        {
            AutoIncrement = true;
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                /*
                IF "No." <> xRec."No." THEN BEGIN
                  SalesSetup.GET;
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(3; depot; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Depot = CONST(true));

            trigger OnValidate()
            begin

                AFK_SecMgt.CheckWarehouseUser(depot);
                /*
                TESTFIELD(Status,Status::Open);
                IF ("Location Code" <> xRec."Location Code") AND
                   (xRec."Sell-to Customer No." = "Sell-to Customer No.")
                THEN
                  MessageIfSalesLinesExist(FIELDCAPTION("Location Code"));
                
                UpdateShipToAddress;
                
                IF "Location Code" <> '' THEN BEGIN
                  IF Location.GET("Location Code") THEN
                    "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                END ELSE BEGIN
                  IF InvtSetup.GET THEN
                    "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                END;
                */

            end;
        }
        field(8; datelivraison; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                /*
                IF xRec."Document Date" <> "Document Date" THEN
                  UpdateDocumentDate := TRUE;
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
                */

            end;
        }
        field(12; idtournee; Integer)
        {
            Caption = 'Trip No';
            Editable = false;

            trigger OnValidate()
            begin
                if Source = Rec.Source::Dispaching then Error(Text001);
            end;
        }
        field(13; codemoyentransport; Code[30])
        {
            Caption = 'Truck N°';
            TableRelation = pro_moyentransport.immatriculation;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if camion.Get(codemoyentransport) then begin
                    nomchauffeur := camion.nomchauffeur;
                    //prenomchauffeur := camion.prenomchauffeur;
                    permis := camion.permis;
                    if Vend.Get(camion.codetransporteur) then
                        nomTransporteur := Vend."Name 2";
                end;
            end;
        }
        field(16; observationBL; Text[250])
        {
            Caption = 'Notes';
        }
        field(17; isconfirme; Boolean)
        {
            Caption = 'Confirmed';
            Editable = false;
        }
        field(18; datevalidite; Date)
        {
            Caption = 'Validity Date';
        }
        field(19; nom; Text[100])
        {
            Caption = 'Prepared by';
        }
        field(20; nomresponsable; Text[100])
        {
            Caption = 'Validated by';
        }
        field(21; datecreation; DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(22; NumAfficheBL; Code[20])
        {
            Caption = 'BE Number';
        }
        field(23; RegimeDouanier; Code[20])
        {
            Caption = 'Customs Regime';

            trigger OnValidate()
            begin
                RelatedBE.Get(numBE);
                RelatedBE.Validate(RegimeDouanier, RegimeDouanier);
            end;
        }
        field(25; NavOrderNo; Code[20])
        {
            Caption = 'Order N°';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                if Source = Rec.Source::Dispaching then Error(Text001);
            end;
        }
        field(26; region; Code[10])
        {
            Caption = 'Region Code';
            TableRelation = "Responsibility Center";
        }
        field(27; tarifville; Boolean)
        {
            Caption = 'Town price';
        }
        field(28; ville; Code[20])
        {
            Caption = 'Town';
        }
        field(29; prix_unitaire; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(30; numBE; Integer)
        {
            Caption = 'BE Number';
            Editable = false;
        }
        field(31; AdrLivraisonBL; Code[20])
        {
            Caption = 'Delivery Adress';
        }
        field(50; CreatedFromDocNo; Code[20])
        {
            Caption = 'Original Document';
        }
        field(100; IsBon; Boolean)
        {
            Editable = false;
        }
        field(101; "Posted Invoice No"; Code[20])
        {
            Caption = 'Posted Invoice No';
            Editable = false;
        }
        field(117; NumBU; Code[20])
        {
            Caption = 'Bon Number';
            Editable = false;
        }
        field(50000; "Posted Shipment No"; Code[20])
        {
            Caption = 'Shipment No';
            Editable = false;
        }
        field(50001; Source; Option)
        {
            OptionCaption = ' ,Dispaching';
            OptionMembers = " ",Dispaching;
        }
        field(50002; Imprime; Boolean)
        {
            Caption = 'Imprimé';
        }
        field(50003; isAnnule; Boolean)
        {
            Caption = 'Annulé';
        }
        field(50004; numcommande; Code[20])
        {

            trigger OnValidate()
            begin
                if Source = Rec.Source::Dispaching then Error(Text001);
            end;
        }
        field(50008; nomchauffeur; Text[50])
        {
            Caption = 'Driver Name';
        }
        field(50010; Provisioned; Boolean)
        {
            Caption = 'provisioned';
            Editable = false;
        }
        field(50011; permis; Text[50])
        {
            Caption = 'Driver licence';
        }
        field(50050; "Transport invoiced"; Boolean)
        {
            Caption = 'Invoice received';
        }
        field(50051; "Invoice Number"; Code[20])
        {
            Caption = 'Invoice N°';
        }
        field(50052; "Code Transporter"; Code[20])
        {
            CalcFormula = Lookup(pro_moyentransport.codetransporteur WHERE(immatriculation = FIELD(codemoyentransport)));
            Caption = 'Transporter Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50053; "Transporter Name"; Text[50])
        {
            CalcFormula = Min(Vendor.Name WHERE("No." = FIELD("Code Transporter")));
            Caption = 'Transporter name';
            FieldClass = FlowField;
        }
        field(50054; nomTransporteur; Text[50])
        {
        }
        field(50055; codemoyentransport2; Code[30])
        {
            Caption = 'Transportation Code';
            TableRelation = pro_moyentransport.immatriculation;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(50056; "Delivery Site"; Code[30])
        {
            Caption = 'Delivery Site';
            TableRelation = "Delivery Site".Site WHERE("Location Code" = FIELD(depot));
        }
        field(50057; "Last Printed Date"; DateTime)
        {
            Caption = 'Last Printed Date';
            Editable = false;
        }
        field(50059; "Nos Printed"; Integer)
        {
            Caption = 'Nos Printed';
            Editable = false;
        }
        field(50060; "Cancelled By"; Code[50])
        {
            Caption = 'Cancelled By';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50061; "Cancelled Date"; DateTime)
        {
            Caption = 'Cancelled Date';
            Editable = false;
        }
        field(50062; "A Livrer JIRAMA"; Decimal)
        {
            CalcFormula = Sum(pro_detailBL.volumealivrer WHERE(numBL = FIELD(numBL),
                                                                NavItemCode = CONST('34000-0000')));
            Caption = 'Volume à livrer JIRAMA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50063; "Livre JIRAMA"; Decimal)
        {
            CalcFormula = Sum(pro_detailBL.volumelivre WHERE(numBL = FIELD(numBL),
                                                              NavItemCode = CONST('34000-0000')));
            Caption = 'Volume livré JIRAMA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50064; "Validation Date"; DateTime)
        {
            Caption = 'Validation Date';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; numBL)
        {
        }
        key(Key2; idtournee)
        {
        }
        key(Key3; codemoyentransport, isconfirme, isAnnule, datelivraison)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Text001);
    end;

    trigger OnInsert()
    begin
        User.SetRange(User."User Name", UserId);
        if User.FindFirst then begin
            nom := User."Full Name";
            //TODO Migration
            //nomresponsable := User."Manager Name";
        end;
        idtournee := -1;
    end;

    var
        //AFK_SecMgt: Codeunit "Security Mgt";
        User: Record User;
        Text001: Label 'Suppression non autorisée';
        camion: Record pro_moyentransport;
        Vend: Record Vendor;
        RelatedBE: Record pro_enteteBE;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc(Rec.datelivraison, Rec."Posted Shipment No");
        NavigateForm.Run;
    end;

    procedure ShowPostedInvoice()
    var
        PostedInv: Record "Sales Invoice Header";
        PageFactEnreg: Page "Posted Sales Invoice";
    begin
        if PostedInv.Get("Posted Invoice No") then begin
            PageFactEnreg.SetRecord(PostedInv);
            PageFactEnreg.Run;
        end;
    end;

    procedure ShowPostedShipment()
    var
        PostedInv: Record "Sales Shipment Header";
        PageFactEnreg: Page "Posted Sales Shipment";
    begin
        if PostedInv.Get("Posted Shipment No") then begin
            PageFactEnreg.SetRecord(PostedInv);
            PageFactEnreg.Run;
        end;
    end;
}

