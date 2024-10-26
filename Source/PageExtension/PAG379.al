pageextension 50034 pageextension70000071 extends "Bank Acc. Reconciliation"
{
    actions
    {
        modify(ImportBankStatement)
        {
            Caption = 'Import Bank Statement';
            Visible = false;
        }
        addafter(ImportBankStatement)
        {
            action(ImportBankStatementAFK)
            {
                Caption = 'Import Bank Statement';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                //"XmlPOrt": XMLport 50076;
                begin
                    CurrPage.UPDATE;
                    //ImportBankStatement;
                    //*************
                    // XmlPOrt.SetInfos(Rec."Statement No.",Rec."Bank Account No.");
                    // XmlPOrt.RUN;
                    //*************
                end;
            }
        }
    }
}

