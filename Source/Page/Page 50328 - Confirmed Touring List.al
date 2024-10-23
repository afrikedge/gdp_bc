page 50328 "Confirmed Touring List"
{
    Caption = 'Posted Touring List';
    CardPageID = "Touring Card";
    Editable = false;
    PageType = List;
    SourceTable = Touring;
    SourceTableView = WHERE(Status = FILTER(Confirmed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IdTouring; Rec.IdTouring)
                {
                }
                field("Touring Date"; Rec."Touring Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("User ID"; Rec.Rec."User ID")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field(TotalGO; Rec.TotalGO)
                {
                }
                field(TotalPL; Rec.TotalPL)
                {
                }
                field(TotalSC; Rec.TotalSC)
                {
                }
                field(TotalFO; Rec.TotalFO)
                {
                }
                field("Total volume to ship"; Rec."Total volume to ship")
                {
                }
                field("Truck capacity"; Rec."Truck capacity")
                {
                }
                field("Validity Date"; Rec."Validity Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;
}

