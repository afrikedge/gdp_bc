page 50203 "Acc. Receivables Adm. GDP-ADP"
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
        }
        area(embedding)
        {
            action("<Page Customer List>")
            {
                Caption = 'Clients';
                RunObject = Page "Customer List";
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List Admin";
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action("<Page Sales Quotes1>")
            {
                Caption = 'Sales Quotes';
                Image = Quote;
                RunObject = Page "Sales Quotes";
            }
            action("<Page Requests to Approve1>")
            {
                Caption = 'Devis à approuver';
                RunObject = Page "Requests to Approve";
            }
            action("<Page Sales Order List - Prices val>")
            {
                Caption = 'Commandes vente en attente validation tarifs';
                RunObject = Page "Sales Order List - Prices val";
            }
            action("Commandes vente - Prix non conformes")
            {
                Caption = 'Commandes vente - Prix non conformes';
                RunObject = Page "Sales Order List - NC Prices";
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
            action("<Page Item Invoiced Conso List>")
            {
                Caption = 'Liste de sorties à refacturer (En attente facturation)';
                RunObject = Page "Item Invoiced Conso List Relea";
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
            action(Action100000001)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp2));
            }
            action(Action100000000)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp3));
            }
            action(Action100000007)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(Litigieuse));
            }
            action(Action100000005)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttentePaiement));
            }
            action(Action100000004)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(Payee));
            }
            action(SuiviFqcturesTrqns)
            {
                Caption = 'Suivi des factures transporteurs';
                RunObject = Page "Confirmed Shipment to invoice";
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
            action("Posted Sales Invoices")
            {
                Caption = 'Posted Sales Invoices';
                Image = PostedOrder;
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
        area(processing)
        {
            group("&Sales")
            {
                Caption = 'Sales';
                Image = Sales;
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

