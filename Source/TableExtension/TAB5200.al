tableextension 70000143 tableextension70000143 extends Employee 
{
    LookupPageID = 60187;
    DrillDownPageID = 60187;
    fields
    {
        modify("First Name")
        {
            Description = 'Prenom';
        }
        modify("Middle Name")
        {
            Description = 'Nom de jeune fille';
        }
        modify("Last Name")
        {
            Caption = 'Last Name';
            Description = 'Nom';
        }
        modify(Initials)
        {
            Description = 'M.';
        }

        //Unsupported feature: Property Modification (Data type) on ""Job Title"(Field 6)".

        modify("Phone No.")
        {
            Caption = 'Phone No.';
        }
        modify("Mobile Phone No.")
        {
            Caption = 'Mobile Phone No.';
        }

        //Unsupported feature: Property Modification (Data type) on "Title(Field 51)".


        //Unsupported feature: Code Insertion on ""First Name"(Field 2)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Nom complet" := FullName();
            */
        //end;


        //Unsupported feature: Code Insertion on ""Middle Name"(Field 3)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Nom complet" := FullName();
            */
        //end;


        //Unsupported feature: Code Insertion on ""Last Name"(Field 4)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            "Nom complet" := FullName();
            */
        //end;


        //Unsupported feature: Code Insertion on ""Employment Date"(Field 29)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF "Seniority Date"=0D THEN
              IF "Employment Date"<>0D THEN
                 VALIDATE("Seniority Date","Employment Date");
            */
        //end;
        field(50001;"Langue parlée Francais";Boolean)
        {
        }
        field(50002;"Langue parlée Anglais";Boolean)
        {
        }
        field(50003;"Nom du Conjoint";Text[30])
        {
        }
        field(50004;"Prénom du Conjoint";Text[30])
        {
        }
        field(50005;"Taille (cm)";Integer)
        {
            MinValue = 0;
        }
        field(60000;"Source Province";Text[50])
        {
            Caption = 'Province origine';
        }
        field(60001;"Retirement Date";Date)
        {
            Caption = 'Date retraite';
            Editable = false;
        }
        field(60003;"Seniority Date";Date)
        {
            Caption = 'Date ancienneté';

            trigger OnValidate()
            var
                DateTheoRet1: Date;
                DateTheoRet2: Date;
            begin
                CheckStatus;
                MajDates;
            end;
        }
        field(60004;Seniority;Integer)
        {
            Caption = 'Ancienneté';
            Editable = false;
        }
        field(60005;"Direction Code";Code[10])
        {
            Caption = 'Code direction';
            TableRelation = "Org. Direction";
        }
        field(60006;"Service Code";Code[10])
        {
            Caption = 'Code Service';
            TableRelation = "Org. Service";
        }
        field(60007;"Subdirection Code";Code[10])
        {
            Caption = 'Code sous-direction';
            TableRelation = Subdirection;
        }
        field(60008;"Office Code";Code[10])
        {
            Caption = 'Code bureau';
            TableRelation = Office;
        }
        field(60009;"Section Code";Code[10])
        {
            Caption = 'Code section';
            TableRelation = Section;
        }
        field(60010;Sanction;Code[10])
        {
            Caption = 'Sanction en cours';
            TableRelation = "Employee Sanction"."Sanction Code" WHERE (Employee No.=FIELD(No.));
        }
        field(60011;Deactivated;Boolean)
        {
            Caption = 'Désactivé';

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(60013;Passive;Boolean)
        {
            Caption = 'Agent passif';
        }
        field(60014;"Employee Type";Option)
        {
            Caption = 'Type agent passif';
            OptionCaption = ' ,Retraité,Veuve,Orphelin';
            OptionMembers = " ",Retired,Widower,Orphan;
        }
        field(60015;"Function Code";Code[10])
        {
            Caption = 'Code fonction';
            TableRelation = "Job Title";

            trigger OnValidate()
            begin
                CheckStatus;

                IF ("Function Code" <> xRec."Function Code") AND ("Function Code" = '') THEN
                    "Job Title" := '';

                IF ("Function Code" <> xRec."Function Code") AND ("Function Code" <> '') THEN BEGIN
                    JobTitle.GET("Function Code");
                    "Job Title" := JobTitle.Name;
                END
            end;
        }
        field(60016;"Payment Method";Option)
        {
            Caption = 'Mode de Paiement';
            OptionCaption = ' ,Espèce,Chèque,Virement';
            OptionMembers = " ",Cash,Check,Transfer;
        }
        field(60017;"RIB Bank Code";Text[10])
        {
            Caption = 'Code Banque';
        }
        field(60018;"RIB Branch";Text[10])
        {
            Caption = 'Code Guichet';
        }
        field(60019;"RIB Account";Text[20])
        {
            Caption = 'N° Compte';
        }
        field(60020;"Slip Template";Code[20])
        {
            Caption = 'Modèle de bulletin';
            TableRelation = "Slip Template Header";

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(60021;NIC;Text[30])
        {
            Caption = 'N° pièce d''identité';
        }
        field(60022;"NIC Delivered At";Text[30])
        {
            Caption = 'Lieu délivrance';
        }
        field(60023;"NIC Delivered Date";Date)
        {
            Caption = 'Date délivrance CNI';
        }
        field(60024;Qualification;Text[10])
        {
            Caption = 'Qualification';
        }
        field(60025;"Emp. Posting Group";Code[20])
        {
            Caption = 'Group compta. salarié';
            TableRelation = "Emp. Posting Group";
        }
        field(60026;Category;Code[10])
        {
            Caption = 'Catégorie';
            TableRelation = Category;

            trigger OnValidate()
            var
                Cat: Record "60021";
            begin
                CheckStatus;

                IF Cat.Code <> Category THEN
                  Cat.GET(Category);

                //"Slip Template" := Cat."Slip Template";
            end;
        }
        field(60027;Echelon;Code[10])
        {
            Caption = 'Echelon';

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(60028;"Cat. /Ech. Date";Date)
        {
            Caption = 'Date d''entrée en Cat./Ech.';
            Editable = true;
        }
        field(60030;"Pay Type";Option)
        {
            Caption = 'Type paie';
            Editable = false;
            OptionCaption = 'Horaire,Mensuel';
            OptionMembers = Hourly,Monthly;
        }
        field(60031;Grade;Code[10])
        {
            Caption = 'Grade';
            TableRelation = Grade;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(60032;"Nos Of Child";Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           Child=CONST(Yes)));
            Caption = 'Nbre d''enfants enregistrés';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60033;Cotation;Code[10])
        {
            Caption = 'Cotation en cours';
            TableRelation = "Employee Cotation"."Cotation Code" WHERE (Employee No.=FIELD(No.));
        }
        field(60034;"Emp. Group Code";Code[10])
        {
            Caption = 'Code groupe de paie';
            TableRelation = "Employee Group";

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(60035;"Template 13rd Month";Code[20])
        {
            Caption = 'Modèle 13ème mois';
            TableRelation = "Slip Template Header";
        }
        field(60036;"Template 14rd Month";Code[20])
        {
            Caption = 'Modèle 14ème mois';
            TableRelation = "Slip Template Header";
        }
        field(60037;"Template 15rd Month";Code[20])
        {
            Caption = 'Modèle 15ème mois';
            TableRelation = "Slip Template Header";
        }
        field(60038;Diploma;Code[10])
        {
            Caption = 'Diplôme le plus élevé';
            TableRelation = Diploma;
        }
        field(60039;Equipe;Code[10])
        {
            Caption = 'Equipe';
            TableRelation = Equipe;
        }
        field(60040;"Seniority (Month)";Integer)
        {
            Caption = 'Ancienneté';
            Editable = false;
        }
        field(60041;"Nos Of Child In Charge";Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           Child=CONST(Yes),
                                                           Birth Date=FIELD(BirthDate Filter)));
            Caption = 'Nombre d''enfants à charge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60042;"Age Filter";Integer)
        {
            Caption = 'Filtre Age';
            FieldClass = FlowFilter;
        }
        field(60043;"Assim. Group Code";Code[10])
        {
            Caption = 'Groupe de paie assimilé';
            TableRelation = "Employee Group";
        }
        field(60045;"Union Delegate";Boolean)
        {
            Caption = 'Délégué syndical';
        }
        field(60046;"Nos of Unpaid Absences";Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Paid=CONST(Unpaid),
                                                                      Period=FIELD(Payroll Period Filter)));
            Caption = 'Nombre d''absences non payés';
            FieldClass = FlowField;
        }
        field(60047;"Nos of Paid Absences";Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Paid=CONST(Paid),
                                                                      Period=FIELD(Payroll Period Filter)));
            Caption = 'Nombre d''absences payés';
            FieldClass = FlowField;
        }
        field(60048;"From Date Filter";Date)
        {
            Caption = 'Filtre date début';
            FieldClass = FlowFilter;
        }
        field(60049;"To Date Filter";Date)
        {
            Caption = 'Filtre date fin';
            FieldClass = FlowFilter;
        }
        field(60050;HS01;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS01)));
            Caption = 'Nombre d''heures supp. HS01';
            FieldClass = FlowField;
        }
        field(60051;HS02;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS02)));
            Caption = 'Nombre d''heures supp. HS02';
            FieldClass = FlowField;
        }
        field(60052;HS03;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS03)));
            Caption = 'Nombre d''heures supp. HS03';
            FieldClass = FlowField;
        }
        field(60053;HS04;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS04)));
            Caption = 'Nombre de permanences - samedi';
            FieldClass = FlowField;
        }
        field(60054;HS05;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS05)));
            Caption = 'Nombre de permanences - dimanche';
            FieldClass = FlowField;
        }
        field(60055;"Nos of Unavailabilities";Decimal)
        {
            CalcFormula = Sum("Emp. Unavailability"."Nos Of Month" WHERE (Employee No.=FIELD(No.),
                                                                          Start Date=FIELD(From Date Filter),
                                                                          End Date=FIELD(To Date Filter)));
            Caption = 'Total indisponibilité';
            FieldClass = FlowField;
        }
        field(60056;"Agency Code";Code[10])
        {
            Caption = 'Code région';
            TableRelation = "Responsibility Center";
        }
        field(60058;"Rubric Filter";Code[20])
        {
            Caption = 'Filtre rubrique';
            TableRelation = "Payroll Rubric";
        }
        field(60059;"RIB Key";Code[2])
        {
            Caption = 'Clé (RIB)';
        }
        field(60061;"Security Family";Code[10])
        {
            Caption = 'Security Family';
            TableRelation = "Emp. Security Family";

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(60063;NoDipe;Code[10])
        {
        }
        field(60064;"Change Status";Option)
        {
            Caption = 'Change Status';
            Editable = true;
            OptionCaption = 'Locked,Open';
            OptionMembers = Locked,Open;
        }
        field(60065;HS06;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS06)));
            Caption = 'Nombre d''heures supp. HS06';
            FieldClass = FlowField;
        }
        field(60066;HS07;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS07)));
            Caption = 'Nombre d''heures supp. HS07';
            FieldClass = FlowField;
        }
        field(60067;HS08;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS08)));
            Caption = 'Nombre d''heures supp. HS08';
            FieldClass = FlowField;
        }
        field(60068;HS09;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS09)));
            Caption = 'Nombre d''heures supp. HS09';
            FieldClass = FlowField;
        }
        field(60069;HS10;Decimal)
        {
            CalcFormula = Sum("Posted Extra Hour".Quantity WHERE (Employee No.=FIELD(No.),
                                                                  Date=FIELD(Date Filter),
                                                                  Type=CONST(HS10)));
            Caption = 'Nombre d''heures supp. HS10';
            FieldClass = FlowField;
        }
        field(60070;ABS01;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS01)));
            Caption = 'Heures absences 01';
            FieldClass = FlowField;
        }
        field(60071;ABS02;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS02)));
            Caption = 'Heures absences 02';
            FieldClass = FlowField;
        }
        field(60072;ABS03;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS03)));
            Caption = 'Heures absences 03';
            FieldClass = FlowField;
        }
        field(60073;ABS04;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS04)));
            Caption = 'Heures absences 04';
            FieldClass = FlowField;
        }
        field(60074;ABS05;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS05)));
            Caption = 'Heures absences 05';
            FieldClass = FlowField;
        }
        field(60075;ABS06;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS06)));
            Caption = 'Heures absences 06';
            FieldClass = FlowField;
        }
        field(60076;ABS07;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS07)));
            Caption = 'Heures absences 07';
            FieldClass = FlowField;
        }
        field(60077;ABS08;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS08)));
            Caption = 'Heures absences 08';
            FieldClass = FlowField;
        }
        field(60078;ABS09;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS09)));
            Caption = 'Heures absences 09';
            FieldClass = FlowField;
        }
        field(60079;ABS10;Decimal)
        {
            CalcFormula = Sum("Rec. Employee Absence".Quantity WHERE (Employee No.=FIELD(No.),
                                                                      Date Validation=FIELD(Date Filter),
                                                                      Type=CONST(ABS10)));
            Caption = 'Heures absences 10';
            FieldClass = FlowField;
        }
        field(60080;"RIB Bank Name";Text[50])
        {
            Caption = 'Nom de la banque';
        }
        field(60081;"RIB Owner Name";Text[80])
        {
            Caption = 'Libéllé du compte';
        }
        field(60082;"Leave Balance";Decimal)
        {
            CalcFormula = Sum("Employee Leave Entry".Quantity WHERE (Employee No.=FIELD(No.),
                                                                     Posting Date=FIELD(Date Filter),
                                                                     Reversed=CONST(No)));
            Caption = 'Solde congés';
            FieldClass = FlowField;
        }
        field(60083;Confirmed;Boolean)
        {
            Caption = 'Confirmé(e)';
        }
        field(60084;"Payroll Status";Option)
        {
            Caption = 'Payroll Status';
            OptionCaption = 'Actif,Veille,Desactivated';
            OptionMembers = Actif,Veille,Desactivated;
        }
        field(70000;"Payroll Period Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(70001;"Montant avance";Decimal)
        {
            CalcFormula = Sum("Paid Advance Payment"."Montant avance" WHERE (Code salarié=FIELD(No.),
                                                                             Période de paie=FIELD(Payroll Period Filter),
                                                                             Reversed=CONST(No)));
            FieldClass = FlowField;
        }
        field(70002;"Montant acompte";Decimal)
        {
            CalcFormula = Sum("Paid Advance Payment"."Montant acompte" WHERE (Code salarié=FIELD(No.),
                                                                              Période de paie=FIELD(Payroll Period Filter)));
            FieldClass = FlowField;
        }
        field(70004;"Nbre enfants debiles";Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           Child=CONST(Yes),
                                                           Enfant débile=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(70007;"Total pret encours";Decimal)
        {
            CalcFormula = Sum("Employee Loan Entry".Amount WHERE (Code agent=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70008;"BirthDate Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(70009;"Epouse en activite";Boolean)
        {
            CalcFormula = Exist("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           Epouse=CONST(Yes),
                                                           En activité=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(70010;"Nom complet";Text[100])
        {
        }
        field(70015;"Jour de repos";Option)
        {
            OptionCaption = 'Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi,Dimanche';
            OptionMembers = Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi,Dimanche;
        }
        field(70017;Cooperative;Code[10])
        {
            TableRelation = Cooperative;
        }
        field(70018;Cashbox;Code[20])
        {
            Caption = 'Caisse';
            TableRelation = "Bank Account";
        }
        field(70019;Town;Code[10])
        {
            Caption = 'Agence';
            TableRelation = "Post Code".City;
        }
        field(70021;LieuNaissance;Text[30])
        {
            Caption = 'Lieu de naissance';
        }
        field(70022;CleNumeroDipe;Text[5])
        {
            Caption = 'Clé Numero Dipe';
        }
        field(70023;CleNumeroSS;Code[5])
        {
            Caption = 'Clé Numéro SS';
        }
        field(70032;"Dimension Code Value 3";Code[20])
        {
            Caption = 'Code centre de profit';
            Description = 'Code imputation';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3,"Dimension Code Value 3");
            end;
        }
        field(70035;PositionAgent;Option)
        {
            Caption = 'Position';
            OptionCaption = 'Agent en sevice,Exclusion temporaire,Malade,Congé,Détachement';
            OptionMembers = EnService,ExclusionTemp,Malade,"Congé",Detachement;
        }
        field(70042;NbreEnfantsPrimaire;Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           NiveauEtudes=FILTER(Primaire)));
            FieldClass = FlowField;
        }
        field(70043;NbreEnfantsSecondaire;Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           NiveauEtudes=FILTER(Secondaire)));
            FieldClass = FlowField;
        }
        field(70044;NbreEnfantsUniv;Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           NiveauEtudes=FILTER(Universitaire)));
            FieldClass = FlowField;
        }
        field(70045;NbreEnfantsScolarises;Integer)
        {
            CalcFormula = Count("Employee Relative" WHERE (Employee No.=FIELD(No.),
                                                           Enfant en âge scolarité=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(70063;Nationalite;Code[20])
        {
            TableRelation = Country/Region.Code;
        }
        field(70064;"Staff Representative";Boolean)
        {
            Caption = 'Délégué du personnel';
        }
        field(70065;"Company Staff";Boolean)
        {
            Caption = 'Comité d''entreprise';
        }
        field(70066;"Remove Loan Mgt";Boolean)
        {
            Caption = 'Exclure gestion des congés';
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        AlternativeAddr.SETRANGE("Employee No.","No.");
        AlternativeAddr.DELETEALL;

        #4..19
        HumanResComment.DELETEALL;

        DimMgt.DeleteDefaultDim(DATABASE::Employee,"No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..22

        //*****************
        EmpSlip.RESET;
        EmpSlip.SETRANGE(EmpSlip."Employee No.",Rec."No.");
        IF EmpSlip.FINDFIRST THEN ERROR(Text50002);

        PostedEmpSlip.RESET;
        PostedEmpSlip.SETRANGE(PostedEmpSlip."Employee No.",Rec."No.");
        IF PostedEmpSlip.FINDFIRST THEN ERROR(Text50001);

        ValeurBase.RESET;
        ValeurBase.SETRANGE(ValeurBase."Employee No.",Rec."No.");
        IF ValeurBase.FINDFIRST THEN ERROR(Text50004);
        //*****************
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Last Modified Date Time" := CURRENTDATETIME;
        IF "No." = '' THEN BEGIN
          HumanResSetup.GET;
        #4..7
        DimMgt.UpdateDefaultDim(
          DATABASE::Employee,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");
        UpdateSearchName;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..10

        //******************
        "Security Family" := 'DEFAUT';
        //******************

        UpdateSearchName;
        */
    //end;


    //Unsupported feature: Code Modification on "FullName(PROCEDURE 1)".

    //procedure FullName();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        OnBeforeGetFullName(Rec,NewFullName,Handled);
        IF Handled THEN
          EXIT(NewFullName);

        IF "Middle Name" = '' THEN
          EXIT("First Name" + ' ' + "Last Name");

        EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
          EXIT("Last Name" + ' ' + "First Name");

        EXIT( "Last Name"+ ' ' + "Middle Name" + ' ' +"First Name" );
        */
    //end;

    procedure CheckStatus()
    begin
        //TESTFIELD("Change Status","Change Status"::Open);
        //IF   "Change Status"<>"Change Status"::Open THEN
        //  ERROR(Text50000);
    end;

    procedure MajDates()
    var
        DateTheoRet1: Date;
        DateTheoRet2: Date;
        DateMaxRetraite: Integer;
    begin
        PaySetup.GET;

        PaySetup.TESTFIELD("Max. Seniority");
        PaySetup.TESTFIELD("Retirement Age");
        //PaySetup.TESTFIELD(PaySetup."Age retraite calculé");

        IF "Seniority Date" = 0D THEN
          EXIT;

        //Seniority := PayMgt.NbreOfMonthsInPeriod("Seniority Date",TODAY);
        //Seniority := PayMgt.NbreYearsInPeriod("Seniority Date",TODAY);
        //Seniority := DATE2DMY(TODAY,3) - DATE2DMY("Seniority Date",3);
        Seniority := CalcCte.NbreYearsInPeriod("Seniority Date",TODAY);


        //EVALUATE(DateMaxRetraite ,CalcCte.CalculerCte("No.",PaySetup."Age retraite calculé",CREATEGUID,FALSE));
        // Date Retraite après 60 ans d'ancienneté
        IF "Birth Date"<>0D THEN
          DateTheoRet2 := CALCDATE('<' + FORMAT(PaySetup."Retirement Age") + 'Y>',
             "Birth Date");

        //DateTheoRet2 := CALCDATE('<' + FORMAT(DateMaxRetraite) + 'Y>',
        //   "Birth Date");



        // Date Retraite après 30 ans d'ancienneté
        IF  "Seniority Date" <> 0D THEN
          DateTheoRet1 := CALCDATE('<' + FORMAT(PaySetup."Max. Seniority") + 'Y>',
             "Seniority Date");


        // La date de retraite est le min des deux dates
        IF DateTheoRet1 < DateTheoRet2 THEN
          "Retirement Date" := DateTheoRet1
        ELSE
          "Retirement Date" := DateTheoRet2;
    end;

    var
        PaySetup: Record "60013";
        PayMgt: Codeunit "60000";
        JobTitle: Record "60020";
        CalcCte: Codeunit "60050";
        Text50000: Label 'Le fiche de cet employé a été vérouillée pour la modification de ce champ\Veuillez contacter l''administrateur.';
        Text50001: Label 'Il existe déjà un bulletin enregistré pour ce matricule';
        EmpSlip: Record "60005";
        PostedEmpSlip: Record "60011";
        Text50002: Label 'Il existe déjà un bulletin pour ce matricule';
        ValeurBase: Record "60009";
        Text50004: Label 'Des valeurs de base existent déjà pour ce salarié';
}

