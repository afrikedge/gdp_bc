namespace gdp_bc.gdp_bc;

page 50077 "Afk Frontdesk Permissions"
{
    ApplicationArea = All;
    Caption = 'Permissions';
    PageType = List;
    SourceTable = "Afk FrontDeskProfilePermission";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FrontDesk Profile"; Rec."FrontDesk Profile")
                {
                }
                field("FrontDesk Features"; Rec."FrontDesk Features")
                {
                }
                field(Read; Rec.Read)
                {
                }
                field(Modification; Rec.Modification)
                {
                }
                field(Insertion; Rec.Insertion)
                {
                }
                field(Deletion; Rec.Deletion)
                {
                }
                field(Execution; Rec.Execution)
                {
                }
            }
        }
    }
}
