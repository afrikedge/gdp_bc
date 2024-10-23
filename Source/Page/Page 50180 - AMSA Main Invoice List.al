page 50180 "AMSA Main Invoice List"
{
    Caption = 'AMSA Main Invoice List';
    CardPageID = "AMSA Main Invoice";
    Editable = false;
    PageType = List;
    SourceTable = "Fuel Statement Header";
    SourceTableView = WHERE("Document Type" = CONST("Main invoice"));

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
                    Caption = 'Contract N°';
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

