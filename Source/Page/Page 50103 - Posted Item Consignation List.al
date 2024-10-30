page 50103 "Posted Item Consignation List"
{
    Caption = 'Posted Item Loan List';
    CardPageID = "Posted Item Consignation";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Consignation));

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
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
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
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

