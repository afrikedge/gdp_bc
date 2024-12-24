page 50220 "Acc. Receivables GDP-CLIENT"
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
            separator(Separator20)
            {
            }
            action("Customer &Document Nos.")
            {
                Caption = 'Customer Document Nos.';
                Image = "Report";
                RunObject = Report "Customer Document Nos.";
            }
            action("Sales &Invoice Nos.")
            {
                Caption = 'Sales Invoice Nos.';
                Image = "Report";
                RunObject = Report "Sales Invoice Nos.";
            }
            action("Sa&les Credit Memo Nos.")
            {
                Caption = 'Sales Credit Memo Nos.';
                Image = "Report";
                RunObject = Report "Sales Credit Memo Nos.";
            }
            action("Re&minder Nos.")
            {
                Caption = 'Re&minder Nos.';
                Image = "Report";
                RunObject = Report "Reminder Nos.";
            }
            action("Finance Cha&rge Memo Nos.")
            {
                Caption = 'Finance Cha&rge Memo Nos.';
                Image = "Report";
                RunObject = Report "Finance Charge Memo Nos.";
            }
            separator(Separator1120005)
            {
            }
            action("Payments Lists")
            {
                Caption = 'Payments Lists';
                Image = "Report";
                RunObject = Report "Payment List";
            }
            action("GL/Cust. Ledger Reconciliation")
            {
                Caption = 'GL/Cust. Ledger Reconciliation';
                Image = "Report";
                RunObject = Report "GL/Cust. Ledger Reconciliation";
            }
        }
        area(embedding)
        {
            action("Chart of Accounts")
            {
                Caption = 'Chart of Accounts';
                RunObject = Page "Chart of Accounts";
            }
            action(Customers)
            {
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Balance)
            {
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
            }
            action(Items)
            {
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Inventory));
            }
            action("<Page Item List>")
            {
                Caption = 'Articles non stockés';
                RunObject = Page "Item List";
                RunPageView = WHERE(Type = CONST(Service));
            }
        }
        area(sections)
        {
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action("Sales Journals")
                {
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(Sales),
                                        Recurring = CONST(false));
                }
                action("General Journals")
                {
                    Caption = 'General Journals';
                    Image = Journal;
                    RunObject = Page "General Journal Batches";
                    RunPageView = WHERE("Template Type" = CONST(General),
                                        Recurring = CONST(false));
                }
            }
            group("Relances clients")
            {
                Caption = 'Relances clients';
                Image = Reconcile;
                action("Reminders Terms")
                {
                    Caption = 'Reminders Terms';
                    Image = ReminderTerms;
                    RunObject = Page "Reminder Terms";
                }
                action(Reminders)
                {
                    Caption = 'Reminders';
                    Image = Reminder;
                    RunObject = Page "Reminder List";
                }
                action("Issued Reminders")
                {
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;

                action("Posted Sales Shipments")
                {
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                }
                action("Posted Return Receipts")
                {
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
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
                action("<Page Posted JIRAMA Forecast List>")
                {
                    Caption = 'Prévisions de vente JIRAMA validées';
                    RunObject = Page "Posted JIRAMA Forecast List";
                }
                action("<Page Posted Moneytech Import List>")
                {
                    Caption = 'Transactions Moneytech enregistrées';
                    RunObject = Page "Posted Moneytech Import List";
                }
                action("G/L Registers")
                {
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                }
            }
        }
        area(processing)
        {
            group("&Sales")
            {
                Caption = 'Sales';
                Image = Sales;
                action("Sales &Invoice")
                {
                    Caption = 'Sales Invoice';
                    Image = Invoice;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                }
                action("Sales &Credit Memo")
                {
                    Caption = 'Sales Credit Memo';
                    Image = CreditMemo;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Credit Memo";
                    RunPageMode = Create;
                }
            }
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cash Receipt &Journal")
            {
                Caption = 'Cash Receipt Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Payment Report")
            {
                Caption = 'Payment Report';
                RunObject = Page "Payment Report";
            }
            action("Archive Payment Journals")
            {
                Caption = 'Archive Payment Journals';
                Image = "Report";
                RunObject = Report "Archive Payment Slips";
            }
            action("Create Payment Slip")
            {
                Caption = 'Create Payment Slip';
                RunObject = Codeunit "Payment Management";
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

