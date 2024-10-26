page 50207 "Purchasing Agent GDP-ACH"
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
                part(Control1907662708;"Purchase Agent Activities")
                {
                }
                part(Control1902476008;"My Vendors")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1905989608;"My Items")
                {
                }
                systempart(Control43;MyNotes)
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
                Caption = 'Vendor - T&op 10 List';
                Image = "Report";
                RunObject = Report "Vendor - Top 10 List";
            }
            action("Vendor/&Item Purchases")
            {
                Caption = 'Vendor/&Item Purchases';
                Image = "Report";
                RunObject = Report "Vendor/Item Purchases";
            }
            separator(Separator28)
            {
            }
            action("Inventory - &Availability Plan")
            {
                Caption = 'Inventory - &Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory &Purchase Orders")
            {
                Caption = 'Inventory &Purchase Orders';
                Image = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
            action("Inventory - &Vendor Purchases")
            {
                Caption = 'Inventory - &Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
        }
        area(embedding)
        {
            action(Vendors)
            {
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
                RunPageView = WHERE(Type=CONST(Inventory));
            }
            action(Action1000000007)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
                RunPageView = WHERE(Type=CONST(Service));
            }
            action("Unités de mesure")
            {
                Caption = 'Unités de mesure';
                RunObject = Page "Units of Measure";
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
            action(Action100000001)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(AttentePaiement));
            }
            action(Action100000000)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(Payee));
            }
        }
        area(sections)
        {
            group(Achats)
            {
                Caption = 'Achats';
                action("Purchase Quotes")
                {
                    Caption = 'Purchase Quotes';
                    RunObject = Page "Purchase Quotes";
                }
                action("Purchase Orders")
                {
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    Visible = false;
                }
                action(NonReceivedPuchOrders)
                {
                    Caption = 'Non Received purchase orders';
                    RunObject = Page "NonReceived Purch Order List";
                }
                action("<Page Requests to Approve >")
                {
                    Caption = 'Commandes à approuver';
                    RunObject = Page "Requests to Approve";
                }
                action(PartiallyReceivedPuchOrders)
                {
                    Caption = 'Partially Received purchase orders';
                    RunObject = Page "Partially Received Purch Order";
                }
                action(ReceivedPuchOrders)
                {
                    Caption = 'Received purchase orders';
                    RunObject = Page "Received Purchase Order List";
                }
                action("<Page Purchase Return Order List>")
                {
                    Caption = 'Purchase Return Orders';
                    RunObject = Page "Purchase Return Order List";
                }
            }
            group(Stocks)
            {
                Caption = 'Stocks';
                action("<Page Item Invoiced Conso List>")
                {
                    Caption = 'Liste de sorties à refacturer';
                    RunObject = Page "Item Invoiced Conso List";
                }
                action("<Item Invoiced Conso List Relea>")
                {
                    Caption = 'Liste de sorties à refacturer (en attente facturation)';
                    RunObject = Page "Item Invoiced Conso List Relea";
                }
                action("Item Journals")
                {
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(Item),
                                        Recurring=CONST(false));
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
                action("<Page Purchase Order invoiced list>")
                {
                    Caption = 'Liste des commandes d''achats facturées';
                    RunObject = Page "Purchase Order Invoiced";
                }
                action("<Page Purchase Order cancelled List>")
                {
                    Caption = 'Liste des commandes d''achats soldées';
                    RunObject = Page "Purchase Order Cancelled";
                }
            }
        }
        area(creation)
        {
            action("Purchase &Quote")
            {
                Caption = 'Purchase &Quote';
                Image = Quote;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Quote";
                RunPageMode = Create;
            }
            action("Purchase &Invoice")
            {
                Caption = 'Purchase &Invoice';
                Image = Invoice;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("Purchase &Order")
            {
                Caption = 'Purchase &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase &Return Order")
            {
                Caption = 'Purchase &Return Order';
                Image = ReturnOrder;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Return Order";
                RunPageMode = Create;
            }
            action("T&ransfer Order")
            {
                Caption = 'T&ransfer Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Transfer Order";
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
            action("Item &Journal")
            {
                Caption = 'Item &Journal';
                Image = Journals;
                RunObject = Page "Item Journal";
            }
            separator(Separator38)
            {
            }
            action("Requisition &Worksheet")
            {
                Caption = 'Requisition &Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type"=CONST("Req."),
                                    Recurring=CONST(false));
            }
        }
    }
}

