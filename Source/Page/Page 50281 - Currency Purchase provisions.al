page 50281 "Currency Purchase provisions"
{
    Caption = 'Currency purchase for provisions';
    Editable = false;
    PageType = List;
    SourceTable = "Expiry Currency Purchase";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Purchase Line No."; Rec."Purchase Line No.")
                {
                }
                field("Purchase Amount"; Rec."Purchase Amount")
                {
                }
                field("Currency Exchange"; Rec."Currency Exchange")
                {
                }
                field("Purchase Amount (LCY)"; Rec."Purchase Amount (LCY)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

