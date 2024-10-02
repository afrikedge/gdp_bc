tableextension 70000139 tableextension70000139 extends "Sales Header Archive" 
{
    fields
    {
        field(50000;"Delivery Status";Option)
        {
            Caption = 'Processing Status';
            OptionCaption = 'Draft,Pending Prices validation,Blocked,Pending Delivery Order,Pending Delivery,Partially Shipped,Shipped,Partially invoiced,Invoiced,Closed,Cancelled,Rupture';
            OptionMembers = Saisie,ValidationTarifs,Bloquee,AttenteOrdreLiv,AttenteLivraison,PartiellementLivree,Livree,PartiellementFacturee,Facturee,Soldee,Annulee,Rupture;
        }
        field(50001;"Created By Doc No.";Code[20])
        {
            Caption = 'Created By Doc No.';
            Editable = false;
        }
        field(50002;"Created By Doc Type";Option)
        {
            Caption = 'Created By Doc Type';
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation,AMSA,Sortie';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation,AMSA,SortieARefacturer;
        }
        field(50003;"Return Reason";Text[200])
        {
            Caption = 'Return Reason';
        }
        field(50010;"JIRAMA Order Ref.";Code[30])
        {
            Caption = 'JIRAMA Order Ref.';
        }
        field(50011;"JIRAMA Invoice No.";Code[30])
        {
            Caption = 'JIRAMA Invoice No.';
        }
        field(50012;Observations;Text[250])
        {
        }
        field(50013;"Type Ecr Cargo";Option)
        {
            Caption = 'Type écriture cargo';
            OptionCaption = ' ,Normale,Fictive';
            OptionMembers = " ",Normale,Fictive;
        }
        field(50061;"Shipment Val UserID";Code[50])
        {
        }
        field(50062;"Shipment Val Date";DateTime)
        {
        }
        field(50063;"Prices Status";Option)
        {
            Caption = 'Prices status';
            OptionCaption = 'Conformes,Prix non conformes';
            OptionMembers = Conformes,"Prix non conformes";
        }
        field(50065;Anticipated;Boolean)
        {
            Caption = 'Anticipated';
        }
        field(50069;"Ref Dossier Cargo";Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
        field(50071;"AMSA Cost Code";Code[20])
        {
            Caption = 'AMSA Cost Code';
            Editable = true;
        }
        field(50075;"Dispatching Status";Option)
        {
            Caption = 'Dispatching Status';
            Editable = false;
            OptionCaption = ' ,Non traitée,Reliquat,Traitée';
            OptionMembers = "None",NoAction,Reliquat,Processed;
        }
        field(50077;"GDP Deletion";Boolean)
        {
        }
    }
}

