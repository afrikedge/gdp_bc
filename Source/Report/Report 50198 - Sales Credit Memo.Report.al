report 50198 "Sales Credit Memo"
{
    Caption = 'Avoir vente';
    Permissions = TableData "Sales Shipment Buffer" = rimd;
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;
    RDLCLayout = './Source/Report/Layout/PostedSalesCreditMemo.rdl';

    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Avoir vente';
            column(DocumentNo; "No.")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(DocumentCopyText; StrSubstNo(DocumentCaption(), CopyText))
            {
            }
            column(GoodsAndServices_Lbl; GetGoodsAndServicesText())
            {
            }
            column(VATPaidOnDebits_Lbl; GetVATPaidOnDebitsText())
            {
            }
            column(VATAmount_Lbl; VATAmtLbl)
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
            column(Foot6; 'Email : ' + CompanyInfo."E-Mail")
            {
            }
            column(Agency; Agency)
            {
            }
            column(DepotName; DepotName)
            {
            }
            column(Due_Date; Format("Due Date"))
            {
            }
            column(Date; Format("Posting Date"))
            {
            }
            column(Customer_No_; "Sell-to Customer No.")
            {
            }
            column(Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Customer_Name_2; "Sell-to Customer Name 2")
            {
            }
            column(Sell_to_Address; "Sell-to Address")
            {
            }
            column(Resp_Center; "Responsibility Center")
            {
            }
            column(Observations; Observations)
            {
            }
            column(NIF; NIF)
            {
            }
            column(STAT; STAT)
            {
            }
            column(CIF; CIF)
            {
            }
            column(ChannelCode; ChannelCode)
            {
            }
            column(PaymentTerm; PaymentTerm)
            {
            }
            column(InvoicetitleLbl; InvoicetitleLbl)
            {
            }
            column(ActivityLbl; ActivityLbl)
            {
            }
            column(AgencyLbl; AgencyLbl)
            {
            }
            column(DateLbl; DateLbl)
            {
            }
            column(CustomerLbl; CustomerLbl)
            {
            }
            column(DeliveryDepotLbl; DeliveryDepotLbl)
            {
            }
            column(BLNumberLbl; BLNumberLbl)
            {
            }
            column(InvoiceNumberLbl; InvoiceNumberLbl)
            {
            }
            column(OrderNumberLbl; OrderNumberLbl)
            {
            }
            column(NIFLbl; NIFLbl)
            {
            }
            column(STATLbl; STATLbl)
            {
            }
            column(CIFCISLbl; CIFCISLbl)
            {
            }
            column(ObservationsLbl; ObservationsLbl)
            {
            }
            column(PaymentTermsLbl; PaymentTermsLbl)
            {
            }
            column(DueDateLbl; DueDateLbl)
            {
            }
            column(DesignationLbl; DesignationLbl)
            {
            }
            column(ProductLbl; ProductLbl)
            {
            }
            column(ProdRefLbl; ProdRefLbl)
            {
            }
            column(ProductCodeLbl; ProductCodeLbl)
            {
            }
            column(ProductUnitLbl; ProductUnitLbl)
            {
            }
            column(QtyOrNbLbl; QtyOrNbLbl)
            {
            }
            column(UnitPriceLbl; UnitPriceLbl)
            {
            }
            column(VATLbl; VATLbl)
            {
            }
            column(AmountHTLbl; AmountHTLbl)
            {
            }
            column(CustomerGeneralTermsLbl; CustomerGeneralTermsLbl)
            {
            }
            column(NetPayableLbl; NetPayableLbl)
            {
            }
            column(InvoiceArrestedLbl; InvoiceArrestedLbl)
            {
            }
            column(ForGalanaLbl; ForGalanaLbl)
            {
            }
            column(NameLbl; NameLbl)
            {
            }
            column(Date1Lbl; Date1Lbl)
            {
            }
            dataitem(Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                column(LineNo_Line; "Line No.")
                {
                }
                column(ItemNo_Line; "No.")
                {
                }
                column(LineHT; LineHT)
                {
                }
                column(LineVAT; LineVAT)
                {
                }
                column(LineTTC; LineTTC)
                {
                }
                column(LineAmt; LineAmt)
                {
                }
                column(LineAmtTTC; LineAmtTTC)
                {
                }
                column(LineQty; LineQtyFormatted)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(LineUP; LineUPFormatted)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(LineAmount; LineAmountFormatted)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(LineVATAmount; LineVATFormatted)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(LineAmountTTC; LineAmountTTCFormatted)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(Lines; Lines)
                {
                }
                column(LineNumberText; LineNumberText)
                {
                }

                column(Description_Line; Description)
                {
                }
                column(UnitOfMeasure; "Unit of Measure")
                {
                }
                column(UnitPrice; FormattedUnitPrice)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(Quantity_Line; FormattedQuantity)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(LineAmount_Line; FormattedLineAmount)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 2;
                }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(AmountExcludingVAT_Line_Lbl; FieldCaption(Amount))
                {
                }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(AmountIncludingVAT_Line_Lbl; FieldCaption("Amount Including VAT"))
                {
                    AutoFormatExpression = GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(Description_Line_Lbl; FieldCaption(Description))
                {
                }
                column(LineDiscountPercent_Line; "Line Discount %")
                {
                }
                column(LineDiscountPercentText_Line; LineDiscountPctText)
                {
                }
                column(LineAmount_Line_Lbl; FieldCaption("Line Amount"))
                {
                }
                column(ItemNo_Line_Lbl; FieldCaption("No."))
                {
                }
                column(ItemReferenceNo_Line; "Item Reference No.")
                {
                }
                column(ItemReferenceNo_Line_Lbl; FieldCaption("Item Reference No."))
                {
                }
                column(ShipmentDate_Line; Format("Shipment Date"))
                {
                }
                // column(ShipmentDate_Line_Lbl; PostedShipmentDateLbl)
                // {
                // }
                column(Quantity_Line_Lbl; FieldCaption(Quantity))
                {
                }
                column(Type_Line; Format(Type))
                {
                }
                column(UnitPrice_Lbl; FieldCaption("Unit Price"))
                {
                }
                column(UnitOfMeasure_Lbl; FieldCaption("Unit of Measure"))
                {
                }
                column(VATIdentifier_Line; "VAT Identifier")
                {
                }
                column(VATIdentifier_Line_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(VATPct_Line; FormattedVATPct)
                {
                }
                column(VATPct_Line_Lbl; FieldCaption("VAT %"))
                {
                }
                column(TransHeaderAmount; TransHeaderAmount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VAT; VAT)
                {
                }
                dataitem(ShipmentLine; "Sales Shipment Buffer")
                {
                    DataItemTableView = sorting("Document No.", "Line No.", "Entry No.");
                    UseTemporary = true;
                    column(DocumentNo_ShipmentLine; "Document No.")
                    {
                    }
                    column(PostingDate_ShipmentLine; Format("Posting Date"))
                    {
                    }
                    column(PostingDate_ShipmentLine_Lbl; FieldCaption("Posting Date"))
                    {
                    }
                    column(Quantity_ShipmentLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(Quantity_ShipmentLine_Lbl; FieldCaption(Quantity))
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        if not DisplayShipmentInformation then
                            CurrReport.Break();

                        SetRange("Line No.", Line."Line No.");
                    end;
                }
                dataitem(AssemblyLine; "Posted Assembly Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.");
                    UseTemporary = true;
                    column(LineNo_AssemblyLine; "No.")
                    {
                    }
                    column(Description_AssemblyLine; Description)
                    {
                    }
                    column(Quantity_AssemblyLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(UnitOfMeasure_AssemblyLine; GetUOMText("Unit of Measure Code"))
                    {
                    }
                    column(VariantCode_AssemblyLine; "Variant Code")
                    {
                    }

                    trigger OnPreDataItem()
                    var
                        ValueEntry: Record "Value Entry";
                    begin
                        Clear(AssemblyLine);
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        GetAssemblyLinesForDocument(
                          AssemblyLine, ValueEntry."Document Type"::"Sales Credit Memo", Line."Document No.", Line."Line No.");
                    end;
                }
                trigger OnAfterGetRecord()
                var
                    HT: Decimal;
                    VATP: Decimal;
                    PU: Decimal;
                    TTC: Decimal;
                begin
                    InitializeSalesShipmentLine();

                    Lines := 1;
                    LineNumber := LineNumber + 1;
                    if (LineNumber < 10) then
                        LineNumberText := '0' + Format(LineNumber)
                    else
                        LineNumberText := Format(LineNumber);

                    SalesHeaderLineRec.Reset();
                    SalesHeaderLineRec.SetRange("Document No.", Header."No.");
                    if SalesHeaderLineRec.FindFirst() then
                        VAT := Format(SalesHeaderLineRec."VAT %") + '%';

                    if Line.Type = Line.Type::" " then begin
                        LineQtyFormatted := '';
                        LineUPFormatted := '';
                        LineAmountFormatted := '';
                        LineVATFormatted := '';
                    end else begin
                        if (Header."Prices Including VAT") then begin
                            PU := Line."Unit Price" * (1 / (1 + Line."VAT %" / 100));
                            HT := Line."Line Amount" * (1 / (1 + Line."VAT %" / 100));
                            VATP := line."Amount Including VAT" - HT;
                            TTC := line."Amount Including VAT";
                        end else begin
                            PU := Line."Unit Price";
                            HT := Line."Line Amount";
                            VATP := HT * Line."VAT %" / 100;
                            TTC := VATP + Line."Line Amount";
                        end;

                        LineAmountFormatted := Format(Round(Line.Quantity * PU, 0.001, '<'), 0, '<Precision,2><Standard Format,0>');
                        LineVATFormatted := Format(Round(VATP, 0.001, '<'));
                        LineAmountTTCFormatted := Format(Round(TTC, 0.001, '<'));
                    end;
                    LineQty := Round(Line.Quantity, 0.001, '<');
                    LineUP := Round(PU, 0.000001, '<');

                    LineQtyFormatted := Format(LineQty, 0, '<Precision,2><Standard Format,0>');
                    LineUPFormatted := Format(LineUP, 0, '<Precision,2><Standard Format,0>');

                    if Type = Type::"G/L Account" then
                        "No." := '';
                    OnLineOnAfterGetRecordOnBeforeCheckLineDiscount(Line, Header);

                    if "Line Discount %" = 0 then
                        LineDiscountPctText := ''
                    else
                        LineDiscountPctText := StrSubstNo('%1%', -Round("Line Discount %", 0.1));

                    if (Header."Prices Including VAT") then begin
                        TransHeaderAmount += PrevLineAmount;
                        PrevLineAmount := HT;
                        TotalSubTotal += HT;
                        TotalInvDiscAmount -= "Inv. Discount Amount";
                        TotalAmount += HT;
                        TotalAmountVAT += "Amount Including VAT" - HT;
                        TotalAmountInclVAT += "Amount Including VAT";
                        TotalPaymentDiscOnVAT += -(HT - "Inv. Discount Amount" - "Amount Including VAT");
                    end else begin
                        TransHeaderAmount += PrevLineAmount;
                        PrevLineAmount := "Line Amount";
                        TotalSubTotal += "Line Amount";
                        TotalInvDiscAmount -= "Inv. Discount Amount";
                        TotalAmount += Amount;
                        TotalAmountVAT += "Amount Including VAT" - Amount;
                        TotalAmountInclVAT += "Amount Including VAT";
                        TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                    end;

                    if FirstLineHasBeenOutput then
                        Clear(DummyCompanyInfo.Picture);
                    FirstLineHasBeenOutput := true;

                    if Line.Quantity = 0 then
                        CurrReport.Skip();

                    FormatLineValues(Line);
                end;

                trigger OnPreDataItem()
                begin
                    VATAmountLine.DeleteAll();
                    VATClauseLine.DeleteAll();
                    ShipmentLine.Reset();
                    ShipmentLine.DeleteAll();
                    MoreLines := Find('+');
                    while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                        MoreLines := Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break();
                    SetRange("Line No.", 0, "Line No.");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                    FirstLineHasBeenOutput := false;
                    DummyCompanyInfo.Picture := CompanyInfo.Picture;

                    LinesNumb := Count();
                end;
            }
            dataitem(LineFooter; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(LinesFoot; Lines)
                {
                }
                column(LineNumberFoot; LineNumberText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    Lines := 1;
                    LineNumber := LineNumber + 1;
                    if (LineNumber < 10) then
                        LineNumberText := '0' + Format(LineNumber)
                    else
                        LineNumberText := Format(LineNumber);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, 14 - LinesNumb);
                end;
            }
            dataitem(WorkDescriptionLines; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 .. 99999));
                column(WorkDescriptionLineNumber; Number)
                {
                }
                column(WorkDescriptionLine; WorkDescriptionLine)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if WorkDescriptionInstream.EOS then
                        CurrReport.Break();
                    WorkDescriptionInstream.ReadText(WorkDescriptionLine);
                end;

                trigger OnPostDataItem()
                begin
                    Clear(WorkDescriptionInstream)
                end;

                trigger OnPreDataItem()
                begin
                    if not ShowWorkDescription then
                        CurrReport.Break();
                    Header."Work Description".CreateInStream(WorkDescriptionInstream, TEXTENCODING::UTF8);
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(InvoiceDiscountAmount_VATAmountLine; "Invoice Discount Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountAmount_VATAmountLine_Lbl; FieldCaption("Invoice Discount Amount"))
                {
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine_Lbl; FieldCaption("Inv. Disc. Base Amount"))
                {
                }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_VatAmountLine_Lbl; FieldCaption("Line Amount"))
                {
                }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmount_VatAmountLine_Lbl; FieldCaption("VAT Amount"))
                {
                }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY)
                {
                }
                column(VATAmountLCY_VATAmountLine_Lbl; VATAmountLCYLbl)
                {
                }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                    AutoFormatExpression = Line.GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(VATBase_VatAmountLine_Lbl; FieldCaption("VAT Base"))
                {
                }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY)
                {
                }
                column(VATBaseLCY_VATAmountLine_Lbl; VATBaseLCYLbl)
                {
                }
                column(VATIdentifier_VatAmountLine; "VAT Identifier")
                {
                }
                column(VATIdentifier_VatAmountLine_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(VATPct_VatAmountLine; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATPct_VatAmountLine_Lbl; FieldCaption("VAT %"))
                {
                }
                column(NoOfVATIdentifiers; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY :=
                      GetBaseLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");
                    VATAmountLCY :=
                      GetAmountLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");

                    TotalVATBaseLCY += VATBaseLCY;
                    TotalVATAmountLCY += VATAmountLCY;
                    TotalVATBaseOnVATAmtLine += "VAT Base";
                    TotalVATAmountOnVATAmtLine += "VAT Amount";

                    if "VAT Clause Code" <> '' then begin
                        VATClauseLine := VATAmountLine;
                        if VATClauseLine.Insert() then;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    Clear(VATBaseLCY);
                    Clear(VATAmountLCY);

                    TotalVATBaseLCY := 0;
                    TotalVATAmountLCY := 0;
                    TotalVATBaseOnVATAmtLine := 0;
                    TotalVATAmountOnVATAmtLine := 0;
                end;
            }
            dataitem(VATClauseLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(VATIdentifier_VATClauseLine; "VAT Identifier")
                {
                }
                column(Code_VATClauseLine; VATClause.Code)
                {
                }
                column(Code_VATClauseLine_Lbl; VATClause.FieldCaption(Code))
                {
                }
                column(Description_VATClauseLine; VATClauseText)
                {
                }
                column(Description2_VATClauseLine; VATClause."Description 2")
                {
                }
                column(VATAmount_VATClauseLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(NoOfVATClauses; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "VAT Clause Code" = '' then
                        CurrReport.Skip();
                    if not VATClause.Get("VAT Clause Code") then
                        CurrReport.Skip();
                    VATClauseText := VATClause.GetDescriptionText(Header);
                end;

                trigger OnPreDataItem()
                begin
                    if Count = 0 then
                        VATClausesText := ''
                    else
                        VATClausesText := VATClausesLbl;
                end;
            }
            dataitem(ReportTotalsLine; "Report Totals Buffer")
            {
                DataItemTableView = sorting("Line No.");
                UseTemporary = true;
                column(Description_ReportTotalsLine; Description)
                {
                }
                column(Amount_ReportTotalsLine; Amount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted")
                {
                }
                column(FontBold_ReportTotalsLine; "Font Bold")
                {
                }
                column(FontUnderline_ReportTotalsLine; "Font Underline")
                {
                }

                trigger OnPreDataItem()
                begin
                    CreateReportTotalLines();
                end;
            }
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalNetAmount; Format(TotalAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalVATBaseLCY; TotalVATBaseLCY)
                {
                }
                column(TotalAmountIncludingVAT; Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalVATAmount; Format(TotalAmountVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalVATAmountLCY; TotalVATAmountLCY)
                {
                }
                column(TotalInvoiceDiscountAmount; Format(TotalInvDiscAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
                {
                }
                column(TotalVATAmountText; VATAmountLine.VATAmountText())
                {
                }
                column(TotalExcludingVATText; TotalExclVATText)
                {
                }
                column(TotalIncludingVATText; TotalInclVATText)
                {
                }
                column(TotalSubTotal; Format(TotalSubTotal, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalSubTotalMinusInvoiceDiscount; Format(TotalSubTotal + TotalInvDiscAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalText; TotalText)
                {
                }
                column(TotalAmountExclInclVAT; Format(TotalAmountExclInclVATValue, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code")))
                {
                }
                column(TotalAmountExclInclVATText; TotalAmountExclInclVATTextValue)
                {
                }
                column(TotalVATBaseOnVATAmtLine; TotalVATBaseOnVATAmtLine)
                {
                }
                column(TotalVATAmountOnVATAmtLine; TotalVATAmountOnVATAmtLine)
                {
                }
                column(CurrencyCode; CurrCode)
                {
                }
                column(CurrencySymbol; CurrSymbol)
                {
                }

                column(Amount_InWords; Amount_InWords)
                {
                }
                column(FormattedTotalHT; FormattedTotalHT)
                {
                }
                column(FormattedTotalVAT; FormattedTotalVAT)
                {
                }
                column(FormattedTotalTTC; FormattedTotalTTC)
                {
                }
                column(TotalHT_LCY; TotalHT_LCY)
                {
                }
                column(FormattedTotalHT_LCYText; FormattedTotalHT_LCYText)
                {
                }
                column(TotalVAT_LCY; TotalVAT_LCY)
                {
                }
                column(FormattedTotalVAT_LCYText; FormattedTotalVAT_LCYText)
                {
                }
                column(TotalTTC_LCY; TotalTTC_LCY)
                {
                }
                column(FormattedTotalTTC_LCYText; FormattedTotalTTC_LCYText)
                {
                }
                column(CurrencyName; CurrencyName)
                {
                }
                column(LocalCurrencyName; LocalCurrencyName)
                {
                }
                column(LocalCurrencyText; LocalCurrencyText)
                {
                }
                trigger OnPreDataItem()
                begin
                    // if Header."Prices Including VAT" then begin
                    //     TotalAmountExclInclVATTextValue := TotalExclVATText;
                    //     TotalAmountExclInclVATValue := TotalAmount;
                    // end else begin
                    TotalAmountExclInclVATTextValue := TotalInclVATText;
                    TotalAmountExclInclVATValue := TotalAmountInclVAT;
                    // end;

                    FormattedTotalHT := Format(TotalAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code"));
                    FormattedTotalVAT := Format(TotalAmountVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code"));
                    FormattedTotalTTC := Format(TotalAmountExclInclVATValue, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, Header."Currency Code"));

                    TotalHT_LCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(Header."Posting Date", Header."Currency Code", TotalAmount, Header."Currency Factor");
                    TotalVAT_LCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(Header."Posting Date", Header."Currency Code", TotalAmountVAT, Header."Currency Factor");
                    TotalTTC_LCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(Header."Posting Date", Header."Currency Code", TotalAmountExclInclVATValue, Header."Currency Factor");

                    TotalTTC_LCY := ROUND(TotalTTC_LCY, LocalCurrency."Amount Rounding Precision");
                    TotalHT_LCY := ROUND(TotalHT_LCY, LocalCurrency."Amount Rounding Precision");
                    TotalVAT_LCY := ROUND(TotalVAT_LCY, LocalCurrency."Amount Rounding Precision");

                    FormattedTotalTTC_LCYText := Format(TotalTTC_LCY, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, LocalCurrency.Code));
                    FormattedTotalTTC_LCYText := Format(TotalTTC_LCY, 0, '<Precision,2><Standard Format,0>');
                    FormattedTotalHT_LCYText := Format(TotalHT_LCY, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, LocalCurrency.Code));
                    FormattedTotalVAT_LCYText := Format(TotalVAT_LCY, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, LocalCurrency.Code));
                    FormattedTotalVAT_LCYText := Format(TotalVAT_LCY, 0, '<Precision,2><Standard Format,0>');

                    RepCheck.InitTextVariable();
                    RepCheck.FormatNoText(NoText, TotalTTC_LCY, LocalCurrency.code);
                    NoText[1] := ReplaceString(NoText[1], '****');
                    NoText[1] := ReplaceString(NoText[1], 'AND 0/100');
                    NoText[2] := ReplaceString(NoText[2], '****');
                    NoText[2] := ReplaceString(NoText[2], 'AND 0/100');
                    Amount_InWords := NoText[1] + ' ' + NoText[2];
                end;
            }

            trigger OnAfterGetRecord()
            var
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                Currency: Record Currency;
            // GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                LineNumber := 0;

                if RespCenter.Get(Header."Responsibility Center") then
                    Agency := RespCenter.Name;

                if Location.Get(Header."Location Code") then
                    DepotName := Location.Name;

                if Cust.Get(Header."Sell-to Customer No.") then begin
                    NIF := Cust."VAT Registration No.";
                    STAT := Cust."STAT Code";
                    CIF := Cust."CIF/CIS";
                    ChannelCode := Cust."Sales Channel Code";
                end;

                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";

                if PaymentTerms.Get(Header."Payment Terms Code") then
                    PaymentTerm := PaymentTerms.Description;

                GLSetup.Get();
                GLSetup.TestField("LCY Code");
                CurrCode := Header."Currency Code";
                if (CurrCode = '') then
                    CurrCode := GLSetup."LCY Code";

                CurrencyName := CurrCode;
                if Currency.Get(CurrCode) then
                    CurrencyName := Currency.Description;

                if (LocalCurrency.Get(GLSetup."LCY Code") and (CurrCode <> GLSetup."LCY Code")) then
                    LocalCurrencyName := LocalCurrency.Description;

                if not IsReportInPreviewMode() then
                    CODEUNIT.Run(CODEUNIT::"Sales Cr. Memo-Printed", Header);

                OnHeaderOnAfterGetRecordOnAfterUpdateNoPrinted(IsReportInPreviewMode(), Header);

                CalcFields("Work Description");
                ShowWorkDescription := "Work Description".HasValue;
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault("Language Code");
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault("Format Region");
                FormatAddr.SetLanguageCode("Language Code");

                FormatAddressFields(Header);
                FormatDocumentFields(Header);
                if SellToContact.Get("Sell-to Contact No.") then;
                if BillToContact.Get("Bill-to Contact No.") then;

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                if not CompanyBankAccount.Get(Header."Company Bank Account Code") then
                    CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);

                if "Currency Code" <> '' then begin
                    CurrencyExchangeRate.FindCurrency("Posting Date", "Currency Code", 1);
                    CalculatedExchRate :=
                      Round(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
                    ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
                    // CurrCode := "Currency Code";
                    // if Currency.Get("Currency Code") then
                    //     CurrSymbol := Currency.GetCurrencySymbol();
                    // end else
                    //     if GeneralLedgerSetup.Get() then begin
                    //         CurrCode := GeneralLedgerSetup."LCY Code";
                    //         CurrSymbol := GeneralLedgerSetup.GetCurrencySymbol();
                end;

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;
                TotalTTC_LCY := 0;
                TotalHT_LCY := 0;
                TotalVAT_LCY := 0;
            end;

            trigger OnPreDataItem()
            begin
                FirstLineHasBeenOutput := false;
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
                    field(LogInteractionR; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                        Visible = false;
                    }
                    // field(DisplayAsmInformation; DisplayAssemblyInformation)
                    // {
                    //     ApplicationArea = Assembly;
                    //     Caption = 'Show Assembly Components';
                    //     ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    // }
                    // field(DisplayShipmentInformation; DisplayShipmentInformation)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Show Shipments';
                    //     ToolTip = 'Specifies that shipments are shown on the document.';
                    // }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            // LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            // LogInteractionEnable := LogInteraction;
        end;
    }
    labels
    {
    }

    trigger OnInitReport()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        IsHandled: Boolean;
    begin
        GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();

        if SalesCrMemoHeader.GetLegalStatement() <> '' then
            LegalStatementLbl := SalesCrMemoHeader.GetLegalStatement();

        IsHandled := false;
        OnInitReportForGlobalVariable(IsHandled, LegalOfficeTxt, LegalOfficeLbl, CustomGiroTxt, CustomGiroLbl, LegalStatementLbl);
#if not CLEAN23
        if not IsHandled then begin
            // LegalOfficeTxt := CompanyInfo.GetLegalOffice();
            // LegalOfficeLbl := CompanyInfo.GetLegalOfficeLbl();
            // CustomGiroTxt := CompanyInfo.GetCustomGiro();
            // CustomGiroLbl := CompanyInfo.GetCustomGiroLbl();
            LegalOfficeTxt := '';
            LegalOfficeLbl := '';
            CustomGiroTxt := '';
            CustomGiroLbl := '';
        end;
#endif
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if Header.FindSet() then
                repeat
                    if Header."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          6, Header."No.", 0, 0, DATABASE::Contact, Header."Bill-to Contact No.", Header."Salesperson Code",
                          Header."Campaign No.", Header."Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          6, Header."No.", 0, 0, DATABASE::Customer, Header."Bill-to Customer No.", Header."Salesperson Code",
                          Header."Campaign No.", Header."Posting Description", '');
                until Header.Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if Header.GetFilters = '' then
            Error(NoFilterSetErr);

        if not CurrReport.UseRequestPage then
            InitLogInteraction();

        CompanyLogoPosition := SalesSetup."Logo Position on Documents";
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PaymentMethod: Record "Payment Method";
        DummyCompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        RespCenter: Record "Responsibility Center";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        LocalCurrency: Record Currency;
        CompanyInfos: Record "Company Information";
        Location: Record Location;
        // Currency: Record Currency;
        SalesHeaderLineRec: Record "Sales Cr.Memo Line";
        RepCheck: Report Check;

        LanguageMgt: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        AutoFormat: Codeunit "Auto Format";
        WorkDescriptionInstream: InStream;
        WorkDescriptionLine: Text;
        MoreLines: Boolean;
        CopyText: Text[30];
        VATClausesText: Text;
        TotalAmountExclInclVATTextValue: Text;
        TotalAmountExclInclVATValue: Decimal;
        ShowWorkDescription: Boolean;
        LogInteraction: Boolean;
        TransHeaderAmount: Decimal;
        TotalVATBaseOnVATAmtLine: Decimal;
        TotalVATAmountOnVATAmtLine: Decimal;
        LogInteractionEnable: Boolean;
        CompanyLogoPosition: Integer;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        PrevLineAmount: Decimal;
        AppliesToText: Text;
        CurrCode: Text[10];
        CurrSymbol: Text[10];
        VATClauseText: Text;

        Lines: Integer;
        LineNumber: Integer;
        LinesNumb: Integer;
        LineNumberText: Code[2];
        DepotName: Text[100];
        Agency: Text[100];
        NIF: Text[20];
        Foot3: Text;
        STAT: Code[50];
        CIF: Code[50];
        PaymentTerm: Text[100];
        ChannelCode: Code[10];
        VAT: Text[5];
        LineHT: Decimal;
        LineVAT: Decimal;
        LineTTC: Decimal;
        LineQty: Decimal;
        LineUP: Decimal;
        LineAmt: Decimal;
        LineAmtTTC: Decimal;
        LineQtyFormatted: Text;
        LineUPFormatted: Text;
        LineAmountFormatted: Text;
        LineVATFormatted: Text;
        LineAmountTTCFormatted: Text;
        Amount_InWords: Text;
        FormattedTotalHT: Text[50];
        FormattedTotalVAT: Text[50];
        FormattedTotalTTC: Text[50];
        FormattedTotalHT_LCYText: Text[50];
        FormattedTotalVAT_LCYText: Text[50];
        FormattedTotalTTC_LCYText: Text[50];
        LocalCurrencyText: Text[100];
        TotalHT_LCY: Decimal;
        TotalVAT_LCY: Decimal;
        TotalTTC_LCY: Decimal;
        CurrencyName: Text;
        LocalCurrencyName: Text;
        NoText: array[2] of Text;
        LegalOfficeTxt, LegalOfficeLbl, CustomGiroTxt, CustomGiroLbl, LegalStatementLbl : Text;
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';

        InvoicetitleLbl: Label 'AVOIR';
        ActivityLbl: Label 'ACTIVITE';
        AgencyLbl: Label 'AGENCE';
        DateLbl: Label 'DATE';
        CustomerLbl: Label 'CLIENT';
        DeliveryDepotLbl: Label 'DÉPÔT LIVRANCIER';
        BLNumberLbl: Label 'BL N°';
        InvoiceNumberLbl: Label 'Document N°';
        OrderNumberLbl: Label 'Commande N°';
        // CustomerBCLbl: Label 'Customer BC';
        NIFLbl: Label 'NIF :';
        STATLbl: Label 'STAT :';
        CIFCISLbl: Label 'CIF/CIS :';
        ObservationsLbl: Label 'OBSERVATIONS';
        PaymentTermsLbl: Label 'Condition de paiement :';
        DueDateLbl: Label 'Date d''écheance :';
        DesignationLbl: Label 'DESIGNATION';
        ProductLbl: Label 'Produit';
        ProductCodeLbl: Label 'Code';
        ProdRefLbl: Label 'RÉFÉRENCE PRODUITS';
        ProductUnitLbl: Label 'Unité';
        QtyOrNbLbl: Label 'QUANTITE ou NOMBRE';
        UnitPriceLbl: Label 'PRIX UNITAIRE';
        AmountHTLbl: Label 'MONTANT (HT)';
        VATLbl: Label 'TVA';
        NetPayableLbl: Label 'MONTANT (TTC)';
        CustomerGeneralTermsLbl: Label 'The customer accepts the general terms and conditions of sale described overleaf';
        InvoiceArrestedLbl: Label 'Note de crédit arrêtée à la somme de :';
        ForGalanaLbl: Label 'POUR GALANA';
        NameLbl: Label 'Nom :';
        Date1Lbl: Label 'Date :';

#pragma warning disable AA0470
        SalesCreditMemoNoLbl: Label 'Sales - Credit Memo %1';
#pragma warning restore AA0470
        VATBaseLCYLbl: Label 'VAT Base (LCY)';
        VATAmountLCYLbl: Label 'VAT Amount (LCY)';
        GreetingLbl: Label 'Hello';
        IncludesGoodsAndServicesLbl: Label 'Sales credit memo includes goods and services.';
        VATClausesLbl: Label 'VAT Clause';
        IncludesServicesLbl: Label 'Sales credit memo includes only services.';
        IncludesGoodsLbl: Label 'Sales credit memo includes only goods.';
        ClosingLbl: Label 'Sincerely';
        SubtotalLbl: Label 'Subtotal';
        LCYTxt: Label ' (LCY)';
        InvDiscountAmtLbl: Label 'Invoice Discount';
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidently printing all documents.';
        BodyLbl: Label 'Thank you for your business. Your credit memo is attached to this message.';
#pragma warning disable AA0470
        SalesPrepCreditMemoNoLbl: Label 'Sales - Prepmt. Credit Memo %1';
#pragma warning restore AA0470

    protected var
        CompanyInfo: Record "Company Information";
        CompanyBankAccount: Record "Bank Account";
        PaymentTerms: Record "Payment Terms";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        VATClause: Record "VAT Clause";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        FormattedLineAmount: Text;
        FormattedQuantity: Text;
        FormattedUnitPrice: Text;
        FormattedVATPct: Text;
        LineDiscountPctText: Text;
        SalesPersonText: Text[50];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalSubTotal: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        DisplayAssemblyInformation: Boolean;
        DisplayShipmentInformation: Boolean;
        FirstLineHasBeenOutput: Boolean;
        ShowShippingAddr: Boolean;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        VATAmtLbl: Label 'VAT Amount';

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '';
    end;

    local procedure InitializeSalesShipmentLine()
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
        if not DisplayShipmentInformation then
            exit;

        if Line."Return Receipt No." <> '' then
            if ReturnReceiptHeader.Get(Line."Return Receipt No.") then
                exit;
        if Header."Return Order No." = '' then
            exit;
        if Line.Type = Line.Type::" " then
            exit;

        // ShipmentLine.GetLinesForSalesCreditMemoLine(Line, Header);

        ShipmentLine.Reset();
        ShipmentLine.SetRange("Line No.", Line."Line No.");
        if not ShipmentLine.IsEmpty() then begin
            ShipmentLine.CalcSums(Quantity);
            if ShipmentLine.Quantity <> Line.Quantity then begin
                ShipmentLine.DeleteAll();
                exit;
            end;
        end;
    end;

    protected procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure DocumentCaption(): Text[250]
    var
        DocCaption: Text[250];
    begin
        OnBeforeDocumentCaption(Header, DocCaption);
        if DocCaption <> '' then
            exit(DocCaption);

        if Header."Prepayment Credit Memo" then
            exit(SalesPrepCreditMemoNoLbl);
        exit(SalesCreditMemoNoLbl);
    end;

    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure GetGoodsAndServicesText(): Text
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        GotGoods: Boolean;
        GotServices: Boolean;
    begin
        SalesCrMemoLine.SetRange("Document No.", Header."No.");
        SalesCrMemoLine.SetFilter(Type, '<> %1', SalesCrMemoLine.Type::Item);
        if not SalesCrMemoLine.IsEmpty() then
            GotServices := true;
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
        SalesCrMemoLine.SetLoadFields("No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                if IsItemInventory(SalesCrMemoLine."No.") then
                    GotGoods := true
                else
                    GotServices := true;
            until SalesCrMemoLine.Next() = 0;
        if GotServices then
            if GotGoods then
                exit(IncludesGoodsAndServicesLbl)
            else
                exit(IncludesServicesLbl)
        else
            exit(IncludesGoodsLbl);
    end;

    local procedure IsItemInventory(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        Item.SetLoadFields(Type);
        if Item.Get(ItemNo) then
            exit(Item.Type = Item.Type::Inventory);
    end;

    local procedure GetVATPaidonDebitsText(): Text
    begin
        if Header."VAT Paid on Debits" then
            exit(Header.FieldCaption("VAT Paid on Debits"));
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[50]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    local procedure CreateReportTotalLines()
    begin
        ReportTotalsLine.DeleteAll();
        if (TotalInvDiscAmount <> 0) or (TotalAmountVAT <> 0) then
            ReportTotalsLine.Add(SubtotalLbl, TotalSubTotal, true, false, false, Header."Currency Code");
        if TotalInvDiscAmount <> 0 then begin
            ReportTotalsLine.Add(InvDiscountAmtLbl, TotalInvDiscAmount, false, false, false, Header."Currency Code");
            if TotalAmountVAT <> 0 then
                ReportTotalsLine.Add(TotalExclVATText, TotalAmount, true, false, false, Header."Currency Code");
        end;
        if TotalAmountVAT <> 0 then begin
            ReportTotalsLine.Add(VATAmountLine.VATAmountText(), TotalAmountVAT, false, true, false, Header."Currency Code");
            if TotalVATAmountLCY <> TotalAmountVAT then
                ReportTotalsLine.Add(VATAmountLine.VATAmountText() + LCYTxt, TotalVATAmountLCY, false, true, false);
        end;
    end;

    local procedure FormatAddressFields(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatAddr.GetCompanyAddr(SalesCrMemoHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesCrMemoBillTo(CustAddr, SalesCrMemoHeader);
        ShowShippingAddr := FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, SalesCrMemoHeader);
    end;

    local procedure FormatDocumentFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatDocument.SetTotalLabels(SalesCrMemoHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesCrMemoHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesCrMemoHeader."Payment Terms Code", SalesCrMemoHeader."Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesCrMemoHeader."Payment Method Code", SalesCrMemoHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesCrMemoHeader."Shipment Method Code", SalesCrMemoHeader."Language Code");

        AppliesToText :=
          FormatDocument.SetText(SalesCrMemoHeader."Applies-to Doc. No." <> '', StrSubstNo('%1 %2', Format(SalesCrMemoHeader."Applies-to Doc. Type"), SalesCrMemoHeader."Applies-to Doc. No."));

        OnAfterFormatDocumentFields(SalesCrMemoHeader);
    end;

    local procedure FormatLineValues(CurrLine: Record "Sales Cr.Memo Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFormatLineValues(CurrLine, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount, IsHandled);
        if not IsHandled then
            FormatDocument.SetSalesCrMemoLine(CurrLine, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDocumentCaption(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var DocCaption: Text[250])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFormatLineValues(SalesCrMemoLine: Record "Sales Cr.Memo Line"; var FormattedQuantity: Text; var FormattedUnitPrice: Text; var FormattedVATPercentage: Text; var FormattedLineAmount: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFormatDocumentFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLineOnAfterGetRecordOnBeforeCheckLineDiscount(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitReportForGlobalVariable(var IsHandled: Boolean; var LegalOfficeTxt: Text; var LegalOfficeLbl: Text; var CustomGiroTxt: Text; var CustomGiroLbl: Text; var LegalStatementLbl: Text)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnHeaderOnAfterGetRecordOnAfterUpdateNoPrinted(ReportInPreviewMode: Boolean; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    local procedure ReplaceString(OriginString: Text; ReplaceStr: Text): Text
    var
        Rep: Text;
        pos: Integer;
    begin
        Rep := OriginString;
        pos := StrPos(OriginString, ReplaceStr);
        if (pos >= 1) then
            Rep := DelStr(OriginString, pos, StrLen(ReplaceStr));
        exit(Rep);
    end;
}