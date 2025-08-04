page 50266 "Bank Account Card Admin"
{
    Caption = 'Bank Account Card';
    PageType = Card;
    SourceTable = "Bank Account";
    UsageCategory = None;
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
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Name; Rec.Name)
                {
                    Importance = Promoted;
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field(Contact; Rec.Contact)
                {
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Importance = Promoted;
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field(Control22; Rec.Balance)
                {
                    Importance = Promoted;
                    ShowCaption = false;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                }
                field("Min. Balance"; Rec."Min. Balance")
                {
                }
                field("Our Contact Code"; Rec."Our Contact Code")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Authorize Payment"; Rec."Authorize Payment")
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
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
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Currency Code"; Rec."Currency Code")
                {
                    Importance = Promoted;
                }
                field("Last Check No."; Rec."Last Check No.")
                {
                }
                field("Starting Check No."; Rec."Starting Check No.")
                {
                }
                field("Ending Check No."; Rec."Ending Check No.")
                {
                }
                field("Check Report ID"; Rec."Check Report ID")
                {
                }
                field("Transit No."; Rec."Transit No.")
                {
                }
                field("Last Statement No."; Rec."Last Statement No.")
                {
                    Importance = Promoted;
                }
                field("Last Payment Statement No."; Rec."Last Payment Statement No.")
                {
                }
                field("Balance Last Statement"; Rec."Balance Last Statement")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if Rec."Balance Last Statement" <> xRec."Balance Last Statement" then
                            if not Confirm(Text001, false, Rec."No.") then
                                Error(Text002);
                    end;
                }
                field("Bank Acc. Posting Group"; Rec."Bank Acc. Posting Group")
                {
                    Importance = Promoted;
                }
                group("Payment Match Tolerance")
                {
                    Caption = 'Payment Match Tolerance';
                    field("Match Tolerance Type"; Rec."Match Tolerance Type")
                    {
                    }
                    field("Match Tolerance Value"; Rec."Match Tolerance Value")
                    {
                        DecimalPlaces = 0 : 2;
                    }
                }
            }
            group(Transfer)
            {
                Caption = 'Transfer';
                field("Bank Branch No.2"; Rec."Bank Branch No.")
                {
                    Importance = Promoted;
                }
                field("Bank Account No.2"; Rec."Bank Account No.")
                {
                    Importance = Promoted;
                }
                field("Transit No.2"; Rec."Transit No.")
                {
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    Importance = Promoted;
                }
                field(IBAN; Rec.IBAN)
                {
                    Importance = Promoted;
                }
                field("National Issuer No."; Rec."National Issuer No.")
                {
                }
            }
            group(" R.I.B")
            {
                Caption = ' R.I.B';
                field("Bank Branch No.3"; Rec."Bank Branch No.")
                {
                }
                field("Agency Code"; Rec."Agency Code")
                {
                }
                field("Bank Account No.3"; Rec."Bank Account No.")
                {
                }
                field("RIB Key Text"; Rec."RIB Key Text")
                {
                }
                field("RIB Key"; Rec."RIB Key")
                {
                }
                field("RIB Checked"; Rec."RIB Checked")
                {
                }
                field("Bank Statement Import Format"; Rec."Bank Statement Import Format")
                {
                }
                field("Payment Export Format"; Rec."Payment Export Format")
                {
                }
                field("SEPA Direct Debit Exp. Format"; Rec."SEPA Direct Debit Exp. Format")
                {
                }
                field("Credit Transfer Msg. Nos."; Rec."Credit Transfer Msg. Nos.")
                {
                }
                field("Direct Debit Msg. Nos."; Rec."Direct Debit Msg. Nos.")
                {
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                }
                // field("Bank Name - Data Conversion";Rec."Bank Name - Data Conversion")
                // {
                // }
                field("Bank Clearing Standard"; Rec."Bank Clearing Standard")
                {
                }
                field("Bank Clearing Code"; Rec."Bank Clearing Code")
                {
                }
                field("Positive Pay Export Code"; Rec."Positive Pay Export Code")
                {
                    LookupPageID = "Bank Export/Import Setup";
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
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
            group("&Bank Acc.")
            {
                Caption = 'Bank Acc.';
                Image = Bank;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bank Account Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("Bank Account"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(270),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Balance)
                {
                    Caption = 'Balance';
                    Image = Balance;
                    RunObject = Page "Bank Account Balance";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action(Statements)
                {
                    Caption = 'Statements';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Bank Account Statement List";
                    RunPageLink = "Bank Account No." = FIELD("No.");
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger Entries';
                    Image = BankAccountLedger;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Bank Account Ledger Entries";
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    RunPageView = SORTING("Bank Account No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Chec&k Ledger Entries")
                {
                    Caption = 'Check Ledger Entries';
                    Image = CheckLedger;
                    RunObject = Page "Check Ledger Entries";
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    RunPageView = SORTING("Bank Account No.");
                }
                action("C&ontact")
                {
                    Caption = 'Contact';
                    Image = ContactPerson;
                    Visible = ContactActionVisible;

                    trigger OnAction()
                    begin
                        Rec.ShowContact;
                    end;
                }
                separator(Separator81)
                {
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
                action(PagePositivePayEntries)
                {
                    Caption = 'Positive Pay Entries';
                    Image = CheckLedger;
                    RunObject = Page "Positive Pay Entries";
                    RunPageLink = "Bank Account No." = FIELD("No.");
                    Visible = false;
                }
            }
            action(BankAccountReconciliations)
            {
                Caption = 'Bank Account Reconciliations';
                Image = BankAccountRec;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Bank Acc. Reconciliation List";
                RunPageLink = "Bank Account No." = FIELD("No.");
                RunPageView = SORTING("Bank Account No.");
            }
            action("Receivables-Payables")
            {
                Caption = 'Receivables-Payables';
                Image = ReceivablesPayables;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Receivables-Payables Lines";
            }
        }
        area(processing)
        {
            action("Cash Receipt Journals")
            {
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
            }
            action("Payment Journals")
            {
                Caption = 'Payment Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Payment Journal";
            }
            action(PagePosPayExport)
            {
                Caption = 'Positive Pay Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Positive Pay Export";
                RunPageLink = "No." = FIELD("No.");
                Visible = false;
            }
        }
        area(reporting)
        {
            action(List)
            {
                Caption = 'List';
                Image = OpportunitiesList;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Bank Account - List";
            }
            action("Detail Trial Balance")
            {
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
            }
            action(Action1906306806)
            {
                Caption = 'Receivables-Payables';
                Image = ReceivablesPayables;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Receivables-Payables";
            }
            action("Check Details")
            {
                Caption = 'Check Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Bank Account - Check Details";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Check Report Name");
    end;

    trigger OnInit()
    begin
        MapPointVisible := true;
    end;

    trigger OnOpenPage()
    var
        Contact: Record Contact;
        MapMgt: Codeunit "Online Map Management";
    begin
        if not MapMgt.TestSetup then
            MapPointVisible := false;
        ContactActionVisible := Contact.ReadPermission;
    end;

    var
        [InDataSet]
        MapPointVisible: Boolean;
        Text001: Label 'There may be a statement using the %1.\\Do you want to change Balance Last Statement?';
        Text002: Label 'Canceled.';
        [InDataSet]
        ContactActionVisible: Boolean;
}

