table 50009 pro_moyentransport
{
    Caption = 'Moyens de transport';
    // LookupPageID = Camions;

    fields
    {
        field(1; immatriculation; Code[30])
        {
            Caption = 'Registration';
        }
        field(2; description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; type; Text[20])
        {
            Caption = 'Type';
        }
        field(4; codetransporteur; Code[20])
        {
            Caption = 'Transporter Code';
            TableRelation = Vendor;
        }
        field(5; lieuaffectation; Code[10])
        {
            Caption = 'Affectation site';
            TableRelation = "Responsibility Center";
        }
        field(6; tarifville; Decimal)
        {
            Caption = 'Town Price';
        }
        field(7; tarifhorsville; Decimal)
        {
            Caption = 'Outside city price';
        }
        field(8; objectifmensuel; Decimal)
        {
            Caption = 'Monthly Goals';
        }
        field(9; disponible; Boolean)
        {
            Caption = 'Available';
        }
        field(10; pompe; Boolean)
        {
            Caption = 'Pump';
        }
        field(11; compartiments; Integer)
        {
            Caption = 'Compartments';
            Editable = false;
        }
        field(12; nomchauffeur; Text[50])
        {
            Caption = 'Driver Name';
        }
        field(13; prenomchauffeur; Text[50])
        {
            Caption = 'Driver First Name';
        }
        field(14; permis; Text[50])
        {
            Caption = 'Permis';
        }
        field(15; telchauffeur; Text[50])
        {
            Caption = 'Driver Phone';
        }
        field(16; capacite; Decimal)
        {
            Caption = 'Capacity';
            Editable = false;
        }
        field(17; vitesse; Decimal)
        {
            Caption = 'Speed';
        }
        field(18; entournee; Boolean)
        {
            Caption = 'In tour';
            Editable = false;
        }
        field(19; remise; Decimal)
        {
            Caption = 'Remise';
        }
        field(20; coutkm; Decimal)
        {
            Caption = 'Cost/KM';
        }
        field(21; couthoraire; Decimal)
        {
            Caption = 'Hour Cost';
        }
        field(22; livraisonsparmois; Decimal)
        {
            Caption = 'Monthly Shipments';
        }
        field(50000; CarteGrise; Text[30])
        {
            Caption = 'Carte grise';
        }
        field(50001; "Transporter Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD(codetransporteur)));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; NumeroContrat; Text[30])
        {
            Caption = 'Contract No';
        }
        field(50003; ZoneActivite; Text[30])
        {
            Caption = 'Zone d''activité';
        }
        field(50004; MarqueTracteur; Text[30])
        {
            Caption = 'Marque (Tracteur)';
        }
        field(50005; MarqueCiterne; Text[30])
        {
            Caption = 'Marque (Citerne)';
        }
        field(50006; DateMEC_Tracteur; Date)
        {
            Caption = 'Date de 1ere MEC';

            trigger OnValidate()
            begin
                AgeTracteur := NbreYearsInPeriod(DateMEC_Tracteur, Today);
            end;
        }
        field(50007; DateMEC_Citerne; Date)
        {
            Caption = 'Date de 1ere MEC';

            trigger OnValidate()
            begin
                AgeCiterne := NbreYearsInPeriod(DateMEC_Citerne, Today);
            end;
        }
        field(50008; AgeTracteur; Integer)
        {
            Caption = 'Age';
            Editable = false;
        }
        field(50009; AgeCiterne; Integer)
        {
            Caption = 'Age (Citerne)';
            Editable = false;
        }
        field(50010; VisiteTechniqueTracteur; Date)
        {
            Caption = 'Visite Technique (Tracteur)';
        }
        field(50011; VisiteTechniqueCiterne; Date)
        {
            Caption = 'Visite Technique (Citerne)';
        }
        field(50012; AssuranceCgnieTracteur; Text[30])
        {
            Caption = 'Compagnie d''assurance (Tracteur)';
        }
        field(50013; ValiditeAssuranceCgnieTracteur; Date)
        {
            Caption = 'Validité assurance (Tracteur)';
        }
        field(50014; AssuranceCgnieCiterne; Text[30])
        {
            Caption = 'Compagnie d''assurance (Citerne)';
        }
        field(50015; ValiditeAssuranceCgnieCiterne; Date)
        {
            Caption = 'Validité assurance (Citerne)';
        }
        field(50016; AssuranceMseCgnie; Text[30])
        {
            Caption = 'Compagnie Assurance M/se';
        }
        field(50017; AssuranceMseCgnieValidite; Date)
        {
            Caption = 'Validité Assurance M/se';
        }
        field(50018; PatenteTracteur; Text[30])
        {
            Caption = 'Patente (Tracteur)';
        }
        field(50019; PatenteCiterne; Text[30])
        {
            Caption = 'Patente (Citerne)';
        }
        field(50020; CtrlTechCodeRouteCertificat; Text[30])
        {
            Caption = 'Certicicat Contrôle technique (code de la route)';
        }
        field(50021; CtrlTechCodeRouteValidite; Date)
        {
            Caption = 'Validité Contrôle technique (code de la route)';
        }
        field(50022; CtrlEtancheiteCtneCertificat; Text[30])
        {
            Caption = 'N° Certificat Contrôle étanchéité (citerne)';
        }
        field(50023; CtrlEtancheiteCtneValidite; Date)
        {
            Caption = 'Validité Contrôle étanchéité (citerne)';
        }
        field(50024; BaremageCertificat; Text[30])
        {
            Caption = 'N° Certificat Barêmage';
        }
        field(50025; BaremageValidite; Date)
        {
            Caption = 'Validité Barêmage';
        }
        field(50026; CertExtincteurVerificateur; Text[30])
        {
            Caption = 'Vérificateur Certificat Extincteur';
        }
        field(50027; CertExtincteurValidite; Date)
        {
            Caption = 'Validité Certificat Extincteur';
        }
        field(50028; NomChauffeurActuel; Text[50])
        {
            CalcFormula = Lookup(Driver.Nom WHERE(immatriculation = FIELD(immatriculation),
                                                   Titulaire = CONST(true)));
            Caption = 'Chauffeur actuel';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50029; NomDispaching; Text[50])
        {
            CalcFormula = Lookup(Vendor."Name 2" WHERE("No." = FIELD(codetransporteur)));
            Caption = 'Transporteur (Logistique)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50030; "Dispaching Compartment Order"; Text[30])
        {
            Caption = 'Ordre compartiments (Dispaching)';

            trigger OnValidate()
            var
                Chain: Text[30];
                Part1: Text[2];
                Pos: Integer;
            begin
                Chain := "Dispaching Compartment Order";
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                Part1 := Token(Chain, ',');
                //Part1 := Token(Chain,',');

                Chain := "Dispaching Compartment Order";
                FindIntext(Chain, '1');
                FindIntext(Chain, '2');
                FindIntext(Chain, '3');
                FindIntext(Chain, '4');
                FindIntext(Chain, '5');
                FindIntext(Chain, '6');
                FindIntext(Chain, '7');
                FindIntext(Chain, '8');
                FindIntext(Chain, '9');
                FindIntext(Chain, '10');
            end;
        }
    }

    keys
    {
        key(Key1; immatriculation)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; immatriculation, capacite)
        {
        }
    }

    trigger OnDelete()
    var
        Driver: Record Driver;
        Compart: Record Compartment;
    begin
        Error(Text001);

        Driver.Reset;
        Driver.SetRange(Driver.immatriculation, Rec.immatriculation);
        Driver.DeleteAll;

        Compart.Reset;
        Compart.SetRange(Compart.immatriculation, Rec.immatriculation);
        Compart.DeleteAll;
    end;

    var
        Text001: Label 'Suppression impossible!';
        Text002: Label 'Chaine invalide, Saissisez les 10 compartiments séparés par une virgule (,)';
        Text003: Label 'Vérifiez que tous les compartiments sont présents';

    procedure NbreYearsInPeriod(Day1: Date; Day2: Date) NoOfYearsInPeriod: Integer
    var
        Wdate: Date;
        FirstDayinCrntYear: Date;
        LastDayinCrntYear: Date;
    begin
        NoOfYearsInPeriod := 0;

        if Day1 > Day2 then
            exit(0);
        if Day1 = 0D then
            exit(0);
        if Day2 = 0D then
            exit(0);

        Wdate := Day1;
        repeat
            Wdate := CalcDate('<1Y>', Wdate);
            if Wdate <= Day2 then
                NoOfYearsInPeriod := NoOfYearsInPeriod + 1;
        until Wdate > Day2;
    end;

    local procedure Token(var Text: Text[30]; Separator: Text[1]) Token: Text[1024]
    var
        Pos: Integer;
    begin
        Pos := StrPos(Text, Separator);
        if Pos > 0 then begin
            Token := CopyStr(Text, 1, Pos - 1);
            if Pos + 1 <= StrLen(Text) then
                Text := CopyStr(Text, Pos + 1)
            else
                Text := '';
        end else begin
            Error(Text002);
        end;
    end;

    local procedure FindIntext(Chain: Text[30]; TextToFind: Text[2])
    var
        Pos: Integer;
    begin
        Pos := StrPos(Chain, TextToFind);
        if (Pos <= 0) then
            Error(Text003);
    end;
}

