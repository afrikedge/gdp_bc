pageextension 50088 "GD1 Fixed Asset Card" extends "Fixed Asset Card"
{
    actions
    {
        addafter(Register)
        {
            action(Transfer)
            {
                Caption = 'Transfer';
                Ellipsis = true;
                Image = TransferFunds;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TransferPage: Page "FA Transfer";
                begin
                    TransferPage.SetFA(Rec);
                    TransferPage.SetCodeImmo(Rec."No.");
                    TransferPage.RunModal;
                end;
            }
            separator(Separator1000000020)
            {
            }
            action(EditionMiseEnService)
            {
                Caption = 'Etat de Mise en service';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Mise en Serv", true, false, FixedAsset);
                end;
            }
            action(EditionTransfert)
            {
                Caption = 'Etat de transfert';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Transf", true, false, FixedAsset);
                end;
            }
            action(EditionMiseRebut)
            {
                Caption = 'Etat de Mise En rebut';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Rebut", true, false, FixedAsset);
                end;
            }
            action(EditionCession)
            {
                Caption = 'Etat de Cession Immo';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Cession", true, false, FixedAsset);
                end;
            }
            action(GenerateCode)
            {
                Caption = 'Générate FA Code';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NewCode: Code[30];
                begin
                    //******************************************
                    NewCode := FAMgt.GenerateCodeImmo(Rec);
                    if NewCode <> Rec.Codification then begin
                        Rec.Codification := NewCode;
                        Rec.Modify();
                    end;
                    //******************************************
                end;
            }
        }
    }
    var
        FAMgt: Codeunit "Fa Mgt";
}
