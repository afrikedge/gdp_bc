page 50097 "Posted Item Loan List"
{
    Caption = 'Posted Item Loan List';
    CardPageID = "Posted Item Loan";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Loan));

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
                field("Vendor No."; Rec."Vendor No.")
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

