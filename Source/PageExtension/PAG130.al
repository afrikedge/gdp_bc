pageextension 50019 pageextension70000021 extends "Posted Sales Shipment"
{
    Editable = false;
    layout
    {
        addlast(Shipping)
        {
            field("Afk Truck Code"; Rec."Afk Truck Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Afk Transporter Code"; Rec."Afk Transporter Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Afk Transporter Name"; Rec."Afk Transporter Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(AfkNomchauffeur; Rec.AfkNomchauffeur)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(AfkPermis; Rec.AfkPermis)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(AfkCarteGrise; Rec.AfkCarteGrise)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}

