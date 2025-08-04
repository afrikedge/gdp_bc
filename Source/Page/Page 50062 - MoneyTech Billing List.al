page 50062 "MoneyTech Billing List"
{
    Caption = 'Moneytech Billing List';
    CardPageID = "Moneytech Billing";
    Editable = false;
    PageType = List;
    SourceTable = "MoneyTech Billing";
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
            }
        }
    }

    actions
    {
    }
}

