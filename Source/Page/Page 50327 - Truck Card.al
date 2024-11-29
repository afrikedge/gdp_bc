page 50327 "Truck Card"
{
    PageType = Card;
    SourceTable = pro_moyentransport;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(immatriculation; Rec.immatriculation)
                {
                }
                field(description; Rec.description)
                {
                }
                field(codetransporteur; Rec.codetransporteur)
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
                field(NomDispaching; Rec.NomDispaching)
                {
                }
                field(lieuaffectation; Rec.lieuaffectation)
                {
                }
                field(disponible; Rec.disponible)
                {
                }
                field(pompe; Rec.pompe)
                {
                }
                field(capacite; Rec.capacite)
                {
                }
                field(entournee; Rec.entournee)
                {
                }
                field(compartiments; Rec.compartiments)
                {
                }
                field(NumeroContrat; Rec.NumeroContrat)
                {
                }
                field(ZoneActivite; Rec.ZoneActivite)
                {
                }
                field(AssuranceMseCgnie; Rec.AssuranceMseCgnie)
                {
                }
                field(AssuranceMseCgnieValidite; Rec.AssuranceMseCgnieValidite)
                {
                }
                field(CtrlTechCodeRouteCertificat; Rec.CtrlTechCodeRouteCertificat)
                {
                }
                field(CtrlTechCodeRouteValidite; Rec.CtrlTechCodeRouteValidite)
                {
                }
                field(NomChauffeurActuel; Rec.NomChauffeurActuel)
                {
                    Importance = Promoted;
                }
                field("Dispaching Compartment Order"; Rec."Dispaching Compartment Order")
                {
                    Visible = false;
                }
            }
            part(Compartments; "Compartment Subform")
            {
                Caption = 'Compartments';
                SubPageLink = immatriculation = FIELD(immatriculation);
            }
            part(CompartmentsOrder; "CompartmentOrderSubform")
            {
                Caption = 'Ordre des compartiments';
                SubPageLink = immatriculation = FIELD(immatriculation);
            }
            group(Citerne)
            {
                Caption = 'Citerne';
                field(MarqueCiterne; Rec.MarqueCiterne)
                {
                }
                field(DateMEC_Citerne; Rec.DateMEC_Citerne)
                {
                }
                field(AgeCiterne; Rec.AgeCiterne)
                {
                }
                field(VisiteTechniqueCiterne; Rec.VisiteTechniqueCiterne)
                {
                }
                field(AssuranceCgnieCiterne; Rec.AssuranceCgnieCiterne)
                {
                }
                field(ValiditeAssuranceCgnieCiterne; Rec.ValiditeAssuranceCgnieCiterne)
                {
                }
                field(PatenteCiterne; Rec.PatenteCiterne)
                {
                }
                field(CtrlEtancheiteCtneCertificat; Rec.CtrlEtancheiteCtneCertificat)
                {
                }
                field(CtrlEtancheiteCtneValidite; Rec.CtrlEtancheiteCtneValidite)
                {
                }
            }
            group(Tracteur)
            {
                Caption = 'Tracteur';
                field(MarqueTracteur; Rec.MarqueTracteur)
                {
                }
                field(DateMEC_Tracteur; Rec.DateMEC_Tracteur)
                {
                }
                field(AgeTracteur; Rec.AgeTracteur)
                {
                }
                field(VisiteTechniqueTracteur; Rec.VisiteTechniqueTracteur)
                {
                }
                field(AssuranceCgnieTracteur; Rec.AssuranceCgnieTracteur)
                {
                }
                field(ValiditeAssuranceCgnieTracteur; Rec.ValiditeAssuranceCgnieTracteur)
                {
                }
                field(PatenteTracteur; Rec.PatenteTracteur)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Chauffeurs)
            {
                Caption = 'Chauffeurs';
                Image = Shipment;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page Drivers;
                RunPageLink = immatriculation = FIELD(immatriculation);
            }
        }
    }
}

