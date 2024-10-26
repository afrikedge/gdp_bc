page 50173 "FA Conso List"
{
    Caption = 'Item consumption to FA List';
    CardPageID = "FA Conso";
    PageType = List;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST("FA Conso"));

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

