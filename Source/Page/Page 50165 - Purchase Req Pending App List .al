page 50165 "Purchase Req Pending App List "
{
    Caption = 'Purch. Requisition List - Pending Approval CDG';
    CardPageID = "Purchase Requisition Workflow";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Purchase Requisition";
    SourceTableView = WHERE(Status = CONST(CDG));

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
    var
        Filtre: Text[1024];
    begin

        //MESSAGE('%1',ReqMgt.GetFiltreDemandesManager(USERID));

        Rec.FilterGroup(2);
        Rec.SetFilter(Rec."Create By", ReqMgt.GetFiltreDemandesCDG(UserId));
        Rec.FilterGroup(0);
    end;

    var
        ReqMgt: Codeunit "Purchase Requisition Mgt";
        ShortcutDimCode: array[8] of Code[20];
}

