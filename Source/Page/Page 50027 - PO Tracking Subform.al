page 50027 "PO Tracking Subform"
{
    AutoSplitKey = true;
    Caption = 'Purchase Order Tracking Lines';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Purchase Order Tracking";
    SourceTableView = WHERE("Data Type" = CONST(Suivi));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tracking Type"; Rec."Tracking Type")
                {
                }
                field("Information Code"; Rec."Information Code")
                {
                }
                field("Information Descr"; Rec."Information Descr")
                {
                }
                field(Notes; Rec.Notes)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Alert; Rec.Alert)
                {
                }
                field(Alerted; Rec.Alerted)
                {
                }
                field("Warning Date"; Rec."Warning Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Order"; Rec.Order)
                {
                }
            }
        }
    }

    actions
    {
    }
}

