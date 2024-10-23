page 50250 "Posted Reception List"
{
    Caption = 'Posted Item Reception List';
    CardPageID = "Posted Reception Transfer";
    Editable = false;
    PageType = List;
    SourceTable = "Item Return Header";
    SourceTableView = WHERE("Document Type" = CONST(Transfer));

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
                field("User ID"; Rec."User ID")
                {
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                }
                field("Original Doc No"; Rec."Original Doc No")
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

