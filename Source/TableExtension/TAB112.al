tableextension 70000011 tableextension70000011 extends "Sales Invoice Header" 
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
        field(50071;"AMSA Cost Code";Code[20])
        {
            Caption = 'AMSA Cost Code';
            Editable = true;
        }
        field(50100;Provisioned;Boolean)
        {
            Editable = false;
        }
        field(50101;IsLivrCamRavitailleur;Boolean)
        {
            Caption = 'Livraison Camion Ravitailleur';
        }
    }


    //Unsupported feature: Code Modification on "PrintRecords(PROCEDURE 1)".

    //procedure PrintRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IsHandled := FALSE;
        OnBeforePrintRecords(DummyReportSelections,Rec,ShowRequestPage,IsHandled);
        IF NOT IsHandled THEN
          DocumentSendingProfile.TrySendToPrinter(
            DummyReportSelections.Usage::"S.Invoice",Rec,FIELDNO("Bill-to Customer No."),ShowRequestPage);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IsHandled := FALSE;
        OnBeforePrintRecords(DummyReportSelections,Rec,ShowRequestPage,IsHandled);

        CRReports.PrintFactureVente(Rec."No.");//ADDED JN200217

        {*************************************************************************
        IF NOT IsHandled THEN
          DocumentSendingProfile.TrySendToPrinter(
            DummyReportSelections.Usage::"S.Invoice",Rec,FIELDNO("Bill-to Customer No."),ShowRequestPage);}
        */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 5)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF UserSetupMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5


        //******************************************
        SETRANGE("User ID",USERID);
        //******************************************
        */
    //end;

    var
        CRReports: Codeunit "50027";
}

