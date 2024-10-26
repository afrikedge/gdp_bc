page 50044 "Posted JIRAMA Forecast List"
{
    Caption = 'Posted JIRAMA Sales Forecast List';
    CardPageID = "Posted JIRAMA Sales Forecast";
    Editable = false;
    PageType = List;
    SourceTable = "Jirama Sales Forecast";
    SourceTableView = WHERE(Status = CONST(Archived));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
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

