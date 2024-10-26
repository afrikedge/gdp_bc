page 50335 "Dispaching Events"
{
    Caption = 'Dispaching Statistiques';
    DataCaptionExpression = MonthName;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                Visible = false;
                field(MonthName;MonthName)
                {
                    Visible = false;
                }
            }
            part(DispachEventMatrix;"Dispach Event Matrix")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Period")
            {
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                    //  EXIT;
                    //FindPeriod('<');
                    ActualDate := CalcDate('<-1M>',ActualDate);
                    MonthName := GetDescrMois(ActualDate);
                    CurrPage.Update;
                    CurrPage.DispachEventMatrix.PAGE.LoadData(ActualDate);
                    //UpdateMatrixSubform;
                end;
            }
            action("Next Period")
            {
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                    //  EXIT;
                    //FindPeriod('>');
                    ActualDate := CalcDate('<1M>',ActualDate);
                    MonthName := GetDescrMois(ActualDate);
                    CurrPage.Update;
                    //UpdateMatrixSubform;
                    CurrPage.DispachEventMatrix.PAGE.LoadData(ActualDate);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ActualDate := GetDebutMois(WorkDate,0);
        MonthName := GetDescrMois(ActualDate);
        CurrPage.Update;
        //UpdateMatrixSubform;
        CurrPage.DispachEventMatrix.PAGE.LoadData(ActualDate);
    end;

    var
        MonthName: Text;
        ActualMonth: Integer;
        ActualYear: Integer;
        ActualDate: Date;

    procedure GetDebutMois(DateRef: Date;AnneesRef: Integer): Date
    begin
        if DateRef<>0D then
           exit(DMY2Date(1,Date2DMY(DateRef,2),Date2DMY(DateRef,3)-AnneesRef));   //Debut de l'année de DateRef - AnneeRef
    end;

    procedure GetDescrMois(date1: Date): Text[50]
    var
        textJan: Label 'Janvier';
        textFev: Label 'Février';
        textMars: Label 'Mars';
        textAvr: Label 'Avril';
        textMai: Label 'Mai';
        textJuin: Label 'Juin';
        textJuillet: Label 'Juillet';
        textAout: Label 'Août';
        textSept: Label 'Septembre';
        textOct: Label 'Octobre';
        textNov: Label 'Novembre';
        textDec: Label 'Décembre';
        Mois: Integer;
    begin
        Mois := Date2DMY(date1,2);
        if Mois=1 then exit(StrSubstNo('%1 %2',textJan,Date2DMY(date1,3)));
        if Mois=2 then exit(StrSubstNo('%1 %2',textFev,Date2DMY(date1,3)));
        if Mois=3 then exit(StrSubstNo('%1 %2',textMars,Date2DMY(date1,3)));
        if Mois=4 then exit(StrSubstNo('%1 %2',textAvr,Date2DMY(date1,3)));
        if Mois=5 then exit(StrSubstNo('%1 %2',textMai,Date2DMY(date1,3)));
        if Mois=6 then exit(StrSubstNo('%1 %2',textJuin,Date2DMY(date1,3)));
        if Mois=7 then exit(StrSubstNo('%1 %2',textJuillet,Date2DMY(date1,3)));
        if Mois=8 then exit(StrSubstNo('%1 %2',textAout,Date2DMY(date1,3)));
        if Mois=9 then exit(StrSubstNo('%1 %2',textSept,Date2DMY(date1,3)));
        if Mois=10 then exit(StrSubstNo('%1 %2',textOct,Date2DMY(date1,3)));
        if Mois=11 then exit(StrSubstNo('%1 %2',textNov,Date2DMY(date1,3)));
        if Mois=12 then exit(StrSubstNo('%1 %2',textDec,Date2DMY(date1,3)));
    end;
}

