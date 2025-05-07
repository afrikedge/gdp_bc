namespace gdp_bc.gdp_bc;

page 50233 "Afk Card Posting Config"
{
    ApplicationArea = All;
    Caption = 'Afk Card Posting Config';
    PageType = List;
    SourceTable = "Afk Card Posting Config";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File"; Rec."File")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
            }
        }
    }
}
