page 50176 "Posted FA Conso List"
{
    Caption = 'Posted Item consumption to FA List';
    CardPageID = "Posted FA Conso";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Adjustment Header";
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
            }
        }
    }

    actions
    {
    }
}

