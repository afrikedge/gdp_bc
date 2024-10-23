page 50290 "Admin Info RC GDP-ADM-INFO"
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
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type=CONST(Inventory));
            }
            action(Action1000000007)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type=CONST(Service));
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
            action("Sites de livraison (Logistique)")
            {
                Caption = 'Sites de livraison (Logistique)';
                RunObject = Page "Delivery Sites";
            }
            action(Camions)
            {
                Caption = 'Camions';
                RunObject = Page "Camions-EditList";
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
            action(Action100000009)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(AttenteValResp2));
            }
            action(Action100000006)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(AttenteValResp3));
            }
            action(Action100000007)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status=CONST(Litigieuse));
            }
        }
        area(sections)
        {
            group("Analytique & Budget")
            {
                Caption = 'Analytique & Budget';
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
                separator("Archives JIRAMA")
                {
                    Caption = 'Archives JIRAMA';
                }
                action("<Page Posted JIRAMA Forecast List>")
                {
                    Caption = 'Prévisions de vente JIRAMA validées';
                    RunObject = Page "Posted JIRAMA Forecast List";
                }
                separator("Archives Cartes")
                {
                    Caption = 'Archives Cartes';
                }
                action("<Page Posted Moneytech Import List>")
                {
                    Caption = 'Transactions Moneytech enregistrées';
                    RunObject = Page "Posted Moneytech Import List";
                }
            }
            group(ActionGroup1000000039)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(Action1000000038)
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action(Action1000000037)
                {
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                }
                action(Action1000000036)
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
                action("MFiles invoices list")
                {
                    Caption = 'MFiles invoices list';
                    RunObject = Page "MFiles Invoice List - Progess";
                }
                action("Posted MFiles Invoices")
                {
                    Caption = 'Posted MFiles Invoices';
                    RunObject = Page "MFiles Invoice List-Integrated";
                }
            }
            group(ActionGroup1000000060)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("<Page G/L Registers>")
                {
                    Caption = 'Historique des transactions comptabilité';
                    RunObject = Page "G/L Registers";
                }
            }
            group(ActionGroup1000000053)
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
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

