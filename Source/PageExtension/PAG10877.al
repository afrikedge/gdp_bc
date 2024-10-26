pageextension 50082 pageextension70000009 extends "Payment Slip Archive"
{
    layout
    {
        addafter("Account No.")
        {
            field(Description; Rec.Description)
            {
            }
            field("Customer No."; Rec."Customer No.")
            {
            }
            field("Origin Document N°"; Rec."Origin Document N°")
            {
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

