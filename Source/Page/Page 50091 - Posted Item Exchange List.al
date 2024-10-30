page 50091 "Posted Item Exchange List"
{
    Caption = 'Posted Item Exchange List';
    CardPageID = "Posted Item Exchange";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Exchange));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Posting Description"; Rec."Posting Description")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

