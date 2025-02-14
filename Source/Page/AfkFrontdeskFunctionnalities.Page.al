

page 50149 "Afk Frontdesk Functionnalities"
{
    ApplicationArea = All;
    Caption = 'Frontdesk Functionnalities';
    PageType = List;
    SourceTable = "Afk Reference";
    UsageCategory = Lists;
    SourceTableView = where(TableType = const("FrontDesk Feature"));

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
