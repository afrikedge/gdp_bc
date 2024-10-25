report 50027 "Fixed Asset - Cession"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Fixed Asset - Cession.rdlc';
    Caption = 'Fixed Asset - Cession';

    dataset
    {
        dataitem("Fixed Asset";"Fixed Asset")
        {
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code","Budgeted Asset";
            column(CompanyName;CompanyName)
            {
            }
            column(DeprBookText;DeprBookText)
            {
            }
            column(FixAssetTableCaptFaFilter;TableCaption + ': ' + FAFilter)
            {
            }
            column(No_FixedAsset;"No.")
            {
            }
            column(Desc_FixedAsset;Description)
            {
            }
            column(LocCode_FixedAsset;"FA Location Name")
            {
            }
            column(RespEmp_FixedAsset;"Responsible Employee")
            {
            }
            column(SerialNo_FixedAsset;"Serial No.")
            {
            }
            column(FaDeprBookAcquDate;Format(FADeprBook."Acquisition Date"))
            {
            }
            column(FixedAssetAcqListCptn;FixedAssetAcqListCptnLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(FADeprBkAcquisitionDtCptn;FADeprBkAcquisitionDtCptnLbl)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo."Administrative Picture")
            {
            }
            column(FAOwner_FixedAsset;FAOwnerName)
            {
            }
            column(Quantity_FixedAsset;Quantity)
            {
            }
            column(StartupDate_FixedAsset;Format("Startup Date"))
            {
            }
            column(Desc_FixedAssetCaption;Desc_FixedAssetCaptionLbl)
            {
            }
            column(FixedAssetNoCaption;FixedAssetNoCaptionLbl)
            {
            }
            column(LocationCaption;LocationCaptionLbl)
            {
            }
            column(CustomerCaption;CustCaptionLbl)
            {
            }
            column(ValeurComptable;PlanAmort."Book Value")
            {
            }
            column(UnitPriceCaption;UnitPriceCaptionLbl)
            {
            }
            column(TaxeCaption;TaxeCaptionLbl)
            {
            }
            column(TotalPriceCaption;TotalPriceCaption)
            {
            }
            column(TotalCaption;TotalCaption)
            {
            }
            column(GenerateNum;GenerateNum)
            {
            }
            column(Codification;Codification)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(FADeprBook);
                PrintFA := true;
                /*IF NOT FADeprBook.GET("No.",DeprBookCode) THEN BEGIN
                  IF FAWithoutAcqDate THEN
                    PrintFA := TRUE;
                END ELSE BEGIN
                  IF FADeprBook."Acquisition Date" = 0D THEN BEGIN
                    IF FAWithoutAcqDate THEN
                      PrintFA := TRUE;
                  END ELSE
                    PrintFA := ("Fixed Asset"."Startup Date"=0D)
                END;*/
                
                //PrintFA := ("Fixed Asset"."Startup Date"=0D);
                
                if not PrintFA then
                  CurrReport.Skip;
                
                if "Fixed Asset"."FA Owner"<>'' then
                  FAOwner.Get("Fixed Asset"."FA Owner");
                if FAOwner.FindFirst then
                  FAOwnerName:=FAOwner.Name;
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                CompanyInfo.CalcFields("Administrative Picture");
                PlanAmort.SetRange("FA No.","Fixed Asset"."No.");
                PlanAmort.SetRange("Depreciation Book Code",FASetup."Default Depr. Book");
                if PlanAmort.FindFirst then
                  PlanAmort.CalcFields("Book Value");

            end;

            trigger OnPostDataItem()
            begin
                if not CurrReport.Preview then
                  GenerateNum:=FAMgt.GenerateNosCession(true);
            end;

            trigger OnPreDataItem()
            begin
                GenerateNum := FAMgt.GenerateNosCession(false);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DeprBookCode;DeprBookCode)
                    {
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                    }
                    field(FAWithoutAcqDate;FAWithoutAcqDate)
                    {
                        Caption = 'Include Fixed Assets Not Yet Acquired';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DeprBookCode = '' then begin
              FASetup.Get;
              DeprBookCode := FASetup."Default Depr. Book";
            end;
        end;
    }

    labels
    {
        DAF = 'DIRECTEUR FINANCIER ET INFORMATIQUE';
        DG = 'DIRECTEUR GENERAL';
        DOP = 'DEPARTEMENT OU SERVICE (DOP/SGX/DIT,...)';
        CSImm = 'CS IMMOBILISATIONS';
        CDCom = 'CD COMPTABILITE';
        Obj = 'Objet :';
        Num = 'No  :';
        Date = 'Date Fiche  :';
        Ref = 'Réf  :';
        Text005 = 'DOP: MATERIAUX STATIONS - CONSO -DEPOT';
        Text006 = 'SGX: LOGEMENT, SIEGE, AGENCES ET MANDATAIRES';
        Text007 = 'DIT: TOUTES MATERIAUX INFORMATIQUE';
        Version = 'Num de la version  :';
        DateVersion = 'Date de la version  :';
        Page = 'Page  :';
        Code = 'CODE D''IMMOBILISATION';
        ValRes = 'Valeur résiduelle';
    }

    trigger OnInitReport()
    begin
        FASetup.Get;
    end;

    trigger OnPreReport()
    begin
        FAGenReport.AppendFAPostingFilter("Fixed Asset",StartingDate,EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
        DeprBookText := StrSubstNo('%1%2 %3',DeprBook.TableCaption,':',DeprBookCode);
        //ValidateDates(StartingDate,EndingDate);
        //FAGenReport.ValidateDates(StartingDate,EndingDate);
    end;

    var
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        FADeprBook: Record "FA Depreciation Book";
        FAGenReport: Codeunit "FA General Report";
        DeprBookCode: Code[10];
        DeprBookText: Text[50];
        FAFilter: Text;
        StartingDate: Date;
        EndingDate: Date;
        FAWithoutAcqDate: Boolean;
        PrintFA: Boolean;
        Text001: Label 'You must specify a Starting Date.';
        Text002: Label 'You must specify an Ending Date.';
        Text003: Label 'You must specify an Ending Date that is later than the Starting Date.';
        FixedAssetAcqListCptnLbl: Label 'Fixed Asset - Acquisition List';
        CurrReportPageNoCaptionLbl: Label 'Page';
        FADeprBkAcquisitionDtCptnLbl: Label 'Acquisition Date';
        MarqueCaptionLbl: Label 'MARQUE';
        TypeCaptionLbl: Label 'TYPE';
        NbreCaptionLbl: Label 'NOMBRE';
        DetenteurCaptionLbl: Label 'NOM ET MATRICULE DU DETENTEUR';
        LocationCaptionLbl: Label 'LOCATION';
        NewLocCaptionLbl: Label 'NOUVEL EMPLACEMENT';
        TotalCaption: Label 'TOTAL';
        CompanyInfo: Record "Company Information";
        Desc_FixedAssetCaptionLbl: Label 'DESCRIPTION';
        FixedAssetNoCaptionLbl: Label 'No IMMO';
        FAOwner: Record "FA Owner";
        FAOwnerName: Text[30];
        ValeurNetteCaptionLbl: Label 'VALEUR NETTE COMPTABLE';
        CustCaptionLbl: Label 'NOM ACHETEUR';
        PlanAmort: Record "FA Depreciation Book";
        UnitPriceCaptionLbl: Label 'PRIX DE CESSION HT';
        TaxeCaptionLbl: Label 'TVA 20%';
        TotalPriceCaption: Label 'PRIX DE CESSION TTC';
        GenerateNum: Code[20];
        FAMgt: Codeunit "FA Mgt";

    local procedure ValidateDates(StartingDate: Date;EndingDate: Date)
    begin
        if StartingDate = 0D then
          Error(Text001);

        if EndingDate = 0D then
          Error(Text002);

        if StartingDate > EndingDate then
          Error(Text003);
    end;
}

