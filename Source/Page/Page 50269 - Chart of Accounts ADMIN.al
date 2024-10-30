page 50269 "Chart of Accounts ADMIN"
{
    Caption = 'Chart of Accounts';
    CardPageID = "G/L Account Card ADMIN";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    RefreshOnActivate = true;
    SourceTable = "G/L Account";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                }
                field(Name; Rec.Name)
                {
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Income/Balance"; Rec."Income/Balance")
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Direct Posting"; Rec."Direct Posting")
                {
                    Visible = false;
                }
                field(Totaling; Rec.Totaling)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        GLaccList: Page "G/L Account List";
                    begin
                        GLaccList.LookupMode(true);
                        if not (GLaccList.RunModal = ACTION::LookupOK) then
                            exit(false);

                        Text := GLaccList.GetSelectionFilter;
                        exit(true);
                    end;
                }
                field("Gen. Posting Type"; Rec."Gen. Posting Type")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Net Change"; Rec."Net Change")
                {
                    BlankZero = true;
                }
                field("Balance at Date"; Rec."Balance at Date")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field(Balance; Rec.Balance)
                {
                    BlankZero = true;
                }
                field("Additional-Currency Net Change"; Rec."Additional-Currency Net Change")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Add.-Currency Balance at Date"; Rec."Add.-Currency Balance at Date")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Additional-Currency Balance"; Rec."Additional-Currency Balance")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Consol. Debit Acc."; Rec."Consol. Debit Acc.")
                {
                    Visible = false;
                }
                field("Consol. Credit Acc."; Rec."Consol. Credit Acc.")
                {
                    Visible = false;
                }
                field("Cost Type No."; Rec."Cost Type No.")
                {
                }
                field("Consol. Translation Method"; Rec."Consol. Translation Method")
                {
                    Visible = false;
                }
                field("Default IC Partner G/L Acc. No"; Rec."Default IC Partner G/L Acc. No")
                {
                    Visible = false;
                }
                field("Default Deferral Template Code"; Rec."Default Deferral Template Code")
                {
                    Caption = 'Default Deferral Template';
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
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No." = FIELD("No.");
                    RunPageView = SORTING("G/L Account No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("G/L Account"),
                                  "No." = FIELD("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(15),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            GLAcc: Record "G/L Account";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            //MIGRATION***************
                            // CurrPage.SETSELECTIONFILTER(GLAcc);
                            // DefaultDimMultiple.SetMultiGLAcc(GLAcc);
                            // DefaultDimMultiple.RUNMODAL;
                            //MIGRATION***************
                        end;
                    }
                }
                action("E&xtended Texts")
                {
                    Caption = 'E&xtended Texts';
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
                action(AutoReconciliation)
                {
                    Caption = 'Lettrage automatique';
                    Image = Reconcile;

                    trigger OnAction()
                    var
                        "XMLPort": XMLport "Post Auto GL Reconciliation";
                    begin
                        XMLPort.SetAccount(Rec."No.");//**********************************
                        XMLPort.Run;//**********************************
                    end;
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
                    RunPageLink = "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Business Unit Filter" = FIELD("Business Unit Filter");
                    RunPageOnRec = true;
                }
                action("G/L Balance by &Dimension")
                {
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    RunObject = Page "G/L Balance by Dimension";
                }
                separator(Separator52)
                {
                    Caption = '';
                }
                action("G/L Account Balance/Bud&get")
                {
                    Caption = 'G/L Account Balance/Bud&get';
                    Image = Period;
                    RunObject = Page "G/L Account Balance/Budget";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Business Unit Filter" = FIELD("Business Unit Filter"),
                                  "Budget Filter" = FIELD("Budget Filter");
                }
                action("G/L Balance/B&udget")
                {
                    Caption = 'G/L Balance/B&udget';
                    Image = ChartOfAccounts;
                    RunObject = Page "G/L Balance/Budget";
                    RunPageLink = "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                                  "Business Unit Filter" = FIELD("Business Unit Filter"),
                                  "Budget Filter" = FIELD("Budget Filter");
                    RunPageOnRec = true;
                }
                separator(Separator55)
                {
                }
                action("Chart of Accounts &Overview")
                {
                    Caption = 'Chart of Accounts &Overview';
                    Image = Accounts;
                    RunObject = Page "Chart of Accounts Overview";
                }
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(IndentChartOfAccounts)
                {
                    Caption = 'Indent Chart of Accounts';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Account-Indent";
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("Recurring General Journal")
                {
                    Caption = 'Recurring General Journal';
                    Image = Journal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Recurring General Journal";
                }
                action("Close Income Statement")
                {
                    Caption = 'Close Income Statement';
                    Image = CloseYear;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Report "Close Income Statement";
                }
                action(DocsWithoutIC)
                {
                    Caption = 'Posted Documents without Incoming Document';
                    Image = Documents;

                    trigger OnAction()
                    var
                        PostedDocsWithNoIncBuf: Record "Posted Docs. With No Inc. Buf.";
                    begin
                        if Rec."Account Type" = Rec."Account Type"::Posting then
                            PostedDocsWithNoIncBuf.SetRange("G/L Account No. Filter", Rec."No.")
                        else
                            if Rec.Totaling <> '' then
                                PostedDocsWithNoIncBuf.SetFilter("G/L Account No. Filter", Rec.Totaling)
                            else
                                exit;
                        PAGE.Run(PAGE::"Posted Docs. With No Inc. Doc.", PostedDocsWithNoIncBuf);
                    end;
                }
            }
            action(AddOnSetup)
            {
                RunObject = Page "AddOn Setup Card";
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
                Promoted = false;
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
    }

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewGLAcc(xRec, BelowxRec);
    end;

    trigger OnOpenPage()
    begin
        //Rec.SetRange("G/L Entry Type Filter",Rec."G/L Entry Type Filter"::Definitive);
    end;

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
}

