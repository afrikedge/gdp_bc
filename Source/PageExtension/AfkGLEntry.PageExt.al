pageextension 50109 "Afk GLEntry" extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore("&Navigate")
        {
            action("ND/NC Royalties")
            {
                ToolTip = 'Imprimer la ND/NC Royalties..Goodies';
                Image = PrintForm;
                Caption = 'Imprimer la ND/NC Royalties..Goodies';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Inv: Record "G/L Entry";
                begin
                    Inv.SetRange("Entry No.", Rec."Entry No.");
                    Report.Run(50079, true, false, Inv);
                end;
            }
        }
    }

}