page 50098 "Posted Return Consignat List"
{
    Caption = 'Posted Item Return Consignation List';
    CardPageID = "Posted Return Consignation";
    Editable = false;
    PageType = List;
    SourceTable = "Item Return Header";
    ApplicationArea = All;
    UsageCategory = History;
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
                field("Original Doc No"; Rec."Original Doc No")
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

