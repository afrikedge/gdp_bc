codeunit 50002 "JIRAMA Sales Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchOrderHeader: Record "Purchase Header";
        PurchOrderLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        Text001: Label 'Souhaitez-vous valider les prévisions ?';
        Cust: Record Customer;
        Text002: Label 'Code agence d''origine invalide !';
        Text003: Label 'Code agence de destination invalide !';
        Text004: Label 'Les deux agences ne peuvent pas être identiques';
        Text005: Label 'Volume à transférer invalide';
        Text006: Label 'Aucune ligne n''a été trouvée pour le code agence %1';
        Text007: Label 'Aucune commande n''a été trouvée pour le code agence %1';
        Text008: Label 'La quantité à transférer ne doit pas être supérieure au volume initial sur %1';
        SalesRelease: Codeunit "Release Sales Document";
        Text009: Label 'La mise à jour de la quantité n''est pas possible sur la commande %1';
        Text010: Label 'Confirmer le transfert de %1 L de %2 vers %3 ?';
        Text011: Label 'Souhaitez-vous archiver le document de prévisions ?';
        Text012: Label 'Les commandes crées doivent êtres toutes soldées ou facturées avant d''archiver le document.\La commande %1 n''a est encore encours.';
        Text013: Label 'Traitement terminé !';
        TextRefJir: Label 'JIR/%1/%2/%3/GO';
        AddOnSetup: Record "AddOn Setup";
        Text014: Label 'La quantité ne peut pas être modifié car la commande provient d''un document de prévisions JIRAMA validé !';
        PurchRelease: Codeunit "Release Purchase Document";
        TextRefJir_FO: Label 'JIR/%1/%2/%3/FO';

    procedure CreateOrders(var JiramaForecast: Record "Jirama Sales Forecast")
    var
        JiramaForecastLine: Record "Jirama Sales Forecast Line";
    begin

        JiramaForecast.TestField(Status,JiramaForecast.Status::Created);
        JiramaForecast.TestField("Cargo Date");

        if not Confirm(Text001) then exit;

        //250716JN
        //CreatePurchOrder(JiramaForecast);

        JiramaForecastLine.Reset();
        JiramaForecastLine.SetRange(JiramaForecastLine."Document No.",JiramaForecast."No.");
        if JiramaForecastLine.FindSet then repeat

          CreateSalesOrder(JiramaForecast,JiramaForecastLine);

        until JiramaForecastLine.Next=0;

        JiramaForecast.Status := JiramaForecast.Status::Validated;
        JiramaForecast.Modify;

        Message(Text013);
    end;

    local procedure CreateSalesOrder(JiramaForecast: Record "Jirama Sales Forecast";var JiramaForecastLine: Record "Jirama Sales Forecast Line")
    var
        Cust: Record Customer;
    begin

        AddOnSetup.Get;

        SalesOrderHeader.Init;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;
        SalesOrderHeader."No." := '';

        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        SalesOrderHeader.Validate(SalesOrderHeader."Sell-to Customer No.",JiramaForecastLine."Sell-to Customer No.");

        if JiramaForecastLine."Ship-to Code" <> '' then
          SalesOrderHeader.Validate("Ship-to Code",JiramaForecastLine."Ship-to Code");//JN 150523

        //281021
        //Les cdes doivent de nveau etre valides
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;
        SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteOrdreLiv;

        JiramaForecastLine."Sales Order No" := SalesOrderHeader."No.";
        JiramaForecastLine.Modify;


        Cust.Get(JiramaForecastLine."Sell-to Customer No.");
        Cust.TestField(Cust."Location Code");

        //IF "Order Date" = 0D THEN
        SalesOrderHeader."Order Date" := JiramaForecast."Starting Date";
        SalesOrderHeader."Requested Delivery Date" := JiramaForecast."Ending Date";
        SalesOrderHeader."Created By Doc No." := JiramaForecast."No.";
        SalesOrderHeader."Shipment Method Code" :=  AddOnSetup."Shipment Method JIRAMA";
        //SalesOrderHeader."Created By Doc Type" := SalesOrderHeader."Created By Doc Type"::
        //ELSE
        //  SalesOrderHeader."Order Date" := ;
        //IF "Posting Date" <> 0D THEN
        SalesOrderHeader."Posting Date" := 0D;
        SalesOrderHeader."Document Date" := WorkDate;
        SalesOrderHeader."Shipment Date" := 0D;
        SalesOrderHeader."JIRAMA Order Ref." := JiramaForecast."JIRAMA Order Ref";
        //SalesOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        //SalesOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        //SalesOrderHeader."Dimension Set ID" := "Dimension Set ID";

        //IF SalesOrderHeader."Posting Date" = 0D THEN
        //  SalesOrderHeader."Posting Date" := WORKDATE;

        if SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" then begin
          SalesOrderHeader."Posting Date" := 0D;
          //SalesOrderHeader.MODIFY;
        end;

        SalesOrderHeader.Modify;






        //Ligne

        SalesOrderLine.Init;
        SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Order;
        SalesOrderLine."Document No.":=SalesOrderHeader."No.";
        SalesOrderLine."Line No.":=10000;
        SalesOrderLine.Insert(true);

        SalesOrderLine.Type:=SalesOrderLine.Type::Item;
        SalesOrderLine.Validate(SalesOrderLine."No.",JiramaForecast."JIRAMA Item No.");
        SalesOrderLine.Validate(SalesOrderLine.Quantity,JiramaForecastLine.Volume);
        SalesOrderLine.Modify;
        //SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
        //SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
        //SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";
    end;

    procedure CreatePurchOrder(var JiramaForecast: Record "Jirama Sales Forecast")
    var
        LineNum: Integer;
        JiramaForecastLine: Record "Jirama Sales Forecast Line";
    begin


        PurchOrderHeader.Init;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Order;
        PurchOrderHeader."No." := '';

        PurchOrderLine.LockTable;
        PurchOrderHeader.Insert(true);

        PurchOrderHeader.Validate(PurchOrderHeader."Buy-from Vendor No.",JiramaForecast."Partner No.");




        PurchOrderHeader."Order Date" := JiramaForecast."Starting Date";
        PurchOrderHeader."Created By Doc No." := JiramaForecast."No.";
        PurchOrderHeader."Purchase Type" := PurchOrderHeader."Purchase Type"::AchatMarchandise;
        PurchOrderHeader."Vendor Order No." := JiramaForecast."JIRAMA Order Ref";
        PurchOrderHeader."Requested Receipt Date" := JiramaForecast."Starting Date";
        //IF "Order Date" = 0D THEN
        //  SalesOrderHeader."Order Date" := WORKDATE
        //ELSE
        //  SalesOrderHeader."Order Date" := "Order Date";

        //IF "Posting Date" <> 0D THEN
        PurchOrderHeader."Posting Date" := 0D;
        PurchOrderHeader."Document Date" := WorkDate;
        //PurchOrderHeader."Shipment Date" := 0D;
        //SalesOrderHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        //SalesOrderHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        //SalesOrderHeader."Dimension Set ID" := "Dimension Set ID";

        //IF SalesOrderHeader."Posting Date" = 0D THEN
        //  SalesOrderHeader."Posting Date" := WORKDATE;

        if PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" then begin
          PurchOrderHeader."Posting Date" := 0D;
          //SalesOrderHeader.MODIFY;
        end;

        PurchOrderHeader.Modify;




        LineNum:=0;
        JiramaForecastLine.Reset();
        JiramaForecastLine.SetRange(JiramaForecastLine."Document No.",JiramaForecast."No.");
        if JiramaForecastLine.FindSet then repeat

          //Ligne
          PurchOrderLine.Init;
          PurchOrderLine."Document Type"  := PurchOrderLine."Document Type"::Order;
          PurchOrderLine."Document No." := PurchOrderHeader."No.";
          LineNum := LineNum + 10000;
          PurchOrderLine."Line No." := LineNum;
          PurchOrderLine.Insert(true);



          PurchOrderLine.Type:=PurchOrderLine.Type::Item;
          PurchOrderLine.Validate(PurchOrderLine."No.",JiramaForecast."JIRAMA Item No.");
          PurchOrderLine.Validate(PurchOrderLine.Quantity,JiramaForecastLine.Volume*JiramaForecast."Jirama Affectation %"/100);
          if Cust.Get(JiramaForecastLine."Sell-to Customer No.") then
            PurchOrderLine.Validate(PurchOrderLine."Location Code",Cust."Location Code");

          PurchOrderLine.Modify;

          JiramaForecastLine."Purchase Order No" := PurchOrderHeader."No.";
          JiramaForecastLine."Purchase Order Line No" := LineNum;
          JiramaForecastLine.Modify;

          //SalesOrderLine."Shortcut Dimension 1 Code" := BlanketOrderSalesLine."Shortcut Dimension 1 Code";
          //SalesOrderLine."Shortcut Dimension 2 Code" := BlanketOrderSalesLine."Shortcut Dimension 2 Code";
          //SalesOrderLine."Dimension Set ID" := BlanketOrderSalesLine."Dimension Set ID";

        until JiramaForecastLine.Next=0;
    end;

    procedure AddNewTransfert(DocumentNo: Code[20];ToClient: Code[20];FromClient: Code[20];Qty: Decimal;Descr: Text[50];ToName: Text[50];FromName: Text[50];ToSite: Code[10];FromSite: Code[10])
    var
        ToLine: Record "Jirama Sales Forecast Line";
        FromLine: Record "Jirama Sales Forecast Line";
        SalesOrder: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item1: Record Item;
        JiramaForecast: Record "Jirama Sales Forecast";
        ItemExists: Boolean;
        JIRTransfert: Record "JIRAMA Forecast Transfer";
        NextNum: Integer;
        NewVolume: Decimal;
        PurchLine: Record "Purchase Line";
        QtyPurch: Decimal;
    begin


        if not Confirm(StrSubstNo(Text010,Qty,FromName,ToName)) then exit;

        JiramaForecast.Get(DocumentNo);

        //Test des données
        if ToClient='' then Error(Text003);
        if FromClient='' then Error(Text002);
        if Qty<=0 then Error(Text005);
        if ((ToClient=FromClient) and (ToSite=FromSite)) then Error(Text004);

        ToLine.Reset;
        ToLine.SetRange("Document No.",DocumentNo);
        ToLine.SetRange("Sell-to Customer No.",ToClient);
        ToLine.SetRange("Ship-to Code",ToSite);
        if not ToLine.FindFirst then
          Error(Text006,ToClient)
        else
          begin
            //ToLine.Volume := ToLine.Volume + Qty;
            //ToLine.MODIFY;

            if PurchLine.Get(PurchLine."Document Type"::Order,
              ToLine."Purchase Order No",ToLine."Purchase Order Line No") then begin

                PurchOrderHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
                PurchRelease.Reopen(PurchOrderHeader);
                QtyPurch := Qty*JiramaForecast."Jirama Affectation %"/100;
                PurchLine.Quantity := PurchLine.Quantity + QtyPurch;
                PurchLine.Modify;
                if CanPerformReleasePurch(PurchOrderHeader) then
                  PurchRelease.PerformManualRelease(PurchOrderHeader);
                PurchOrderHeader.Modify;
            end;


          end;


        FromLine.Reset;
        FromLine.SetRange("Document No.",DocumentNo);
        FromLine.SetRange("Sell-to Customer No.",FromClient);
        FromLine.SetRange("Ship-to Code",FromSite);
        if not FromLine.FindFirst then
          Error(Text006,FromLine)
        else
          begin
            FromLine.CalcFields("Added Volume","Removed Volume");
            NewVolume := FromLine.Volume
              +FromLine."Added Volume"-FromLine."Removed Volume";

            NewVolume := NewVolume - Qty;

            if NewVolume<0 then Error(Text008,FromClient);


            if PurchLine.Get(PurchLine."Document Type"::Order,
              FromLine."Purchase Order No",FromLine."Purchase Order Line No") then begin

                PurchOrderHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
                PurchRelease.Reopen(PurchOrderHeader);
                QtyPurch := Qty*JiramaForecast."Jirama Affectation %"/100;
                PurchLine.Quantity := PurchLine.Quantity - QtyPurch;
                PurchLine.Modify;
                if CanPerformReleasePurch(PurchOrderHeader) then
                  PurchRelease.PerformManualRelease(PurchOrderHeader);
                PurchOrderHeader.Modify;

            end;

            //FromLine.MODIFY;
          end;



        //Mise à jour des commandes

        if SalesOrder.Get(SalesOrder."Document Type"::Order,ToLine."Sales Order No") then begin

          SalesRelease.Reopen(SalesOrder);

          SalesLine.Reset;
          SalesLine.SetRange(SalesLine."Document Type",SalesLine."Document Type"::Order);
          SalesLine.SetRange(SalesLine."Document No.",SalesOrder."No.");
          SalesLine.SetRange(SalesLine.Type,SalesLine.Type::Item);
          SalesLine.SetRange(SalesLine."No.",JiramaForecast."JIRAMA Item No.");
          if SalesLine.FindFirst then
          repeat

            SalesLine.SetHideValidationDialog(true);

            SalesLine.Validate(SalesLine.Quantity,SalesLine.Quantity+Qty);
            SalesLine.Modify;
            ItemExists:=true;

          until SalesLine.Next=0;

          if not ItemExists then Error(Text009,SalesOrder."No.");

          if CanPerformRelease(SalesOrder) then
            SalesRelease.PerformManualRelease(SalesOrder);

          SalesOrder.Modify;
        end;



        if SalesOrder.Get(SalesOrder."Document Type"::Order,FromLine."Sales Order No") then begin

          SalesRelease.Reopen(SalesOrder);

          SalesLine.Reset;
          SalesLine.SetRange(SalesLine."Document Type",SalesLine."Document Type"::Order);
          SalesLine.SetRange(SalesLine."Document No.",SalesOrder."No.");
          SalesLine.SetRange(SalesLine.Type,SalesLine.Type::Item);
          SalesLine.SetRange(SalesLine."No.",JiramaForecast."JIRAMA Item No.");
          if SalesLine.FindFirst then
          repeat

            SalesLine.SetHideValidationDialog(true);

            SalesLine.Validate(SalesLine.Quantity,SalesLine.Quantity-Qty);
            SalesLine.Modify;
            ItemExists:=true;

          until SalesLine.Next=0;

          if not ItemExists then Error(Text009,SalesOrder."No.");

          if CanPerformRelease(SalesOrder) then
            SalesRelease.PerformManualRelease(SalesOrder);

          SalesOrder.Modify;
        end;




        //Enregistrement du transfert
        Clear(JIRTransfert);

        if JIRTransfert.FindLast then
          NextNum := JIRTransfert."Entry No.";

        JIRTransfert."Document No." := DocumentNo;
        JIRTransfert.Description := Descr;
        JIRTransfert."Entry Date" := Today;
        JIRTransfert."User ID" := UserId;
        NextNum := NextNum + 1;
        JIRTransfert."Entry No." := NextNum;
        //FATransfert."External Document No." := ExtDocNo;

        JIRTransfert."From Sell-to Customer No." := FromClient;
        JIRTransfert."To Sell-to Customer No." := ToClient;
        JIRTransfert.Volume := Qty;

        JIRTransfert."To Customer Name" := ToName;
        JIRTransfert."From Customer Name" := FromName;

        JIRTransfert."From Ship-to Code" := FromSite;
        JIRTransfert."To Ship-to Code" := ToSite;

        JIRTransfert.Insert;


        RefreshValuesForecast(JiramaForecast);

        Message(Text013);
    end;

    procedure ArchiveForecast(var JiramaForecast: Record "Jirama Sales Forecast")
    var
        JiramaForecastLine: Record "Jirama Sales Forecast Line";
        SalesH: Record "Sales Header";
        ForecastLine: Record "Jirama Sales Forecast Line";
    begin

        if not Confirm(Text011) then exit;

        //Check sales orders
        JiramaForecastLine.Reset();
        JiramaForecastLine.SetRange("Document No.",JiramaForecast."No.");
        if JiramaForecastLine.FindSet then repeat
          if SalesH.Get(SalesH."Document Type"::Order,JiramaForecastLine."Sales Order No") then
            Error(Text012,SalesH."No.");
        until JiramaForecastLine.Next=0;

        JiramaForecast.Status := JiramaForecast.Status::Archived;
        JiramaForecast.Modify;


        Message(Text013);
    end;

    procedure RefreshValuesForecast(var JiramaForecast: Record "Jirama Sales Forecast")
    var
        JiramaForecastLine: Record "Jirama Sales Forecast Line";
        SalesH: Record "Sales Header";
        ForecastLine: Record "Jirama Sales Forecast Line";
        LigneBE: Record pro_detailBE;
        EnteteBE: Record pro_enteteBE;
        LigneFacture: Record "Sales Invoice Line";
        QteEnleve: Decimal;
        QteFacturee: Decimal;
        EnteteFacture: Record "Sales Invoice Header";
        SalesLine: Record "Sales Line";
    begin

        //Check sales orders
        JiramaForecastLine.Reset();
        JiramaForecastLine.SetRange("Document No.",JiramaForecast."No.");
        if JiramaForecastLine.FindSet then repeat

          JiramaForecastLine.CalcFields("Added Volume","Removed Volume");
          JiramaForecastLine."Actual Volume" := JiramaForecastLine.Volume
            +JiramaForecastLine."Added Volume"-JiramaForecastLine."Removed Volume";

          QteEnleve:=0;
          EnteteBE.Reset;
          EnteteBE.SetCurrentKey(CreatedFromDocNo,isconfirme);
          EnteteBE.SetRange(CreatedFromDocNo,JiramaForecastLine."Sales Order No");
          EnteteBE.SetRange(isconfirme,true);
          if EnteteBE.FindSet then repeat
            LigneBE.Reset;
            LigneBE.SetRange(numBE,EnteteBE.numBE);
            if LigneBE.FindSet then repeat
              if LigneBE.NavItemCode =JiramaForecast."JIRAMA Item No." then
                QteEnleve := QteEnleve + LigneBE.volumeenleve;
            until LigneBE.Next=0;

          until  EnteteBE.Next=0;



          QteFacturee:=0;
          //QTE FACTUREE
          if SalesH.Get(SalesH."Document Type"::Order,JiramaForecastLine."Sales Order No") then begin
            //Qté sur commande encours
            SalesLine.Reset;
            SalesLine.SetRange("Document Type",SalesLine."Document Type"::Order);
            SalesLine.SetRange("Document No.",SalesH."No.");
            SalesLine.SetRange(Type,SalesLine.Type::Item);
            SalesLine.SetRange("No.",JiramaForecast."JIRAMA Item No.");
            if SalesLine.FindSet then repeat
              QteFacturee := QteFacturee + SalesLine."Quantity Invoiced";
            until SalesLine.Next=0;
          end else begin
            //Qté sur facture enregistrée
            EnteteFacture.Reset;
            EnteteFacture.SetCurrentKey("Order No.");
            EnteteFacture.SetRange("Order No.",JiramaForecastLine."Sales Order No");
            if EnteteFacture.FindSet then repeat
              LigneFacture.Reset;
              LigneFacture.SetRange("Document No.",SalesH."No.");
              LigneFacture.SetRange(Type,SalesLine.Type::Item);
              LigneFacture.SetRange("No.",JiramaForecast."JIRAMA Item No.");
              if LigneFacture.FindSet then repeat
                QteFacturee := QteFacturee + LigneFacture.Quantity;
              until LigneFacture.Next=0;
            until EnteteFacture.Next=0;
          end;


          JiramaForecastLine."Total Facture" := QteFacturee;
          JiramaForecastLine."Total Enleve" := QteEnleve;
          JiramaForecastLine."Remaining Volume" := JiramaForecastLine."Actual Volume" - QteEnleve;
          JiramaForecastLine.Modify;


        until JiramaForecastLine.Next=0;
    end;

    procedure GetRefJIRAMA(EnteteBE: Record pro_enteteBE): Code[35]
    var
        Annee: Code[2];
        Location: Record Location;
    begin
        AddOnSetup.Get;

        //IF EnteteBE.CreatedFromDocNo='' THEN EXIT '';


        if SalesOrderHeader.Get(SalesOrderHeader."Document Type"::Order,EnteteBE.CreatedFromDocNo) then begin
          SalesOrderHeader.TestField(SalesOrderHeader."Location Code");
          Location.Get(SalesOrderHeader."Location Code");
          Location.TestField(Location."Code JIRAMA");
          if Cust.Get(SalesOrderHeader."Sell-to Customer No.") then begin
            if Cust."Sales Channel Code"=AddOnSetup."JIRAMA Sales Channel" then begin
              Annee := CopyStr(Format(Date2DMY(EnteteBE.dateBE,3)),3,2);
              if(IsGOOrder(SalesOrderHeader)) then
                exit(StrSubstNo(TextRefJir,Annee,Location."Code JIRAMA",EnteteBE.NumAfficheBE))
              else
                exit(StrSubstNo(TextRefJir_FO,Annee,Location."Code JIRAMA",EnteteBE.NumAfficheBE));
            end;
          end;
        end;
    end;

    local procedure CanPerformRelease(SalesH: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin

        SalesLine.SetRange("Document Type",SalesH."Document Type");
        SalesLine.SetRange("Document No.",SalesH."No.");
        SalesLine.SetFilter(Type,'>0');
        SalesLine.SetFilter(Quantity,'<>0');
        if SalesLine.Find('-') then
          exit(true);
    end;

    local procedure CanPerformReleasePurch(PurchH: Record "Purchase Header"): Boolean
    var
        PurchLine: Record "Purchase Line";
    begin

        PurchLine.SetRange("Document Type",PurchH."Document Type");
        PurchLine.SetRange("Document No.",PurchH."No.");
        PurchLine.SetFilter(Type,'>0');
        PurchLine.SetFilter(Quantity,'<>0');
        if PurchLine.Find('-') then
          exit(true);
    end;

    local procedure IsGOOrder(SalesO: Record "Sales Header"): Boolean
    var
        SOLine: Record "Sales Line";
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup.GOItem);

        SOLine.SetRange("Document Type",SalesO."Document Type");
        SOLine.SetRange("Document No.",SalesO."No.");
        SOLine.SetRange("No.",AddOnSetup.GOItem);
        //PurchLine.SETFILTER(Quantity,'<>0');
        if SOLine.Find('-') then
          exit(true);
    end;
}

