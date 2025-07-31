namespace gdp_bc.gdp_bc;

page 50234 "Afk Operation Plein Cuve List"
{
    ApplicationArea = All;
    Caption = 'Operation Plein Cuve List';
    PageType = List;
    SourceTable = "Afk Operation Plein Cuve";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field(Inactif; Rec.Inactif)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportLettrage)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                Ellipsis = true;
                RunObject = xmlport "Afk Import Op Plein Cuve";
            }
        }
    }
}

