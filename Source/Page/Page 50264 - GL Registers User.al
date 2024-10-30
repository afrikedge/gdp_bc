page 50264 "G/L Registers User"
{
    Caption = 'G/L Registers';
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "G/L Register";
    SourceTableView = WHERE("No." = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field(Reversed; Rec.Reversed)
                {
                    Visible = false;
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                }
                field("From VAT Entry No."; Rec."From VAT Entry No.")
                {
                }
                field("To VAT Entry No."; Rec."To VAT Entry No.")
                {
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
        area(navigation)
        {
            group("&Register")
            {
                Caption = '&Register';
                Image = Register;
                action("General Ledger")
                {
                    Caption = 'General Ledger';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Reg.-Gen. Ledger";
                }
                action("Customer &Ledger")
                {
                    Caption = 'Customer &Ledger';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Reg.-Cust.Ledger";
                }
                action("Ven&dor Ledger")
                {
                    Caption = 'Ven&dor Ledger';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "G/L Reg.-Vend.Ledger";
                }
                action("Bank Account Ledger")
                {
                    Caption = 'Bank Account Ledger';
                    Image = BankAccountLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-Bank Account Ledger";
                }
                action("Fixed &Asset Ledger")
                {
                    Caption = 'Fixed &Asset Ledger';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-FALedger";
                }
                action("Maintenance Ledger")
                {
                    Caption = 'Maintenance Ledger';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-Maint.Ledger";
                }
                action("VAT Entries")
                {
                    Caption = 'VAT Entries';
                    Image = VATLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "G/L Reg.-VAT Entries";
                }
                action("Item Ledger Relation")
                {
                    Caption = 'Item Ledger Relation';
                    Image = ItemLedger;
                    RunObject = Page "G/L - Item Ledger Relation";
                    RunPageLink = "G/L Register No." = FIELD("No.");
                    RunPageView = SORTING("G/L Register No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ReverseRegister)
                {
                    Caption = 'Reverse Register';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReversalEntry: Record "Reversal Entry";
                    begin
                        Rec.TestField("No.");
                        ReversalEntry.ReverseRegister(Rec."No.");
                    end;
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
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report Budget;
            }
            action("Trial Balance by Period")
            {
                Caption = 'Trial Balance by Period';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period";
            }
            action("G/L Register")
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "G/L Register";
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter(Rec."User ID", UserId);
        Rec.FilterGroup(0);
    end;
}

