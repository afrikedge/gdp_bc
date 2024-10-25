report 50008 "Recap Import MoneyTech"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Recap Import MoneyTech.rdlc';
    Caption = 'MoneyTech Import';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("MoneyTech Import";"MoneyTech Import")
        {
            RequestFilterFields = "No.";
            column(StartDate;"Starting Date")
            {
            }
            column(EndDate;"Ending Date")
            {
            }
            column(PostDate;"Posting Date")
            {
            }
            column(TotCharg;"Total Charge")
            {
            }
            column(TotDechar;"Total Decharge")
            {
            }
            column(No_MoneyTech;"No.")
            {
            }
            dataitem("MoneyTech Import Line";"MoneyTech Import Line")
            {
                DataItemTableView = SORTING("Document No.");
                RequestFilterHeading = 'Import MoneyTech';
                column(Cust_Name;Cust.Name)
                {
                }
                column(EMailCaption;EMailCaptionLbl)
                {
                }
                column(PhoneNoCaption;PhoneNoCaptionLbl)
                {
                }
                column(FaxCaption;FaxCaptionLbl)
                {
                }
                column(StationCode;"Station Code")
                {
                }
                column(CompanyInfo_Picture;CompanyInfo.Picture)
                {
                }
                column(CustAddr1;CustAddr[1])
                {
                }
                column(CompanyAddr1;CompanyAddr[1])
                {
                }
                column(CustAddr2;CustAddr[2])
                {
                }
                column(CompanyAddr2;CompanyAddr[2])
                {
                }
                column(CustAddr3;CustAddr[3])
                {
                }
                column(CompanyAddr3;CompanyAddr[3])
                {
                }
                column(CustAddr4;CustAddr[4])
                {
                }
                column(CompanyAddr4;CompanyAddr[4])
                {
                }
                column(CustAddr5;CustAddr[5])
                {
                }
                column(CustAddr6;CustAddr[6])
                {
                }
                column(CompanyInfoEMail;CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoRCS;' - R.C.S. : '+ CompanyInfo."Trade Register")
                {
                }
                column(CompanyInfoCA;'S.A. au capital de AR '+CompanyInfo."Stock Capital")
                {
                }
                column(CompanyInfoNIF;'NIF : '+CompanyInfo."Registration No.")
                {
                }
                column(CompanyInfoSTAT;'STAT : ' +CompanyInfo."Legal Form")
                {
                }
                column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfoFax;CompanyInfo."Fax No.")
                {
                }
                column(CustAddr7;CustAddr[7])
                {
                }
                column(CustAddr8;CustAddr[8])
                {
                }
                column(CompanyAddr5;CompanyAddr[5])
                {
                }
                column(CompanyAddr6;CompanyAddr[6])
                {
                }
                column(DocumentNo;"Document No.")
                {
                }
                column(SatationCode;"Station Code")
                {
                }
                column(CodeClient;"Debitor No.")
                {
                }
                column(TypeCarte;"Card Type")
                {
                }
                column(TypeTrans;"Transaction Type")
                {
                }
                column(DateDebut;Format("MoneyTech Import Line".TransmissionDate))
                {
                }
                column(NumCarte;"MoneyTech Import Line".TransmissionNo)
                {
                }
                column("MontDebpré";MontDebpré)
                {
                }
                column(MontCred;MontCred)
                {
                }
                column(MontDebPost;MontDebPost)
                {
                }
                column(StatCaption;StatCaption)
                {
                }
                column(NumCartCaption;NumCartCaption)
                {
                }
                column(StartCaption;StartCaption)
                {
                }
                column(TeleColDateCaption;TeleColDateCaption)
                {
                }
                column(JournalCaption;JournalCaption)
                {
                }
                column(EndCaption;EndCaption)
                {
                }
                column(DocCaption;DocCaption)
                {
                }
                column(DebAmountPre;DebAmountPre)
                {
                }
                column(DebAmountPost;DebAmountPost)
                {
                }
                column(DebAmountTot;DebAmountTot)
                {
                }
                column(CredAmountTot;CredAmountTot)
                {
                }
                column(LineNo;"Line No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    SalesInvLineLocation: Record "Sales Invoice Line";
                    CondPaiem: Record "Payment Terms";
                begin

                    FormatAddr.Company(CompanyAddr,CompanyInfo);

                    Cust.Get("MoneyTech Import Line"."Station Code");

                    FormatAddr.Customer(CustAddr,Cust);
                    if ("Transaction Type"="Transaction Type"::Decharge) and("Card Type"="Card Type"::Prepaid)  then begin
                      MontDebpré:=Amount;
                      MontDebPost:=0;
                      MontCred:=0;
                    end
                    else if ("Transaction Type"="Transaction Type"::Decharge) and("Card Type"="Card Type"::Postpaid) then begin
                      MontDebpré:=0;
                      MontDebPost:=Amount;
                      MontCred:=0;
                    end
                    else if ("Transaction Type"="Transaction Type"::Recharge) and("Card Type"="Card Type"::Prepaid) then begin
                      MontDebpré:=0;
                      MontDebPost:=0;
                      MontCred:=Amount;
                    end
                end;

                trigger OnPreDataItem()
                begin
                    "MoneyTech Import Line".SetRange("Document No.","MoneyTech Import"."No.");
                end;
            }
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
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;
        //CompanyInfo.VerifyAndSetPaymentInfo;

        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin

        if not CurrReport.UseRequestPage then

          InitLogInteraction;
    end;

    var
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label 'Sales - Invoice %1';
        PageCaptionCap: Label 'Page %1 of %2';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        TotalText: Text[50];
        MoreLines: Boolean;
        CopyText: Text[30];
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        Text008: Label 'Local Currency';
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        NoCaptionLbl: Label 'Invoice No.';
        UnitPriceCaptionLbl: Label 'Unit Price';
        AmtCaptionLbl: Label 'Amount';
        TotalCaptionLbl: Label 'Total';
        DisplayAdditionalFeeNote: Boolean;
        OrderNoCaptionLbl: Label 'Order No.';
        Location: Record Location;
        LocationName: Text[60];
        Desc_Caption: Label 'DESIGNATION';
        No_LineCaption: Label 'REFERENCE';
        UnitofMeasure_Caption: Label 'UNITE';
        Quantity_Caption: Label 'QUANTITE';
        NbTLet: Report Check;
        TotalAmountLetter: array [2] of Text[80];
        PhoneNoCaptionLbl: Label 'Phone No.';
        EMailCaptionLbl: Label 'E-Mail';
        FaxCaptionLbl: Label 'Fax : ';
        CondPaieName: Text[50];
        Num: Label 'CAP0001';
        Fact: Text[30];
        Descript: Text[30];
        StatCaption: Label 'Station';
        NumCartCaption: Label 'N° Carte';
        TeleColDateCaption: Label 'Date Télécollecte';
        StartCaption: Label 'Date Début';
        EndCaption: Label 'Date Fin';
        DocCaption: Label 'N° Document';
        DebAmountPre: Label 'Débit Pré (Ar)';
        DebAmountPost: Label 'Débit Post (Ar)';
        DebAmountTot: Label 'Total Débit (Ar)';
        CredAmountTot: Label 'Total Crédit (Ar)';
        "MontDebpré": Integer;
        MontCred: Integer;
        MontDebPost: Integer;
        "TotalMontDebpré": Decimal;
        TotalMontCred: Decimal;
        TotalMontDebPost: Decimal;
        JournalCaption: Label 'N° Journal';

    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean;IncludeShptNo: Boolean;DisplAsmInfo: Boolean)
    begin
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        IncludeShptNo := IncludeShptNo;
        DisplayAssemblyInformation := DisplAsmInfo;
    end;
}

