table 50083 "Delivery Constraint"
{
    Caption = 'Delivery Constraint';

    fields
    {
        field(1;ConstraintId;Integer)
        {
            AutoIncrement = true;
        }
        field(2;Type;Option)
        {
            OptionCaption = 'Axe,Transport,Livraison,PointLivraison,PointLivraisonAxe';
            OptionMembers = Axe,Transport,Livraison,PointLivraison,PointLivraisonAxe;
        }
        field(3;Item1;Option)
        {
            Caption = 'Item 1';
            OptionCaption = ' ,GO,SP95,PL,FO,NA';
            OptionMembers = " ",GO,SP95,PL,FO,NA;
        }
        field(4;Item2;Option)
        {
            Caption = 'Item 2';
            OptionCaption = ' ,GO,SP95,PL,FO,NA';
            OptionMembers = " ",GO,SP95,PL,FO,NA;
        }
        field(5;Axe1;Option)
        {
            Caption = 'Axe 1';
            OptionCaption = ' ,C,N,NE,NO,S,SE,SO,E,O';
            OptionMembers = " ",C,N,NE,NO,S,SE,SO,E,O;
        }
        field(6;Axe2;Option)
        {
            Caption = 'Axe 2';
            OptionCaption = ' ,C,N,NE,NO,S,SE,SO,E,O';
            OptionMembers = " ",C,N,NE,NO,S,SE,SO,E,O;
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Depot=CONST(true),
                                            "Location Type"=CONST(" "));

            trigger OnValidate()
            begin
                if Loc.Get("Location Code") then
                  "Responsibility Center" := Loc."Responsibility Center";
            end;
        }
        field(8;Site1;Code[30])
        {
            Caption = 'Delivery Site 1';
            TableRelation = "Delivery Site".Site WHERE ("Location Code"=FIELD("Location Code"));
        }
        field(9;"Location Name";Text[50])
        {
            CalcFormula = Lookup(Location.Name WHERE (Code=FIELD("Location Code")));
            Caption = 'Location Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;Site2;Code[30])
        {
            Caption = 'Delivery Site 2';
            TableRelation = "Delivery Site".Site WHERE ("Location Code"=FIELD("Location Code"));
        }
        field(11;"Customer No";Code[20])
        {
            Caption = 'Customer No';
            Description = 'Customer for delivery site compatibility';
            TableRelation = Customer WHERE ("Sales Category Code"=CONST('PBL'),
                                            "Responsibility Center"=FIELD("Responsibility Center"));
        }
        field(12;"Customer Site";Code[10])
        {
            Caption = 'Ship-to-Adress';
            TableRelation = "Ship-to Address".Code WHERE ("Customer No."=FIELD("Customer No"));
        }
        field(13;"Customer Site Name";Text[50])
        {
            CalcFormula = Lookup("Ship-to Address".Name WHERE ("Customer No."=FIELD("Customer No"),
                                                               Code=FIELD("Customer Site")));
            Caption = 'Ship-to-Adress Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
    }

    keys
    {
        key(Key1;ConstraintId)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Loc: Record Location;
}

