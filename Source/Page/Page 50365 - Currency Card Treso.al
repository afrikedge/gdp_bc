page 50365 "Currency Card Treso"
{
    Caption = 'Currency Card';
    Editable = false;
    PageType = Card;
    SourceTable = Currency;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    Importance = Promoted;
                }
                field(Description; Rec.Description)
                {
                    Importance = Promoted;
                }
                field("Unrealized Gains Acc."; Rec."Unrealized Gains Acc.")
                {
                }
                field("Realized Gains Acc."; Rec."Realized Gains Acc.")
                {
                }
                field("Unrealized Losses Acc."; Rec."Unrealized Losses Acc.")
                {
                }
                field("Realized Losses Acc."; Rec."Realized Losses Acc.")
                {
                }
                field("EMU Currency"; Rec."EMU Currency")
                {
                    Importance = Promoted;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Last Date Adjusted"; Rec."Last Date Adjusted")
                {
                    Importance = Promoted;
                }
                field("Payment Tolerance %"; Rec."Payment Tolerance %")
                {
                }
                field("Max. Payment Tolerance Amount"; Rec."Max. Payment Tolerance Amount")
                {
                }
            }
            group(Rounding)
            {
                Caption = 'Rounding';
                field("Invoice Rounding Precision"; Rec."Invoice Rounding Precision")
                {
                    Importance = Promoted;
                }
                field("Invoice Rounding Type"; Rec."Invoice Rounding Type")
                {
                    Importance = Promoted;
                }
                field("Amount Rounding Precision"; Rec."Amount Rounding Precision")
                {
                }
                field("Amount Decimal Places"; Rec."Amount Decimal Places")
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
                    Importance = Promoted;
                }
                field("VAT Rounding Type"; Rec."VAT Rounding Type")
                {
                    Importance = Promoted;
                }
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                field("Realized G/L Gains Account"; Rec."Realized G/L Gains Account")
                {
                    Importance = Promoted;
                }
                field("Realized G/L Losses Account"; Rec."Realized G/L Losses Account")
                {
                    Importance = Promoted;
                }
                field("Residual Gains Account"; Rec."Residual Gains Account")
                {
                    Importance = Promoted;
                }
                field("Residual Losses Account"; Rec."Residual Losses Account")
                {
                    Importance = Promoted;
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
        }
        area(reporting)
        {
            action("Foreign Currency Balance")
            {
                Caption = 'Foreign Currency Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Foreign Currency Balance";
            }
            action("Aged Accounts Receivable")
            {
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Payable")
            {
                Caption = 'Aged Accounts Payable';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            action("Trial Balance")
            {
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance";
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
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
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
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
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
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
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

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
}

