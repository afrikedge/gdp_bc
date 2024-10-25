pageextension 50081 pageextension70000008 extends "Payment Slip List"
{

    //Unsupported feature: Property Insertion (DeleteAllowed) on ""Payment Slip List"(Page 10870)".

    layout
    {
        addafter("Status Name")
        {
            field("Check Number"; Rec."Check Number")
            {
            }
            field("Amount (LCY)"; Rec."Amount (LCY)")
            {
            }
            field(Description; Rec.Description)
            {
            }
            field("Customer No."; Rec."Customer No.")
            {
            }
            field("Customer Name"; Rec."Customer Name")
            {
            }
            field("Origin Document N°"; Rec."Origin Document N°")
            {
                Visible = false;
            }
            field("Due Date"; Rec."Due Date")
            {
            }
        }
    }
}

