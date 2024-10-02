tableextension 50024 "A02 Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50000; "Delivery Status"; Option)
        {
            Caption = 'Processing Status';
            OptionCaption = 'Draft,Pending Prices validation,Blocked,Pending Delivery Order,Pending Delivery,Partially Shipped,Shipped,Partially invoiced,Invoiced,Closed,Cancelled,Rupture';
            OptionMembers = Saisie,ValidationTarifs,Bloquee,AttenteOrdreLiv,AttenteLivraison,PartiellementLivree,Livree,PartiellementFacturee,Facturee,Soldee,Annulee,Rupture;
        }
        field(50001; "Created By Doc No."; Code[20])
        {
            Caption = 'Created By Doc No.';
            Editable = false;
        }
        field(50002; "Created By Doc Type"; Option)
        {
            Caption = 'Created By Doc Type';
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation;
        }
        field(50050; "BL Number"; Integer)
        {
        }
        field(50051; "BE Number"; Integer)
        {
        }
        field(50052; "Livre JIRAMA"; Decimal)
        {
            CalcFormula = Sum("Sales Shipment Line".Quantity WHERE("Document No." = FIELD("No."),
                                                                    "No." = CONST('34000-0000')));
            Caption = 'Volume livré JIRAMA';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

