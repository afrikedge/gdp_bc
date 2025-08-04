page 50270 "G/L Account Card ADMIN"
{
    Caption = 'G/L Account Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "G/L Account";
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
                }
                field(Name; Rec.Name)
                {
                    Importance = Promoted;
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                    Importance = Promoted;
                }
                field("Debit/Credit"; Rec."Debit/Credit")
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field(Totaling; Rec.Totaling)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLAccountList: Page "G/L Account List";
                        OldText: Text;
                    begin
                        OldText := Text;
                        GLAccountList.LookupMode(true);
                        if not (GLAccountList.RunModal = ACTION::LookupOK) then
                            exit(false);

                        Text := OldText + GLAccountList.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field("No. of Blank Lines"; Rec."No. of Blank Lines")
                {
                }
                field("New Page"; Rec."New Page")
                {
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field(Balance; Rec.Balance)
                {
                    Importance = Promoted;
                }
                field("Reconciliation Account"; Rec."Reconciliation Account")
                {
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                }
                field("Direct Posting"; Rec."Direct Posting")
                {
                }
                field("Purchased Account"; Rec."Purchased Account")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Omit Default Descr. in Jnl."; Rec."Omit Default Descr. in Jnl.")
                {
                }
                field("Migration Account"; Rec."Migration Account")
                {
                    Visible = false;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Importance = Promoted;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Importance = Promoted;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Importance = Promoted;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    Importance = Promoted;
                }
                field("Default IC Partner G/L Acc. No"; Rec."Default IC Partner G/L Acc. No")
                {
                }
                field("Default Deferral Template Code"; Rec."Default Deferral Template Code")
                {
                    Caption = 'Default Deferral Template';
                }
            }
            group(Consolidation)
            {
                Caption = 'Consolidation';
                field("Consol. Debit Acc."; Rec."Consol. Debit Acc.")
                {
                    Importance = Promoted;
                }
                field("Consol. Credit Acc."; Rec."Consol. Credit Acc.")
                {
                    Importance = Promoted;
                }
                field("Consol. Translation Method"; Rec."Consol. Translation Method")
                {
                    Importance = Promoted;
                }
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                field("Exchange Rate Adjustment"; Rec."Exchange Rate Adjustment")
                {
                    Importance = Promoted;
                }
            }
            group("Cost Accounting")
            {
                Caption = 'Cost Accounting';
                field("Cost Type No."; Rec."Cost Type No.")
                {
                    Importance = Promoted;
                }
            }
        }
        area(factboxes)
        {
            part(Control1905532107; "Dimensions FactBox")
            {
                SubPageLink = "Table ID" = CONST(15),
                              "No." = FIELD("No.");
                Visible = false;
            }
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
            group("A&ccount")
            {
                Caption = 'Account';
                Image = ChartOfAccounts;
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger Entries';
                    Image = GLRegisters;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No." = FIELD("No.");
                    RunPageView = SORTING("G/L Account No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("G/L Account"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(15),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("E&xtended Texts")
                {
                    Caption = 'Extended Texts';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = CONST("G/L Account"),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                }
                action("Receivables-Payables")
                {
                    Caption = 'Receivables-Payables';
                    Image = ReceivablesPayables;
                    RunObject = Page "Receivables-Payables";
                }
                action("Where-Used List")
                {
                    Caption = 'Where-Used List';
                    Image = Track;

                    trigger OnAction()
                    var
                        CalcGLAccWhereUsed: Codeunit "Calc. G/L Acc. Where-Used";
                    begin
                        CalcGLAccWhereUsed.CheckGLAcc(Rec."No.");
                    end;
                }
                action("Apply Entries")
                {
                    Caption = 'Apply Entries';
                    Image = ApplyEntries;
                    RunObject = Page "Apply G/L Entries";
                    RunPageLink = "G/L Account No." = FIELD("No.");
                    ShortCutKey = 'Shift+F11';
                }
            }
            group("&Balance")
            {
                Caption = '&Balance';
                Image = Balance;
                action("G/L &Account Balance")
                {
                    Caption = 'G/L &Account Balance';
                    Image = GLAccountBalance;
                    RunObject = Page "G/L Account Balance";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Business Unit Filter" = FIELD("Business Unit Filter");
                }
                action("G/L &Balance")
                {
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    RunObject = Page "G/L Balance";
                    RunPageOnRec = true;
                }
                action("G/L Balance by &Dimension")
                {
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    RunObject = Page "G/L Balance by Dimension";
                }
            }
            action("General Posting Setup")
            {
                Caption = 'General Posting Setup';
                Image = GeneralPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "General Posting Setup";
            }
            action("VAT Posting Setup")
            {
                Caption = 'VAT Posting Setup';
                Image = VATPostingSetup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "VAT Posting Setup";
            }
            action("G/L Register")
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "G/L Registers";
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Detail Trial Balance";
            }
            action("Trial Balance")
            {
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance";
            }
            action("Trial Balance by Period")
            {
                Caption = 'Trial Balance by Period';
                Image = "Report";

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action(Action1900210206)
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "G/L Register";
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'Functions';
                Image = "Action";
                action("Apply Template")
                {
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;

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
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewGLAcc(xRec, BelowxRec);
    end;
}

