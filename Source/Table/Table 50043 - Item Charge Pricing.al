table 50043 "Item Charge Pricing"
{

    fields
    {
        field(1;Date;Date)
        {
            Caption = 'Date';
        }
        field(2;"Service Code";Code[20])
        {
            Caption = 'Service Code';
            TableRelation = Item WHERE (Type=CONST(Service));
        }
        field(3;"Vendor Code";Code[20])
        {
            Caption = 'Transporter';
            TableRelation = Vendor WHERE (Transporter=CONST(true));
        }
        field(4;"Origin Location";Code[10])
        {
            Caption = 'Origin Location';
            TableRelation = Location;
        }
        field(5;"Arrival Location";Code[10])
        {
            Caption = 'Arrival Location';
            TableRelation = Location;
        }
        field(6;Price;Decimal)
        {
            Caption = 'Price';
        }
        field(7;Discount;Decimal)
        {
            Caption = 'Discount';
        }
        field(8;"Service Name";Text[50])
        {
            CalcFormula = Min(Item.Description WHERE ("No."=FIELD("Service Code")));
            Caption = 'Service Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Vendor Name";Text[50])
        {
            CalcFormula = Min(Vendor.Name WHERE ("No."=FIELD("Vendor Code")));
            Caption = 'Transporter Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Origin Location Name";Text[50])
        {
            CalcFormula = Min(Location.Name WHERE (Code=FIELD("Origin Location")));
            Caption = 'Origin Location Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Arrival Location Name";Text[30])
        {
            CalcFormula = Min(Location.Name WHERE (Code=FIELD("Arrival Location")));
            Caption = 'Arrival Location Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(13;"Service Type";Option)
        {
            Caption = 'Service Type';
            OptionCaption = 'Storage,Transport,TransportAmbatovy,LivraisonSite,JiramaSite';
            OptionMembers = Storage,Transport,TransportAmbatovy,LivraisonSite,JiramaSite;
        }
        field(14;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(15;Site;Code[30])
        {
            TableRelation = "Delivery Site".Site WHERE ("Location Code"=FIELD("Origin Location"));
        }
        field(20;codetransporteur;Code[20])
        {
            Caption = 'Transporter Code';
            TableRelation = Vendor WHERE (Transporter=CONST(true));
        }
        field(21;"Transporter Name";Text[50])
        {
            CalcFormula = Min(Vendor.Name WHERE ("No."=FIELD(codetransporteur)));
            Caption = 'Nom du transporteur';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Customer No";Code[20])
        {
            Caption = 'Customer No';
            TableRelation = Customer;
        }
        field(23;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE ("Customer No."=FIELD("Customer No"));
        }
    }

    keys
    {
        key(Key1;Date,"Service Type","Item No.","Origin Location","Arrival Location",Site,codetransporteur,"Customer No","Ship-to Code")
        {
        }
    }

    fieldgroups
    {
    }
}

