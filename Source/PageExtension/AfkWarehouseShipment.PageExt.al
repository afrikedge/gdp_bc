namespace gdp_bc.gdp_bc;

using Microsoft.Warehouse.Document;

pageextension 50111 "Afk Warehouse Shipment" extends "Warehouse Shipment"
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
            }
            field("Afk Transporter Code"; Rec."Afk Transporter Code")
            {
                ApplicationArea = All;
            }
            field("Afk Transporter Name"; Rec."Afk Transporter Name")
            {
                ApplicationArea = All;
            }
            field(AfkNomchauffeur; Rec.AfkNomchauffeur)
            {
                ApplicationArea = All;
            }
            field(AfkPermis; Rec.AfkPermis)
            {
                ApplicationArea = All;
            }
            field(AfkCarteGrise; Rec.AfkCarteGrise)
            {
                ApplicationArea = All;
            }
        }

    }
}
