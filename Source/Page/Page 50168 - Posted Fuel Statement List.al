page 50168 "Posted Fuel Statement List"
{
    Caption = 'Posted Fuel Statement List';
    CardPageID = "Posted Fuel Statement";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Posted Fuel Statement";
    SourceTableView = WHERE("Document Type" = CONST(FS));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

