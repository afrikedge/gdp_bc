pageextension 50049 pageextension70000099 extends "Sales Order Archive"
{
    layout
    {
        addafter("Order Date")
        {
            field("Delivery Status"; Rec."Delivery Status")
            {
                ApplicationArea = All;
            }
            field(Observations; Rec.Observations)
            {
                MultiLine = true;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(Restore)
        {
            Visible = false;
        }
        addafter(Restore)
        {
            action(Restore2)
            {
                Caption = '&Restore';
                Ellipsis = true;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit "5063";
                begin
                    //ArchiveManagement.AFK_RestoreSalesDocument2(Rec);
                end;
            }
            action(SuiviEtapesValidation)
            {
                Caption = 'Validation Step Lines';
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 50275;
                RunPageLink = "Document Type" = CONST("Sales Order"),
                              "Document No." = FIELD("No.");
            }
        }
    }
}

