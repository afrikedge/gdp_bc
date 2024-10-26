page 50106 "Posted Return Borrow List"
{
    Caption = 'Posted Item Return Loan List';
    CardPageID = "Posted Return Borrow";
    Editable = false;
    PageType = List;
    SourceTable = "Item Return Header";
    SourceTableView = WHERE("Document Type" = CONST(Borrow));

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

