report 50016 "Demande d'achat "
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Demande d''achat.rdlc';
    Caption = 'Purchase Requisition ';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Requisition"; "Purchase Requisition")
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase Quote';
            column(No_PurchHeader; "No.")
            {
            }
            column(DocDate_PurchHeader; "Creation Date")
            {
            }
            column(CondTerm; CondTerm)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(OrderNoCaption; OrderNoCaptionLbl)
            {
            }
            column(MontLetter; MontLetter)
            {
            }
            column(RecptDate; RecptDate)
            {
            }
            column(CodeDem; "No.")
            {
            }
            column(ResquetDate; Format("Requested Receipt Date"))
            {
            }
            column(UnderContrat; Format("Under Contract"))
            {
            }
            column(ContratRef; "Contract Ref")
            {
            }
            column(RespCenter; "Department Code")
            {
            }
            column(PurchaseType; Format("Type Achat"))
            {
            }
            column(OrderType; Format("Order Type"))
            {
            }
            column(RequiDescript; Description)
            {
            }
            column(Text012; Text012)
            {
            }
            column(Text013; Text013)
            {
            }
            column(Text014; Text014)
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
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
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
            column(CompanyInfoSTAT; ' - STAT : ' + CompanyInfo."Legal Form")
            {
            }
            dataitem("Purchase Requisition Line"; "Purchase Requisition Line")
            {
                DataItemLink = "Document No" = FIELD("No.");
                DataItemLinkReference = "Purchase Requisition";
                column(LineNo_PurchLine; "Line No.")
                {
                }
                column(DocNo_PurchLine; "Document No")
                {
                }
                column(No_PurchLine; "No.")
                {
                }
                column(Desc_PurchLine; Description)
                {
                    IncludeCaption = true;
                }
                column(Qty_PurchLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(UOM_PurchLine; "Unit Code")
                {
                }
                column(Num; Num)
                {
                }
                column(TotalInclVATText; TotalInclVATText)
                {
                }
                column(VATAmountText; VATAmountLine.VATAmountText)
                {
                }
                column(No_PurchLineCaption; No_PurchLineCaption)
                {
                }
                column(UOM_PurchLineCaption; UOM_PurchLineCaptionLbl)
                {
                }
                column(UnitPriceCaption; UnitPriceCaption)
                {
                }
                column(TotaPriceCation; TotalPriceCaption)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Num += 1;
                end;

                trigger OnPreDataItem()
                begin
                    Num := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
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
            ArchiveDocument := PurchSetup."Archive Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        DemCot = 'Demande de Cotation';
        Text10 = 'Siège Social';
        PrepareBy = 'Signature du demandeur';
        VerifyBy = 'Validé par';
        AutoriseBy = 'Autorisé par';
        Dept = 'Département :';
        Descript = 'Description :';
        Date = 'Date';
        Achat = 'ACHAT';
        Cont = 'CONTRAT';
        Urg = 'Urgent';
        Spec = 'Spécification technique necessaire';
        RefCont = 'Réf Contrat :';
        Aut = 'Autre (à préciser) :';
        Non = 'NON';
        Oui = 'OUI';
        ComType = 'Type Commande';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        PurchSetup.Get;
        Num := 0;
    end;

    var
        Text000: Label 'Purchaser';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label ' COPY';
        Text004: Label 'Order%1';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        PurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        PrepmtDimSetEntry: Record "Dimension Set Entry";
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchCountPrinted: Codeunit "Purch.Header-Printed";
        FormatAddr: Codeunit "Format Address";
        PurchPost: Codeunit "Purch.-Post";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        PurchPostPrepmt: Codeunit "Purchase-Post Prepayments";
        VendAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        PricesInclVATtxt: Text[30];
        AllowInvDisctxt: Text[30];
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        OrderNoCaptionLbl: Label 'Order No.';
        TotalPriceCaption: Label 'Amount';
        UnitPriceCaption: Label 'Prix Unitaire';
        CondTerm: Label 'Subtotal';
        VATAmtLineVATCaptionLbl: Label 'VAT %';
        VATAmtLineVATAmtCaptionLbl: Label 'VAT Amount';
        TotalCaptionLbl: Label 'Total';
        No_PurchLineCaption: Label 'Produit';
        MontLetter: Label 'Arrêté le présent bon de commande à la somme de  :     ';
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[80];
        PhoneNoCaptionLbl: Label 'Phone No.';
        FaxCaptionLbl: Label 'Fax : ';
        EmailCaptionLbl: Label 'Email : ';
        DocDate_PurchHeaderCaption: Label 'Date Document :';
        RecptDate: Label 'Date de Réception Souhaitée : ';
        UOM_PurchLineCaptionLbl: Label 'Unité';
        Text012: Label 'DDA N° :   ';
        Num: Integer;
        DemAchat: Record "Purchase Requisition";
        Text013: Label 'Commentaire : ';
        Text014: Label 'Documents en annexe : ';

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewArchiveDocument: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;
}

