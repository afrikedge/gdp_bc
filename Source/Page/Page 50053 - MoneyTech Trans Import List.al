page 50053 "MoneyTech Trans Import List"
{
    Caption = 'Moneytech transactions Import';
    CardPageID = "Moneytech Import";
    Editable = false;
    PageType = List;
    SourceTable = "MoneyTech Import";
    SourceTableView = WHERE(Status = CONST(Created));

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

