page 50150 "Budget Document Lines"
{
    Caption = 'Budget Document Lines';
    Editable = false;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Purchase Budget Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("G/L Account No"; Rec."G/L Account No")
                {
                    Caption = 'G/L Account N°';
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    Caption = 'Budget Code';
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    Caption = 'G/L Account Name';
                }
                field("Yearly Budgeted Amt"; Rec."Yearly Budgeted Amt")
                {
                }
                field("Monthly Budgeted Amt"; Rec."Monthly Budgeted Amt")
                {
                }
                field("Acc Budgeted Amt"; Rec."Acc Budgeted Amt")
                {
                }
                field("Monthly Commitment"; Rec."Monthly Commitment")
                {
                }
                field("Acc Commitment"; Rec."Acc Commitment")
                {
                }
                field("Monthly Realized Amt"; Rec."Monthly Realized Amt")
                {
                }
                field("Acc Realized Amt"; Rec."Acc Realized Amt")
                {
                }
                field("Monthly Available Amt"; Rec."Monthly Available Amt")
                {
                }
                field("Acc Available Amt"; Rec."Acc Available Amt")
                {
                }
                field("Document Amount"; Rec."Document Amount")
                {
                    Visible = ColMontantVisible;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        ColMontantVisible := Rec."Document Type" <> Rec."Document Type"::Requisition;
    end;

    var
        ColMontantVisible: Boolean;
}

