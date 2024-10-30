page 50305 "Purchase Req Partially pr List"
{
    Caption = 'Purch. Requisition List - Partially processed';
    CardPageID = "Purchase Requisition Workflow";
    Editable = false;
    InsertAllowed = false;
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Purchase Requisition";
    SourceTableView = WHERE("Processing Status" = CONST("Partially processed"));

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
                field("Processing Status"; Rec."Processing Status")
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
    var
        Filtre: Text[1024];
    begin

        //MESSAGE('%1',ReqMgt.GetFiltreDemandesManager(USERID));

        /*FILTERGROUP(2);
        SETFILTER(Rec."Create By",ReqMgt.GetFiltreDemandesCDG(USERID));
        FILTERGROUP(0);*/

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
}

