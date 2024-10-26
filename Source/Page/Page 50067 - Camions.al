page 50067 Camions
{
    CardPageID = "Truck Card";
    Editable = false;
    PageType = List;
    SourceTable = pro_moyentransport;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(immatriculation; Rec.immatriculation)
                {
                }
                field(description; Rec.description)
                {
                }
                field(type; Rec.type)
                {
                }
                field(codetransporteur; Rec.codetransporteur)
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
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
                field(tarifhorsville; Rec.tarifhorsville)
                {
                }
                field(objectifmensuel; Rec.objectifmensuel)
                {
                }
                field(disponible; Rec.disponible)
                {
                }
                field(pompe; Rec.pompe)
                {
                }
                field(compartiments; Rec.compartiments)
                {
                }
                field(nomchauffeur; Rec.nomchauffeur)
                {
                }
                field(prenomchauffeur; Rec.prenomchauffeur)
                {
                    Visible = false;
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

