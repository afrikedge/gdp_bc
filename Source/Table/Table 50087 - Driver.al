table 50087 Driver
{
    DrillDownPageID = Drivers;
    LookupPageID = Drivers;

    fields
    {
        field(1;immatriculation;Code[30])
        {
            Caption = 'Registration';
        }
        field(2;NumOrdre;Integer)
        {
        }
        field(3;Nom;Text[50])
        {

            trigger OnValidate()
            begin
                if Titulaire then begin
                  Camion.Get(immatriculation);
                  Camion.nomchauffeur := Nom;
                  Camion.Modify;
                end;
            end;
        }
        field(4;Permis;Text[30])
        {

            trigger OnValidate()
            begin
                if Titulaire then begin
                  Camion.Get(immatriculation);
                  Camion.permis := Permis;
                  Camion.Modify;
                end;
            end;
        }
        field(5;Categorie;Text[10])
        {
            Caption = 'Catégorie';
        }
        field(6;ValiditePermis;Date)
        {
            Caption = 'Validité Permis';
        }
        field(7;CartePath;Text[30])
        {
            Caption = 'Carte PATH';
        }
        field(8;ValiditeCartePath;Date)
        {
            Caption = 'Validité Carte PATH';
        }
        field(9;MotifRemplacement;Text[30])
        {
            Caption = 'Motif remplacement';
        }
        field(10;Formateur;Text[30])
        {
        }
        field(11;Telephone;Text[20])
        {

            trigger OnValidate()
            begin
                if Titulaire then begin
                  Camion.Get(immatriculation);
                  Camion.telchauffeur := Telephone;
                  Camion.Modify;
                end;
            end;
        }
        field(12;Titulaire;Boolean)
        {

            trigger OnValidate()
            begin
                if Titulaire then begin
                  Driv.Reset;
                  Driv.SetRange(immatriculation,Rec.immatriculation);
                  Driv.SetFilter(NumOrdre,'<>%1',Rec.NumOrdre);
                  Driv.ModifyAll(Titulaire,false);

                  if Camion.Get(immatriculation) then begin
                    Camion.nomchauffeur := Nom;
                    Camion.telchauffeur := Telephone;
                    Camion.permis := Permis;
                    Camion.Modify;
                  end;
                end;
            end;
        }
        field(13;DateDebService;Date)
        {
            Caption = 'Date début service';
        }
        field(14;CreatedDate;Date)
        {
            Caption = 'Ajouté le';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;immatriculation,NumOrdre)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        //Driv.RESET;
        //Driv.SETRANGE(immatriculation,Rec.immatriculation);
        //Driv.MODIFYALL(Titulaire,FALSE);

        Driv.Reset;
        Driv.SetRange(immatriculation,Rec.immatriculation);
        if Driv.IsEmpty then
          Titulaire:=true;

        CreatedDate := Today;
    end;

    var
        Driv: Record Driver;
        Camion: Record pro_moyentransport;
}

