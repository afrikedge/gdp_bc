page 50221 "Accounting Manager GDP-FOUR"
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
                part(Control1902304208; "Account Manager Activities")
                {
                }
                part(Control1907692008; "My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1902476008; "My Vendors")
                {
                }
                systempart(Control1901377608; MyNotes)
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
                Caption = 'Budget';
                Image = "Report";
                RunObject = Report Budget;
            }
            action("Trial Bala&nce/Budget")
            {
                Caption = 'Trial Balance/Budget';
                Image = "Report";
                RunObject = Report "Trial Balance/Budget";
            }
            action("Trial Balance by &Period")
            {
                Caption = 'Trial Balance by Period';
                Image = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action("&Fiscal Year Balance")
            {
                Caption = 'Fiscal Year Balance';
                Image = "Report";
                RunObject = Report "Fiscal Year Balance";
            }
            action("Balance Comp. - Prev. Y&ear")
            {
                Caption = 'Balance Comp. - Prev. Year';
                Image = "Report";
                RunObject = Report "Balance Comp. - Prev. Year";
            }
            action("&Closing Trial Balance")
            {
                Caption = 'Closing Trial Balance';
                Image = "Report";
                RunObject = Report "Closing Trial Balance";
            }
            separator(Separator49)
            {
            }
            action("Aged Accounts Pa&yable")
            {
                Caption = 'Aged Accounts Payable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
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
            action("Vendor Journal")
            {
                Caption = 'Vendor Journal';
                Image = "Report";
                RunObject = Report "Vendor Journal";
            }
            separator(Separator1120013)
            {
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
                RunObject = Page "Chart of Accounts";
            }
            action("Vendor List - Workflow")
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
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
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
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action(Action1000000000)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Service));
            }
        }
        area(sections)
        {
            group(ActionGroup1000000006)
            {
                Caption = 'Journals';
                Image = Journals;
                action("Purchase Orders")
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
            group(ActionGroup107)
            {
                Caption = 'Journals';
                Image = Journals;
                action("Purchase Journals")
                {
                    Caption = 'Purchase Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Purchases),
                                        Recurring = CONST(false));
                }
                action("Payment Journals")
                {
                    Caption = 'Payment Journals';
                    Image = Journals;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                }
                action("General Journals")
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                }
                action(Action1000000001)
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(true));
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
                    RunPageView = WHERE(Status = CONST(Receptionee));
                }
                action(Action100000011)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Rejetee));
                }
                action(Action100000010)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttenteValResp1));
                }
                action(Action100000009)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttenteValResp2));
                }
                action(Action100000008)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttenteValResp3));
                }
                action(Action100000007)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Litigieuse));
                }
                action(Action100000004)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttentePaiement));
                }
                action(Action100000000)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Archived));
                }
                action(Action100000002)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Payee));
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
                action("<Page Delivery Order List1>")
                {
                    Caption = 'Liste des bons de livraisons';
                    RunObject = Page "Delivery Order List";
                }
                action("<Page Confirmed Delivery Order List>")
                {
                    Caption = 'Liste des bons de livraison confirmés';
                    RunObject = Page "Confirmed Delivery Order List";
                }
                action(BLAnnules)
                {
                    Caption = 'Cancelled Delivery Order List';
                    RunObject = Page "Cancelled Delivery Order List";
                }
            }
        }
        area(creation)
        {
            action("Purchase Invoice")
            {
                Caption = 'Purchase Invoice';
                Image = CreditMemo;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("P&urchase Credit Memo")
            {
                Caption = 'Purchase Credit Memo';
                Image = CreditMemo;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Credit Memo";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Pa&yment Journal")
            {
                Caption = 'Payment Journal';
                Image = PaymentJournal;
                RunObject = Page "Payment Journal";
            }
            action("Payment Slip")
            {
                Caption = 'Payment Slip';
                RunObject = Page "Payment Slip";
            }
            separator(Separator73)
            {
            }
            action("Calc. and Pos&t VAT Settlement")
            {
                Caption = 'Calc. and Post VAT Settlement';
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
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

