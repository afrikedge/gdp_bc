pageextension 50005 pageextension70000051 extends "General Ledger Entries"
{
    layout
    {

        //Unsupported feature: Property Insertion (Name) on "Control 29".


        //Unsupported feature: Property Deletion (Visible) on "Control 40".

        addafter("VAT Bus. Posting Group")
        {
            field("Transaction Date"; Rec."Transaction Date")
            {
                ApplicationArea = All;
            }
            field("External Document No.2"; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
            field("Purchase Invoice Doc"; Rec."Purchase Invoice Doc")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Amount")
        {
            field("Source No.2"; Rec."Source No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(ReverseTransaction)
        {
            action(ReverseProvisions)
            {
                Caption = 'Reverse Provisions';
                Image = CancelAllLines;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ReverseProvisions: Report "50165";
                begin
                    CLEAR(ReverseProvisions);
                    ReverseProvisions.SetTransactionNo2(Rec."Transaction No.");
                    ReverseProvisions.RUN;
                end;
            }
        }
    }
}

