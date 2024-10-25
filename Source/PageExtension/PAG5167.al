pageextension 50050 pageextension70000100 extends "Purchase Order Archive"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field(Derogation; Rec.Derogation)
            {
            }
        }
    }
    actions
    {
        addlast("Functions")
        {
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprovalEntries: Page "658";
                begin
                    // ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                    // ApprovalEntries.SetDisableDelegate;
                    // ApprovalEntries.RUN;
                end;
            }
        }
    }
}

