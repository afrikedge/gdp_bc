page 50368 "Purchasing Agent GDP-DF"
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
                part(Control1902476008; "My Vendors")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1905989608; "My Items")
                {
                }
                systempart(Control43; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Vendor - T&op 10 List")
            {
                Caption = 'Vendor - Top 10 List';
                Image = "Report";
                RunObject = Report "Vendor - Top 10 List";
            }
            action("Vendor/&Item Purchases")
            {
                Caption = 'Vendor/Item Purchases';
                Image = "Report";
                RunObject = Report "Vendor/Item Purchases";
            }
            separator(Separator28)
            {
            }
            action("Inventory - &Availability Plan")
            {
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory &Purchase Orders")
            {
                Caption = 'Inventory Purchase Orders';
                Image = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
            action("Inventory - &Vendor Purchases")
            {
                Caption = 'Inventory - Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
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
            separator(Separator1000000082)
            {
            }
            action("Cash Flow Date List")
            {
                Caption = 'Cash Flow Date List';
                Image = "Report";
                RunObject = Report "Cash Flow Date List";
            }
            separator(Separator1000000080)
            {
            }
            action("Aged Accounts &Receivable")
            {
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Aged Accounts Pa&yable")
            {
                Caption = 'Aged Accounts Payable';
                Image = "Report";
                RunObject = Report "Aged Accounts Payable";
            }
            action("Reconcile Cus&t. and Vend. Accs")
            {
                Caption = 'Reconcile Cust. and Vend. Accs';
                Image = "Report";
                RunObject = Report "Reconcile Cust. and Vend. Accs";
            }
            separator(Separator1000000076)
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
            separator(Separator1000000071)
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
            action("Item List - Workflow")
            {
                Caption = 'Vendors to validate';
                RunObject = Page "Vendor List - Workflow";
            }
            action(Budgets)
            {
                Caption = 'Budgets';
                RunObject = Page "G/L Budget Names";
            }
            action("<Page Item ListWorflow>")
            {
                Caption = 'Items to approve';
                Image = Item;
                RunObject = Page "Item List - Compta Four";
            }
            action("Requests to Approve")
            {
                Caption = 'Requests to Approve';
                Image = Vendor;
                RunObject = Page "Requests to Approve";
            }
            action("Purchase requisition to approve")
            {
                Caption = 'Purchase requisition to approve';
                Image = Item;
                RunObject = Page "Purchase Req Pending Manager";
            }
            action("Factures comptabilisées en attente BAP")
            {
                Caption = 'Factures comptabilisées en attente BAP';
                RunObject = Page "Vendor Invoice List DFI";
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
                RunPageView = WHERE(Status = CONST(AttenteValResp1));
            }
            action(Action100000003)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp2));
            }
            action(Action100000002)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp3));
            }
            action(Action100000001)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(Litigieuse));
            }
            action(Action100000007)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttentePaiement));
            }
            action(Action100000006)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(Payee));
            }
        }
        area(sections)
        {
            group("Master files")
            {
                Caption = 'Master files';
                action("<Page Customer List>")
                {
                    Caption = 'Clients';
                    RunObject = Page "Customer List";
                }
                action(Vendors)
                {
                    Caption = 'Vendors';
                    Image = Vendor;
                    RunObject = Page "Vendor List";
                }
                action("<Page Chart of Accounts>")
                {
                    Caption = 'Plan comptable';
                    RunObject = Page "Chart of Accounts";
                }
                action("Fixed Assets list")
                {
                    Caption = 'Fixed Assets list';
                    Image = Item;
                    RunObject = Page "Fixed Asset List";
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
                action(Items)
                {
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                    RunPageView = WHERE(Type = CONST(Inventory));
                }
                action(Action1000000008)
                {
                    Caption = 'Items';
                    Image = Item;
                    RunObject = Page "Item List";
                    RunPageView = WHERE(Type = CONST(Service));
                }
                action("<Page Customer Price Groups>")
                {
                    Caption = 'Groupes prix client';
                    RunObject = Page "Customer Price Groups";
                }
                action("<Page Customer Disc. Groups>")
                {
                    Caption = 'Groupes remise client';
                    RunObject = Page "Customer Disc. Groups";
                }
                action("<Page AMSA Sales Prices>")
                {
                    Caption = 'Prix de vente AMSA';
                    RunObject = Page "AMSA Sales Prices";
                }
                action("<Page Item Fees Transport Pricing>")
                {
                    Caption = 'Frais de transport massif';
                    RunObject = Page "Item Fees Transport Pricing";
                }
                action("<page Item Fees Storage Pricing>")
                {
                    Caption = 'Frais de passage';
                    RunObject = Page "Item Fees Storage Pricing";
                }
                action("Frais de transport sur Logistique")
                {
                    Caption = 'Frais de transport sur Logistique';
                    RunObject = Page "Sites Fees Transport";
                }
                action("Prix de vente par site Jirama")
                {
                    Caption = 'Prix de vente par site Jirama';
                    RunObject = Page "Jirama Sites Item Pricing";
                }
                action("<Page Location List>")
                {
                    Caption = 'Magasins';
                    RunObject = Page "Location List";
                }
            }
            group("Analytique & Budget")
            {
                Caption = 'Analytique et Budget';
                action("<Page Dimensions>")
                {
                    Caption = 'Axes analytiques';
                    RunObject = Page Dimensions;
                }
                action("Cost Types")
                {
                    Caption = 'Cost Types';
                    RunObject = Page "Chart of Cost Types";
                }
                action("Cost Centers")
                {
                    Caption = 'Cost Centers';
                    RunObject = Page "Chart of Cost Centers";
                }
                action("Cost Objects")
                {
                    Caption = 'Cost Objects';
                    RunObject = Page "Chart of Cost Objects";
                }
                action("Cost Allocations")
                {
                    Caption = 'Cost Allocations';
                    RunObject = Page "Cost Allocation Sources";
                }
                action("Cost Budgets")
                {
                    Caption = 'Cost Budgets';
                    RunObject = Page "Cost Budget Names";
                }
                action("<Page G/L Budget Names>")
                {
                    Caption = 'Budgets';
                    RunObject = Page "G/L Budget Names";
                }
            }
            group(ActionGroup1000000105)
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
                    RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
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
            group("Fixed Assets")
            {
                Caption = 'Fixed Assets';
                Image = FixedAssets;
                action(Action1000000115)
                {
                    Caption = 'Fixed Assets';
                    RunObject = Page "Fixed Asset List";
                }
                action("Fixed Assets G/L Journals")
                {
                    Caption = 'Fixed Assets G/L Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Assets),
                                        Recurring = CONST(false));
                }
                action("Fixed Assets Journals")
                {
                    Caption = 'Fixed Assets Journals';
                    RunObject = Page "FA Journal Batches";
                    RunPageView = WHERE(Recurring = CONST(false));
                }
                action("Fixed Assets Reclass. Journals")
                {
                    Caption = 'Fixed Assets Reclass. Journals';
                    RunObject = Page "FA Reclass. Journal Batches";
                }
            }
            group(ActionGroup1000000097)
            {
                Caption = 'Validation Factures fournisseur';
                Image = ValidateEmailLoggingSetup;
                action("Factures fournisseur")
                {
                    Caption = 'Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                }
                action(Action1000000095)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status = CONST(AttenteValResp1));
                }
                action(Action1000000094)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status = CONST(AttenteValResp2));
                }
                action(Action1000000093)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status = CONST(AttenteValResp3));
                }
                action(Action1000000092)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status = CONST(Litigieuse));
                }
                action(Action1000000091)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status = CONST(AttentePaiement));
                }
                action(Action1000000090)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Validation";
                    RunPageView = WHERE(Status = CONST(Payee));
                }
            }
            group("Autres Traitement")
            {
                Caption = 'Autres Traitement';
                action("Purchase Orders")
                {
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                }
                action("<Page Sales Order List - Prices val>")
                {
                    Caption = 'Commandes vente en attente validation tarifs';
                    RunObject = Page "Sales Order List - Prices val";
                }
                action("<Page Sales Order List - To Ship>")
                {
                    Caption = 'Commandes vente en attente de livraison';
                    RunObject = Page "Sales Order List - To Ship";
                }
                action("<Page Sales Order List - PartShipped>")
                {
                    Caption = 'Commandes vente partiellement livrées';
                    RunObject = Page "Sales Order List - PartShipped";
                }
                action("<Page Sales Order List - Shipped>")
                {
                    Caption = 'Commandes vente livrées';
                    RunObject = Page "Sales Order List - Shipped";
                }
                action("<Page Sales Order List - PartInvoice>")
                {
                    Caption = 'Commandes vente partiellement facturées';
                    RunObject = Page "Sales Order List - PartInvoice";
                }
                action("<Page Sales Order List>")
                {
                    Caption = 'Sales Orders';
                    Image = "Order";
                    RunObject = Page "Sales Order List";
                }
                action("<Page Removal Order List1>")
                {
                    Caption = 'Liste des bons d''enlèvement';
                    RunObject = Page "Removal Order List";
                }
                action("<Page Delivery Order List1>")
                {
                    Caption = 'Liste des bons de livraisons';
                    RunObject = Page "Delivery Order List";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Page Posted Sales Shipments>")
                {
                    Caption = 'Livraisons ventes enregistrées';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("<Page Posted Sales Invoices>")
                {
                    Caption = 'Factures ventes enregistrées';
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Purchase Invoices")
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("<Page Posted JIRAMA Forecast List>")
                {
                    Caption = 'Prévisions de vente JIRAMA validées';
                    RunObject = Page "Posted JIRAMA Forecast List";
                }
                action("<Page Posted Moneytech Import List>")
                {
                    Caption = 'Transactions Moneytech enregistrées';
                    RunObject = Page "Posted Moneytech Import List";
                }
            }
            group(ActionGroup1000000036)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(Action1000000035)
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action(Action1000000034)
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action(Action1000000033)
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
                }
                action("Posted Purchase Credit Memos")
                {
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                }
                action("<Page Posted Purch Requisition List>")
                {
                    Caption = 'Liste des demandes d''achat enregistrées';
                    RunObject = Page "Posted Purch Requisition List";
                }
                action("<Page Posted Item Inv. Conso List>")
                {
                    Caption = 'Liste des sorties à refacturer enregistrées';
                    RunObject = Page "Posted Item Inv. Conso List";
                }
            }
            group(ActionGroup1000000029)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Page G/L Registers>")
                {
                    Caption = 'Historique des transactions comptabilité';
                    RunObject = Page "G/L Registers";
                }
                action("Payment Slip List Archives")
                {
                    Caption = 'Payment Slip List Archives';
                    RunObject = Page "Payment Slip List Archive";
                }
                action("<Page Bank Account Ledger Entries>")
                {
                    Caption = 'Ecritures comptables compte bancaire';
                    RunObject = Page "Bank Account Ledger Entries";
                }
                action("Issued Reminders")
                {
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
            }
            group(ActionGroup1000000027)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Page Posted Item Transfer List>")
                {
                    Caption = 'Liste des transferts enregistrés';
                    RunObject = Page "Posted Item Transfer List";
                }
                action("<Page Posted Item Exchange List>")
                {
                    Caption = 'Liste d''échanges de produits enregistrés';
                    RunObject = Page "Posted Item Exchange List";
                }
                action("<Page Posted Item Loan List>")
                {
                    Caption = 'Liste de prêts produits enregistrés';
                    RunObject = Page "Posted Item Loan List";
                }
                action("<Page Posted Item Consignation List>")
                {
                    Caption = 'Liste de consignations de produits enregistrées';
                    RunObject = Page "Posted Item Consignation List";
                }
                action("<Page Posted Item Borrow List>")
                {
                    Caption = 'Liste d''emprunts de produts enregistrés';
                    RunObject = Page "Posted Item Borrow List";
                }
                action("<Page Confirmed Delivery Order List>")
                {
                    Caption = 'Liste des bons de livraison confirmés';
                    RunObject = Page "Confirmed Delivery Order List";
                }
                action("<Page Confirmed Removal Order List>")
                {
                    Caption = 'Liste des bons d''enlèvement confirmés';
                    RunObject = Page "Confirmed Removal Order List";
                }
                action("Posted Sales Shipment")
                {
                    Caption = 'Posted Sales Shipment';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
                action(RetousEnreg)
                {
                    Caption = 'Liste des retours enregistres';
                    RunObject = Page "Posted Return Shipments";
                }
                action("<Page Posted Item Shipment List>")
                {
                    Caption = 'Liste documents de préparation enregistrés';
                    RunObject = Page "Posted Item Shipment List";
                }
                action(BLAnnules)
                {
                    Caption = 'Cancelled Delivery Order List';
                    RunObject = Page "Cancelled Delivery Order List";
                }
                action(BEAnnules)
                {
                    Caption = 'Cancelled Removal Order List';
                    RunObject = Page "Cancelled Removal Order List";
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action(Action1000000125)
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
    }
}

