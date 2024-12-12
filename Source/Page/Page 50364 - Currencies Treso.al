page 50364 "Currencies Treso"
{
    Caption = 'Currencies';
    CardPageID = "Currency Card Treso";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Exchange Rate Service';
    SourceTable = Currency;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(ExchangeRateDate; ExchangeRateDate)
                {
                    Caption = 'Exchange Rate Date';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(ExchangeRateAmt; ExchangeRateAmt)
                {
                    Caption = 'Exchange Rate';
                    DecimalPlaces = 0 : 7;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field("EMU Currency"; Rec."EMU Currency")
                {
                }
                field("Realized Gains Acc."; Rec."Realized Gains Acc.")
                {
                }
                field("Realized Losses Acc."; Rec."Realized Losses Acc.")
                {
                }
                field("Unrealized Gains Acc."; Rec."Unrealized Gains Acc.")
                {
                }
                field("Unrealized Losses Acc."; Rec."Unrealized Losses Acc.")
                {
                }
                field("Realized G/L Gains Account"; Rec."Realized G/L Gains Account")
                {
                    Visible = false;
                }
                field("Realized G/L Losses Account"; Rec."Realized G/L Losses Account")
                {
                    Visible = false;
                }
                field("Residual Gains Account"; Rec."Residual Gains Account")
                {
                    Visible = false;
                }
                field("Residual Losses Account"; Rec."Residual Losses Account")
                {
                    Visible = false;
                }
                field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
                {
                }
                field("Amount Decimal Places"; Rec."Amount Decimal Places")
                {
                }
                field("Invoice Rounding Precision"; Rec."Invoice Rounding Precision")
                {
                }
                field("Invoice Rounding Type"; Rec."Invoice Rounding Type")
                {
                }
                field("Unit-Amount Rounding Precision"; Rec."Unit-Amount Rounding Precision")
                {
                }
                field("Unit-Amount Decimal Places"; Rec."Unit-Amount Decimal Places")
                {
                }
                field("Appln. Rounding Precision"; Rec."Appln. Rounding Precision")
                {
                }
                field("Conv. LCY Rndg. Debit Acc."; Rec."Conv. LCY Rndg. Debit Acc.")
                {
                }
                field("Conv. LCY Rndg. Credit Acc."; Rec."Conv. LCY Rndg. Credit Acc.")
                {
                }
                field("Max. VAT Difference Allowed"; Rec."Max. VAT Difference Allowed")
                {
                    Visible = false;
                }
                field("VAT Rounding Type"; Rec."VAT Rounding Type")
                {
                    Visible = false;
                }
                field("Last Date Adjusted"; Rec."Last Date Adjusted")
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Payment Tolerance %"; Rec."Payment Tolerance %")
                {
                }
                field("Max. Payment Tolerance Amount"; Rec."Max. Payment Tolerance Amount")
                {
                }
                field(CurrencyFactor; CurrencyFactor)
                {
                    Caption = 'Currency Factor';
                    DecimalPlaces = 1 : 6;

                    trigger OnValidate()
                    var
                        CurrencyExchangeRate: Record "Currency Exchange Rate";
                    begin
                        CurrencyExchangeRate.SetCurrentCurrencyFactor(Rec.Code, CurrencyFactor);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Change Payment &Tolerance")
                {
                    Caption = 'Change Payment &Tolerance';
                    Image = ChangePaymentTolerance;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ChangePmtTol: Report "Change Payment Tolerance";
                    begin
                        ChangePmtTol.SetCurrency(Rec);
                        ChangePmtTol.RunModal;
                    end;
                }
            }
            action("Exch. &Rates")
            {
                Caption = 'Exch. &Rates';
                Image = CurrencyExchangeRates;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Currency Exchange Rates";
                RunPageLink = "Currency Code" = FIELD(Code);
            }
            action("Adjust Exchange Rate")
            {
                Caption = 'Adjust Exchange Rate';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("Exchange Rate Adjust. Register")
            {
                Caption = 'Exchange Rate Adjust. Register';
                Image = ExchangeRateAdjustRegister;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Exchange Rate Adjmt. Register";
                RunPageLink = "Currency Code" = FIELD(Code);
            }
            action("Exchange Rate Services")
            {
                Caption = 'Exchange Rate Services';
                Image = Web;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Curr. Exch. Rate Service List";
            }
            action(UpdateExchangeRates)
            {
                Caption = 'Update Exchange Rates';
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Codeunit "Update Currency Exchange Rates";
            }
        }
        area(reporting)
        {
            action("Foreign Currency Balance")
            {
                Caption = 'Foreign Currency Balance';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Foreign Currency Balance";
            }
        }
        area(navigation)
        {
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Image = Administration;
                Visible = CRMIntegrationEnabled;
                action(CRMGotoTransactionCurrency)
                {
                    Caption = 'Transaction Currency';
                    Image = CoupledCurrency;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM transaction currency.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record" = IM;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send updated data to Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        Currency: Record Currency;
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        CurrencyRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(Currency);
                        Currency.Next;

                        if Currency.Count = 1 then
                            CRMIntegrationManagement.UpdateOneNow(Currency.RecordId)
                        else begin
                            CurrencyRecordRef.GetTable(Currency);
                            CRMIntegrationManagement.UpdateMultipleNow(CurrencyRecordRef);
                        end
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM Transaction Currency.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            //MIGRATION***************
                            //CRMIntegrationManagement.CreateOrUpdateCoupling(RECORDID);
                            //MIGRATION***************
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM Transaction Currency.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(Rec.RecordId);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
    end;

    trigger OnAfterGetRecord()
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        CurrencyFactor := CurrencyExchangeRate.GetCurrentCurrencyFactor(Rec.Code);
        CurrencyExchangeRate.GetLastestExchangeRate(Rec.Code, ExchangeRateDate, ExchangeRateAmt);
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CurrencyFactor: Decimal;
        ExchangeRateAmt: Decimal;
        ExchangeRateDate: Date;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;

    procedure GetSelectionFilter(): Text
    var
        Currency: Record Currency;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Currency);
        exit(SelectionFilterManagement.GetSelectionFilterForCurrency(Currency));
    end;

    procedure GetCurrency(var CurrencyCode: Code[10])
    begin
        CurrencyCode := Rec.Code;
    end;

    local procedure DrillDownActionOnPage()
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.SetRange("Currency Code", Rec.Code);
        PAGE.RunModal(0, CurrExchRate);
        CurrPage.Update(false);
    end;
}

