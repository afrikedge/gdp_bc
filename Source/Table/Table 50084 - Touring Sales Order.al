table 50084 "Touring Sales Order"
{
    // DrillDownPageID = "Touring Order Lines";
    // LookupPageID = "Touring Order Lines";

    fields
    {
        field(1; IdTouring; Integer)
        {
        }
        field(2; "Order No"; Code[20])
        {
            Caption = 'Order No.';

            trigger OnValidate()
            begin
                TestField("Order No");
                if "Order No" = '' then begin
                    GO := 0;
                    SC := 0;
                    PL := 0;
                    FO := 0;
                    "Sell-to Customer No." := '';
                    "Sell-to Customer Name" := '';
                    "Ship-to Code" := '';
                    "Responsibility Center" := '';
                    "Requested Delivery Date" := 0D;
                end;


                //TODO Migration 
                //DispachMgt.CheckNewOrderDispaching(IdTouring,"Order No");

                Touring.Get(IdTouring);

                SO.Get(SO."Document Type"::Order, "Order No");
                "Sell-to Customer No." := SO."Sell-to Customer No.";
                "Sell-to Customer Name" := SO."Sell-to Customer Name";
                "Ship-to Code" := SO."Ship-to Code";
                "Responsibility Center" := SO."Responsibility Center";
                "Requested Delivery Date" := SO."Requested Delivery Date";

                SO.TestField(SO."Shipment Method Code", 'TRP');
                SO.TestField(SO."Location Code", Touring."Location Code");
                SO.TestField(SO."Document Type", SO."Document Type"::Order);
                if SO."Dispatching Status" = SO."Dispatching Status"::Processed then
                    Error(Text003, "Order No");

                if ((SO."Delivery Status" <> SO."Delivery Status"::AttenteLivraison) and
                  (SO."Delivery Status" <> SO."Delivery Status"::PartiellementFacturee) and
                  (SO."Delivery Status" <> SO."Delivery Status"::PartiellementLivree)) then
                    Error(Text002);


                DeliveryConstraint.Reset;
                DeliveryConstraint.SetRange(Type, DeliveryConstraint.Type::PointLivraisonAxe);
                DeliveryConstraint.SetRange("Customer No", "Sell-to Customer No.");
                DeliveryConstraint.SetRange("Customer Site", "Ship-to Code");
                if not DeliveryConstraint.FindFirst then
                    Message(Text001, "Ship-to Code");

                GO := 0;
                SC := 0;
                PL := 0;
                FO := 0;

                //TODO Migration
                //DispachMgt.SetVolumeRestantALivrerCde("Order No",GO,SC,PL,FO);
                Total := GO + SC + PL + FO;
            end;
        }
        field(3; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(4; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name';
            Editable = false;
        }
        field(5; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(6; "Requested Delivery Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(7; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(8; GO; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                UpdateTotal;
            end;
        }
        field(9; PL; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                UpdateTotal;
            end;
        }
        field(10; SC; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                UpdateTotal;
            end;
        }
        field(11; FO; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                UpdateTotal;
            end;
        }
        field(12; Total; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(13; Pompe; Boolean)
        {
        }
        field(14; "Touring Status"; Option)
        {
            Caption = 'Touring Status';
            Editable = false;
            OptionCaption = 'Created,Dispached,Posted,Confirmed';
            OptionMembers = Created,Dispached,Posted,Confirmed;
        }
    }

    keys
    {
        key(Key1; IdTouring, "Order No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SO: Record "Sales Header";
        //DispachMgt: Codeunit "Logistique Mgt";
        Touring: Record Touring;
        DeliveryConstraint: Record "Delivery Constraint";
        Text001: Label 'Vous devez définir un axe pour le point de livraison %1';
        Text002: Label 'La commande n''a pas encore été validée pour la livraison';
        Text003: Label 'La commande %1 a déjà été traitée';

    local procedure UpdateTotal()
    begin
        Total := GO + SC + PL + FO;
    end;
}

