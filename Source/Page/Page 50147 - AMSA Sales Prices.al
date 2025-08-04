page 50147 "AMSA Sales Prices"
{
    Caption = 'AMSA Sales Prices';
    PageType = List;
    SourceTable = "AMSA Sales Price";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

