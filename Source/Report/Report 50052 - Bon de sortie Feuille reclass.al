report 50052 "Bon de sortie Feuille reclass"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Bon de sortie Feuille reclass.rdlc';
    Caption = 'Bon de sortie';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Journal Batch"; "Item Journal Batch")
        {
            DataItemTableView = SORTING("Journal Template Name", Name) ORDER(Ascending);
            RequestFilterFields = "Journal Template Name", Name;
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(JournalTempName_ItemJournalBatch; "Journal Template Name")
            {
            }
            column(Name_ItemJournalBatch; Name)
            {
            }
            column(CompanyName; CompanyName)
            {
            }
            column(TodayFormatted; Format(Today, 0, 4))
            {
            }
            column(Time; Time)
            {
            }
            column(ShipmentNoCaption; No_Text)
            {
            }
            column(CompanyInfo_Picture; CompanyInfo."Administrative Picture")
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
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
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
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
            {
            }
            column(ProductCodeCaption; ProductCodeCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(UOMCaption; UOMCaptionLbl)
            {
            }
            column(LocationCaption; LocationCaptionLbl)
            {
            }
            column(StrTitre1; StrTitre)
            {
            }
            column(AdresseClient1; AdresseClient1)
            {
            }
            column(EnteteSignature; EnteteSignature)
            {
            }
            column(MoyenTransfert; MoyenTransfert)
            {
            }
            column(EnteteClient; EnteteClient)
            {
            }
            column(NomClient; NomClient)
            {
            }
            column(AdresseClient2; AdresseClient2)
            {
            }
            dataitem("Item Journal Line"; "Item Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Location Code", "Bin Code", "Item No.", "Variant Code";
                column(LineNo; "Line No.")
                {
                }
                column(JournalTempName_ItemJournalLine; "Journal Template Name")
                {
                }
                column(JournalBatchName_ItemJournalLine; "Journal Batch Name")
                {
                }
                column(UOM_ItemJournalLine; "Unit of Measure Code")
                {
                }
                column(Qty_ItemJournalLine; Quantity)
                {
                }
                column(BinCode_ItemJournalLine; "Bin Code")
                {
                }
                column(LocationCode_ItemJournalLine; "Location Code")
                {
                }
                column(VariantCode_ItemJournalLine; "Variant Code")
                {
                }
                column(Description_ItemJournalLine; Description)
                {
                }
                column(ItemNo_ItemJournalLine; "Item No.")
                {
                }
                column(PostingDate_ItemJournalLine; Format("Posting Date"))
                {
                }
                column(EntryType_ItemJournalLine; "Entry Type")
                {
                }
                column(QuantityBase_ItemJournalLine; "Quantity (Base)")
                {
                }
                column(QuantityFormat; Quantity)
                {
                }
                column(NewBinCode_ItemJournalLine; "New Bin Code")
                {
                }
                column(NewLocationCode_ItemJournalLine; "New Location Code")
                {
                }
                column(QuantityBaseFormat; "Quantity (Base)")
                {
                }
                column(DocumentNo_ItemJournalLine; "Document No.")
                {
                }
                column(CodeClient; "Customer No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    Loc: Record Location;
                begin
                    //***************************

                    No_Text := ShipmentNoCaptionLbl;
                    EnteteSignature := TextSignatureClient;
                    EnteteClient := '';
                    Cust.Init;


                    if TypeEtat = 0 then begin
                        if Cust.Get("Item Journal Line"."Customer No") then begin
                            EnteteClient := TexteClient;
                            CodeClient := Cust."No.";
                            NomClient := Cust.Name;
                            EnteteClient := TexteClient;
                            AdresseClient1 := Cust.Address;
                            AdresseClient2 := Cust."Address 2";
                        end;
                    end;

                    if TypeEtat = 1 then begin//BON ENLEVEMENT
                        StrTitre := TitreBonE;
                        No_Text := NumBEText;
                        if Cust.Get("Item Journal Line"."Customer No") then;
                        AddOnSetup.TestField(AddOnSetup."GRT Location Code");
                        CodeClient := AddOnSetup."GRT Location Code";
                        if Loc.Get(AddOnSetup."GRT Location Code") then
                            NomClient := Loc.Name;
                        EnteteSignature := TextSignatureDepot;
                        EnteteClient := TextDepot;
                        if ShipmentMethod.Get(Cust."Shipment Method Code") then
                            MoyenTransfert := StrSubstNo(TextMoyenTransport, ShipmentMethod.Description);
                    end;

                    if TypeEtat = 2 then begin//BON LIVRAISON
                        StrTitre := TitreBonL;
                        No_Text := NumBLText;
                        if Cust.Get("Item Journal Line"."Customer No") then;
                        CodeClient := Cust."No.";
                        NomClient := Cust.Name;
                        EnteteClient := TexteClient;

                        AdresseClient1 := Cust.Address;
                        AdresseClient2 := Cust."Address 2";
                        if ShipmentMethod.Get(Cust."Shipment Method Code") then
                            MoyenTransfert := StrSubstNo(TextMoyenTransport, ShipmentMethod.Description);
                        //AdresseLivraison := Cust."Ship-to Code";
                    end;
                    //*************************
                end;

                trigger OnPreDataItem()
                begin
                    ItemJnlTemplate.Get("Item Journal Batch"."Journal Template Name");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.PageNo := 1;
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                //******************************************
                StrTitre := TitreBonSortie;
                if TypeEtat = 1 then begin//BON ENLEVEMENT
                    StrTitre := TitreBonE;
                end;
                if TypeEtat = 2 then begin//BON LIVRAISON
                    StrTitre := TitreBonL;
                end;
                //******************************************
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        BonSort = 'BON DE SORTIE';
        PrepareBy = 'Etabli par *';
        Client = 'Le Client *';
        ApproveBy = 'Approuvé par *';
        Text10 = 'Siège Social';
        Text1 = 'Date opération :';
        CodeProjetLbl = 'Code Client :';
        NumBonSortieLbl = 'N° Bon de sortie magasin :';
        NewLocationCodeLbl = 'Code magasin destinataire';
        MagasinierLbl = 'Le magasinier *';
        NomSignCachetLbl = '* : Nom, signature, cachet et date.';
        NumDoclbl = 'N° Document';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.CalcFields("Administrative Picture");
        SalesSetup.Get;
        AddOnSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."Logo Position on Documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;

        //******************************************
        StrTitre := TitreBonSortie;
        if TypeEtat = 1 then begin//BON ENLEVEMENT
            StrTitre := TitreBonE;
        end;
        if TypeEtat = 2 then begin//BON LIVRAISON
            StrTitre := TitreBonL;
        end;
        //******************************************
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
        AsmHeaderExists := false;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'COPY';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        SegManagement: Codeunit SegManagement;
        MoreLines: Boolean;
        SalesSetup: Record "Sales & Receivables Setup";
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        i: Integer;
        FormatAddr: Codeunit "Format Address";
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        LinNo: Integer;
        ShipmentNoCaptionLbl: Label 'Shipment No.';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        DocumentDateCaptionLbl: Label 'Document Date';
        PageCaptionCap: Label 'Page %1 of %2';
        FaxCaptionLbl: Label 'Fax : ';
        PhoneNoCaptionLbl: Label 'Phone No.';
        Cust: Record Customer;
        ProductCodeCaptionLbl: Label 'Code produit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantité';
        UOMCaptionLbl: Label 'Unité';
        LocationCaptionLbl: Label 'Code Magasin';
        ItemJnlTemplate: Record "Item Journal Template";
        TypeEtat: Integer;
        StrTitre: Text[50];
        TitreBonSortie: Label 'BON DE SORTIE';
        TitreBonE: Label 'BON D''ENLEVEMENT';
        TitreBonL: Label 'BON DE LIVRAISON';
        No_Text: Text[50];
        NumBEText: Label 'N° BE';
        NumBLText: Label 'N° BL';
        TexteClient: Label 'CLIENT';
        TextDepot: Label 'DEPOT';
        TextSignatureClient: Label 'Le Client : (Nom, Signature et Cachet)';
        TextSignatureDepot: Label 'Le Depôt : (Nom, Signature et Cachet)';
        TextMoyenTransport: Label 'Moyen de transfert : %1';
        AdresseClient1: Text[50];
        EnteteSignature: Text[50];
        MoyenTransfert: Text[100];
        EnteteClient: Text[50];
        CodeClient: Text[50];
        NomClient: Text[50];
        AddOnSetup: Record "AddOn Setup";
        ShipmentMethod: Record "Shipment Method";
        AdresseClient2: Text[50];

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean; DisplayAsmInfo: Boolean)
    begin
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
    end;

    procedure BlanksForIndent(): Text[10]
    begin
    end;

    procedure SetTypeEtat(newType: Integer)
    begin
        TypeEtat := newType;
    end;
}

