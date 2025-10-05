namespace gdp_bc.gdp_bc;

using Microsoft.Warehouse.Document;
using Microsoft.Purchases.Vendor;

tableextension 50080 "AfkWarehouse Shipment Header" extends "Warehouse Shipment Header"
{
    fields
    {
        field(50004; "Afk Truck Code"; Code[20])
        {
            Caption = 'Truck code';
            TableRelation = pro_moyentransport.immatriculation;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Camion: record pro_moyentransport;
            begin
                if Camion.Get("Afk Truck Code") then begin
                    AfkNomchauffeur := Camion.nomchauffeur;
                    AfkPrenomchauffeur := Camion.prenomchauffeur;
                    AfkPermis := Camion.permis;
                    AfkCarteGrise := Camion.CarteGrise;
                    if (Camion.codetransporteur <> '') then
                        Validate("Afk Transporter Code", Camion.codetransporteur);
                end
            end;
        }
        field(50005; "Afk Transporter Code"; Code[20])
        {
            Caption = 'Transporter';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.Get("Afk Transporter Code") then
                    "Afk Transporter Name" := Vend.Name;
            end;
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

    trigger OnAfterInsert()
    var
    begin
        Rec."Assigned User ID" := UserId;
    end;
}
