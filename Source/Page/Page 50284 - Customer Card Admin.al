page 50284 "Customer Card Admin"
{
    Caption = 'Customer Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = Customer;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Caption = 'Customer Code';
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(Address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(County; Rec.County)
                {
                }
                field("Town Code"; Rec."Town Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("Primary Contact No."; Rec."Primary Contact No.")
                {
                    Caption = 'Primary Contact No.';
                }
                field(Contact; Rec.Contact)
                {
                    Caption = 'Contact';
                    Editable = ContactEditable;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field("Search Name"; Rec."Search Name")
                {
                    Caption = 'Search Name';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    Caption = 'Balance (LCY)';

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SetRange("Customer No.", Rec."No.");
                        Rec.CopyFilter("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Rec.CopyFilter("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Rec.CopyFilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    Caption = 'Credit Limit (LCY)';
                    StyleExpr = StyleTxt;

                    trigger OnValidate()
                    begin
                        StyleTxt := Rec.SetStyle;
                    end;
                }
                field("Risk Level"; Rec."Risk Level")
                {
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                }
                field("Holding Code"; Rec."Holding Code")
                {
                }
                // New
                field("Holding Name"; Rec."Holding Name") { }
                field("Company Code"; Rec."Company Code")
                {
                }
                // New
                field("Company Name"; Rec."Company Name") { }
                field("Legal Status Code"; Rec."Legal Status Code")
                {
                }
                field("Industry Group"; Rec."Industry Group")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                    Editable = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Related Vendor"; Rec."Related Vendor")
                {
                }
                field("GDP Partner"; Rec."GDP Partner")
                {
                }
                field("Sales Category Code"; Rec."Sales Category Code")
                {
                }
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Profit Center"; Rec."Profit Center")
                {
                    Visible = false;
                }
                field("Customer Status"; Rec."Customer Status")
                {
                }
                field("Appliquer Ecart pompe JIR"; Rec."Appliquer Ecart pompe JIR")
                {
                }
                field("Remove JIR Ref on BE"; Rec."Remove JIR Ref on BE")
                {
                }
                field("Category 1"; Rec."Category 1")
                {
                }
                field("Category 2"; Rec."Category 2")
                {
                }
                field("Afk Type transport"; Rec."Transport Type")
                {
                }
                field("Disable Blocking"; Rec."Disable Blocking")
                {
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2"; Rec."Phone No.")
                {
                    Importance = Promoted;
                }
                field("Fax No."; Rec."Fax No.")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Importance = Promoted;
                }
                field("Home Page"; Rec."Home Page")
                {
                    Caption = 'Home Page';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {

                    trigger OnDrillDown()
                    var
                        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                    begin
                        VATRegistrationLogMgt.AssistEditCustomerVATReg(Rec);
                    end;
                }
                field("STAT Code"; Rec."STAT Code")
                {
                }
                field("CIF/CIS"; Rec."CIF/CIS")
                {
                }
                field("Trade Number"; Rec."Trade Number")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ShowMandatory = true;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    Importance = Promoted;
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    Importance = Promoted;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                }
                field("AMSA Invoice Type"; Rec."AMSA Invoice Type")
                {
                }
                field("AMSA Invoice Model"; Rec."AMSA Invoice Model")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Application Method"; Rec."Application Method")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Importance = Promoted;
                }
                field("Cash payment"; Rec."Cash payment")
                {
                }
                field("Check Set"; Rec."Check Set")
                {
                }
                field("Bank Transfer Bank Stamp"; Rec."Bank Transfer Bank Stamp")
                {
                }
                field(Traite; Rec.Traite)
                {
                }
                field("Received Check"; Rec."Received Check")
                {
                }
                field("Credit Note"; Rec."Credit Note")
                {
                }
                field("Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    Importance = Promoted;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    Importance = Promoted;
                }
                field("Cash Flow Payment Terms Code"; Rec."Cash Flow Payment Terms Code")
                {
                }
                field("Print Statements"; Rec."Print Statements")
                {
                }
                field("Last Statement No."; Rec."Last Statement No.")
                {
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {
                }
                field("Payment in progress (LCY)"; Rec."Payment in progress (LCY)")
                {
                }
                field("""Balance (LCY)"" - ""Payment in progress (LCY)"""; Rec."Balance (LCY)" - Rec."Payment in progress (LCY)")
                {
                    Caption = 'Net amount (LCY)';
                    Editable = false;
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code2"; Rec."Ship-to Code2")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Importance = Promoted;
                }
                field(Reserve; Rec.Reserve)
                {
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    Importance = Promoted;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    Importance = Promoted;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    Importance = Promoted;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    DrillDown = false;
                }
                // field("Customized Calendar";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Customer,"No.",'',"Base Calendar Code"))
                // {
                //     Caption = 'Customized Calendar';
                //     Editable = false;

                //     trigger OnDrillDown()
                //     begin
                //         CurrPage.SaveRecord;
                //         TestField("Base Calendar Code");
                //         CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Customer,"No.",'',"Base Calendar Code");
                //     end;
                // }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    Importance = Promoted;
                }
                field("Language Code"; Rec."Language Code")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control39; "CRM Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = CRMIsCoupledToRecord;
            }
            // part(Control35;"Social Listening FactBox")
            // {
            //     SubPageLink = "Source Type"=CONST(Customer),
            //                   "Source No."=FIELD("No.");
            //     Visible = SocialListeningVisible;
            // }
            // part(Control27;"Social Listening Setup FactBox")
            // {
            //     SubPageLink = "Source Type"=CONST(Customer),
            //                   "Source No."=FIELD("No.");
            //     UpdatePropagation = Both;
            //     Visible = SocialListeningSetupVisible;
            // }
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part(Control1905532107; "Dimensions FactBox")
            {
                SubPageLink = "Table ID" = CONST(18),
                              "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907829707; "Service Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(Control1902613707; "Service Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(18),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Bank Accounts")
                {
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Customer Bank Account List";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("Direct Debit Mandates")
                {
                    Caption = 'Direct Debit Mandates';
                    Image = MakeAgreement;
                    RunObject = Page "SEPA Direct Debit Mandates";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("Ship-&to Addresses")
                {
                    Caption = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
                action("C&ontacts")
                {
                    AccessByPermission = TableData Contact = R;
                    Caption = 'Signataires';
                    Image = ContactPerson;
                    RunObject = Page "Signatory List";
                    RunPageLink = "Company No." = FIELD("No.");

                    trigger OnAction()
                    begin
                        //ShowContact;
                    end;
                }
                action("&Payment Addresses")
                {
                    Caption = 'Payment Addresses';
                    Image = Addresses;
                    RunObject = Page "Payment Addresses";
                    RunPageLink = "Account Type" = CONST(Customer),
                                  "Account No." = FIELD("No.");
                }
                action("Cross Re&ferences")
                {
                    // Caption = 'Cross References';
                    // Image = Change;
                    // RunObject = Page "Cross References";
                    // RunPageLink = "Cross-Reference Type"=CONST(Customer),
                    //               "Cross-Reference Type No."=FIELD("No.");
                    // RunPageView = SORTING("Cross-Reference Type","Cross-Reference Type No.");
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                }
                action(ApprovalEntries)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    Image = Map;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                action(CheckWarranty)
                {
                    Caption = 'Check Warranty';
                    Image = Check;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CheckWarPage: Page "Open Check Warranty";
                        CheckWar: Record "Check Warranty";
                    begin
                        CheckWar.Reset;
                        CheckWar.SetRange(CheckWar."Customer No.", Rec."No.");

                        Clear(CheckWarPage);
                        CheckWarPage.Editable := false;
                        CheckWarPage.SetTableView(CheckWar);
                        CheckWarPage.Run;
                    end;
                }
                action(CustomerReportSelections)
                {
                    Caption = 'Document Layouts';
                    Image = Quote;

                    trigger OnAction()
                    var
                        CustomReportSelection: Record "Custom Report Selection";
                    begin
                        CustomReportSelection.SetRange("Source Type", DATABASE::Customer);
                        CustomReportSelection.SetRange("Source No.", Rec."No.");
                        PAGE.RunModal(PAGE::"Customer Report Selections", CustomReportSelection);
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoAccount)
                {
                    Caption = 'Account';
                    Image = CoupledCustomer;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM account.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record" = IM;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(Rec.RecordId);
                    end;
                }
                action(UpdateStatisticsInCRM)
                {
                    Caption = 'Update Account Statistics';
                    Enabled = CRMIsCoupledToRecord;
                    Image = UpdateXML;
                    ToolTip = 'Send Customer Statistics data to Microsoft Dynamics CRM to update the Account Statistics factbox';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.CreateOrUpdateCRMAccountStatistics(Rec);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment = 'Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM account.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            //MIGRATION***************
                            //CRMIntegrationManagement.CreateOrUpdateCoupling(RECORDID);
                            //MIGRATION***************
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record" = IM;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM account.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(Rec.RecordId);
                        end;
                    }
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger Entries';
                    Image = CustomerLedger;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("S&ales")
                {
                    Caption = 'Sales';
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("Statistics by C&urrencies")
                {
                    Caption = 'Statistics by Currencies';
                    Image = Currencies;
                    RunObject = Page "Cust. Stats. by Curr. Lines";
                    RunPageLink = "Customer Filter" = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Date Filter" = FIELD("Date Filter");
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    var
                        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                    begin
                        // ItemTrackingDocMgt.ShowItemTrackingForMasterData(1,"No.",'','','','','');
                    end;
                }
                separator(Separator140)
                {
                }
            }
            group(ActionGroup82)
            {
                Caption = 'Sales';
                Image = Sales;
                action("Invoice &Discounts")
                {
                    Caption = 'Invoice Discounts';
                    Image = CalculateInvoiceDiscount;
                    RunObject = Page "Cust. Invoice Discounts";
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepayment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Sales Type" = CONST(Customer),
                                  "Sales Code" = FIELD("No.");
                    RunPageView = SORTING("Sales Type", "Sales Code");
                }
                action("S&td. Cust. Sales Codes")
                {
                    Caption = 'S&td. Cust. Sales Codes';
                    Image = CodesList;
                    RunObject = Page "Standard Customer Sales Codes";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Order List";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                }
                group("Issued Documents")
                {
                    Caption = 'Issued Documents';
                    Image = Documents;
                    action("Issued &Reminders")
                    {
                        Caption = 'Issued Reminders';
                        Image = OrderReminder;
                        RunObject = Page "Issued Reminder List";
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                    }
                    action("Issued &Finance Charge Memos")
                    {
                        Caption = 'Issued Finance Charge Memos';
                        Image = FinChargeMemo;
                        RunObject = Page "Issued Fin. Charge Memo List";
                        RunPageLink = "Customer No." = FIELD("No.");
                        RunPageView = SORTING("Customer No.", "Posting Date");
                    }
                }
                action("Blanket Orders")
                {
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Sales Orders";
                    RunPageLink = "Sell-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Sell-to Customer No.");
                }
                action("&Jobs")
                {
                    Caption = '&Jobs';
                    Image = Job;
                    RunObject = Page "Job List";
                    RunPageLink = "Bill-to Customer No." = FIELD("No.");
                    RunPageView = SORTING("Bill-to Customer No.");
                }
            }
            group("Credit Card")
            {
                Caption = 'Credit Card';
                Image = CreditCard;
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckCustomerApprovalsWorkflowEnabled(Rec) then
                            ApprovalsMgmt.OnSendCustomerForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'Functions';
                Image = "Action";
                action("Apply Template")
                {
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Customer Detailed Aging")
            {
                Caption = 'Customer Detailed Aging';
                Image = "Report";

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Customer Detailed Aging";
            }
            action("Customer - Labels")
            {
                Caption = 'Customer - Labels';
                Image = "Report";

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Customer - Labels";
            }
            action("Customer - Balance to Date")
            {
                Caption = 'Customer - Balance to Date';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Customer - Balance to Date";
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    trigger OnAfterGetRecord()
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnInit()
    begin
        ContactEditable := true;
        MapPointVisible := true;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        ActivateFields;

        if not MapMgt.TestSetup then
            MapPointVisible := false;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        StyleTxt: Text;
        [InDataSet]
        MapPointVisible: Boolean;
        [InDataSet]
        ContactEditable: Boolean;
        [InDataSet]
        SocialListeningSetupVisible: Boolean;
        [InDataSet]
        SocialListeningVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;

    local procedure ActivateFields()
    begin
        SetSocialListeningFactboxVisibility;
        ContactEditable := Rec."Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure SetSocialListeningFactboxVisibility()
    var
    //SocialListeningMgt: Codeunit "Social Listening Management";
    begin
        // SocialListeningMgt.GetCustFactboxVisibility(Rec,SocialListeningSetupVisible,SocialListeningVisible);
    end;
}

