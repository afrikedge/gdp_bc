report 50029 "Fixed Asset - Inventaire"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Fixed Asset - Inventaire.rdlc';
    Caption = 'Fixed Asset - Inventory';
    ApplicationArea = All;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Posting Group", "FA Location Code";
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
                IncludeCaption = true;
            }
            column(Desc_FixedAsset; Description)
            {
            }
            column(LocCode_FixedAsset; "FA Location Name")
            {
                IncludeCaption = true;
            }
            column(RespEmp_FixedAsset; "Responsible Employee")
            {
                IncludeCaption = true;
            }
            column(SerialNo_FixedAsset; "Serial No.")
            {
                IncludeCaption = true;
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
            column(MarqueCaption; MarqueCaptionLbl)
            {
            }
            column(TypeCaption; TypeCaptionLbl)
            {
            }
            column(DetenteurCaption; DetenteurCaptionLbl)
            {
            }
            column(EmplacementCaption; EmplacementCaptionLbl)
            {
            }
            column(ObservationCaption; ObservationCaptionLbl)
            {
            }
            column(Brand_FixedAsset; Brand)
            {
            }
            column(FAType_FixedAsset; "FA Type")
            {
            }
            column(FAOwner_FixedAsset; "FA Owner")
            {
            }
            column(Quantity_FixedAsset; Quantity)
            {
            }
            column(StartupDate_FixedAsset; Format(FADeprBook."Acquisition Date"))
            {
            }
            column(Desc_FixedAssetCaption; Desc_FixedAssetCaptionLbl)
            {
            }
            column(VendCaption; VendCaptionLbl)
            {
            }
            column(InventoryDate; InventoryDate)
            {
            }
            column(DetName; DetName)
            {
            }
            column(WorkerName; WorkerName)
            {
            }
            column(CodificationCaption; CodificationCaptionLbl)
            {
            }
            column(GenerateNum; GenerateNum)
            {
            }
            column(Codification; Codification)
            {
            }
            column(Fournisseur; "Vendor No.")
            {
            }
            column(NomFseur; NomFseur)
            {
            }
            column(NumReference; NumReference)
            {
            }

            trigger OnAfterGetRecord()
            var
                Vend: Record Vendor;
            begin
                Clear(FADeprBook);
                PrintFA := true;

                if not FADeprBook.Get("No.", DeprBookCode) then
                    CurrReport.Skip;
                //IF FADeprBook."Acquisition Date" <> 0D THEN
                //  PrintFA := TRUE;

                if FADeprBook."Disposal Date" <> 0D then
                    CurrReport.Skip;

                if not PrintFA then
                    CurrReport.Skip;

                if ProjectCode <> '' then
                    if (DoSkipFixedAsset("Fixed Asset")) then
                        CurrReport.Skip;

                NomFseur := '';
                if Vend.Get("Fixed Asset"."Vendor No.") then
                    NomFseur := Vend.Name;

                NumReference := GenerateNum + '/' + Format(Date2DMY(Today, 2)) + '/' + Format(Date2DMY(Today, 3)) + '/...     ';
            end;

            trigger OnPostDataItem()
            begin

                if not CurrReport.Preview then
                    GenerateNum := FAMgt.GenerateNosInventaire(true);
            end;

            trigger OnPreDataItem()
            begin
                GenerateNum := FAMgt.GenerateNosInventaire(false);

                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                CompanyInfo.CalcFields("Administrative Picture");
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
                    field(ProjectCode; ProjectCode)
                    {
                        Caption = 'Filtre Code projet';
                        TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                      "Dimension Value Type" = FILTER(Standard));
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
        RespInv = 'RESPONSABLES INVENTAIRE';
        Mag = 'MAGASIN';
        Det = 'DETENTEUR';
        CSImm = 'CS IMMOBILISATIONS';
        CDCom = 'CD COMPTABILITE';
        Obj = 'Objet :';
        Num = 'No  :';
        Date = 'Date Fiche  :';
        Ref = 'Réf  :';
        Version = 'Num de la version  :';
        DateVersion = 'Date de la version  :';
        Page = 'Page  :';
        Code = 'No Immo';
        Bon = 'BON';
        Moyen = 'MOYEN';
        Mauvais = 'MAUVAIS';
        HorsService = 'HORS SERVICE';
        Text001 = 'DETENTEUR/Gérants pour les Stations - Client B2B pour les Consommateurs';
        Serial = 'Référence ou No de série';
    }

    trigger OnPreReport()
    begin
        FAGenReport.AppendFAPostingFilter("Fixed Asset", StartingDate, EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
        DeprBookText := StrSubstNo('%1%2 %3', DeprBook.TableCaption, ':', DeprBookCode);
        //ValidateDates(StartingDate,EndingDate);
        //FAGenReport.ValidateDates(StartingDate,EndingDate);
        if DeprBookCode = '' then
            Error(Text004);
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
        MarqueCaptionLbl: Label 'Marque';
        TypeCaptionLbl: Label 'Type';
        VendCaptionLbl: Label 'Fournisseurs';
        DetenteurCaptionLbl: Label 'Détenteur';
        EmplacementCaptionLbl: Label 'Emplacement';
        ObservationCaptionLbl: Label 'Observations complémentaires';
        CompanyInfo: Record "Company Information";
        Desc_FixedAssetCaptionLbl: Label 'Description';
        CodificationCaptionLbl: Label 'Codifications';
        InventoryDate: Label 'DATE INVENTAIRE : ';
        DetName: Label 'NOM ET SIGNATURE DETENTEUR : ';
        WorkerName: Label 'NOM ET SIGNATURE DE LA PERSONNE QUI EFFECTUE L''INVENTAIRE :  ';
        Text004: Label 'Vous devez choisir la loi d''amortissement';
        GenerateNum: Code[20];
        FAMgt: Codeunit "FA Mgt";
        NomFseur: Text[100];
        ProjectCode: Code[20];
        NumReference: Text;

    local procedure ValidateDates(StartingDate: Date; EndingDate: Date)
    begin
        if StartingDate = 0D then
            Error(Text001);

        if EndingDate = 0D then
            Error(Text002);

        if StartingDate > EndingDate then
            Error(Text003);
    end;

    local procedure DoSkipFixedAsset(FA: Record "Fixed Asset"): Boolean
    var
        FALocation: Record "FA Location";
    begin
        if ProjectCode = '' then exit(false);
        if FA."FA Location Code" = '' then exit(true);
        if (FALocation.Get(FA."FA Location Code")) then begin
            if FALocation."Project Code" <> ProjectCode then exit(true);
        end;
    end;
}

