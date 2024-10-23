page 50054 "Posted Moneytech Import List"
{
    Caption = 'Posted Moneytech transactions';
    CardPageID = "Posted Moneytech Import";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Moneytech Import";

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
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Posting Description"; Rec."Posting Description")
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

