tableextension 70000146 tableextension70000146 extends "Employee Absence" 
{
    fields
    {

        //Unsupported feature: Code Modification on ""Employee No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Employee.GET("Employee No.");
            IF Employee."Privacy Blocked" THEN
              ERROR(BlockedErr);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            Employee.GET("Employee No.");
            //*****************************
            Rec."Employee Name":=Employee."Last Name"+' '+Employee."First Name";
            Employee.TESTFIELD(Employee.Deactivated,FALSE);
            //*****************************
            IF Employee."Privacy Blocked" THEN
              ERROR(BlockedErr);
            */
        //end;
        field(50000;"Employee Name";Text[100])
        {
            Caption = 'Employee Name';
            Description = 'GRH-TRIUM1.00';
            Editable = false;
        }
        field(50001;Paid;Option)
        {
            Editable = false;
            OptionCaption = 'Non payé,Payé';
            OptionMembers = Unpaid,Paid;
        }
        field(50002;"Unité absence";Option)
        {
            Description = 'GRH-TRIUM1.00';
            OptionCaption = 'Jour,Heure';
            OptionMembers = Jour,Heure;

            trigger OnValidate()
            begin
                IF Quantity>0 THEN VALIDATE(Quantity,Quantity);
            end;
        }
        field(50005;"Quantité en journée";Decimal)
        {
            DecimalPlaces = 0:5;
            Description = 'GRH-TRIUM1.00';
            Editable = false;

            trigger OnValidate()
            begin
                HumanResSetup.TESTFIELD(HumanResSetup."Number of days per week");
                TESTFIELD("From Date");
                VALIDATE("To Date","From Date"+ROUND(("Quantité en journée"/HumanResSetup."Number of days per week"*7),1,'<'));
            end;
        }
        field(50006;"Agency Code";Code[10])
        {
            Caption = 'Code agence';
            NotBlank = true;
            TableRelation = Table0;
        }
        field(50007;"User ID";Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                //LoginMgt.LookupUserID("User ID");
            end;
        }
        field(50012;"Code sécurité salarié";Code[20])
        {
        }
        field(50050;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
        }
        field(50051;Period;Code[20])
        {
            Caption = 'Période';
            TableRelation = "Payroll Period";

            trigger OnValidate()
            var
                PPeriod: Record "60004";
            begin
                IF Period <> '' THEN BEGIN
                  PPeriod.GET(Period);
                  PPeriod.TESTFIELD(Status,PPeriod.Status::Opened);
                  "From Date" := PPeriod."Starting Date";
                  "To Date" := PPeriod."Ending Date";
                END;
            end;
        }
        field(60000;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Absence maladie,Absence maternité,Absence congés payés,Chomage partiel,Congés sans solde,Absence disciplinaire,ABS07,ABS08,ABS09,ABS10';
            OptionMembers = ABS01,ABS02,ABS03,ABS04,ABS05,ABS06,ABS07,ABS08,ABS09,ABS10;
        }
    }

    procedure ValidateAbsence(var EmployeeAbsence: Record "5207")
    var
        RecLEmployeeAbsenceEnreg: Record "60031";
    begin
        WITH EmployeeAbsence DO
         BEGIN
          SETFILTER(Quantity,'<>%1',0);
          IF FIND('-') THEN
             REPEAT
               TESTFIELD("Employee No.");
               //TESTFIELD("Cause of Absence Code");
               TESTFIELD("From Date");
               TESTFIELD("Agency Code");
               SecMgt.CheckIfHaveAccessToEmp1("Employee No.");
               TESTFIELD("External Document No.");

               RecLEmployeeAbsenceEnreg.INIT;
               RecLEmployeeAbsenceEnreg."Employee No."              := "Employee No.";
               RecLEmployeeAbsenceEnreg.Period                      := Period;
               RecLEmployeeAbsenceEnreg."From Date"                 := "From Date";
               RecLEmployeeAbsenceEnreg."To Date"                   := "To Date";
               RecLEmployeeAbsenceEnreg."Cause of Absence Code"     := "Cause of Absence Code";
               RecLEmployeeAbsenceEnreg.Description                 := Description;
               RecLEmployeeAbsenceEnreg.Quantity                    := Quantity;
               RecLEmployeeAbsenceEnreg."Employee Name"             := "Employee Name";
               RecLEmployeeAbsenceEnreg.Paid              := Paid;
               RecLEmployeeAbsenceEnreg."Unité absence"             := "Unité absence";
               RecLEmployeeAbsenceEnreg."Quantité en journée"       := "Quantité en journée";
               //RecLEmployeeAbsenceEnreg."Agency Code"               := "Agency Code";
               RecLEmployeeAbsenceEnreg."Date Validation"           := "From Date";
               //RecLEmployeeAbsenceEnreg."Utilisateur Validation"    := USERID;
               RecLEmployeeAbsenceEnreg."External Document No." := "External Document No.";

               IF RecLEmployeeAbsenceEnreg.INSERT(TRUE) THEN
                 DELETE
               ELSE
                 ERROR(TEXT001,"Entry No.","Employee No.");
             UNTIL NEXT=0;
         END;
    end;

    procedure CheckIfIsOverlap()
    var
        EmployeeAbsence: Record "5207";
    begin
        EmployeeAbsence.SETRANGE("Employee No.","Employee No.");
        EmployeeAbsence.SETFILTER("From Date",'<%1',"From Date");
        EmployeeAbsence.SETFILTER("To Date",'<%1',"From Date");
    end;

    procedure CheckIfCauseExist(var Absence: Record "5207"): Boolean
    var
        EmpAbsence: Record "5207";
    begin
        EmpAbsence.SETRANGE("Employee No.",Absence."Employee No.");
        EmpAbsence.SETRANGE("Cause of Absence Code",Absence."Cause of Absence Code");
        IF EmpAbsence.FINDSET THEN
          REPEAT
            IF ((EmpAbsence."From Date" <= Absence."From Date") AND
               (EmpAbsence."To Date" <= Absence."To Date")) OR
               ((EmpAbsence."From Date" <= Absence."From Date") AND
               (EmpAbsence."To Date" >= Absence."To Date")) OR
               ((EmpAbsence."From Date" >= Absence."From Date") AND
               (EmpAbsence."To Date" <= Absence."To Date"))
            THEN BEGIN
              MESSAGE(TEXT002);
              EXIT(FALSE);
            END ELSE
              EXIT(TRUE);
          UNTIL EmpAbsence.NEXT = 0;
    end;

    procedure ValidateRec()
    var
        RecLEmployeeAbsenceEnreg: Record "60031";
    begin
               TESTFIELD("Employee No.");
               //TESTFIELD("Cause of Absence Code");
               TESTFIELD("From Date");
               //TESTFIELD("Agency Code");
               SecMgt.CheckIfHaveAccessToEmp1("Employee No.");
               TESTFIELD("External Document No.");

               ControlTotalAbsenceMois(Period,"Employee No.",Quantity);

               RecLEmployeeAbsenceEnreg.INIT;
               RecLEmployeeAbsenceEnreg."Employee No."              := "Employee No.";
               RecLEmployeeAbsenceEnreg.Period                      := Period;
               RecLEmployeeAbsenceEnreg."From Date"                 := "From Date";
               RecLEmployeeAbsenceEnreg."To Date"                   := "To Date";
               RecLEmployeeAbsenceEnreg."Cause of Absence Code"     := "Cause of Absence Code";
               RecLEmployeeAbsenceEnreg.Description                 := Description;
               RecLEmployeeAbsenceEnreg.Quantity                    := Quantity;
               RecLEmployeeAbsenceEnreg."Employee Name"             := "Employee Name";
               RecLEmployeeAbsenceEnreg.Paid              := Paid;
               RecLEmployeeAbsenceEnreg.Type := Rec.Type;
               RecLEmployeeAbsenceEnreg."Unité absence"             := "Unité absence";
               RecLEmployeeAbsenceEnreg."Quantité en journée"       := "Quantité en journée";
               //RecLEmployeeAbsenceEnreg."Agency Code"               := "Agency Code";
               RecLEmployeeAbsenceEnreg."Date Validation"           := "From Date";
               //RecLEmployeeAbsenceEnreg."Utilisateur Validation"    := USERID;
               RecLEmployeeAbsenceEnreg."External Document No." := "External Document No.";





               RecLEmployeeAbsenceEnreg.INSERT(TRUE);
    end;

    procedure ControlTotalAbsenceMois(CodePeriod: Code[20];EmployeeNo: Code[20];NewQty: Decimal)
    var
        PostedHSupp1: Record "60037";
        NbreHS: Decimal;
        RecLEmployeeAbsenceEnreg: Record "60031";
    begin
        NbreHS:=0;
        PaySetup.GET;
        RecLEmployeeAbsenceEnreg.RESET;
        RecLEmployeeAbsenceEnreg.SETRANGE("Employee No.",EmployeeNo);
        RecLEmployeeAbsenceEnreg.SETRANGE(RecLEmployeeAbsenceEnreg.Period,CodePeriod);
        IF RecLEmployeeAbsenceEnreg.FINDSET THEN
        REPEAT
           NbreHS := NbreHS + RecLEmployeeAbsenceEnreg.Quantity;
        UNTIL RecLEmployeeAbsenceEnreg.NEXT=0;

        IF (NbreHS+NewQty)>PaySetup."Nos Of WDay By Month" THEN
           ERROR(Text004,CodePeriod,NewQty);
    end;

    var
        HumanResSetup: Record "60013";
        SecMgt: Codeunit "60009";
        PaySetup: Record "60013";
        TEXT001: Label 'Impossible de valide la ligne %1 du salarié %2';
        TEXT002: Label 'Impossible de saisir deux absences de même motif pour un même salarié dans des périodes qui se chevauchent !';
        Text004: Label 'Le nombre d''absence ne doit pas être supérieur au nombre de jours de travail\pour la période de %1 \La quantité déjà saisie est de %2';
}

