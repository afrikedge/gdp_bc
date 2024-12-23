page 50214 "Purchasing Agent GDP-STKK"
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
            separator(Separator28)
            {
            }
            action("Inventory - &Availability Plan")
            {
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory - &Vendor Purchases")
            {
                Caption = 'Inventory - Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
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
            group(Achats)
            {
                Caption = 'Achats';
                action("<Page Purchase Requisition List>")
                {
                    Caption = 'Liste des demandes d''achat';
                    RunObject = Page "Purchase Requisition List";
                }
                action("<Page Purchase Req Pending Manager>")
                {
                    Caption = 'Liste des demandes d''achat à valider (Responsable)';
                    RunObject = Page "Purchase Req Pending Manager";
                }
                action("<Page Purchase Req Pending App List>")
                {
                    Caption = 'Liste des demandes d''achat à valider (CDG)';
                    RunObject = Page "Purchase Req Pending App List ";
                }
                action("<Page Purchase Req Validated List>")
                {
                    Caption = 'Liste des demandes d''achats valdiées';
                    RunObject = Page "Purchase Req Validated List";
                }
                action("<Page Purchase Req Tracking List>")
                {
                    Caption = 'Suivi des demandes d''achat';
                    RunObject = Page "Purchase Req Tracking List";
                }
                action("Requisition Worksheets")
                {
                    Caption = 'Requisition Worksheets';
                    RunObject = Page "Req. Wksh. Names";
                    RunPageView = WHERE("Template Type" = CONST("Req."),
                                        Recurring = CONST(false));
                }
            }
            group("Stock Marketing")
            {
                Caption = 'Stock Marketing';
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
                    RunPageView = WHERE("Template Type" = CONST(Item),
                                        Recurring = CONST(false));
                }
                action(Action1000000008)
                {
                    Caption = 'Item Journals';
                    RunObject = Page "Item Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST("Phys. Inventory"),
                                        Recurring = CONST(false));
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
            action("&Purchase Journal")
            {
                Caption = 'Purchase Journal';
                Image = Journals;
                RunObject = Page "Purchase Journal";
            }
            action("Item &Journal")
            {
                Caption = 'Item Journal';
                Image = Journals;
                RunObject = Page "Item Journal";
            }
            action("Order Plan&ning")
            {
                Caption = 'Order Planning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Separator38)
            {
            }
            action("Requisition &Worksheet")
            {
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                RunObject = Page "Req. Wksh. Names";
                RunPageView = WHERE("Template Type" = CONST("Req."),
                                    Recurring = CONST(false));
            }
            action("Pur&chase Prices")
            {
                Caption = 'Purchase Prices';
                Image = Price;
                RunObject = Page "Purchase Prices";
            }
            action("Purchase &Line Discounts")
            {
                Caption = 'Purchase Line Discounts';
                Image = LineDiscount;
                RunObject = Page "Purchase Line Discounts";
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

