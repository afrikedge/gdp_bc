page 50219 "Accounting Manager GDP-CDC"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control1902304208;"Account Manager Activities")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1902476008;"My Vendors")
                {
                }
                systempart(Control1901377608;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("&G/L Trial Balance")
            {
                Caption = '&G/L Trial Balance';
                Image = "Report";
                RunObject = Report "G/L Trial Balance";
            }
            action("G/L Detail Trial Balance")
            {
                Caption = 'G/L Detail Trial Balance';
                Image = "Report";
                RunObject = Report "G/L Detail Trial Balance";
            }
            action("Bank Trial Balance")
            {
                Caption = 'Bank Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Account Trial Balance";
            }
            action("&Bank Detail Trial Balance")
            {
                Caption = '&Bank Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Bank Acc. Detail Trial Balance";
            }
            action("&Account Schedule")
            {
                Caption = '&Account Schedule';
                Image = "Report";
                RunObject = Report "Account Schedule";
            }
            action("FR Account Schedule")
            {
                Caption = 'FR Account Schedule';
                Image = "Report";
                RunObject = Report "FR Account Schedule";
            }
            action("Report G/L Account Statement")
            {
                Caption = 'Report G/L Account Statement';
                Image = "Report";
                RunObject = Report "G/L Account Statement";
            }
            action("Bu&dget")
            {
                Caption = 'Bu&dget';
                Image = "Report";
                RunObject = Report Budget;
            }
            action("Trial Bala&nce/Budget")
            {
                Caption = 'Trial Bala&nce/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
            }
            action("Trial Balance by &Period")
            {
                Caption = 'Trial Balance by &Period';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action("&Fiscal Year Balance")
            {
                Caption = '&Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                Caption = 'Balance Comp. - Prev. Y&ear';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("&Closing Trial Balance")
            {
                Caption = '&Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            separator(Separator49)
            {
            }
            action("Cash Flow Date List")
            {
                Caption = 'Cash Flow Date List';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
            }
            separator(Separator115)
            {
            }
            action("Aged Accounts &Receivable")
            {
                Caption = 'Aged Accounts &Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Pa&yable")
            {
                Caption = 'Aged Accounts Pa&yable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            action("Reconcile Cus&t. and Vend. Accs")
            {
                Caption = 'Reconcile Cus&t. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(Separator4)
            {
            }
            action("Cost Accounting P/L Statement")
            {
                Caption = 'Cost Accounting P/L Statement';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement";
            }
            action("CA P/L Statement per Period")
            {
                Caption = 'CA P/L Statement per Period';
                Image = "Report";
                RunObject = Report "Cost Acctg. Stmt. per Period";
            }
            action("CA P/L Statement with Budget")
            {
                Caption = 'CA P/L Statement with Budget';
                Image = "Report";
                RunObject = Report "Cost Acctg. Statement/Budget";
            }
            action("Cost Accounting Analysis")
            {
                Caption = 'Cost Accounting Analysis';
                Image = "Report";
                RunObject = Report "Cost Acctg. Analysis";
            }
            separator(Separator1120008)
            {
            }
            action(Journals)
            {
                Caption = 'Journals';
                Image = "Report";
                RunObject = Report Journals;
            }
            action("Customer Journal")
            {
                Caption = 'Customer Journal';
                Image = "Report";
                RunObject = Report "Customer Journal";
            }
            action("Vendor Journal")
            {
                Caption = 'Vendor Journal';
                Image = "Report";
                RunObject = Report "Vendor Journal";
            }
            action("Bank Account Journal")
            {
                Caption = 'Bank Account Journal';
                Image = "Report";
                RunObject = Report "Bank Account Journal";
            }
            separator(Separator1120013)
            {
            }
            action("Payments Lists")
            {
                Caption = 'Payments Lists';
                Image = "Report";
                RunObject = Report "Payment List";
            }
            action("GL/Cust. Ledger Reconciliation")
            {
                Caption = 'GL/Cust. Ledger Reconciliation';
                Image = "Report";
                RunObject = Report "GL/Cust. Ledger Reconciliation";
            }
            action("GL/Vend. Ledger Reconciliation")
            {
                Caption = 'GL/Vend. Ledger Reconciliation';
                Image = "Report";
                RunObject = Report "GL/Vend. Ledger Reconciliation";
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts ADMIN";
            }
            action("Item List - Workflow")
            {
                Caption = 'Vendors to validate';
                RunObject = Page "Vendor List - Workflow";
            }
            action(Vendors)
            {
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(Balance)
            {
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Vendor List";
                RunPageView = WHERE("Balance (LCY)"=FILTER(<>0));
            }
            action("Purchase Orders")
            {
                Caption = 'Purchase Orders';
                RunObject = Page "Purchase Order List";
            }
            action(Budgets)
            {
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
            action("Bank Accounts")
            {
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List Admin";
            }
            action("VAT Statements")
            {
                Caption = 'VAT Statements';
                RunObject = Page "VAT Statement Names";
            }
            action("<Page Item ListWorflow>")
            {
                Caption = 'Items to approve';
                Image = Item;
                RunObject = Page "Item List - Compta Four";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
                RunPageView = WHERE(Type=CONST(Inventory));
            }
            action(Action1000000000)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
                RunPageView = WHERE(Type=CONST(Service));
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Action13)
            {
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE("Balance (LCY)"=FILTER(<>0));
            }
        }
        area(sections)
        {
            group(ActionGroup107)
            {
                Caption = 'Journals';
                Image = Journals;
                action("Purchase Journals")
                {
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(Purchases),
                                        Recurring=CONST(false));
                }
                action("Sales Journals")
                {
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(Sales),
                                        Recurring=CONST(false));
                }
                action("Cash Receipt Journals")
                {
                    Caption = 'Cash Receipt Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST("Cash Receipts"),
                                        Recurring=CONST(false));
                }
                action("Payment Journals")
                {
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(Payments),
                                        Recurring=CONST(false));
                }
                action("General Journals")
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(General),
                                        Recurring=CONST(false));
                }
                action(Action1000000001)
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(General),
                                        Recurring=CONST(true));
                }
                action("Payment Slips")
                {
                    Caption = 'Payment Slips';
                    RunObject = Page "Payment Slip List";
                }
            }
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;
                action(Action17)
                {
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                }
                action("Fixed Assets G/L Journals")
                {
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(Assets),
                                        Recurring=CONST(false));
                }
                action("Fixed Assets Journals")
                {
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring=CONST(false));
                }
                action("Fixed Assets Reclass. Journals")
                {
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                }
            }
            group("Cash Flow")
            {
                Caption = 'Cash Flow';
                action("Cash Flow Forecasts")
                {
                    Caption = 'Cash Flow Forecasts';
                    RunObject = Page "Cash Flow Forecast List";
                }
                action("Chart of Cash Flow Accounts")
                {
                    Caption = 'Chart of Cash Flow Accounts';
                    RunObject = Page "Chart of Cash Flow Accounts";
                }
                action("Cash Flow Manual Revenues")
                {
                    Caption = 'Cash Flow Manual Revenues';
                    RunObject = Page "Cash Flow Manual Revenues";
                }
                action("Cash Flow Manual Expenses")
                {
                    Caption = 'Cash Flow Manual Expenses';
                    RunObject = Page "Cash Flow Manual Expenses";
                }
            }
            group("Validation Factures fournisseur")
            {
                Caption = 'Validation Factures fournisseur';
                action("Payroll Modif Validated")
                {
                    Caption = 'Payroll Modif Validated';
                    RunObject = Page "Vendor Invoice List Saisie";
                }
                action("Factures fournisseur")
                {
                    Caption = 'Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                }
                action("Historique Factures fournisseur")
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(Receptionee));
                }
                action(Action100000012)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(Rejetee));
                }
                action(Action100000011)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(AttenteValResp1));
                }
                action(Action100000005)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(AttenteValResp2));
                }
                action(Action100000004)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(AttenteValResp3));
                }
                action(Action100000003)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(Litigieuse));
                }
                action(Action100000002)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(AttentePaiement));
                }
                action(Action100000001)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(Archived));
                }
                action(Action100000000)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status=CONST(Payee));
                }
            }
            group(ActionGroup1000000015)
            {
                Caption = 'Journals';
                Image = Journals;
                action(Action1000000014)
                {
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                }
                action("<Page PBL Purchase Order List>")
                {
                    Caption = 'Commande achat marchandise';
                    RunObject = Page "PBL Purchase Order List";
                }
                action("<Page Purchase Invoices>")
                {
                    Caption = 'Purchase Invoices';
                    RunObject = Page "Purchase Invoices";
                }
                action("Purchase Credit Memo List")
                {
                    Caption = 'Purchase Credit Memo List';
                    RunObject = Page "Purchase Credit Memos";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("Issued Reminders")
                {
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
                action("Issued Fin. Charge Memos")
                {
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                action("Cost Accounting Registers")
                {
                    Caption = 'Cost Accounting Registers';
                    RunObject = Page "Cost Registers";
                }
                action("Cost Accounting Budget Registers")
                {
                    Caption = 'Cost Accounting Budget Registers';
                    RunObject = Page "Cost Budget Registers";
                }
                action("Payment Slip List Archives")
                {
                    Caption = 'Payment Slip List Archives';
                    RunObject = Page "Payment Slip List Archive";
                }
                action("Confirmed Shipment to invoice")
                {
                    Caption = 'Confirmed Shipment to invoice';
                    RunObject = Page "Confirmed Shipment to invoice";
                }
                action("Invoice To Receive BE")
                {
                    Caption = 'Invoice To Receive BE';
                    RunObject = Page "Invoice To Receive BE";
                }
                action("Ecritures cargaison")
                {
                    Caption = 'Ecritures cargaison';
                    RunObject = Page "Item Cargo Entries List";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action(Currencies)
                {
                    Caption = 'Currencies';
                    Image = Currency;
                    RunObject = Page Currencies;
                }
                action("Accounting Periods")
                {
                    Caption = 'Accounting Periods';
                    Image = AccountingPeriods;
                    RunObject = Page "Accounting Periods";
                }
                action("Number Series")
                {
                    Caption = 'Number Series';
                    RunObject = Page "No. Series";
                }
                action("Account Schedules")
                {
                    Caption = 'Account Schedules';
                    RunObject = Page "Account Schedule Names";
                }
                action("FR Account Schedules")
                {
                    Caption = 'FR Account Schedules';
                    RunObject = Page "FR Account Schedule Names";
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page Dimensions;
                }
                action("Users groups")
                {
                    Caption = 'Users groups';
                    Image = Item;
                    RunObject = Page "User Groups";
                }
                action("Users groups Company")
                {
                    Caption = 'Users groups Company';
                    Image = Item;
                    RunObject = Page "Période de validation Societe";
                }
                action("OMG Exchange Rates")
                {
                    Caption = 'OMG Exchange Rates';
                    Image = Item;
                    RunObject = Page "LPSA Echange rates";
                }
            }
        }
        area(creation)
        {
            action("Sales &Credit Memo")
            {
                Caption = 'Sales &Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Credit Memo";
                RunPageMode = Create;
            }
            action("P&urchase Credit Memo")
            {
                Caption = 'P&urchase Credit Memo';
                Image = CreditMemo;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            action("Archive Payment Journals")
            {
                Caption = 'Archive Payment Journals';
                Image = "Report";
                RunObject = Report "Archive Payment Slips";
            }
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action(Action1120020)
            {
                Caption = 'Archive Payment Journals';
                Image = "Report";
                RunObject = Report "Archive Payment Slips";
            }
            action("Create Payment Slips")
            {
                Caption = 'Create Payment Slips';
                RunObject = Codeunit "Payment Management";
            }
            separator(Separator67)
            {
            }
            action("Analysis &Views")
            {
                Caption = 'Analysis &Views';
                Image = AnalysisView;
                RunObject = Page "Analysis View List";
            }
            action("Analysis by &Dimensions")
            {
                Caption = 'Analysis by &Dimensions';
                Image = AnalysisViewDimension;
                RunObject = Page "Analysis by Dimensions";
            }
            action("Calculate Deprec&iation")
            {
                Caption = 'Calculate Deprec&iation';
                Ellipsis = true;
                Image = CalculateDepreciation;
                RunObject = Report "Calculate Depreciation";
            }
            action("Import Co&nsolidation from Database")
            {
                Caption = 'Import Co&nsolidation from Database';
                Ellipsis = true;
                Image = ImportDatabase;
                RunObject = Report "Import Consolidation from DB";
            }
            action("Bank Account R&econciliation")
            {
                Caption = 'Bank Account R&econciliation';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation";
            }
            action("Adjust E&xchange Rates")
            {
                Caption = 'Adjust E&xchange Rates';
                Ellipsis = true;
                Image = AdjustExchangeRates;
                RunObject = Report "Adjust Exchange Rates";
            }
            action("P&ost Inventory Cost to G/L")
            {
                Caption = 'P&ost Inventory Cost to G/L';
                Image = PostInventoryToGL;
                RunObject = Report "Post Inventory Cost to G/L";
            }
            separator(Separator97)
            {
            }
            action("C&reate Reminders")
            {
                Caption = 'C&reate Reminders';
                Ellipsis = true;
                Image = CreateReminders;
                RunObject = Report "Create Reminders";
            }
            separator(Separator73)
            {
            }
            action("Intrastat &Journal")
            {
                Caption = 'Intrastat &Journal';
                Image = Journal;
                RunObject = Page "Intrastat Jnl. Batches";
            }
            action("Calc. and Pos&t VAT Settlement")
            {
                Caption = 'Calc. and Pos&t VAT Settlement';
                Image = SettleOpenTransactions;
                RunObject = Report "Calc. and Post VAT Settlement";
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

