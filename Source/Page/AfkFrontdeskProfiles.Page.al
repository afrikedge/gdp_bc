namespace gdp_bc.gdp_bc;

page 50039 "Afk Frontdesk Profiles"
{
    ApplicationArea = All;
    Caption = 'Profiles';
    PageType = List;
    SourceTable = "Afk FrontDesk Profile";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Active; Rec.Active)
                {
                }
            }
        }
    }
}
