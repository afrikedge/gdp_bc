report 50063 "Consignation Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Consignation Order.rdlc';
    Caption = 'Transfer Order';
    PreviewMode = PrintLayout;

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
                    column(CopyCaption; StrSubstNo(Text001, CopyText))
                    {
                    }
                    column(TransferToAddr1; StrSubstNo(TextDestination, Cust."No.", Cust.Name))
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
                    column(PageCaption; StrSubstNo(Text002, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ShptMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PrdCaption; PrdCaption)
                    {
                    }
                    column(CodeCaption; CodeCaption)
                    {
                    }
                    column(WeightCaption; WeightCaption)
                    {
                    }
                    column(ObsCaption; ObsCaption)
                    {
                    }
                    column(ExpCaption; ExpCaption)
                    {
                    }
                    column(DestCaption; DestCaption)
                    {
                    }
                    column(TelCaption; TelCaption)
                    {
                    }
                    column(BPCaption; BPCaption)
                    {
                    }
                    column(EmailCaption; EmailCaption)
                    {
                    }
                    column(NumCaption; NumCaption)
                    {
                    }
                    column(TranspCaption; TranspCaption)
                    {
                    }
                    column(ChaufNameCaption; ChaufNameCaption)
                    {
                    }
                    column(PermisCaption; PermisCaption)
                    {
                    }
                    column(CamionCaption; CamionCaption)
                    {
                    }
                    column(CartGriseCaption; CartGriseCaption)
                    {
                    }
                    column(TotalWeightCaption; TotalWeightCaption)
                    {
                    }
                    column(CompanyInfoEMail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoRCS; ' - R.C.S. : ' + CompanyInfo."Trade Register")
                    {
                    }
                    column(CompanyInfoCA; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital")
                    {
                    }
                    column(CompanyInfoNIF; 'NIF : ' + CompanyInfo."Registration No.")
                    {
                    }
                    column(CompanyInfoSTAT; 'STAT : ' + CompanyInfo."Legal Form")
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoFax; CompanyInfo."Fax No.")
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
                    column(CompanyInfo_Picture; CompanyInfo.Picture)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(FaxCaption; FaxCaptionLbl)
                    {
                    }
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
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

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
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Adjustment Line"; "Adjustment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Adjustment Header";
                        DataItemTableView = WHERE("Document Type" = CONST(Consignation));
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
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

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
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;
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
                        CopyText := Text000;
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
            var
                AdjLine: Record "Adjustment Line";
            begin
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                //FormatAddr.TransferHeaderTransferFrom(TransferFromAddr,"Adjustment Header");
                //FormatAddr.TransferHeaderTransferTo(TransferToAddr,"Transfer Header");


                AdjLine.Reset;
                AdjLine.SetRange(AdjLine."Document Type", AdjLine."Document Type"::Consignation);
                AdjLine.SetRange(AdjLine."Document No.", "Adjustment Header"."No.");
                if AdjLine.FindFirst then;

                AdjLine.TestField(AdjLine."Location Code");

                Location.Get(AdjLine."Location Code");
                //Location1.GET("Adjustment Header"."Transfer-to Code");


                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;

                FormatAddr.Company(CompanyAddr, CompanyInfo);

                Cust.Get("Adjustment Header"."Customer No.");
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
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
        PostingDateCaption = 'Posting Date';
        ShptMethodDescCaption = 'Shipment Method';
        Trans = 'ORDRE DE TRANSFERT POUR CONSIGNATION';
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
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Text000: Label 'COPY';
        Text001: Label 'Transfer Order %1';
        Text002: Label 'Page %1';
        ShipmentMethod: Record "Shipment Method";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        FormatAddr: Codeunit "Format Address";
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        HdrDimensionsCaptionLbl: Label 'Header Dimensions';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        PrdCaption: Label 'Produit';
        CodeCaption: Label 'Code';
        WeightCaption: Label 'Poids (Kg)';
        ObsCaption: Label 'Observations';
        ExpCaption: Label 'EXPEDITEUR';
        DestCaption: Label 'Destination :  ';
        TelCaption: Label 'Tél/Fax : ';
        BPCaption: Label 'BP : ';
        EmailCaption: Label 'Email : ';
        NumCaption: Label 'N° : ';
        TranspCaption: Label 'TRANSPORTEUR :  ';
        ChaufNameCaption: Label 'NOM DU CHAUFFEUR :  ';
        PermisCaption: Label 'N° PERMIS : ';
        CamionCaption: Label 'CAMION : ';
        CartGriseCaption: Label 'N° CARTE GRISE : ';
        TotalWeightCaption: Label 'Total Poids';
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        PhoneNoCaptionLbl: Label 'Phone No.';
        EMailCaptionLbl: Label 'E-Mail';
        FaxCaptionLbl: Label 'Fax : ';
        Location: Record Location;
        Location1: Record Location;
        Article: Record Item;
        Cust: Record Customer;
        TextDestination: Label '%1 - %2';
}

