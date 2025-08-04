page 50187 "Posted AMSA Main Invoice List"
{
    Caption = 'Posted AMSA Main Invoice List';
    CardPageID = "Posted AMSA Main Invoice";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Fuel Statement";
    SourceTableView = WHERE("Document Type" = CONST("Main invoice"));
    ApplicationArea = All;

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

