namespace gdp_bc.gdp_bc;

using Microsoft.Warehouse.History;

pageextension 50112 "Afk Posted Whse. Shipment" extends "Posted Whse. Shipment"
{
    layout
    {
        modify("Assigned User ID")
        {
            Editable = false;
            Caption = 'Created by';
        }
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
