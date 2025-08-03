report 50065 "Order Autres Achat archive"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Order Autres Achat archive.rdlc';
    Caption = 'Order';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header Archive"; "Purchase Header Archive")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Purchase Order';
            column(DocType_PurchHeader; "Document Type")
            {
                IncludeCaption = true;
            }
            column(No_PurchHeader; "No.")
            {
            }
            column(DateCde; DateCde)
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
            column(CodeDem; CodeDemand)
            {
            }
            column(QuoteNo; "Vendor Order No.")
            {
            }
            column(PaymentTerm; PaymentTerms.Description)
            {
            }
            column(ReceiveRequestDate; Format("Requested Receipt Date"))
            {
            }
            column(Text012; Text012)
            {
            }
            column(Text013; Text013)
            {
            }
            column(Comment; Com)
            {
            }
            column(DevAmount; DevAmount)
            {
            }
            column(RespCenter; DepartementDemandeur)
            {
            }
            column(Observations_PurchaseHeader; "Purchase Header Archive".Observations)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(ReportTitleCopyText; StrSubstNo(Text004, CopyText))
                    {
                    }
                    column(CurrRepPageNo; StrSubstNo(Text005, Format(CurrReport.PageNo)))
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
                    column(CompanyAddr4; CompanyAddr[4] + '  -  ' + NomPays)
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
                    column(DocDate_PurchHeader; Format("Purchase Header Archive"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_PurchHeader; "Purchase Header Archive"."VAT Registration No.")
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_PurchHeader; "Purchase Header Archive"."Your Reference")
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(BuyFrmVendNo_PurchHeader; "Purchase Header Archive"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyFromAddr1; BuyFromAddr[1])
                    {
                    }
                    column(BuyFromAddr2; BuyFromAddr[2])
                    {
                    }
                    column(BuyFromAddr3; BuyFromAddr[3])
                    {
                    }
                    column(BuyFromAddr4; BuyFromAddr[4])
                    {
                    }
                    column(BuyFromAddr5; BuyFromAddr[5])
                    {
                    }
                    column(BuyFromAddr6; BuyFromAddr[6])
                    {
                    }
                    column(BuyFromAddr7; BuyFromAddr[7])
                    {
                    }
                    column(BuyFromAddr8; BuyFromAddr[8])
                    {
                    }
                    column(PricesInclVAT_PurchHeader; "Purchase Header Archive"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(VATBaseDisc_PurchHeader; "Purchase Header Archive"."VAT Base Discount %")
                    {
                    }
                    column(PricesInclVATtxt; PricesInclVATtxt)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
                    {
                    }
                    column(ShowInternalInfo; ShowInternalInfo)
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(DimText; DimText)
                    {
                    }
                    column(BuyFrmVendNo_PurchHeaderCaption; "Purchase Header Archive".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    column(PricesInclVAT_PurchHeaderCaption; "Purchase Header Archive".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(TotalAmountLetter; TotalAmountLetter2[1])
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Purchase Header archive";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

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
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
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
                    dataitem("Purchase Line Archive"; "Purchase Line Archive")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header archive";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(LineAmt_PurchLine; PurchLineArch."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Line Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineNo_PurchLine; "Purchase Line Archive"."Line No.")
                        {
                        }
                        column(DocNo_PurchLine; "Purchase Line Archive"."Document No.")
                        {
                        }
                        column(AllowInvDisctxt; AllowInvDisctxt)
                        {
                        }
                        column(Type_PurchLine; Format("Purchase Line Archive".Type, 0, 2))
                        {
                        }
                        column(No_PurchLine; "Purchase Line Archive"."No.")
                        {
                        }
                        column(Desc_PurchLine; "Purchase Line Archive".Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Qty_PurchLine; "Purchase Line Archive".Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(UOM_PurchLine; "Purchase Line Archive"."Unit of Measure Code")
                        {
                        }
                        column(DirUnitCost_PurchLine; "Purchase Line Archive"."Direct Unit Cost")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 2;
                            IncludeCaption = true;
                        }
                        column(LineDisc_PurchLine; "Purchase Line Archive"."Line Discount %")
                        {
                            IncludeCaption = true;
                        }
                        column(LineAmt2_PurchLine; "Purchase Line Archive"."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                            IncludeCaption = true;
                        }
                        column(AllowInvDisc_PurchLine; "Purchase Line Archive"."Allow Invoice Disc.")
                        {
                            IncludeCaption = true;
                        }
                        column(VATIdentifier_PurchLine; "Purchase Line Archive"."VAT Identifier")
                        {
                        }
                        column(InvDiscAmt_PurchLine; -PurchLineArch."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Line Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Num; Num)
                        {
                        }
                        column(TotalInclVAT; PurchLineArch."Line Amount" - PurchLineArch."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmountText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(No_PurchLineCaption; No_PurchLineCaption)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaption)
                        {
                        }
                        column(TotaPriceCation; TotalPriceCaption)
                        {
                        }
                        column(UOM_PurchLineCaption; UOM_PurchLineCaptionLbl)
                        {
                        }
                        column(VATIdentifier_PurchLineCaption; "Purchase Line Archive".FieldCaption("VAT Identifier"))
                        {
                        }
                        column(ModePaieCaption; ModePaieCaptionLbl)
                        {
                        }
                        column(DelaiLivCaption; DelaiLivCaptionLbl)
                        {
                        }
                        column(TextRemis; Text010)
                        {
                        }
                        column(TextTotalRemis; Text011)
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(LineDimCaption; LineDimCaptionLbl)
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
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
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

                                DimSetEntry2.SetRange("Dimension Set ID", "Purchase Line Archive"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            /*IF Number = 1 THEN
                              PurchLine.FIND('-')
                            ELSE
                              PurchLine.NEXT;
                            "Purchase Line Archive" := PurchLineArch;
                            
                            IF NOT "Purchase Header Archive"."Prices Including VAT" AND
                               (PurchLineArch."VAT Calculation Type" = PurchLineArch."VAT Calculation Type"::"Full VAT")
                            THEN
                              PurchLineArch."Line Amount" := 0;
                            
                            IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                              "Purchase Line Archive"."No." := '';
                            AllowInvDisctxt := FORMAT("Purchase Line Archive"."Allow Invoice Disc.");
                            TotalSubTotal += "Purchase Line Archive"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line Archive"."Inv. Discount Amount";
                            TotalAmount += "Purchase Line Archive".Amount;*/
                            Num := Num + 1;

                            if Number = 1 then
                                PurchLineArch.Find('-')
                            else
                                PurchLineArch.Next;
                            "Purchase Line Archive" := PurchLineArch;

                            if not "Purchase Header Archive"."Prices Including VAT" and
                               (PurchLineArch."VAT Calculation Type" = PurchLineArch."VAT Calculation Type"::"Full VAT")
                            then
                                PurchLineArch."Line Amount" := 0;

                            if (PurchLineArch.Type = PurchLineArch.Type::"G/L Account") and (not ShowInternalInfo) then
                                "Purchase Line Archive"."No." := '';
                            AllowInvDisctxt := Format("Purchase Line Archive"."Allow Invoice Disc.");
                            PurchaseLineArchiveType := "Purchase Line Archive".Type;

                            TotalSubTotal += "Purchase Line Archive"."Line Amount";
                            TotalInvoiceDiscountAmount -= "Purchase Line Archive"."Inv. Discount Amount";
                            TotalAmount += "Purchase Line Archive".Amount;

                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLineArch.DeleteAll;

                        end;

                        trigger OnPreDataItem()
                        begin
                            /*
                            MoreLines := PurchLine.FIND('+');
                            WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2" = '') AND
                                  (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
                                  (PurchLine.Amount = 0)
                            DO
                              MoreLines := PurchLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                              CurrReport.BREAK;
                            PurchLine.SETRANGE("Line No.",0,PurchLine."Line No.");
                            SETRANGE(Number,1,PurchLine.COUNT);
                            CurrReport.CREATETOTALS(PurchLine."Line Amount",PurchLine."Inv. Discount Amount");
                            */
                            MoreLines := PurchLineArch.Find('+');

                            while MoreLines and (PurchLineArch.Description = '') and (PurchLineArch."Description 2" = '') and
                                  (PurchLineArch."No." = '') and (PurchLineArch.Quantity = 0) and
                                  (PurchLineArch.Amount = 0)
                            do
                                MoreLines := PurchLineArch.Next(-1) <> 0;

                            if not MoreLines then
                                CurrReport.Break;

                            PurchLineArch.SetRange("Line No.", 0, PurchLineArch."Line No.");
                            SetRange(Number, 1, PurchLineArch.Count);
                            CurrReport.CreateTotals(PurchLineArch."Line Amount", PurchLineArch."Inv. Discount Amount");

                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if VATAmount = 0 then
                                CurrReport.Break;
                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purchase Header Archive"."Posting Date", "Purchase Header Archive"."Currency Code", "Purchase Header Archive"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purchase Header Archive"."Posting Date", "Purchase Header Archive"."Currency Code", "Purchase Header Archive"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Purchase Header Archive"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount = 0)
                            then
                                CurrReport.Break;

                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purchase Header Archive"."Posting Date", "Purchase Header Archive"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(PayToVendNo_PurchHeader; "Purchase Header Archive"."Pay-to Vendor No.")
                        {
                        }
                        column(VendAddr8; VendAddr[8])
                        {
                        }
                        column(VendAddr7; VendAddr[7])
                        {
                        }
                        column(VendAddr6; VendAddr[6])
                        {
                        }
                        column(VendAddr5; VendAddr[5])
                        {
                        }
                        column(VendAddr4; VendAddr[4])
                        {
                        }
                        column(VendAddr3; VendAddr[3])
                        {
                        }
                        column(VendAddr2; VendAddr[2])
                        {
                        }
                        column(VendAddr1; VendAddr[1])
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if "Purchase Header Archive"."Buy-from Vendor No." = "Purchase Header Archive"."Pay-to Vendor No." then
                                CurrReport.Break;
                        end;
                    }
                    dataitem(Total3; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        column(SellToCustNo_PurchHeader; "Purchase Header Archive"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if ("Purchase Header Archive"."Sell-to Customer No." = '') and (ShipToAddr[1] = '') then
                                CurrReport.Break;
                        end;
                    }
                    dataitem(PrepmtLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufGLAccNo; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        {
                        }
                        column(TotalInclVATText2; TotalInclVATText)
                        {
                        }
                        column(TotalExclVATText2; TotalExclVATText)
                        {
                        }
                        column(PrepmtInvBufAmt; PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmountText; PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtVATAmount; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        dataitem(PrepmtDimLoop; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not PrepmtDimSetEntry.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', PrepmtDimSetEntry."Dimension Code", PrepmtDimSetEntry."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            PrepmtDimSetEntry."Dimension Code", PrepmtDimSetEntry."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until PrepmtDimSetEntry.Next = 0;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not PrepmtInvBuf.Find('-') then
                                    CurrReport.Break;
                            end else
                                if PrepmtInvBuf.Next = 0 then
                                    CurrReport.Break;

                            if ShowInternalInfo then
                                PrepmtDimSetEntry.SetRange("Dimension Set ID", PrepmtInvBuf."Dimension Set ID");

                            if "Purchase Header Archive"."Prices Including VAT" then
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            else
                                PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(
                              PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT",
                              PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT Base",
                              PrepmtVATAmountLine."VAT Amount",
                              PrepmtLineAmount);
                        end;
                    }
                    dataitem(PrepmtVATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purchase Header Archive"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVAT; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(PrepmtVATAmtLineVATId; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, PrepmtVATAmountLine.Count);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtPurchLine: Record "Purchase Line" temporary;
                    TempPurchLine: Record "Purchase Line" temporary;
                    Test: Decimal;
                    PurchLineArchive: Record "Purchase Line Archive";
                    TempPurchHeader: Record "Purchase Header" temporary;
                begin

                    Clear(PurchLineArch);
                    PurchLineArch.DeleteAll;
                    PurchLineArchive.SetRange("Document Type", "Purchase Header Archive"."Document Type");
                    PurchLineArchive.SetRange("Document No.", "Purchase Header Archive"."No.");
                    PurchLineArchive.SetRange("Version No.", "Purchase Header Archive"."Version No.");
                    if PurchLineArchive.FindSet then
                        repeat
                            PurchLineArch := PurchLineArchive;
                            PurchLineArch.Insert;
                            TempPurchLine.TransferFields(PurchLineArchive);
                            TempPurchLine.Insert;
                        until PurchLineArchive.Next = 0;

                    VATAmountLine.DeleteAll;

                    TempPurchHeader.TransferFields("Purchase Header Archive");
                    TempPurchLine."Prepayment Line" := true;  // used as flag in CalcVATAmountLines -> not invoice rounding
                    TempPurchLine.CalcVATAmountLines(0, TempPurchHeader, TempPurchLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount(TempPurchHeader."Currency Code", TempPurchHeader."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
                    //****************************
                    TotalAvecRemise := VATAmountLine.GetTotalLineAmount(false, "Purchase Header Archive"."Currency Code") - VATAmountLine.GetTotalInvDiscAmount;
                    NbTLet.InitTextVariable;
                    //TODO Montants
                    if TotalAvecRemise <> 0 then
                        if ("Purchase Header Archive"."Currency Code" <> '') then
                            NbTLet.FormatNoText(TotalAmountLetter2, TotalAvecRemise, "Purchase Header Archive"."Currency Code")
                        else
                            NbTLet.FormatNoText(TotalAmountLetter2, TotalAvecRemise, GlSetup."LCY Code");

                    Amount_InWords := TotalAmountLetter2[1] + ' ' + TotalAmountLetter2[2];
                    //****************************

                    /*
                    CLEAR(PurchLine);
                    CLEAR(PurchPost);
                    PurchLine.DELETEALL;
                    VATAmountLine.DELETEALL;
                    PurchPost.GetPurchLines("Purchase Header Archive",PurchLine,0);
                    PurchLine.CalcVATAmountLines(0,"Purchase Header",PurchLine,VATAmountLine);
                    PurchLine.UpdateVATOnLines(0,"Purchase Header",PurchLine,VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
                    
                    
                    //****************************
                    TotalAvecRemise := VATAmountLine.GetTotalLineAmount(FALSE,"Purchase Header"."Currency Code") -VATAmountLine.GetTotalInvDiscAmount;
                    NbTLet.InitTextVariable;
                    IF TotalAvecRemise<>0 THEN
                      NbTLet.FormatNoTextFR(TotalAmountLetter2,TotalAvecRemise,"Purchase Header"."Currency Code");
                    //****************************
                    
                    
                    PrepmtInvBuf.DELETEALL;
                    PurchPostPrepmt.GetPurchLines("Purchase Header",0,PrepmtPurchLine);
                    IF NOT PrepmtPurchLine.ISEMPTY THEN BEGIN
                      PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header",TempPurchLine);
                      IF NOT TempPurchLine.ISEMPTY THEN
                        PurchPostPrepmt.CalcVATAmountLines("Purchase Header",TempPurchLine,PrePmtVATAmountLineDeduct,1);
                    END;
                    PurchPostPrepmt.CalcVATAmountLines("Purchase Header",PrepmtPurchLine,PrepmtVATAmountLine,0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrePmtVATAmountLineDeduct);
                    PurchPostPrepmt.UpdateVATOnLines("Purchase Header",PrepmtPurchLine,PrepmtVATAmountLine,0);
                    PurchPostPrepmt.BuildInvLineBuffer2("Purchase Header",PrepmtPurchLine,0,PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;
                    */
                    if Number > 1 then
                        CopyText := Text003;
                    CurrReport.PageNo := 1;
                    OutputNo := OutputNo + 1;

                    TotalSubTotal := 0;
                    TotalAmount := 0;

                end;

                trigger OnPostDataItem()
                begin
                    //IF NOT CurrReport.PREVIEW THEN
                    //  PurchCountPrinteda.RUN("Purchase Header archive");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //TODO
                //CurrReport.Language := Language.GetLanguageID("Language Code");

                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);


                //*****************

                if Pays.Get(CompanyInfo."Country/Region Code") then
                    NomPays := Pays.Name;
                //*****************

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Purchaser Code" = '' then begin
                    SalesPurchPerson.Init;
                    PurchaserText := '';
                end else begin
                    SalesPurchPerson.Get("Purchaser Code");
                    PurchaserText := Text000
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;

                FormatAddr.PurchHeaderBuyFromArch(BuyFromAddr, "Purchase Header Archive");
                if "Buy-from Vendor No." <> "Pay-to Vendor No." then
                    FormatAddr.PurchHeaderPayToArch(VendAddr, "Purchase Header Archive");
                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;
                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                FormatAddr.PurchHeaderShipToArch(ShipToAddr, "Purchase Header Archive");

                /*
                IF NOT CurrReport.PREVIEW THEN BEGIN
                  IF ArchiveDocument THEN
                    ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);
                
                  IF LogInteraction THEN BEGIN
                    CALCFIELDS("No. of Archived Versions");
                    SegManagement.LogDocument(
                      13,"No.","Doc. No. Occurrence","No. of Archived Versions",DATABASE::Vendor,"Buy-from Vendor No.",
                      "Purchaser Code",'',"Posting Description",'');
                  END;
                END;
                */
                PricesInclVATtxt := Format("Prices Including VAT");
                TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");


                //***********************
                //"Purchase Header".TESTFIELD("Purchase Header"."Order Date");
                DateCde := "Purchase Header Archive"."Order Date";
                if "Purchase Header Archive"."Order Date" = 0D then
                    DateCde := "Purchase Header Archive"."Document Date";

                CodeDemand := "Purchase Header Archive"."Code Demande";
                if CodeDemand = '' then CodeDemand := TxtNeant;

                if CodeDemand <> '' then begin
                    //TODO
                    // if PurchReq.Get(CodeDemand) then
                    //     if Dept.Get(PurchReq."Department Code") then
                    //         DepartementDemandeur := Dept.Name;

                    // if PostedPurchReq.Get(CodeDemand) then
                    //     if Dept.Get(PostedPurchReq."Department Code") then
                    //         DepartementDemandeur := Dept.Name;
                end;
                //***********************
                CalcFields("No. of Archived Versions");

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
                    field(NoofCopies; NoOfCopies)
                    {
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInformation; ShowInternalInfo)
                    {
                        Caption = 'Show Internal Information';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        Caption = 'Archive Document';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
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
            //ArchiveDocument := PurchSetup."Archive Quotes and Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        BonCom = 'Bon de Commande';
        Text1 = '(A rappeler impérativement sur chaque facture)';
        Text2 = '(Facture à adresser à l''adresse située dans l''entête)';
        PrepareBy = 'Coordonnateur Achat';
        VerifyBy = 'Validé par';
        AutoriseBy = 'Autorisé par';
        NbrFact = 'Important : Les factures doivent nous parvenir en 3 exemplaires avec les détails fiscaux.';
        Text10 = 'Siège Social';
        Dept = 'Département :';
        Descript = 'Description :';
        Date = 'Date';
        PrintedOn = 'Imprimé le';
        DateCommande = 'Date commande';
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
        LineDimCaptionLbl: Label 'Line Dimensions';
        PaymentDetailsCaptionLbl: Label 'Payment Details';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        TotalPriceCaption: Label 'Amount';
        UnitPriceCaption: Label 'Prix Unitaire';
        CondTerm: Label 'Subtotal';
        VATAmtLineVATCaptionLbl: Label 'VAT %';
        VATAmtLineVATAmtCaptionLbl: Label 'VAT Amount';
        TotalCaptionLbl: Label 'Total';
        No_PurchLineCaption: Label 'Produit';
        MontLetter: Label 'Arrêté le présent bon de commande à la somme de  :     ';
        NbTLet: Report Check;
        TotalAmountLetter2: array[2] of Text[150];
        PhoneNoCaptionLbl: Label 'Phone No.';
        FaxCaptionLbl: Label 'Fax : ';
        EmailCaptionLbl: Label 'Email : ';
        UOM_PurchLineCaptionLbl: Label 'Unité';
        Text010: Label 'REMISE  %';
        ModePaieCaptionLbl: Label 'Mode de Paiement';
        DelaiLivCaptionLbl: Label 'Délai de livraison';
        Text011: Label 'Total avec remise';
        Text012: Label 'DDA N° :   ';
        Text013: Label 'Devis N° :   ';
        Num: Integer;
        Com: Label 'Commentaires';
        DevAmount: Label 'Devise AR';
        TxtNeant: Label 'NEANT';
        CodeDemand: Code[20];
        TotalAvecRemise: Decimal;
        Pays: Record "Country/Region";
        Amount_InWords: Text;
        NomPays: Text[50];
        DateCde: Date;
        DepartementDemandeur: Text[50];
        PostedPurchReq: Record "Posted Purchase Requisition";
        //Dept: Record Subdirection;
        PurchReq: Record "Purchase Requisition";
        PurchLineArch: Record "Purchase Line Archive" temporary;
        PurchaseLineArchiveType: Integer;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewArchiveDocument: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;
}

