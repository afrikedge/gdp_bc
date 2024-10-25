report 50028 "FA - Cession sur F Compta"
{
    DefaultLayout = RDLC;
    RDLCLayout = './FA - Cession sur F Compta.rdlc';
    Caption = 'Fixed Asset - Cession ON JOURNAL';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            RequestFilterFields = "Journal Template Name", "Journal Batch Name";
            column(JournalTemplate; "Journal Template Name")
            {
            }
            column(JournalName; "Journal Batch Name")
            {
            }
            column(UnitPrice; Amount)
            {
            }
            column(VAT_Amount; "VAT Amount")
            {
            }
            column(PostingDate; Format("Posting Date"))
            {
            }
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
                column(FaDeprBookAcquDate; Format(FADeprBook."Acquisition Date"))
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
                column(CompanyInfo_Picture; CompanyInfo.Picture)
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
                column(LocationCaption; LocationCaptionLbl)
                {
                }
                column(CustomerCaption; CustCaptionLbl)
                {
                }
                column(ValeurComptable; PlanAmort."Book Value")
                {
                }
                column(UnitPriceCaption; UnitPriceCaptionLbl)
                {
                }
                column(TaxeCaption; TaxeCaptionLbl)
                {
                }
                column(TotalPriceCaption; TotalPriceCaption)
                {
                }
                column(TotalCaption; TotalCaption)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(FADeprBook);
                    PrintFA := true;


                    if not PrintFA then
                        CurrReport.Skip;

                    if "Fixed Asset"."FA Owner" <> '' then
                        FAOwner.Get("Fixed Asset"."FA Owner");
                    if FAOwner.FindFirst then
                        FAOwnerName := FAOwner.Name;
                    CompanyInfo.Get;
                    CompanyInfo.CalcFields(Picture);
                    PlanAmort.SetRange("FA No.", "Fixed Asset"."No.");
                    PlanAmort.SetRange("Depreciation Book Code", FASetup."Default Depr. Book");
                    if PlanAmort.FindFirst then
                        PlanAmort.CalcFields("Book Value");
                end;

                trigger OnPreDataItem()
                begin
                    "Fixed Asset".Get("Gen. Journal Line"."Account No.");
                    if "Fixed Asset".FindFirst then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::"Fixed Asset" then
                    Error(Text005);
                if "Gen. Journal Line"."Account No." = '' then
                    Error(Text007);
                if "Gen. Journal Line"."FA Posting Type" <> "Gen. Journal Line"."FA Posting Type"::Disposal then
                    Error(Text006);
                JournalTemplate.SetRange(Name, "Gen. Journal Line"."Journal Template Name");
                if JournalTemplate.FindFirst then
                    if JournalTemplate.Type <> JournalTemplate.Type::Assets then
                        Error(Text004)
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
        DAF = 'DIRECTEUR ADMINISTRATIF ET FIANCIER';
        DG = 'DIRECTEUR GENERALE';
        DOP = 'DOP/SGX/DIT';
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
        Text004: Label '%1 or %2 must be specified.';
        Text005: Label 'Type de compte doit être immobilisation';
        Text006: Label 'Type compta immo doit être cession ';
        Text007: Label 'Vous devez choisir une immobilisation à ceder';
        JournalTemplate: Record "Gen. Journal Template";

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

