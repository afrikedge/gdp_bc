page 50206 "Purchasing Agent RAPP GDP xxx"
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
                part(Control25; "Purchase Performance")
                {
                }
                part(Control37; "Purchase Performance")
                {
                    Visible = false;
                }
                part(Control21; "Inventory Performance")
                {
                }
                part(Control44; "Inventory Performance")
                {
                    Visible = false;
                }
                part(Control45; "Report Inbox Part")
                {
                }
                part(Control35; "My Job Queue")
                {
                    Visible = false;
                }
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
            separator(Separator28)
            {
            }
            action("Inventory - &Availability Plan")
            {
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                RunObject = Report "Inventory - Availability Plan";
            }
            action("Inventory &Purchase Orders")
            {
                Caption = 'Inventory Purchase Orders';
                Image = "Report";
                RunObject = Report "Inventory Purchase Orders";
            }
            action("Inventory - &Vendor Purchases")
            {
                Caption = 'Inventory - Vendor Purchases';
                Image = "Report";
                RunObject = Report "Inventory - Vendor Purchases";
            }
            action("Inventory &Cost and Price List")
            {
                Caption = 'Inventory Cost and Price List';
                Image = "Report";
                RunObject = Report "Inventory Cost and Price List";
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
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action(Action1000000007)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Service));
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
                action("Purchase Orders")
                {
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
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
                action("Posted Transfer Shipments")
                {
                    Caption = 'Posted Transfer Shipments';
                    RunObject = Page "Posted Transfer Shipments";
                }
                action("Posted Transfer Receipts")
                {
                    Caption = 'Posted Transfer Receipts';
                    RunObject = Page "Posted Transfer Receipts";
                }
                action("<Page Transfer List Archive>")
                {
                    Caption = 'Liste de transferts archivés';
                    RunObject = Page "Transfer List Archive";
                }
                action("<Page Complex Transfer List Archive>")
                {
                    Caption = 'Liste de transferts complexes archivés';
                    RunObject = Page "Complex Transfer List Archive";
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
            }
        }
        area(creation)
        {
            action("Purchase &Quote")
            {
                Caption = 'Purchase Quote';
                Image = Quote;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Quote";
                RunPageMode = Create;
            }
            action("Purchase &Invoice")
            {
                Caption = 'Purchase Invoice';
                Image = Invoice;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("Purchase &Order")
            {
                Caption = 'Purchase Order';
                Image = Document;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
            action("Purchase &Return Order")
            {
                Caption = 'Purchase Return Order';
                Image = ReturnOrder;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Purchase Return Order";
                RunPageMode = Create;
            }
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

