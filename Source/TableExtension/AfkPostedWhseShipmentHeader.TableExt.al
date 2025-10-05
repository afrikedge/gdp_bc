namespace gdp_bc.gdp_bc;

using Microsoft.Warehouse.History;
using Microsoft.Purchases.Vendor;

tableextension 50081 "AfkPosted Whse. Shipment Head" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50004; "Afk Truck Code"; Code[20])
        {
            Caption = 'Truck code';
            TableRelation = pro_moyentransport.immatriculation;
            ValidateTableRelation = false;
        }
        field(50005; "Afk Transporter Code"; Code[20])
        {
            Caption = 'Transporter';
            TableRelation = Vendor;
        }
        field(50006; "Afk Transporter Name"; Text[50])
        {
            Caption = 'Transporter Name';
        }
        field(50007; AfkNomchauffeur; Text[50])
        {
            Caption = 'Driver Name';
        }
        field(50008; AfkPrenomchauffeur; Text[50])
        {
            Caption = 'Driver First Name';
        }
        field(50009; AfkPermis; Text[50])
        {
            Caption = 'Driver licence';
        }
        field(50010; AfkCarteGrise; Text[30])
        {
            Caption = 'Carte grise';
        }
    }

}
