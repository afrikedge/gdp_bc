namespace gdp_bc.gdp_bc;

page 50229 "Afk Main Industry List"
{
    ApplicationArea = All;
    Caption = 'Afk Main industry list';
    PageType = List;
    SourceTable = "Afk Reference";
    UsageCategory = Lists;
    SourceTableView = where(TableType = const("Main Industry"));

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
            }
        }
    }
}
