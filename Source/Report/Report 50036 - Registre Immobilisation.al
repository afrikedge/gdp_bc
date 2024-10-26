report 50036 "Registre Immobilisation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Registre Immobilisation.rdlc';

    dataset
    {
        dataitem("FA Depreciation Book"; "FA Depreciation Book")
        {
            DataItemTableView = WHERE("Depreciation Book Code" = CONST('FISCAL'));
            RequestFilterFields = "FA No.", "FA Posting Group";
            column(FA_No; "FA No.")
            {
            }
            column(Description; Description)
            {
            }
            column(Acquisition_Date; Format("Depreciation Starting Date"))
            {
            }
            column(Acquisition_Cost; "Acquisition Cost")
            {
            }
            column(Taux; "Straight-Line %")
            {
            }
            column(Valeur_Comptable; "Book Value")
            {
            }
            column(Reevaluation; Appreciation)
            {
            }
            column(Depreciation_Cost; Depreciation)
            {
            }
            column(PeriodAmort; PériodAmort)
            {
            }
            column(CptImmo; GrpCompta."Acquisition Cost Account")
            {
            }
            column(CptAmort; GrpCompta."Accum. Depreciation Account")
            {
            }
            column(Location_Name; Immo."FA Location Name")
            {
            }
            column(Codification; Immo.Codification)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(Code_Projet; Dimension."Dimension Value Code")
            {
            }
            column(DateDebutPeriod; DateDebutPeriod)
            {
            }
            column(DateFinPeriod; DateFinPeriod)
            {
            }
            column(AmortissementPeriode; AmortissementPeriode)
            {
            }
            column(aff; aff)
            {
            }

            trigger OnAfterGetRecord()
            var
                FADeprBook1: Record "FA Depreciation Book";
            begin
                PériodAmort := 0;
                Immo.Get("FA Depreciation Book"."FA No.");
                //IF Immo.MiseEnService=FALSE THEN
                //  CurrReport.SKIP;

                if "FA Depreciation Book"."Disposal Date" <> 0D then
                    CurrReport.Skip;

                Immo.CalcFields("FA Location Name");
                if "FA Depreciation Book"."FA Posting Group" <> '' then
                    GrpCompta.Get("FA Depreciation Book"."FA Posting Group");
                if ("FA Depreciation Book"."Last Depreciation Date" <> 0D) and ("FA Depreciation Book"."Depreciation Starting Date" <> 0D) then begin
                    //PériodAmort:= ROUND(("FA Depreciation Book"."Last Depreciation Date"-"FA Depreciation Book"."Depreciation Starting Date")/365*12,1,'=');
                    PériodAmort := GetNumberOfDepreciation(Immo."No.", DateDebutPeriod, DateFinPeriod);
                    //IF PériodAmort> (100/"FA Depreciation Book"."Straight-Line %"*12) THEN
                    //  PériodAmort:=100/"FA Depreciation Book"."Straight-Line %"*12;
                end;


                FADeprBook1.Get("FA Depreciation Book"."FA No.", "FA Depreciation Book"."Depreciation Book Code");
                FADeprBook1.SetFilter("FA Posting Date Filter", '%1..%2', DateDebutPeriod, DateFinPeriod);
                FADeprBook1.CalcFields(FADeprBook1.Depreciation);
                AmortissementPeriode := -FADeprBook1.Depreciation;


                //CumulAmortissement := "FA Depreciation Book".Depreciation;

                Dimension.Reset;
                Dimension.SetRange("Table ID", 5600);
                Dimension.SetRange("No.", "FA No.");
                Dimension.SetRange("Dimension Code", 'PROJET');
                if Dimension.FindFirst then;

                aff := AfficheReclass("FA Depreciation Book");
            end;

            trigger OnPreDataItem()
            begin
                if DateDebutPeriod = 0D then Error(Text001);
                if DateFinPeriod = 0D then Error(Text002);
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));
            column(CompanyInfo_Picture; CompanyInfo."Administrative Picture")
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateDebutPeriod; DateDebutPeriod)
                {
                    Caption = 'Starting Date';
                }
                field(DateFinPeriod; DateFinPeriod)
                {
                    Caption = 'Ending Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        code = 'N° Immo';
        Desc = 'Description';
        Acqui_Date = 'Date de début amortissement';
        TauxCaption = 'Taux fiscal';
        Cap = 'Capital';
        Amort = 'Amort';
        Val_Res = 'Valeur Résiduelle';
        PerAmort = 'Pers Amort';
        Adjust = 'Adjust';
        CpteImmo = 'N° de compte Immo';
        CpteAmort = 'N° de compte Amt';
        Projet = 'N° Projet';
        Empl = 'Emplacement';
        Codif = 'Codification';
        Titre = 'REGISTRE D''IMMOBILISATIONS';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.CalcFields("Administrative Picture");
    end;

    var
        "PériodAmort": Decimal;
        CptImmo: Code[20];
        CptAmort: Code[20];
        Immo: Record "Fixed Asset";
        CompanyInfo: Record "Company Information";
        Taux: Decimal;
        CurrReportPageNoCaptionLbl: Label 'Page';
        GrpCompta: Record "FA Posting Group";
        test: Date;
        Dimension: Record "Default Dimension";
        DateDebutPeriod: Date;
        DateFinPeriod: Date;
        AmortissementPeriode: Decimal;
        CumulAmortissement: Decimal;
        Text001: Label 'La date début ne doit pas être vide';
        Text002: Label 'La date fin ne doit pas être vide';
        aff: Boolean;

    local procedure AfficheReclass(ImmoAReclass: Record "FA Depreciation Book") affich: Boolean
    var
        FALegEntry: Record "FA Ledger Entry";
    begin
        FALegEntry.SetRange(FALegEntry."FA No.", ImmoAReclass."FA No.");
        if ImmoAReclass."Acquisition Cost" = 0 then
            if FALegEntry.FindLast then
                if FALegEntry."Reclassification Entry" = true then
                    affich := true
                else
                    affich := false;
    end;

    procedure NbreOfMonthsInPeriod(Day1: Date; Day2: Date) NoOfMonthsInPeriod: Integer
    var
        Wdate: Date;
        FirstDayinCrntMonth: Date;
        LastDayinCrntMonth: Date;
    begin
        NoOfMonthsInPeriod := 0;

        if Day1 > Day2 then
            exit(0);
        if Day1 = 0D then
            exit(0);
        if Day2 = 0D then
            exit(0);

        /*
        Wdate := Day1;
        REPEAT
          FirstDayinCrntMonth := CALCDATE('<-CM>',Wdate);
          LastDayinCrntMonth := CALCDATE('<CM>',Wdate);
          IF (Wdate = FirstDayinCrntMonth) AND (LastDayinCrntMonth <= Day2) THEN BEGIN
            NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
            Wdate := LastDayinCrntMonth + 1;
          END ELSE BEGIN
            Wdate := Wdate + 1;
          END;
        UNTIL Wdate > Day2;
        */


        Wdate := Day1;
        repeat
            Wdate := CalcDate('<1M>', Wdate);
            if Wdate <= Day2 then
                NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
        until Wdate > Day2;

    end;

    local procedure GetNumberOfDepreciation(FANo: Code[20]; StartingDate: Date; EndingDate: Date): Integer
    var
        FAEntry: Record "FA Ledger Entry";
    begin
        FAEntry.Reset;
        FAEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "FA Posting Date");
        FAEntry.SetRange(FAEntry."FA No.", FANo);
        FAEntry.SetFilter(FAEntry."Posting Date", '..%1', EndingDate);
        FAEntry.SetRange(FAEntry."FA Posting Type", FAEntry."FA Posting Type"::Depreciation);
        exit(FAEntry.Count);
    end;
}

