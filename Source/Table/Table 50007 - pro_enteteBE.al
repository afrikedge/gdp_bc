table 50007 pro_enteteBE
{
    Caption = 'Bon Order';
    DataCaptionFields = NumBU;

    fields
    {
        field(1; numBE; Integer)
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
                //TODO Migration
                //AFK_SecMgt.CheckWarehouseUser(depot);

                if ((depot <> xRec.depot) and (xRec.depot <> '')) then begin
                    if not Confirm(Text001) then Error('');
                    TestField(Rec.isconfirme, false);
                    TestField(Rec.isAnnule, false);

                    enteteBL.Reset;
                    enteteBL.SetRange(enteteBL.numBE, Rec.numBE);
                    enteteBL.ModifyAll(enteteBL.depot, Rec.depot);
                end;

                RefreshNumBEClient;
                /*
                
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
                //NumAfficheBE := 'BE' + FORMAT(numBE);

            end;
        }
        field(8; dateBE; Date)
        {
            Caption = 'Removal order Date';

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
            Caption = 'Tour ID';
            Editable = false;

            trigger OnValidate()
            begin
                if Source = Rec.Source::Dispaching then Error(Text002);
            end;
        }
        field(13; codemoyentransport; Code[30])
        {
            Caption = 'Transportation Code';
            TableRelation = pro_moyentransport.immatriculation;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin

                //JN 041023 *********Maj camion si docs imprimés
                if ((idtournee = -1) and (Imprime)) then begin
                    enteteBL.Reset;
                    enteteBL.SetRange(enteteBL.numBE, Rec.numBE);
                    if enteteBL.FindSet then
                        repeat
                            if enteteBL.Imprime then
                                Error(Text004);
                        until enteteBL.Next = 0;
                end;
                //****************************


                if codemoyentransport <> xRec.codemoyentransport then begin

                    codemoyentransport2 := codemoyentransport;
                    enteteBL.Reset;
                    enteteBL.SetRange(enteteBL.numBE, Rec.numBE);
                    if enteteBL.FindSet then
                        repeat
                            enteteBL.Validate(codemoyentransport, Rec.codemoyentransport);
                            enteteBL.Modify;
                        until enteteBL.Next = 0;
                end;

                if camion.Get(codemoyentransport) then begin
                    nomchauffeur := camion.nomchauffeur;
                    //prenomchauffeur := camion.prenomchauffeur;
                    permis := camion.permis;
                    if Vend.Get(camion.codetransporteur) then
                        nomTransporteur := Vend."Name 2";
                end;
            end;
        }
        field(14; temperature; Decimal)
        {
            Caption = 'Temperature';
        }
        field(15; densite; Decimal)
        {
            Caption = 'Density';
        }
        field(16; observation; Text[250])
        {
            Caption = 'Observations';
        }
        field(17; isconfirme; Boolean)
        {
            Caption = 'Confirmed BE';
            Editable = false;
        }
        field(18; datevalidite; Date)
        {
            Caption = 'Validity Date';
        }
        field(19; nom; Text[100])
        {
            Caption = 'Prepared by';

            trigger OnValidate()
            begin
                enteteBL.Reset;
                enteteBL.SetRange(numBE, Rec.numBE);
                if enteteBL.FindSet then
                    repeat
                        enteteBL.Validate(nom, Rec.nom);
                        enteteBL.Modify;
                    until enteteBL.Next = 0;
            end;
        }
        field(20; nomresponsable; Text[100])
        {
            Caption = 'Validated by';

            trigger OnValidate()
            begin
                enteteBL.Reset;
                enteteBL.SetRange(numBE, Rec.numBE);
                if enteteBL.FindSet then
                    repeat
                        enteteBL.Validate(nomresponsable, Rec.nomresponsable);
                        enteteBL.Modify;
                    until enteteBL.Next = 0;
            end;
        }
        field(21; datecreation; DateTime)
        {
            Caption = 'Creation date';
            Editable = false;
        }
        field(22; NumAfficheBE; Code[20])
        {
            Caption = 'BE Number';

            trigger OnValidate()
            begin
                if not MasquerRefBEJIRAMA then
                    RefreshNumBEClient;
            end;
        }
        field(23; RegimeDouanier; Code[20])
        {
            Caption = 'Customs Regime';
        }
        field(24; numBSL; Code[20])
        {
            Caption = 'BSL Number';
        }
        field(25; CreateFromBE; Integer)
        {
            Caption = 'Original BE';
            Editable = false;
            InitValue = 0;
        }
        field(26; CreatedFromDocNo; Code[20])
        {
            Caption = 'Original Document';
        }
        field(100; numBL; Integer)
        {
            Caption = 'BL No.';
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
        field(101; datelivraison; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(datelivraison, datelivraison);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(102; datevaliditeBL; Date)
        {
            Caption = 'Validity Date BL';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(datevalidite, datevaliditeBL);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(103; NumAfficheBL; Code[20])
        {
            Caption = 'BE Number';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(NumAfficheBL, NumAfficheBL);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(104; NavOrderNo; Code[20])
        {
            Caption = 'Order N°';
            Editable = true;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            var
                SOrder: Record "Sales Header";
                Cust1: Record Customer;
            begin
                if Source = Rec.Source::Dispaching then Error(Text001);
                //IF Source=Rec.Source::Dispaching THEN ERROR(Text001);
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(NavOrderNo, NavOrderNo);
                    if (SOrder.Get(SOrder."Document Type"::Order, NavOrderNo)) then begin
                        if Cust1.Get(SOrder."Sell-to Customer No.") then begin
                            "Customer No" := Cust1."No.";
                            "Sales Channel Code" := Cust1."Sales Channel Code";
                        end;
                    end;
                end;
            end;
        }
        field(105; region; Code[10])
        {
            Caption = 'Region Code';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(region, region);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(106; tarifville; Boolean)
        {
            Caption = 'Town price';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(tarifville, tarifville);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(107; ville; Code[20])
        {
            Caption = 'Town';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(ville, ville);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(108; AdrLivraisonBL; Code[20])
        {
            Caption = 'Delivery Adress';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(AdrLivraisonBL, AdrLivraisonBL);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(109; prix_unitaire; Decimal)
        {
            Caption = 'Unit Price';

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate(prix_unitaire, prix_unitaire);
                    RelatedBL.Modify;
                end;
            end;
        }
        field(110; "Customer No"; Code[20])
        {
            Caption = 'Customer N°';
            Editable = false;
        }
        field(111; "Sales Channel Code"; Code[10])
        {
            Caption = 'Sales Channel Code';
            Editable = false;
            TableRelation = "Sales Channel";
        }
        field(112; "Delivery Site"; Code[30])
        {
            Caption = 'Delivery Site';
            TableRelation = "Delivery Site".Site WHERE("Location Code" = FIELD(depot));

            trigger OnValidate()
            begin
                if IsBon then begin
                    RelatedBL.Get(numBL);
                    RelatedBL.Validate("Delivery Site", "Delivery Site");
                    RelatedBL.Modify;
                end;
            end;
        }
        field(113; IsBon; Boolean)
        {
            Caption = 'Bon';
            Editable = false;
        }
        field(114; "Posted Shipment No"; Code[20])
        {
            CalcFormula = Lookup(pro_enteteBL."Posted Shipment No" WHERE(numBL = FIELD(numBL)));
            Caption = 'N° Livraison enreg.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115; "Posted Invoice No"; Code[20])
        {
            CalcFormula = Lookup(pro_enteteBL."Posted Invoice No" WHERE(numBL = FIELD(numBL)));
            Caption = 'N° Facture enreg.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(116; BonIsConfirme; Boolean)
        {
            Caption = 'Bon confirmé';
        }
        field(117; NumBU; Code[20])
        {
            Caption = 'Bon Number';
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
        field(50004; Provisioned; Boolean)
        {
            Caption = 'provisioned';
            Editable = false;
        }
        field(50005; "Invoice Received"; Boolean)
        {
            Caption = 'Invoice received';
        }
        field(50006; "Invoice Number"; Code[20])
        {
            Caption = 'Invoice number';
        }
        field(50007; "Customer BE"; Code[30])
        {
            Caption = 'Customer BE N°';
        }
        field(50008; nomchauffeur; Text[50])
        {
            Caption = 'Driver Name';

            trigger OnValidate()
            begin
                //IF nomchauffeur <>xRec.nomchauffeur THEN BEGIN
                enteteBL.Reset;
                enteteBL.SetRange(enteteBL.numBE, Rec.numBE);
                if enteteBL.FindSet then
                    repeat
                        enteteBL.Validate(nomchauffeur, Rec.nomchauffeur);
                        enteteBL.Modify;
                    until enteteBL.Next = 0;
                //END;
            end;
        }
        field(50010; permis; Text[50])
        {
            Caption = 'Driver licence';

            trigger OnValidate()
            begin
                //IF permis <>xRec.permis THEN BEGIN
                enteteBL.Reset;
                enteteBL.SetRange(enteteBL.numBE, Rec.numBE);
                if enteteBL.FindSet then
                    repeat
                        enteteBL.Validate(permis, Rec.permis);
                        enteteBL.Modify;
                    until enteteBL.Next = 0;
                //END;
            end;
        }
        field(50011; nomTransporteur; Text[50])
        {
            Caption = 'Transporter Name';

            trigger OnValidate()
            begin
                //IF nomTransporteur <>xRec.nomTransporteur THEN BEGIN
                enteteBL.Reset;
                enteteBL.SetRange(enteteBL.numBE, Rec.numBE);
                if enteteBL.FindSet then
                    repeat
                        enteteBL.Validate(nomTransporteur, Rec.nomTransporteur);
                        enteteBL.Modify;
                    until enteteBL.Next = 0;
                //END;
            end;
        }
        field(50012; codemoyentransport2; Code[30])
        {
            Caption = 'Transportation Code';
            TableRelation = pro_moyentransport.immatriculation;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                BL: Record pro_enteteBL;
            begin

                if codemoyentransport <> xRec.codemoyentransport then begin

                    /*
                    IF camion.GET(codemoyentransport) THEN BEGIN
                      IF Rec.Source=Rec.Source::Dispaching THEN
                        SQLMgt.ChangerCamionBE(Rec.numBE,codemoyentransport);
                        //camion.TESTFIELD(camion.entournee,FALSE);
                    END;
                    */
                    //   IF camion.GET(xRec.codemoyentransport) THEN BEGIN
                    //     IF Rec.Source=Rec.Source::Dispaching THEN
                    //       IF camion.entournee THEN BEGIN
                    //         camion.entournee := FALSE;
                    //         camion.MODIFY;
                    //       END;
                    //   END;
                end;
                /*
                IF camion.GET(codemoyentransport) THEN BEGIN
                  nomchauffeur := camion.nomchauffeur;
                  //prenomchauffeur := camion.prenomchauffeur;
                  permis := camion.permis;
                  IF Vend.GET(camion.codetransporteur) THEN
                    nomTransporteur := Vend.Name;
                END;
                */

                if Source = Rec.Source::Dispaching then
                    TestField(codemoyentransport2);

                //Maj sur les BL associés
                BL.Reset;
                BL.SetRange(BL.numBE, numBE);
                if BL.FindSet then
                    repeat
                        BL.codemoyentransport2 := codemoyentransport2;
                        BL.Modify;
                    until BL.Next = 0;

            end;
        }
        field(50013; Destination; Option)
        {
            OptionCaption = 'Ville,Soutage International,Bornage,Soute Local';
            OptionMembers = Ville,"Soutage International",Bornage,"Soute Local";
        }
        field(50014; "Cargo Name"; Text[150])
        {
            Caption = 'Cargo name';
        }
        field(50015; "Last Printed Date"; DateTime)
        {
            Caption = 'Last Printed Date';
            Editable = false;
        }
        field(50017; "Nos Printed"; Integer)
        {
            Caption = 'Nos Printed';
            Editable = false;
        }
        field(50018; "Cancelled By"; Code[50])
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
        field(50019; "Cancelled Date"; DateTime)
        {
            Caption = 'Cancelled Date';
            Editable = false;
        }
        field(50020; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Validation Date"; DateTime)
        {
            Caption = 'Validation Date';
            Editable = false;
        }
        field(50022; "Customer BC"; Code[50])
        {
            Caption = 'BC Client';
        }
        field(50023; "Cancelled Incident Type"; Option)
        {
            CalcFormula = Lookup("Dispaching Incident".IncidentType WHERE(IdRef = FIELD(numBE),
                                                                           AnnulerBon = CONST(true)));
            Caption = 'Type d''incident';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Déviation,Changement de camion,Changement de chauffeur,Autre';
            OptionMembers = Deviation,ChangementCamion,ChangementChauffeur,Autre;
        }
        field(50024; "Canceleld Comments"; Text[250])
        {
            CalcFormula = Lookup("Dispaching Incident".Comments WHERE(IdRef = FIELD(numBE),
                                                                       AnnulerBon = CONST(true)));
            Caption = 'Observations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "Cancelled Reason"; Text[100])
        {
            CalcFormula = Lookup("Dispaching Incident".Reason WHERE(IdRef = FIELD(numBE),
                                                                     AnnulerBon = CONST(true)));
            Caption = 'Motif';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; numBE)
        {
        }
        key(Key2; CreatedFromDocNo, isconfirme)
        {
        }
        key(Key3; idtournee)
        {
        }
        key(Key4; codemoyentransport, isconfirme, isAnnule, dateBE)
        {
        }
        key(Key5; NumBU)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Text002);
    end;

    trigger OnInsert()
    var
        NewNumBon: Code[20];
        I: Integer;
        oldBE: Record pro_enteteBE;
    begin
        datecreation := CreateDateTime(Today, Time);
        idtournee := -1;

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Bons Nos.");
        NewNumBon := NoSeriesMgt.GetNextNo(AddOnSetup."Bons Nos.", Today, true);
        for I := 1 to 6 - StrLen(NewNumBon) do begin
            NewNumBon := '0' + NewNumBon;
        end;
        NewNumBon := 'BU' + NewNumBon;
        oldBE.Reset;
        oldBE.SetCurrentKey(NumBU);
        oldBE.SetRange(NumBU, NewNumBon);
        if oldBE.FindFirst then Error(Text003, NewNumBon);
        NumBU := NewNumBon;
    end;

    var
        camion: Record pro_moyentransport;
        Vend: Record Vendor;
        //SQLMgt: Codeunit "SQL Mgt";
        oldCamion: Record pro_moyentransport;
        newCamion: Record pro_moyentransport;
        Text001: Label 'Voulez vous modifier le code dépôt ?';
        // AFK_SecMgt: Codeunit "Security Mgt";
        // JIRAMAMgt: Codeunit "JIRAMA Sales Mgt";
        AddOnSetup: Record "AddOn Setup";
        Cust: Record Customer;
        Text002: Label 'Suppression impossible !';
        enteteBL: Record pro_enteteBL;
        RelatedBL: Record pro_enteteBL;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text003: Label 'Le numéro de bon %1 a déjà été utilisé';
        Text004: Label 'Vous ne pouvez pas changer le camion car les document BE et BL ont déjà été imprimés.';

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc(Rec.dateBE, Rec.NumBU);
        NavigateForm.Run;
    end;

    local procedure RefreshAllBLs(proBL: Record pro_enteteBL)
    begin
        proBL.Reset;
        proBL.SetRange(proBL.numBE, Rec.numBE);
        if proBL.FindSet then
            repeat
                proBL.codemoyentransport := Rec.codemoyentransport;
                proBL.Modify;
            until proBL.Next = 0;
    end;

    local procedure RefreshNumBEClient()
    var
        RefClientBE: Code[35];
    begin
        //TODO Migration
        // RefClientBE := JIRAMAMgt.GetRefJIRAMA(Rec);
        // if RefClientBE<>'' then
        //   "Customer BE" := RefClientBE;
    end;

    procedure IsBEJIRAMA(): Boolean
    var
        SalesOrderHeader: Record "Sales Header";
    begin
        AddOnSetup.Get;

        //IF EnteteBE.CreatedFromDocNo='' THEN EXIT '';

        if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, CreatedFromDocNo) then begin
            if Cust.Get(SalesOrderHeader."Sell-to Customer No.") then begin
                if Cust."Sales Channel Code" = AddOnSetup."JIRAMA Sales Channel" then begin

                    exit(true);
                end;
            end;
        end;
    end;

    procedure IsBEJIRAMAPompe(): Boolean
    var
        SalesOrderHeader: Record "Sales Header";
    begin
        AddOnSetup.Get;

        //IF EnteteBE.CreatedFromDocNo='' THEN EXIT '';

        if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, CreatedFromDocNo) then begin
            if Cust.Get(SalesOrderHeader."Sell-to Customer No.") then begin
                if Cust."Appliquer Ecart pompe JIR" then begin

                    exit(true);
                end;
            end;
        end;
    end;

    procedure MasquerRefBEJIRAMA(): Boolean
    var
        SalesOrderHeader: Record "Sales Header";
    begin
        AddOnSetup.Get;

        if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order, CreatedFromDocNo) then begin
            if Cust.Get(SalesOrderHeader."Sell-to Customer No.") then begin
                if Cust."Remove JIR Ref on BE" then begin

                    exit(true);
                end;
            end;
        end;
    end;
}

