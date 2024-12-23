page 50204 "Whse. Basic GDP-LIV"
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
                part(Control1906245608; "Whse Ship & Receive Activities")
                {
                }
                part(Control1907692008; "My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
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
            separator(Separator54)
            {
            }
            action("Customer &Labels")
            {
                Caption = 'Customer Labels';
                Image = "Report";
                RunObject = Report "Customer - Labels";
            }
        }
        area(embedding)
        {
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action("<Page Camion>")
            {
                Caption = 'Camions';
                RunObject = Page Camions;
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
                action("Liste des tournées")
                {
                    Caption = 'Liste des tournées';
                    RunObject = Page "Touring List";
                }
                action("En saisie")
                {
                    Caption = 'En saisie';
                    RunObject = Page "Touring List";
                    RunPageView = WHERE(Status = FILTER(Created | Dispached));
                }
                action("A confirmer")
                {
                    Caption = 'A confirmer';
                    RunObject = Page "Touring List";
                    RunPageView = WHERE(Status = CONST(Posted));
                }
                action("<Page Bon Dispaching List>")
                {
                    Caption = 'Liste des bons';
                    RunObject = Page "Bon Dispaching List";
                }
                action("Liste des tournées traitées")
                {
                    Caption = 'Liste des tournées traitées';
                    RunObject = Page "Confirmed Touring List";
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
            }
            group("Posted Documents")
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
                action("<Page Posted Item Transfer List>")
                {
                    Caption = 'Liste des transferts enregistrés';
                    RunObject = Page "Posted Item Transfer List";
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
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Item &Tracing")
            {
                Caption = 'Item Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
            }
        }
    }
}

