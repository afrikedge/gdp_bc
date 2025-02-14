namespace gdp_bc.gdp_bc;

page 50079 "Afk Requirement Matrix"
{
    ApplicationArea = All;
    Caption = 'Requirement Matrix';
    PageType = Card;
    SourceTable = "Afk Requirement Matrix";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Criteria Code"; Rec."Criteria Code")
                {
                    ToolTip = 'Specifies the value of the Criteria Code field.', Comment = '%';
                }
                field("Legal Status"; Rec."Legal Status")
                {
                    ToolTip = 'Specifies the value of the Legal Status field.', Comment = '%';
                }
                field("Requirement Level"; Rec."Requirement Level")
                {
                    ToolTip = 'Specifies the value of the Requirement Level field.', Comment = '%';
                }
                field("Sales Category Code"; Rec."Sales Category Code")
                {
                    ToolTip = 'Specifies the value of the Sales Category Code field.', Comment = '%';
                }
                field("Sales Channel"; Rec."Sales Channel")
                {
                    ToolTip = 'Specifies the value of the Sales Channel field.', Comment = '%';
                }
            }
        }
    }
}
