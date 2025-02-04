page 50038 "Afk SO Unblocking List"
{
    ApplicationArea = All;
    Caption = 'Afk SO Unblocking List';
    PageType = List;
    SourceTable = "Afk SalesOrder Unblocking";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Object; Rec.Object)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                }
                field("Balance Amount"; Rec."Balance Amount")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Amount Due"; Rec."Amount Due")
                {
                }
                field("Exceeding Amount"; Rec."Exceeding Amount")
                {
                }
                field("Gross exposure"; Rec."Gross exposure")
                {
                }
                field(Observations; Rec.Observations)
                {
                }
                field("Payment In Progress"; Rec."Payment In Progress")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Pending Delivery"; Rec."Pending Delivery")
                {
                }
                field("Pending Invoice"; Rec."Pending Invoice")
                {
                }
                field("Pending Traite"; Rec."Pending Traite")
                {
                }
                field("Pending Order"; Rec."Pending Order")
                {
                }
                field("Risk Level"; Rec."Risk Level")
                {
                }
                field("Unblocking justified"; Rec."Unblocking justified")
                {
                }
                field("Unpaid bills"; Rec."Unpaid bills")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
            }
        }
    }
}
