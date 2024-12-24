page 50212 "Purchasing Agent GDP-STKM"
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
                part(Control1000000000; "Whse Ship & Receive Activities")
                {
                }
                part(Control1902476008; "My Vendors")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                systempart(Control1000000001; MyNotes)
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
        }
        area(embedding)
        {
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action("<Page Location List>")
            {
                Caption = 'Location';
                Image = Item;
                RunObject = Page "Location List";
            }
            action(Transporteurs)
            {
                Caption = 'Transporteurs';
                RunObject = Page "Transporteurs GDP";
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
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(false));
                }
                action(Action1000000033)
                {
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Phys. Inventory"),
                                        Recurring = CONST(false));
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
            }
            group("Posted Documents")
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
                action("Page Posted Item Inv. Conso List")
                {
                    Caption = 'Liste des sorties à refacturer enregistrées';
                    RunObject = Page "Posted Item Inv. Conso List";
                }
            }
            group(ActionGroup1000000045)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
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
            }
        }
        area(creation)
        {
            action("T&ransfer Order")
            {
                Caption = 'Transfer Order';
                Image = Document;

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
            action("Navi&gate")
            {
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

