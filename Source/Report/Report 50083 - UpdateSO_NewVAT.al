report 50083 UpdateSO_NewVAT
{
    Caption = 'Mise à jour TVA';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = SORTING("Document Type","No.") ORDER(Ascending) WHERE("Document Type"=CONST(Order));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                CreateEntry: Boolean;
                Cust: Record Customer;
            begin

                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000,1));


                Cust.Get("Sales Header"."Sell-to Customer No.");
                if Cust."Sales Category Code"<>'PBL' then exit;

                ReleaseSalesDocument.PerformManualReopen("Sales Header");

                ChangeVATPostingGroups("Sales Header");

                //IF Cust."Sales Channel Code"='100' THEN
                //  ChangeUnitPrices("Sales Header");

                Nbres:=Nbres+1;
            end;

            trigger OnPostDataItem()
            var
                LastDocNo: Code[20];
                CommandeVente: Record "Sales Header";
                GenerateNewDocNo: Boolean;
                LineNum: Integer;
            begin
                Window.Close;
                Message(TextFin,Nbres);
            end;

            trigger OnPreDataItem()
            var
                StartingDate: Date;
                EndingDate: Date;
            begin
                AddOnSetup.Get;
                //AddOnSetup.TESTFIELD(AddOnSetup."Unbilled Revenues Account");
                
                //GenJrnTableND.GET(ModeleFeuille,NomFeuille);
                
                /*
                GenJrnLine.RESET;
                GenJrnLine.SETRANGE("Journal Template Name",ModeleFeuille);
                GenJrnLine.SETRANGE("Journal Batch Name",NomFeuille);
                IF GenJrnLine.FINDFIRST THEN ERROR(Text001,NomFeuille);
                */
                BesoinNo :=0;
                
                Window.Open(Text008);
                
                //IF ((DateDeb=0D) OR (DateFin=0D)) THEN ERROR(Text009);
                StartingDate:=DMY2Date(1,2,2023);
                EndingDate:=DMY2Date(7,2,2023);
                
                "Sales Header".SetFilter("Sales Header"."Requested Delivery Date",'%1..',StartingDate);
                
                LineNum:=0;
                 NbreTotalLignes := "Sales Header".Count;
                 Nbres:=0;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField("Provision Tmpl Journal");
        ModeleFeuille := AddOnSetup."Provision Tmpl Journal";
        PostingDate:=WorkDate;
    end;

    var
        PostingDate: Date;
        ModeleFeuille: Code[10];
        NomFeuille: Code[10];
        AddOnSetup: Record "AddOn Setup";
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        GenJrnTemplate: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJrnTableND: Record "Gen. Journal Batch";
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        LineNum: Integer;
        LastDocNo: Code[20];
        GLMgt: Codeunit "Provisions Cde Mgt";
        DateDeb: Date;
        DateFin: Date;
        Text009: Label 'Veuillez saisir une plage de dates commande';
        AFK_ERR003: Label 'Vous ne devez pas seléctionner un magasin de ce type. Commande %1';
        AFK_ERR004: Label 'La date de livraison du BL n''appartient pas au mois de novembre. Commande %1';
        AFK_Text003: Label 'Aucune document de livraison n''a été trouvé pour cette commande %1';
        PriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        Nbres: Integer;
        TextFin: Label '%1 commandes traitées';

    procedure SetFeuille(CodeModele1: Code[10];CodeFeuille1: Code[10])
    begin
        ModeleFeuille:=CodeModele1;
        NomFeuille:=CodeFeuille1;
    end;

    local procedure ChangeVATPostingGroups(SalesH: Record "Sales Header")
    var
        SLine: Record "Sales Line";
    begin
        SLine.Reset;
        SLine.SetRange(SLine."Document Type",SLine."Document Type"::Order);
        SLine.SetRange(SLine."Document No.",SalesH."No.");
        SLine.SetFilter(SLine."No.",'%1|%2|%3|%4','31000-0000','34000-0000','REM0002','REM0005');
        if SLine.FindSet then
          repeat

            if SLine."No."='31000-0000' then
              if SLine."VAT Prod. Posting Group"<>'TVAPPI' then
                SLine.Validate(SLine."VAT Prod. Posting Group",'TVAPPI');

            if SLine."No."='34000-0000' then
              if SLine."VAT Prod. Posting Group"<>'TVAPPI' then
                SLine.Validate(SLine."VAT Prod. Posting Group",'TVAPPI');

            if SLine."No."='REM0002' then
              if SLine."VAT Prod. Posting Group"<>'TVAPPI' then
                SLine.Validate(SLine."VAT Prod. Posting Group",'TVAPPI');

            if SLine."No."='REM0005' then
              if SLine."VAT Prod. Posting Group"<>'TVAPPI' then
                SLine.Validate(SLine."VAT Prod. Posting Group",'TVAPPI');

            SLine.Modify;

          until SLine.Next=0;
    end;

    procedure ChangeUnitPrices(SalesH: Record "Sales Header")
    var
        SalesLine1: Record "Sales Line";
        PricesDate: Date;
        BLHeader: Record pro_enteteBL;
        DocPrepa: Record "Posted Adjustment Header";
    begin
        
        if SalesH."Document Type" <> SalesH."Document Type"::Order then exit;
        
        PricesDate:=0D;
        /*
        BLHeader.RESET;
        BLHeader.SETRANGE(BLHeader.NavOrderNo,SalesH."No.");
        BLHeader.SETRANGE(isconfirme,TRUE);
        IF BLHeader.FINDLAST THEN
          PricesDate := BLHeader.datelivraison;
        
        IF PricesDate=0D THEN BEGIN
          DocPrepa.RESET;
          DocPrepa.SETRANGE(DocPrepa."Document Type",DocPrepa."Document Type"::Shipment);
          DocPrepa.SETRANGE(DocPrepa."Order No.",SalesH."No.");
          IF DocPrepa.FINDLAST THEN
            PricesDate := DocPrepa."Posting Date";
        END;
        
        IF PricesDate=0D THEN EXIT;
        IF (
          DATE2DMY(PricesDate,2)<>11) OR (DATE2DMY(PricesDate,3)<>2022
          ) THEN
          ERROR(AFK_Text003);
          */
        
        SalesH.TestField("Requested Delivery Date");
        PricesDate := SalesH."Requested Delivery Date";
        
        
        SalesLine1.Reset;
        SalesLine1.SetRange("Document Type",SalesLine1."Document Type"::Order);
        SalesLine1.SetRange("Document No.",SalesH."No.");
        if SalesLine1.FindSet then repeat
          if ((SalesLine1.Type=SalesLine1.Type::Item) or
            (SalesLine1.Type=SalesLine1.Type::Resource)) then begin
        
            SalesLine1.TestField("Qty. per Unit of Measure");
        
            case SalesLine1.Type of
              SalesLine1.Type::Item,SalesLine1.Type::Resource:
                begin
                  PriceCalcMgt.SetSalesPriceDate(PricesDate);
                  PriceCalcMgt.FindSalesLineLineDisc(SalesH,SalesLine1);
                  PriceCalcMgt.FindSalesLinePrice(SalesH,SalesLine1,SalesLine1.FieldNo("No."));
                end;
            end;
            SalesLine1.Validate("Unit Price");
            SalesLine1.Modify;
        
          end;
        until SalesLine1.Next=0;

    end;
}

