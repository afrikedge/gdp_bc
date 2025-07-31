pageextension 50082 pageextension70000009 extends "Payment Slip Archive"
{
    layout
    {
        addafter("Account No.")
        {
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field("Origin Document N°"; Rec."Origin Document N°")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {
            action(Imprimer)
            {
                Caption = 'Imprimer';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;


                trigger OnAction()
                var
                    SlipH: Record "10867";
                begin
                    SlipH.RESET;
                    SlipH.SETRANGE(SlipH."No.", Rec."No.");
                    REPORT.RUNMODAL(REPORT::"ND Bordereau Paiement Archive", TRUE, FALSE, SlipH);
                end;
            }
        }
    }
}

