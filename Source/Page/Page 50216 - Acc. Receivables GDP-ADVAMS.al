page 50216 "Acc. Receivables GDP-ADVAMS"
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
                part(Control1902899408; "Acc. Receivable Activities")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1907692008; "My Customers")
                {
                }
                part(Control1905989608; "My Items")
                {
                    Visible = false;
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
            action("C&ustomer - List")
            {
                Caption = 'Customer - List';
                Image = "Report";
                RunObject = Report "Customer - List";
            }
            action("Customer - &Balance to Date")
            {
                Caption = 'Customer - Balance to Date';
                Image = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
            action("Aged &Accounts Receivable")
            {
                Caption = 'Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }
            action("Customer - &Summary Aging Simp.")
            {
                Caption = 'Customer - Summary Aging Simp.';
                Image = "Report";
                RunObject = Report "Customer - Summary Aging Simp.";
            }
            action("Customer Trial Balan&ce")
            {
                Caption = 'Customer Trial Balance';
                RunObject = Report "Customer - Trial Balance";
            }
            action("Customer Detail Trial Balance")
            {
                Caption = 'Customer Detail Trial Balance';
                Image = "Report";
                RunObject = Report "Customer Detail Trial Balance";
            }
            action("Cus&tomer/Item Sales")
            {
                Caption = 'Customer/Item Sales';
                Image = "Report";
                RunObject = Report "Customer/Item Sales";
            }
            action("Customer Journal")
            {
                Caption = 'Customer Journal';
                Image = "Report";
                RunObject = Report "Customer Journal";
            }
            separator(Separator20)
            {
            }
            action("Customer &Document Nos.")
            {
                Caption = 'Customer Document Nos.';
                Image = "Report";
                RunObject = Report "Customer Document Nos.";
            }
            action("Sales &Invoice Nos.")
            {
                Caption = 'Sales Invoice Nos.';
                Image = "Report";
                RunObject = Report "Sales Invoice Nos.";
            }
            action("Sa&les Credit Memo Nos.")
            {
                Caption = 'Sales Credit Memo Nos.';
                Image = "Report";
                RunObject = Report "Sales Credit Memo Nos.";
            }
            action("Re&minder Nos.")
            {
                Caption = 'Re&minder Nos.';
                Image = "Report";
                RunObject = Report "Reminder Nos.";
            }
            action("Finance Cha&rge Memo Nos.")
            {
                Caption = 'Finance Cha&rge Memo Nos.';
                Image = "Report";
                RunObject = Report "Finance Charge Memo Nos.";
            }
            separator(Separator1120005)
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
            action("<Report JIRAMA Sales  Invoice>")
            {
                Caption = 'Facture JIRAMA';
                Image = "Report";
                RunObject = Report "JIRAMA Sales  Invoice";
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Balance)
            {
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
            }
            action("Sales Quotes")
            {
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action("<Page Item List>")
            {
                Caption = 'Articles non stockés';
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Service));
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
            action(Action100000008)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp2));
            }
            action(Action100000007)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp3));
            }
            action(Action100000006)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(Litigieuse));
            }
            action(Action100000001)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttentePaiement));
            }
            action(Action100000000)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(Payee));
            }
        }
        area(sections)
        {
            group("Traitement des commandes")
            {
                Caption = 'Traitement des commandes';
                action(Action1000000026)
                {
                    Caption = 'Sales Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quotes";
                }
                action("<Page Sales Order List>")
                {
                    Caption = 'Sales Orders';
                    Image = "Order";
                    RunObject = Page "Sales Order List";
                }
                action("<Page Sales Order List - Draft>")
                {
                    Caption = 'Sales Invoices';
                    Image = Invoice;
                    RunObject = Page "Sales Order List - Draft";
                }
                action("<Page Sales Order List - Blocked>")
                {
                    Caption = 'Commandes vente bloquées';
                    RunObject = Page "Sales Order List - Blocked";
                }
                action("<Page Sales Order List - Rupture>")
                {
                    Caption = 'Commandes vente en rupture de stock';
                    RunObject = Page "Sales Order List - Rupture";
                }
                action("<Page JIRAMA Forecast List>")
                {
                    Caption = 'Prévisions de vente JIRAMA';
                    RunObject = Page "JIRAMA Forecast List";
                }
            }
            group("Logistique livraison")
            {
                Caption = 'Logistique livraison';
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
                action("<Page Sales Order List - PartInvoice>")
                {
                    Caption = 'Commandes vente partiellement facturées';
                    RunObject = Page "Sales Order List - PartInvoice";
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
                action("<Page Item Shipment List1 >")
                {
                    Caption = 'Liste documents de préparation LUBS';
                    RunObject = Page "Item Shipment List";
                }
                action(Retours)
                {
                    Caption = 'Retours de vente';
                    RunObject = Page "Sales Return Order List";
                }
            }
            group(Facturation)
            {
                Caption = 'Facturation';
                separator(Separator1000000020)
                {
                    Caption = 'Commande vente';
                }
                action("Page Sales Order List - PartShipped2")
                {
                    Caption = 'Sales Orders';
                    Image = "Order";
                    RunObject = Page "Sales Order List - PartShipped";
                }
                action("Page Sales Order List - Shipped2")
                {
                    Caption = 'Commande vente livrées';
                    RunObject = Page "Sales Order List - Shipped";
                }
                action("Page Sales Order List - PartInvoice2")
                {
                    Caption = 'Commandes vente partiellement facturées';
                    RunObject = Page "Sales Order List - PartInvoice";
                }
                separator(Cartes)
                {
                    Caption = 'Cartes';
                }
                action("<Page MoneyTech Trans Import List>")
                {
                    Caption = 'Import des transactions Moneytech';
                    RunObject = Page "MoneyTech Trans Import List";
                }
                action("General Journals")
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                }
                action("Sales Invoices")
                {
                    Caption = 'Sales Invoices';
                    Image = Invoice;
                    RunObject = Page "Sales Invoice List";
                }
                action("<Page Sales Credit Memos>")
                {
                    Caption = 'Avoirs vente';
                    RunObject = Page "Sales Credit Memos";
                }
                action("<Page Item Consignation List >")
                {
                    Caption = 'Liste de consignations de produits';
                    RunObject = Page "Item Consignation List";
                }
            }
            group("Facturation AMSA")
            {
                Caption = 'Facturation AMSA';
                action("<Page Customer Price Groups>")
                {
                    Caption = 'Groupes prix client';
                    RunObject = Page "Customer Price Groups";
                }
                action("<Page AMSA Sales Prices>")
                {
                    Caption = 'Prix de vente AMSA';
                    RunObject = Page "AMSA Sales Prices";
                }
                action("<Page Fuel Statement List>")
                {
                    Caption = 'Fuel Statement AMSA';
                    RunObject = Page "Fuel Statement List";
                }
                action(FacturePeriodique)
                {
                    Caption = 'Facturation périodique AMSA';
                    RunObject = Page "AMSA Main Invoice List";
                }
                action(FuelStatementEnreg)
                {
                    Caption = 'Fuel Statement Enregistrés';
                    RunObject = Page "Posted Fuel Statement List";
                }
                action("page Liste Facturation extra AMSA Enreg.")
                {
                    Caption = 'Facturation périodique AMSA Enregistrée';
                    RunObject = Page "Posted AMSA Main Invoice List";
                }
            }
            group("Reglement Client")
            {
                Caption = 'Reglement Client';
                action("<Page General Journal Batches CC>")
                {
                    Caption = 'Cash Receipt Journal';
                    Image = CashReceiptJournal;
                    RunObject = Page "General Journal Batches CCL";
                    RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                        Recurring = CONST(false));
                }
                action(ChequeEncours)
                {
                    Caption = 'Chèques commandes encours';
                    RunObject = Page "Open Check Warranty";
                }
                action(PaymentSlipList)
                {
                    Caption = 'Bordereaux de paiement';
                    RunObject = Page "Payment Slip List";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                }
                action(ChequesCdesConfirmes)
                {
                    Caption = 'Chèques commande encours confirmés';
                    RunObject = Page "Confirmed Check Warranty";
                }
                action(ChequesCdesRetournes)
                {
                    Caption = 'Chèques commandes encours retournés';
                    RunObject = Page "Returned Check Warranty";
                }
                action("<Page Sales Order List - Invoiced>")
                {
                    Caption = 'Commandes vente facturées';
                    RunObject = Page "Sales Order List - Invoiced";
                }
                action("<Page Sales Order List - Cancelled>")
                {
                    Caption = 'Commandes vente annulées';
                    RunObject = Page "Sales Order List - Cancelled";
                }
                action("<Page Sales Order List - Closed>")
                {
                    Caption = 'Commandes vente soldées';
                    RunObject = Page "Sales Order List - Closed";
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
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
            }
            group(ActionGroup1000000052)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
        }
        area(processing)
        {
            separator(New)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("C&ustomer")
            {
                Caption = 'Customer';
                Image = Customer;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Customer Card";
                RunPageMode = Create;
            }
            group("&Sales")
            {
                Caption = 'Sales';
                Image = Sales;
                action("Sales &Order")
                {
                    Caption = 'Sales Order';
                    Image = Document;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Order";
                    RunPageMode = Create;
                }
                action("Sales &Invoice")
                {
                    Caption = 'Sales Invoice';
                    Image = Invoice;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                }
                action("Sales &Credit Memo")
                {
                    Caption = 'Sales Credit Memo';
                    Image = CreditMemo;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Credit Memo";
                    RunPageMode = Create;
                }
            }
        }
    }
}

