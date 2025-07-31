pageextension 50081 pageextension70000008 extends "Payment Slip List"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Payment Slip List"(Page 10870)".

    layout
    {
        addafter("Status Name")
        {
            field("Check Number"; Rec."Check Number")
            {
                ApplicationArea = All;
            }
            field("Amount (LCY)"; Rec."Amount (LCY)")
            {
                ApplicationArea = All;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
            }
            field("Origin Document N°"; Rec."Origin Document N°")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }
}

