report 50022 "Fixed Asset - Rebut"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Fixed Asset - Rebut.rdlc';
    Caption = 'Fixed Asset - Rebut';

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";
            column(CompanyName; CompanyName)
            {
            }
            column(DeprBookText; DeprBookText)
            {
            }
            column(FixAssetTableCaptFaFilter; TableCaption + ': ' + FAFilter)
            {
            }
            column(No_FixedAsset; "No.")
            {
            }
            column(Desc_FixedAsset; Description)
            {
            }
            column(LocCode_FixedAsset; "FA Location Name")
            {
            }
            column(RespEmp_FixedAsset; "Responsible Employee")
            {
            }
            column(SerialNo_FixedAsset; "Serial No.")
            {
            }
            column(FaDeprBookAcquDate; Format(FADeprBook."G/L Acquisition Date"))
            {
            }
            column(FixedAssetAcqListCptn; FixedAssetAcqListCptnLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(FADeprBkAcquisitionDtCptn; FADeprBkAcquisitionDtCptnLbl)
            {
            }
            column(MarqueCaption; MarqueCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(NbreCaption; NbreCaptionLbl)
            {
            }
            column(DetenteurCaption; DetenteurCaptionLbl)
            {
            }
            column(ObservationCaption; ObservationCaptionLbl)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo."Administrative Picture")
            {
            }
            column(FAOwner_FixedAsset; FAOwnerName)
            {
            }
            column(Quantity_FixedAsset; Quantity)
            {
            }
            column(StartupDate_FixedAsset; Format("Startup Date"))
            {
            }
            column(Desc_FixedAssetCaption; Desc_FixedAssetCaptionLbl)
            {
            }
            column(FixedAssetNoCaption; FixedAssetNoCaptionLbl)
            {
            }
            column(ValeurNetteCaption; ValeurNetteCaptionLbl)
            {
            }
            column(LocationCaption; LocationCaptionLbl)
            {
            }
            column(VendorCaption; VendCaptionLbl)
            {
            }
            column(ValeurComptable; PlanAmort."Book Value")
            {
            }
            column(Codification_FixedAsset; "Fixed Asset".Codification)
            {
            }
            column(Vendor_Name; NomFsseur)
            {
            }
            column(GenerateNum; GenerateNum)
            {
            }
            column(DateAcq; Format(FADeprBook."Depreciation Starting Date"))
            {
            }

            trigger OnAfterGetRecord()
            var
                Vend: Record Vendor;
            begin
                Clear(FADeprBook);
                PrintFA := true;

                if FADeprBook.Get("No.", DeprBookCode) then;
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
                if "Fixed Asset"."FA Owner" <> '' then
                    FAOwner.Get("Fixed Asset"."FA Owner");
                if FAOwner.FindFirst then
                    FAOwnerName := FAOwner.Name;
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                CompanyInfo.CalcFields("Administrative Picture");
                PlanAmort.SetRange("FA No.", "Fixed Asset"."No.");
                PlanAmort.SetRange("Depreciation Book Code", FASetup."Default Depr. Book");
                if PlanAmort.FindFirst then
                    PlanAmort.CalcFields("Book Value");

                NomFsseur := '';
                if Vend.Get("Fixed Asset"."Vendor No.") then
                    NomFsseur := Vend.Name;

            end;

            trigger OnPostDataItem()
            begin
                if not CurrReport.Preview then
                    GenerateNum := FAMgt.GenerateNosRebus(true);
            end;

            trigger OnPreDataItem()
            begin
                GenerateNum := FAMgt.GenerateNosRebus(false);
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
                    field(DeprBookCode; DeprBookCode)
                    {
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                    }
                    field(FAWithoutAcqDate; FAWithoutAcqDate)
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
        RespAchat = 'DEPARTEMENT OU SERVICE (DOP/SGX/DIT,...)';
        Mag = 'MAGASIN';
        Det = 'DETENTEUR';
        CSImm = 'CS IMMOBILISATIONS';
        CDCom = 'CD COMPTABILITE';
        Obj = 'Objet :';
        Num = 'No  :';
        Date = 'Date Fiche  :';
        Ref = 'Réf  :';
        AnDet = 'ANCIEN DETENTEUR';
        NovDet = 'NOUVEAU DETENTEUR';
        Text005 = '- Les personnels ou représentants du société';
        Text006 = '- Les gérants pour les stations ou DCR pour les stations en GD';
        Text007 = '- Les clients B2B pour installations hors réseau';
        Text008 = '- Le responsable de départment (DOP/SGX/DIT) qui a fait';
        Text009 = 'la demande';
        Version = 'Num de la version  :';
        DateVersion = 'Date de la version  :';
        Page = 'Page  :';
        Code = 'CODE D''IMMOBILISATION';
        DAF = 'DIRECTEUR FINANCIER ET INFORMATIQUE';
        DG = 'DIRECTEUR GENERAL';
        AcDateLib = 'Date d''acquisition';
    }

    trigger OnInitReport()
    begin
        FASetup.Get;
    end;

    trigger OnPreReport()
    begin
        FAGenReport.AppendFAPostingFilter("Fixed Asset", StartingDate, EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
        DeprBookText := StrSubstNo('%1%2 %3', DeprBook.TableCaption, ':', DeprBookCode);
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
        ObservationCaptionLbl: Label 'OBSERVATIONS';
        CompanyInfo: Record "Company Information";
        Desc_FixedAssetCaptionLbl: Label 'DESCRIPTION';
        FixedAssetNoCaptionLbl: Label 'No IMMO';
        FAOwner: Record "FA Owner";
        FAOwnerName: Text[30];
        ValeurNetteCaptionLbl: Label 'VALEUR NETTE COMPTABLE';
        VendCaptionLbl: Label 'FOURNISSEUR';
        PlanAmort: Record "FA Depreciation Book";
        NomFsseur: Text[50];
        GenerateNum: Code[20];
        FAMgt: Codeunit "FA Mgt";

    local procedure ValidateDates(StartingDate: Date; EndingDate: Date)
    begin
        if StartingDate = 0D then
            Error(Text001);

        if EndingDate = 0D then
            Error(Text002);

        if StartingDate > EndingDate then
            Error(Text003);
    end;
}

