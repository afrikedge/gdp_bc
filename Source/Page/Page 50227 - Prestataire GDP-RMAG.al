page 50227 "Prestataire GDP-RMAG"
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
                RunPageView = WHERE(Type = CONST(Inventory),
                                    "Parent Category" = CONST('LUB'));
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
            action(Action100000009)
            {
                Caption = 'Historique Factures fournisseur';
                RunObject = Page "Vendor Invoice List Validation";
                RunPageView = WHERE(Status = CONST(AttenteValResp2));
            }
            action(Action100000006)
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
            }
            group("Logistique livraison")
            {
                Caption = 'Logistique livraison';
                action("<Page Item Shipment List1 >")
                {
                    Caption = 'Liste documents de préparation LUBS';
                    RunObject = Page "Item Shipment List";
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
                action("<Page Posted Item Shipment List>")
                {
                    Caption = 'Liste documents de préparation enregistrés';
                    RunObject = Page "Posted Item Shipment List";
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
            action("Navi&gate")
            {
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

