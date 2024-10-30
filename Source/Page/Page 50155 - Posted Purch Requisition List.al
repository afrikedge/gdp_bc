page 50155 "Posted Purch Requisition List"
{
    Caption = 'Posted Purchase Requisition List';
    CardPageID = "Posted Purchase Requisition";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Posted Purchase Requisition";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Budget Code"; Rec."Budget Code")
                {
                }
                field(Initiator; Rec.Initiator)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Purchase Type"; Rec."Purchase Type")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
            }
            systempart(Control1000000001; Links)
            {
                Visible = false;
            }
            systempart(Control1000000000; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        UserSetup.Get(UserId);
        if not UserSetup."Enlever Filtre Demande Achat" then begin
            Rec.FilterGroup(2);
            Rec.SetFilter(Rec."PO Type", '%1', ReqMgt.GetFiltreTypeCommandeAchat);
            Rec.FilterGroup(0);
        end;
    end;

    var
        ReqMgt: Codeunit "Purchase Requisition Mgt";
        UserSetup: Record "User Setup";
        ShortcutDimCode: array[8] of Code[20];
}

