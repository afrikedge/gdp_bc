page 50205 "Purchasing Agent GDP-APP"
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
                RunObject = Page "Item List";
                RunPageView = WHERE(Type=CONST(Inventory));
            }
            action("<Page Location List>")
            {
                Caption = 'Location';
                Image = Item;
                RunObject = Page "Location List";
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
            action(Action100000002)
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
            group("Achat Marchandise")
            {
                Caption = 'Achat Marchandise';
                action("Purchase Quotes")
                {
                    Caption = 'Purchase Quotes';
                    RunObject = Page "Purchase Quotes";
                }
                action("<Page PBL Purchase Order List>")
                {
                    Caption = 'Commande achat marchandise';
                    RunObject = Page "PBL Purchase Order List";
                }
                action("Purchase Return Orders")
                {
                    Caption = 'Purchase Return Orders';
                    RunObject = Page "Purchase Return Order List";
                }
                action("<Page Cargo List>")
                {
                    Caption = 'Cargaison';
                    RunObject = Page "Cargo List";
                }
            }
            group("Stock Marchandise")
            {
                Caption = 'Stock Marchandise';
                action("<Page Item Transfer List>")
                {
                    Caption = 'Transferts de produits';
                    RunObject = Page "Item Transfer List";
                }
                action("<Page Item Exchange List>")
                {
                    Caption = 'Echanges de produits';
                    RunObject = Page "Item Exchange List";
                }
                action("<Page Item Loan List>")
                {
                    Caption = 'Prêts de produits';
                    RunObject = Page "Item Loan List";
                }
                action("<Page Item Consignation List>")
                {
                    Caption = 'Consignations de produits';
                    RunObject = Page "Item Consignation List";
                }
                action("<Page Item Borrow List>")
                {
                    Caption = 'Emprunts de produits';
                    RunObject = Page "Item Borrow List";
                }
                action("Item Journals")
                {
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST(Item),
                                        Recurring=CONST(false));
                }
                action(Action1000000004)
                {
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type"=CONST("Phys. Inventory"),
                                        Recurring=CONST(false));
                }
                action("Requisition Worksheets")
                {
                    Caption = 'Requisition Worksheets';
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = WHERE("Template Type"=CONST("Req."),
                                        Recurring=CONST(false));
                }
                action("Page Item Invoiced Conso List2")
                {
                    Caption = 'Liste de sorties à refacturer';
                    RunObject = Page "Item Invoiced Conso List";
                }
                action("<Page Item Invoiced Conso List>")
                {
                    Caption = 'Liste de sorties à refacturer (En attente facturation)';
                    RunObject = Page "Item Invoiced Conso List Relea";
                }
            }
            group("Logistique livraison")
            {
                Caption = 'Logistique livraison';
                action("Sales Orders")
                {
                    Caption = 'Sales Orders';
                    Image = "Order";
                    RunObject = Page "Sales Order List";
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
                action("<Page Sales Order List - PartInvoice>")
                {
                    Caption = 'Commandes vente partiellement facturées';
                    RunObject = Page "Sales Order List - PartInvoice";
                }
                action("<Page Bon Dispaching List>")
                {
                    Caption = 'Liste des bons';
                    RunObject = Page "Bon Dispaching List";
                }
                action("<Page Confirmed Bon List>")
                {
                    Caption = 'Liste des bons confirmés';
                    RunObject = Page "Confirmed Bon List";
                }
                action("<Page Cancelled Bon List>")
                {
                    Caption = 'Liste des bons annulés';
                    RunObject = Page "Cancelled Bon List";
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
                action(SuiviFqcturesTrqns)
                {
                    Caption = 'Suivi des factures transporteurs';
                    RunObject = Page "Confirmed Shipment to invoice";
                }
                action(Retours)
                {
                    Caption = 'Retours de vente';
                    RunObject = Page "Sales Return Order List";
                }
                action("<Page Sales Order List - Shipped>")
                {
                    Caption = 'Commandes vente livrées';
                    RunObject = Page "Sales Order List - Shipped";
                }
                action("<Page Sales Order List - Rupture>")
                {
                    Caption = 'Commandes vente en rupture de stock';
                    RunObject = Page "Sales Order List - Rupture";
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
                action("<Page Posted Purch Requisition List ")
                {
                    Caption = 'Liste des demandes d''achat archivées';
                    RunObject = Page "Posted Purch Requisition List";
                }
                action("<Page Posted Item Inv. Conso List>")
                {
                    Caption = 'Liste des sorties à refacturer enregistrées';
                    RunObject = Page "Posted Item Inv. Conso List";
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
                action("Page Posted Item Inv. Conso List")
                {
                    Caption = 'Liste des sorties à refacturer enregistrées';
                    RunObject = Page "Posted Item Inv. Conso List";
                }
                action("Purchases orders archive")
                {
                    Caption = 'Purchases orders archive';
                    RunObject = Page "Purchase List Archive PBL";
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
            action("Requisition &Worksheet")
            {
                Caption = 'Requisition &Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type"=CONST("Req."),
                                    Recurring=CONST(false));
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

