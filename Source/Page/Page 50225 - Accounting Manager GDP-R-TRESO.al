page 50225 "Accounting Manager GDP-R-TRESO"
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
            action("<Page Customer List>")
            {
                Caption = 'Clients';
                RunObject = Page "Customer List";
            }
            action("Bank Accounts")
            {
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List Admin";
            }
            action(Currencies)
            {
                Caption = 'Currencies';
                Image = Currency;
                RunObject = Page Currencies;
            }
            action("OMH Exchange Rates")
            {
                Caption = 'OMH Exchange Rates';
                Image = Currency;
                RunObject = Page "LPSA Echange rates";
            }
            action("Validation Factures fournisseur")
            {
                Caption = 'Validation Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
            }
            action("Historique Factures fournisseur")
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(AttenteValResp1));
            }
            action(Action100000008)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(AttenteValResp2));
            }
            action(Action100000007)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(AttenteValResp3));
            }
            action(Action100000006)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(Litigieuse));
            }
        }
        area(sections)
        {
            group(ActionGroup107)
            {
                Caption = 'Journals';
                Image = Journals;
                action(ChequeEncours)
                {
                    Caption = 'Chèques commandes encours';
                    RunObject = Page "Open Check Warranty";
                }
                action("Payment Journals")
                {
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches TRESO";
                    RunPageView = WHERE("Template Type"=CONST(Payments),
                                        Recurring=CONST(false));
                }
                action("Payment Slips")
                {
                    Caption = 'Payment Slips';
                    RunObject = Page "Payment Slip List";
                }
                action("<Page Open Letters of credit>")
                {
                    Caption = 'Lettres de crédit';
                    RunObject = Page "Open Letters of credit";
                }
                action("<Page Bank Acc. Reconciliation List>")
                {
                    Caption = 'Rapprochements Bancaires';
                    RunObject = Page "Bank Acc. Reconciliation List";
                }
            }
            group(ActionGroup100000005)
            {
                Caption = 'Validation Factures fournisseur';
                Image = ValidateEmailLoggingSetup;
                action("Factures fournisseur")
                {
                    Caption = 'Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                }
                action(Action100000003)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status=CONST(AttenteValResp1));
                }
                action(Action100000002)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status=CONST(AttenteValResp2));
                }
                action(Action100000001)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status=CONST(AttenteValResp3));
                }
                action(Action100000000)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status=CONST(Litigieuse));
                }
                action(Action100000012)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status=CONST(AttentePaiement));
                }
                action(Action100000011)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status=CONST(Payee));
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Payment Slip List Archives")
                {
                    Caption = 'Payment Slip List Archives';
                    RunObject = Page "Payment Slip List Archive";
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
                action("<Page Bank Account Ledger Entries>")
                {
                    Caption = 'Ecritures comptables compte bancaire';
                    RunObject = Page "Bank Account Ledger Entries";
                }
                action("Page Bank Account Ledger Entries1")
                {
                    Caption = 'Chèques commande encours confirmés';
                    RunObject = Page "Confirmed Check Warranty";
                }
                action("Page Bank Account 22")
                {
                    Caption = 'Chèques commande encours retournés';
                    RunObject = Page "Returned Check Warranty";
                }
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Payment Slip")
            {
                Caption = 'Payment Slip';
                RunObject = Page "Payment Slip";
            }
            action("Look/Edit Payment Line")
            {
                Caption = 'Look/Edit Payment Line';
                RunObject = Page "View/Edit Payment Line";
            }
            action("Payment Report")
            {
                Caption = 'Payment Report';
                RunObject = Page "Payment Report";
            }
            action("Create Payment Slips")
            {
                Caption = 'Create Payment Slips';
                RunObject = Codeunit "Payment Management";
            }
            separator(Separator67)
            {
            }
            action("Bank Account R&econciliation")
            {
                Caption = 'Bank Account R&econciliation';
                Image = BankAccountRec;
                RunObject = Page "Bank Acc. Reconciliation";
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

