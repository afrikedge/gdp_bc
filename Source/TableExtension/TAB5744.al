tableextension 70000153 tableextension70000153 extends "Transfer Shipment Header" 
{
    fields
    {
        field(50000;"Transfer Type";Option)
        {
            Caption = 'Transfer Type';
            OptionCaption = 'Normal Transfer,Hypothetical Transfer';
            OptionMembers = Normal,Hypothetical;
        }
        field(50001;"Original Transfer No";Code[20])
        {
            Caption = 'Original Transfer No';
        }
        field(50002;"Transfer Doc Type";Option)
        {
            Caption = 'Transfer Document';
            Editable = false;
            OptionCaption = 'Simple,Hypothetical Shipment,Hypothetical Receipt';
            OptionMembers = Simple,"Hypothetical Shipment","Hypothetical Receipt";
        }
        field(50003;"Receive-to Code";Code[10])
        {
            Caption = 'Receive to Location';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            var
                Location: Record "14";
                Confirmed: Boolean;
            begin
            end;
        }
        field(50004;"Truck Code";Code[20])
        {
            Caption = 'Truck code';
            TableRelation = pro_moyentransport.immatriculation;
        }
        field(50005;"Transporter Code";Code[20])
        {
            Caption = 'Transporter';
            TableRelation = Vendor WHERE (Transporter=CONST(Yes));
        }
        field(50006;"Transporter Name";Text[50])
        {
        }
        field(50007;nomchauffeur;Text[50])
        {
            Caption = 'Driver Name';
        }
        field(50008;prenomchauffeur;Text[50])
        {
            Caption = 'Driver First Name';
        }
        field(50009;permis;Text[50])
        {
            Caption = 'Permis';
        }
        field(50010;CarteGrise;Text[30])
        {
        }
    }
}

