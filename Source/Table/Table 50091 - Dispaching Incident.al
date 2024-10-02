table 50091 "Dispaching Incident"
{

    fields
    {
        field(1;EntryId;Integer)
        {
            Caption = 'ID';
        }
        field(2;IncidentType;Option)
        {
            Caption = 'Type d''incident';
            OptionCaption = 'Déviation,Changement de camion,Changement de chauffeur,Autre';
            OptionMembers = Deviation,ChangementCamion,ChangementChauffeur,Autre;
        }
        field(3;Comments;Text[250])
        {
            Caption = 'Observations';
        }
        field(5;Reason;Text[100])
        {
            Caption = 'Motif';
        }
        field(6;IdRef;Integer)
        {
            Caption = 'Reference';
            Editable = false;
        }
        field(7;"User ID";Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.ValidateUserID("User ID");
            end;
        }
        field(8;"Creation Date";Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(9;nomchauffeur;Text[50])
        {
            Caption = 'Driver Name';
        }
        field(10;permis;Text[50])
        {
            Caption = 'Driver licence';
        }
        field(11;nomTransporteur;Text[50])
        {
            Caption = 'Transporter Name';
        }
        field(12;Posted;Boolean)
        {
        }
        field(13;NewOrderNo;Code[20])
        {
            Caption = 'Nvelle Commande';
        }
        field(14;NewTruckId;Code[30])
        {
            Caption = 'Nveau camion';
        }
        field(15;AnnulerBon;Boolean)
        {
            Caption = 'Bon annulé';
        }
        field(16;"Reason Type";Option)
        {
            Caption = 'Reason Type';
            OptionCaption = 'Camion,Chauffeur,Commande,Dispatcheur,Autres';
            OptionMembers = Camion,Chauffeur,Commande,Dispatcheur,Autres;
        }
        field(17;"Reason Code";Code[20])
        {
            TableRelation = "Dispaching Incident Type"."Incident Code" WHERE ("Incident Type"=FIELD("Reason Type"));
        }
    }

    keys
    {
        key(Key1;EntryId)
        {
        }
    }

    fieldgroups
    {
    }
}

