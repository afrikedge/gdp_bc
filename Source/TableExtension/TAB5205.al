tableextension 70000145 tableextension70000145 extends "Employee Relative" 
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Last Name"(Field 6)".


        //Unsupported feature: Code Insertion on ""Relative Code"(Field 3)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF Rel.GET("Relative Code") THEN BEGIN
              Epouse := Rel.Epouse;
              Child := Rel.Child;
            END;
            */
        //end;
        field(50012;"Code sécurité salarié";Code[20])
        {
            Editable = false;
        }
        field(60000;Child;Boolean)
        {
            Caption = 'Enfant';
            Editable = false;
        }
        field(60001;Age;Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                /*PaySetup.GET;
                IF Age >= PaySetup."Max. Age" THEN
                  "Enfant à charge" := FALSE
                ELSE
                  "Enfant à charge" := TRUE;
                */

            end;
        }
        field(60002;"Enfant à charge";Boolean)
        {
            Editable = true;
        }
        field(60003;"Enfant débile";Boolean)
        {
        }
        field(60004;"En activité";Boolean)
        {
        }
        field(60005;Epouse;Boolean)
        {
        }
        field(60006;NiveauEtudes;Option)
        {
            Caption = 'Niveau d''études';
            OptionCaption = 'Non défini,Primaire,Secondaire,Universitaire';
            OptionMembers = NonDefini,Primaire,Secondaire,Universitaire;
        }
        field(60007;"Enfant en âge scolarité";Boolean)
        {
        }
        field(60008;"Date de sortie";Date)
        {
        }
        field(60009;"Motif de sortie";Text[50])
        {
        }
        field(60010;Certificat;Boolean)
        {
        }
        field(60011;Sex;Option)
        {
            Caption = 'Sex';
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
    }

    var
        Rel: Record "5204";
}

