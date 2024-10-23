page 50337 "Bank Acc. Swift Correspondence"
{
    Caption = 'Correspondances banque Swift';
    PageType = List;
    SourceTable = "BA Swift Correspondence";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Actualiser tous les comptes")
            {
                Caption = 'Actualiser tous les comptes';
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    RepMaj: Report "Set Vendor Bank Accounts";
                begin
                    RepMaj.Run;
                end;
            }
        }
    }
}

