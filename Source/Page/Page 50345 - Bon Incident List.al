page 50345 "Bon Incident List"
{
    Caption = 'Incidents sur un bon';
    Editable = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "Dispaching Incident";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryId; Rec.EntryId)
                {
                    Visible = false;
                }
                field(IncidentType; Rec.IncidentType)
                {
                }
                field(Reason; Rec.Reason)
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field(AnnulerBon; Rec.AnnulerBon)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(NewOrderNo; Rec.NewOrderNo)
                {
                }
                field(NewTruckId; Rec.NewTruckId)
                {
                }
                field(nomchauffeur; Rec.nomchauffeur)
                {
                }
                field(permis; Rec.permis)
                {
                }
                field(nomTransporteur; Rec.nomTransporteur)
                {
                }
            }
        }
    }

    actions
    {
    }
}

