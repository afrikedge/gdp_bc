page 50042 "JIRAMA Forecast List"
{
    Caption = 'Commandes JIRAMA';
    CardPageID = "JIRAMA Sales Forecast";
    PageType = List;
    SourceTable = "Jirama Sales Forecast";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = WHERE(Status = FILTER(Created | Validated));

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
                field("Partner Name"; Rec."Partner Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("JIRAMA Order Ref"; Rec."JIRAMA Order Ref")
                {
                }
            }
        }
    }

    actions
    {
    }
}

