page 50213 "Purchasing Agent GDP-DEM"
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
            separator(Separator28)
            {
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
            action(Action1000000007)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Service));
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
        }
        area(sections)
        {
            group(Achats)
            {
                Caption = 'Achats';
                action("Purchase Orders")
                {
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    Visible = false;
                }
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
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Purchase Receipts")
                {
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                }
                action("<Page Posted Purch Requisition List>")
                {
                    Caption = 'Liste des demandes d''achat enregistrées';
                    RunObject = Page "Posted Purch Requisition List";
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

