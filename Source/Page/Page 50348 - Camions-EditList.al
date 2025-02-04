page 50348 "Camions-EditList"
{
    Caption = 'Camions - edition';
    DeleteAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = pro_moyentransport;
    CardPageId = "Truck Card";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(immatriculation; Rec.immatriculation)
                {
                }
                field(codetransporteur; Rec.codetransporteur)
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
                field(nomchauffeur; Rec.nomchauffeur)
                {
                }
                field(prenomchauffeur; Rec.prenomchauffeur)
                {
                }
                field(capacite; Rec.capacite)
                {
                }
                field(entournee; Rec.entournee)
                {
                }
                field(lieuaffectation; Rec.lieuaffectation)
                {
                }
                field(tarifville; Rec.tarifville)
                {
                }
                field(description; Rec.description)
                {
                }
                field(tarifhorsville; Rec.tarifhorsville)
                {
                }
                field(objectifmensuel; Rec.objectifmensuel)
                {
                }
                field(disponible; Rec.disponible)
                {
                }
                field(type; Rec.type)
                {
                }
                field(pompe; Rec.pompe)
                {
                }
                field(compartiments; Rec.compartiments)
                {
                }
                field(vitesse; Rec.vitesse)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Statistiques transporteurs")
            {
                Caption = 'Statistiques transporteurs';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Dispaching Events";
            }
        }
    }
}

