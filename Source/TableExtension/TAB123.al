tableextension 70000019 tableextension70000019 extends "Purch. Inv. Line" 
{
    fields
    {
        field(50010;"Purchase Account";Code[20])
        {
            Caption = 'Charge Account';
            Editable = false;
        }
        field(50015;"Purch Req Line No.";Integer)
        {
        }
        field(50016;"Purch Req No.";Code[20])
        {
        }
        field(50024;Disponibility;Option)
        {
            Caption = 'Disponibility';
            OptionCaption = 'Available,Non available';
            OptionMembers = Dispo,Indisponible;
        }
        field(50025;"Starting Warranty";Option)
        {
            Caption = 'Starting Garanty';
            OptionCaption = 'On receipt, On starting,No Warranty';
            OptionMembers = Receipt,Starting,"No Warranty";
        }
        field(50026;"Warranty (Months)";Integer)
        {
            Caption = 'Warranty (Months)';
        }
        field(50027;Insurance;Boolean)
        {
            Caption = 'Insurance';
        }
        field(50030;"Batch Number";Code[100])
        {
            Caption = 'Batch Number';
        }
        field(50031;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
        }
        field(50050;"Provision Qty";Decimal)
        {
            Editable = false;
        }
    }
    keys
    {
        key(Key1;"Purch Req No.","Purch Req Line No.")
        {
        }
    }
}

