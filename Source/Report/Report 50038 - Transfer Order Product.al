report 50038 "Transfer Order Product"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Transfer Order Product.rdl';
    Caption = 'Transfer Order';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Adjustment Header"; "Adjustment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Transfer Order';
            column(No_TransferHdr; "No.")
            {
            }
            column(TransFromBinCode_TransLine; "Adjustment Header"."Location Code")
            {
                IncludeCaption = true;
            }
            column(TransToBinCode_TransLine; "Adjustment Header"."Transfer-to Code")
            {
                IncludeCaption = true;
            }
            column(Camion_TransLine; "Adjustment Header"."Truck Code")
            {
            }
            column(TransportName; "Adjustment Header"."Transporter Name")
            {
            }
            column(NomChauffeur; "Adjustment Header".nomchauffeur)
            {
            }
            column(Permis; "Adjustment Header".permis)
            {
            }
            column(CarteGrise; "Adjustment Header".CarteGrise)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CopyCaption; StrSubstNo(Text001Lbl, CopyText))
                    {
                    }
                    column(TransferToAddr1; Location1.Name)
                    {
                    }
                    column(TransferFromAddr1; Location.Name)
                    {
                    }
                    column(TransferToAddr2; TransferToAddr[2])
                    {
                    }
                    column(TransferFromAddr2; TransferFromAddr[2])
                    {
                    }
                    column(TransferToAddr3; TransferToAddr[3])
                    {
                    }
                    column(TransferFromAddr3; TransferFromAddr[3])
                    {
                    }
                    column(TransferToAddr4; TransferToAddr[4])
                    {
                    }
                    column(TransferFromAddr4; TransferFromAddr[4])
                    {
                    }
                    column(TransferToAddr5; TransferToAddr[5])
                    {
                    }
                    column(TransferToAddr6; TransferToAddr[6])
                    {
                    }
                    column(InTransitCode_TransHdr; "Adjustment Header"."In-Transit Code")
                    {
                        IncludeCaption = true;
                    }
                    column(PostingDate_TransHdr; Format("Adjustment Header"."Posting Date", 0, 4))
                    {
                    }
                    column(TransferToAddr7; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr8; TransferToAddr[8])
                    {
                    }
                    column(TransferFromAddr5; TransferFromAddr[5])
                    {
                    }
                    column(TransferFromAddr6; TransferFromAddr[6])
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002Lbl, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ShptMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PrdCaption; PrdCaptionLbl)
                    {
                    }
                    column(CodeCaption; CodeCaptionLbl)
                    {
                    }
                    column(WeightCaption; WeightCaptionLbl)
                    {
                    }
                    column(ObsCaption; ObsCaptionLbl)
                    {
                    }
                    column(ExpCaption; ExpCaptionLbl)
                    {
                    }
                    column(DestCaption; DestCaptionLbl)
                    {
                    }
                    column(TelCaption; TelCaptionLbl)
                    {
                    }
                    column(BPCaption; BPCaptionLbl)
                    {
                    }
                    column(BacthCaptionLbl; BacthCaptionLbl)
                    {
                    }
                    column(PLVCaptionLbl; PLVCaptionLbl)
                    {
                    }
                    column(PCBCaptionLbl; PCBCaptionLbl)
                    {
                    }

                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(NumCaption; NumCaptionLbl)
                    {
                    }
                    column(TranspCaption; TranspCaptionLbl)
                    {
                    }
                    column(ChaufNameCaption; ChaufNameCaptionLbl)
                    {
                    }
                    column(PermisCaption; PermisCaptionLbl)
                    {
                    }
                    column(CamionCaption; CamionCaptionLbl)
                    {
                    }
                    column(CartGriseCaption; CartGriseCaptionLbl)
                    {
                    }
                    column(TotalWeightCaption; TotalWeightCaptionLbl)
                    {
                    }
                    column(CompanyInfoEMail; 'Email : ' + CompanyInfo."E-Mail")
                    {
                    }
                    column(Foot1; 'Siège social ' + CompanyInfo.Address)
                    {
                    }
                    column(Foot2; CompanyInfo."Post Code" + ' - ' + CompanyInfo.City)
                    {
                    }
                    column(Foot3; Foot3)
                    {
                    }
                    column(Foot4; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital" + ' - ' + 'NIF : ' + CompanyInfo."Registration No.")
                    {
                    }
                    column(Foot5; 'R.C.S. : ' + CompanyInfo."Trade Register" + ' - ' + 'STAT : ' + CompanyInfo."Legal Form")
                    {
                    }
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(FaxCaption; FaxCaptionLbl)
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    // column(CompanyInfoRCS; ' - R.C.S. : ' + CompanyInfo."Trade Register")
                    // {
                    // }
                    // column(CompanyInfoCA; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital")
                    // {
                    // }
                    // column(CompanyInfoNIF; 'NIF : ' + CompanyInfo."Registration No.")
                    // {
                    // }
                    // column(CompanyInfoSTAT; 'STAT : ' + CompanyInfo."Legal Form")
                    // {
                    // }
                    // column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    // {
                    // }
                    // column(CompanyInfoFax; CompanyInfo."Fax No.")
                    // {
                    // }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Adjustment Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number_DimensionLoop1; Number)
                        {
                        }
                        column(HdrDimensionsCaption; HdrDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet() then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Adjustment Line"; "Adjustment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Adjustment Header";
                        DataItemTableView = WHERE("Document Type" = CONST(Transfer));
                        column(ItemNo_TransLine; "Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_TransLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Qty_TransLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(UOM_TransLine; "Unit of Measure Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Qty_TransLineShipped; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(QtyReceived_TransLine; "Qty to receive Adj")
                        {
                            IncludeCaption = true;
                        }
                        column(LineNo_TransLine; "Line No.")
                        {
                        }
                        column(Weight_TransLine; Article."Gross Weight" * Quantity)
                        {
                        }
                        column(Batch_Number; "Batch Number")
                        {
                        }
                        column(Expiration_Date; Format("Expiration Date"))
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText2; DimText)
                            {
                            }
                            column(Number_DimensionLoop2; Number)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                            Article.Get("Adjustment Line"."Item No.");
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000Lbl;
                        OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                //FormatAddr.TransferHeaderTransferFrom(TransferFromAddr,"Adjustment Header");
                //FormatAddr.TransferHeaderTransferTo(TransferToAddr,"Transfer Header");

                Location.Get("Adjustment Header"."Location Code");
                Location1.Get("Adjustment Header"."Transfer-to Code");


                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init();

                FormatAddr.Company(CompanyAddr, CompanyInfo);

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";

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
                    field(NoOfCopie; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                        ToolTip = 'Specify No. of Copies';
                    }
                    field(ShowInternalInf; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specify Internal Information';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PostingDateCaption = 'Date';
        ShptMethodDescCaption = 'Shipment Method';
        Trans = 'ORDRE DE TRANSFERT';
        PrepareBy = 'Préparé par';
        AutoriseBy = 'Autorisé par';
        CondPaie = 'Conditions de paiement';
        Text1 = 'POUR GALANA';
        Text2 = 'Nom :';
        Text3 = 'Date :';
        Text10 = 'Siège Social';
        Text4 = 'POUR L''EXPEDITEUR';
        Text5 = 'POUR LE RECEPTIONNAIRE';
        ControlBy = 'Contrôle dépot :';
        ReceiptBy = 'Produit reçu conforme :';
        Text6 = 'Heure arrivée :';
        Text7 = 'Heure départ :';
        ValidatedBy = 'Validated by :';
        Security = 'SECURITY';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        CompanyInfo: Record "Company Information";
        CompanyInfos: Record "Company Information";
        Location: Record Location;
        Location1: Record Location;
        Article: Record Item;
        FormatAddr: Codeunit "Format Address";
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        NoOfCopies: Integer;
        Foot3: Text;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        HdrDimensionsCaptionLbl: Label 'Header Dimensions';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        Text000Lbl: Label 'COPY';
        Text001Lbl: Label 'Transfer Order %1', Comment = '';
        Text002Lbl: Label 'Page %1', Comment = '';
        BacthCaptionLbl: Label 'Batch';
        PLVCaptionLbl: Label 'PLV';
        PCBCaptionLbl: Label 'PCB';
        PrdCaptionLbl: Label 'Produit';
        CodeCaptionLbl: Label 'Code';
        WeightCaptionLbl: Label 'Poids (Kg)';
        ObsCaptionLbl: Label 'Observations';
        ExpCaptionLbl: Label 'EXPEDITEUR';
        DestCaptionLbl: Label 'Magasin de destination :  ';
        TelCaptionLbl: Label 'Tél/Fax : ';
        BPCaptionLbl: Label 'BP : ';
        EmailCaptionLbl: Label 'Email : ';
        NumCaptionLbl: Label 'N° : ';
        TranspCaptionLbl: Label 'TRANSPORTEUR :  ';
        ChaufNameCaptionLbl: Label 'NOM DU CHAUFFEUR :  ';
        PermisCaptionLbl: Label 'N° PERMIS : ';
        CamionCaptionLbl: Label 'CAMION : ';
        CartGriseCaptionLbl: Label 'N° CARTE GRISE : ';
        TotalWeightCaptionLbl: Label 'Total Poids';
        CompanyAddr: array[8] of Text[50];
        PhoneNoCaptionLbl: Label 'Tel :';
        // EMailCaptionLbl: Label 'E-Mail';
        FaxCaptionLbl: Label 'Fax : ';
}

