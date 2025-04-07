namespace gdp_bc.gdp_bc;

page 50231 "Afk Customer Revision List"
{
    ApplicationArea = All;
    Caption = 'Customer Revision List';
    PageType = List;
    SourceTable = "Afk Customer Revision";
    UsageCategory = Lists;
    ModifyAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Parent Account No."; Rec."Parent Account No.")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Approved Credit limit (LCY)"; Rec."Approved Credit limit (LCY)")
                {
                }
                field("Approved Payment Method"; Rec."Approved Payment Method")
                {
                }
                field("Approved Payment Terms Code"; Rec."Approved Payment Terms Code")
                {
                }
                field("Approved Risk Level"; Rec."Approved Risk Level")
                {
                }
                field("Automatic Debit"; Rec."Automatic Debit")
                {
                }
                field("Bank Transfer Bank Stamp"; Rec."Bank Transfer Bank Stamp")
                {
                }
                field("Cash payment"; Rec."Cash payment")
                {
                }
                field("Check Set"; Rec."Check Set")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Credit Note"; Rec."Credit Note")
                {
                }
                field("Credit limit (LCY)"; Rec."Credit limit (LCY)")
                {
                }
                field("Mobile Banking"; Rec."Mobile Banking")
                {
                }
                field("New Automatic Debit"; Rec."New Automatic Debit")
                {
                }
                field("New Bank Transfer Bank Stamp"; Rec."New Bank Transfer Bank Stamp")
                {
                }
                field("New Cash payment"; Rec."New Cash payment")
                {
                }
                field("New Check Set"; Rec."New Check Set")
                {
                }
                field("New Credit Note"; Rec."New Credit Note")
                {
                }
                field("New Credit limit (LCY)"; Rec."New Credit limit (LCY)")
                {
                }
                field("New Mobile Banking"; Rec."New Mobile Banking")
                {
                }
                field("New Payment Terms Code"; Rec."New Payment Terms Code")
                {
                }
                field("New Received Check"; Rec."New Received Check")
                {
                }
                field("New Risk Level"; Rec."New Risk Level")
                {
                }
                field("New Traite"; Rec."New Traite")
                {
                }
                field(Traite; Rec.Traite)
                {
                }
                field(Object; Rec.Object)
                {
                }
                field("Received Check"; Rec."Received Check")
                {
                }
                field("Revised Credit limit (LCY)"; Rec."Revised Credit limit (LCY)")
                {
                }
                field("Revised Payment Method"; Rec."Revised Payment Method")
                {
                }
                field("Revised Payment Terms Code"; Rec."Revised Payment Terms Code")
                {
                }
                field("Revised Risk Level"; Rec."Revised Risk Level")
                {
                }
                field("Risk Level"; Rec."Risk Level")
                {
                }
                field("Sales Category Code"; Rec."Sales Category Code")
                {
                }
            }
        }
    }
}
