page 50208 "Purchasing Agent GDP-CDG"
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
                part(Control1907662708; "Purchase Agent Activities")
                {
                }
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
        }
        area(embedding)
        {
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
            action("<Page Item ListWorflow>")
            {
                Caption = 'Items to approve';
                Image = Item;
                RunObject = Page "Item List - CDG";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action(Action1000000007)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
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
            action(FeesTransporAMBATOVYPricing)
            {
                Caption = 'Frais de transport vers Ambatovy';
                RunObject = Page "Fees Transpor AMBATOVY Pricing";
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
            action("<Page Delivery List>")
            {
                Caption = 'Sites de livraison';
                RunObject = Page "Delivery Sites";
            }
            action("Analytique salariés")
            {
                Caption = 'Analytique salariés';
                //RunObject = Page "Employee List - CDG";
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
                action("Cost Journal")
                {
                    Caption = 'Cost Journal';
                    RunObject = Page "Cost Journal Batches";
                }
            }
            group("Suivi des des ventes")
            {
                Caption = 'Suivi des des ventes';
                action("Requests to Approve")
                {
                    Caption = 'Requests to Approve';
                    Image = Vendor;
                    RunObject = Page "Requests to Approve";
                }
                action("<Page Purchase Req Pending App List>")
                {
                    Caption = 'Listes des demandes d''achat à valider';
                    RunObject = Page "Purchase Req Pending App List ";
                }
                action("Commandes vente - Prix non conformes")
                {
                    Caption = 'Commandes vente - Prix non conformes';
                    RunObject = Page "Sales Order List - NC Prices";
                }
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
                action("<Page Item Invoiced Conso List>")
                {
                    Caption = 'Liste de sorties à refacturer (En attente facturation)';
                    RunObject = Page "Item Invoiced Conso List Relea";
                }
                action("<Page Sales Order List>")
                {
                    Caption = 'Sales Orders';
                    Image = "Order";
                    RunObject = Page "Sales Order List";
                }
                action(SuiviFqcturesTrqns)
                {
                    Caption = 'Suivi des factures transporteurs';
                    RunObject = Page "Confirmed Shipment to invoice";
                }
                action("<Page JIRAMA Forecast List>")
                {
                    Caption = 'Prévisions de vente JIRAMA';
                    RunObject = Page "JIRAMA Forecast List";
                }
            }
            group("Suivi des achats")
            {
                Caption = 'Suivi des achats';
                action("<Page Purchase Requisition List>")
                {
                    Caption = 'Liste des demandes d''achat';
                    RunObject = Page "Purchase Requisition List";
                }
                action("<Page Purchase Req Tracking List>")
                {
                    Caption = 'Suivi des demandes d''achat';
                    RunObject = Page "Purchase Req Tracking List";
                }
                action("<Page Purchase Req Validated List>")
                {
                    Caption = 'Liste des demandes d''achats validées';
                    RunObject = Page "Purchase Req Validated List";
                }
                action(ReceivedPuchOrders)
                {
                    Caption = 'Received purchase orders';
                    RunObject = Page "Received Purchase Order List";
                }
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Item Journals")
                {
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(false));
                }
                action("Item Journals revalorisation")
                {
                    Caption = 'Item Journals revalorisation';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Revaluation),
                                        Recurring = CONST(false));
                }
            }
            group("Suivi Factures fournisseur")
            {
                Caption = 'Suivi Factures fournisseur';
                action("Factures fournisseur")
                {
                    Caption = 'Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                }
                action(Action100000015)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Receptionee));
                }
                action(Action100000014)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Rejetee));
                }
                action(Action100000013)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttenteValResp1));
                }
                action(Action100000012)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttenteValResp2));
                }
                action(Action100000011)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttenteValResp3));
                }
                action(Action100000004)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Litigieuse));
                }
                action(Action100000005)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(AttentePaiement));
                }
                action(Action100000002)
                {
                    Caption = 'Historique Factures fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                    RunPageView = WHERE(Status = CONST(Archived));
                }
                action(Action100000003)
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
                action("<Page Posted Item Inv. Conso List>")
                {
                    Caption = 'Liste des sorties à refacturer enregistrées';
                    RunObject = Page "Posted Item Inv. Conso List";
                }
                action("<Page G/L Registers>")
                {
                    Caption = 'Historique des transactions comptabilité';
                    RunObject = Page "G/L Registers";
                }
            }
            group(ActionGroup39)
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
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                }
                action("<Page Posted Purch Requisition List>")
                {
                    Caption = 'Liste des demandes d''achat enregistrées';
                    RunObject = Page "Posted Purch Requisition List";
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
            group(ActionGroup1000000055)
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
                action("<Page Posted Sales Shipments>")
                {
                    Caption = 'Livraisons ventes enregistrées';
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Return Shipments")
                {
                    Caption = 'Posted Return Shipments';
                    RunObject = Page "Posted Return Shipments";
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
            group(ActionGroup1000000046)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Page Posted Item Transfer List>")
                {
                    Caption = 'Liste des transferts enregistrés';
                    RunObject = Page "Posted Item Transfer List";
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
                action(Action1000000037)
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
            action("Navi&gate")
            {
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

