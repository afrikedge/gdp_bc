table 50086 "Touring Product Entry"
{

    fields
    {
        field(1; IdTouring; Integer)
        {
        }
        field(2; OrderNo; Code[20])
        {
        }
        field(3; Immatriculation; Code[30])
        {

            trigger OnValidate()
            var
                Camion1: Record pro_moyentransport;
                Compartiment: Record Compartment;
            begin
            end;
        }
        field(4; ItemNo; Code[20])
        {
        }
        field(5; IdCompartment; Integer)
        {
        }
        field(6; Volume; Decimal)
        {
        }
        field(7; TouringStatus; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Created,Dispached,Posted,Confirmed';
            OptionMembers = Created,Dispached,Posted,Confirmed;
        }
        field(8; "Real Shipped Volume"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; IdTouring, OrderNo, Immatriculation, IdCompartment)
        {
        }
        key(Key2; IdTouring, Immatriculation)
        {
        }
        key(Key3; TouringStatus, OrderNo, ItemNo)
        {
        }
    }

    fieldgroups
    {
    }
}

