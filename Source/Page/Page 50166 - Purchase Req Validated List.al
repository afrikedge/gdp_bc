page 50166 "Purchase Req Validated List"
{
    Caption = 'Purch. Requisition List - Validated';
    CardPageID = "Purchase Requisition Workflow";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Requisition";
    SourceTableView = WHERE(Status = CONST(Validated),
                            "Processing Status" = CONST(" "));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Type article"; Rec."Type article")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Type Achat"; Rec."Type Achat")
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
                field("Budget Code"; Rec."Budget Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Manager Validation"; Rec."Manager Validation")
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

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

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

