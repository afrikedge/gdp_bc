namespace gdp_bc.gdp_bc;

page 50078 "Afk Requirement Criteria List"
{
    ApplicationArea = All;
    Caption = 'Requirement Criteria List';
    PageType = List;
    SourceTable = "Afk Requirement Criteria";
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
                field(Coefficient; Rec.Coefficient)
                {
                }
                field("Document required"; Rec."Document required")
                {
                }
                field("Point Maximal"; Rec."Point Maximal")
                {
                }
                field(Requirement; Rec.Requirement)
                {
                }
                field(Validity; Rec.Validity)
                {
                }
                field("Value Size"; Rec."Value Size")
                {
                }
                field("Value Type"; Rec."Value Type")
                {
                }
            }
        }
    }
}
