namespace gdp_bc.gdp_bc;

page 50230 AfkFrontDeskPaymentMethod
{
    ApplicationArea = All;
    Caption = 'Moyens de paiement Frontdesk';
    PageType = List;
    SourceTable = "Afk Reference";
    UsageCategory = Lists;
    SourceTableView = where(TableType = const("Payment Method"));

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
                field("BC Payment"; Rec."BC Payment")
                {
                }
                field("Attachment Required"; Rec."Attachment Required")
                {
                }
            }
        }
    }
}
