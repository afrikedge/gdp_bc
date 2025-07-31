page 50158 "Posted Purchase Requisition"
{
    Caption = 'Posted Purchase Requisition';
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Purchase Requisition";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                }
                field("Budget Code"; Rec."Budget Code")
                {
                }
                field(Initiator; Rec.Initiator)
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Purchase Type"; Rec."Purchase Type")
                {
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        //CurrPage.Lines.PAGE.UpdatePage(TRUE);
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        //CurrPage.Lines.PAGE.UpdateForm(TRUE);
                    end;
                }
                field("Retained Offer Code"; Rec."Retained Offer Code")
                {
                }
                field("External Doc No"; Rec."External Doc No")
                {
                }
                field("Created Doc Type"; Rec."Created Doc Type")
                {
                }
                field("Created Doc Code"; Rec."Created Doc Code")
                {
                }
                field("Direction Code"; Rec."Direction Code")
                {
                }
                field("Service Code"; Rec."Service Code")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field("Type Achat"; Rec."Type Achat")
                {
                }
                field("Type article"; Rec."Type article")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field(Budgeted; Rec.Budgeted)
                {
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                }
                field("Under Contract"; Rec."Under Contract")
                {
                }
                field("Contract Ref"; Rec."Contract Ref")
                {
                }
                field(Project; Rec.Project)
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
            }
            part(Lines; "Posted Purch Requisit Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No" = FIELD("No.");
            }
            part("Offers List"; "Posted Vendor Offers Part")
            {
                Caption = 'Offers List';
                SubPageLink = "Code Demande" = FIELD("No.");
            }
            systempart(Control1000000001; Links)
            {
                Visible = false;
            }
            systempart(Control1000000000; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}

