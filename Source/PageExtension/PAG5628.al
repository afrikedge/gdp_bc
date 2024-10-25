pageextension 50056 pageextension70000113 extends "Fixed Asset G/L Journal"
{
    actions
    {
        addafter("ShowAllLines")
        {
            action(ImprimerCession)
            {
                Caption = 'Etat Cession Immo';
                Image = "report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "81";
                begin
                    FixedAsset.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    FixedAsset.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    REPORT.RUNMODAL(REPORT::"FA - Cession sur F Compta", TRUE, FALSE, FixedAsset);
                end;
            }
        }
    }
}

