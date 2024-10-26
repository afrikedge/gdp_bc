page 50066 "Fuel Statement List"
{
    Caption = 'Fuel Statement List';
    CardPageID = "Fuel Statement";
    Editable = false;
    PageType = List;
    SourceTable = "Fuel Statement Header";
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

