page 50092 "Posted Return Loan List"
{
    Caption = 'Posted Item Return Loan List';
    CardPageID = "Posted Return Loan";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Item Return Header";
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
            }
        }
    }

    actions
    {
    }
}

