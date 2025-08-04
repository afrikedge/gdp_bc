page 50063 "Posted Moneytech Billing List"
{
    Caption = 'Posted Moneytech Billing List';
    CardPageID = "Posted Moneytech Billing";
    Editable = false;
    PageType = List;
    SourceTable = "Posted MoneyTech Billing";
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
                field("Posting Date"; Rec."Posting Date")
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

