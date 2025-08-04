page 50315 "General Jrnl Batches TRESO VIR"
{
    Caption = 'General Journal Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Gen. Journal Batch";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Copy VAT Setup to Jnl. Lines"; Rec."Copy VAT Setup to Jnl. Lines")
                {
                }
                field("Allow VAT Difference"; Rec."Allow VAT Difference")
                {
                }
                field("Allow Payment Export"; Rec."Allow Payment Export")
                {
                }
                field("Bank Statement Import Format"; Rec."Bank Statement Import Format")
                {
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditJournal)
            {
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    //*********************************************************
                    //GenJnlManagement.TemplateSelectionFromBatch(Rec);
                    //TODO
                    //GenJnlManagement.TemplateSelectionFromBatchTRESO_VIREMENT(Rec);
                    //*********************************************************
                end;
            }
            group("P&osting")
            {
                Caption = 'Posting';
                Image = Post;
                action(Reconcile)
                {
                    Caption = 'Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';

                    trigger OnAction()
                    begin
                        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        GenJnlLine.SetRange("Journal Batch Name", Rec.Name);
                        GLReconcile.SetGenJnlLine(GenJnlLine);
                        GLReconcile.Run;
                    end;
                }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintGenJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'Post';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-B.Post";
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Gen. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
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
                action("G/L Register")
                {
                    Caption = 'G/L Register';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "G/L Registers";
                }
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
            action(Action10)
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "G/L Register";
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewBatch;
    end;

    trigger OnOpenPage()
    begin
        GenJnlManagement.OpenJnlBatch(Rec);
    end;

    var
        ReportPrint: Codeunit "Test Report-Print";
        GenJnlManagement: Codeunit GenJnlManagement;
        GenJnlLine: Record "Gen. Journal Line";
        GLReconcile: Page Reconciliation;

    local procedure DataCaption(): Text[250]
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        if not CurrPage.LookupMode then
            if Rec.GetFilter("Journal Template Name") <> '' then
                if Rec.GetRangeMin("Journal Template Name") = Rec.GetRangeMax("Journal Template Name") then
                    if GenJnlTemplate.Get(Rec.GetRangeMin("Journal Template Name")) then
                        exit(GenJnlTemplate.Name + ' ' + GenJnlTemplate.Description);
    end;
}

