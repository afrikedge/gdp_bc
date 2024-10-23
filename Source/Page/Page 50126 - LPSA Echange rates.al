page 50126 "LPSA Echange rates"
{
    Caption = 'LPSA Exchange rates';
    PageType = List;
    SourceTable = "LPSA Exchange Rate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

