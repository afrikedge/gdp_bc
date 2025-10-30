namespace gdp_bc.gdp_bc;

page 50079 "Afk Requirement Matrix"
{
    ApplicationArea = All;
    Caption = 'Requirement Matrix';
    PageType = List;
    SourceTable = "Afk Requirement Matrix";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Criteria Code"; Rec."Criteria Code")
                {
                }
                field("Legal Status"; Rec."Legal Status")
                {
                }
                field("Requirement Level"; Rec."Requirement Level")
                {
                }
                field("Sales Category Code"; Rec."Sales Category Code")
                {
                }
                field("Sales Channel"; Rec."Sales Channel")
                {
                }
            }
        }
    }
}
