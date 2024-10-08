codeunit 50015 "Item Value Cargo Mgt"
{
    // 180817 Enlever trans reelles jovenna de la compta des écarts et correction comptabilisation
    // 070917 Achats reels jovenna a passer dans le cargo Regul
    // 061017 Affichage qté déja affectée pour JIRAMA afin de controler avec cargo JOV
    // 271017 Troubleshooting query duration add waiting message
    // 081117 Calculer les couts a la date de fin du traitement

    Permissions = TableData "Item Ledger Entry"=rim;

    trigger OnRun()
    begin
        //MESSAGE('%1',GetUnitCostCargaison('1611BIS','42001-0000'));
        //MESSAGE('%1',FinMois(CALCDATE('<-1M>',310117D)));
    end;

    var
        Text001: Label 'Aucune méthode d''allocation (Cargaison) n''a été trouvée pour cette vente\N° Document %1, N° Ecriture %2, Date : %3, Canal de vente : %4';
        Text002: Label 'Cette opération ne peut être affectée à une cargaison disponible\N° Document %1, N° Ecriture %2, Date : %3';
        AddOnSetup: Record "AddOn Setup";
        Text003: Label 'Une cargaison doit être associée à cette opération';
        Text004: Label 'Cargo JOVENNA FO introuvable';
        Text005: Label 'Cargo JOVENNA GO introuvable';
        Text006: Label 'Cargo CONFRERE introuvable';
        CargoConfrere: Code[20];
        CargoTransfert: Code[20];
        Text007: Label 'Souhaitez-vous valider les lignes?';
        Text008: Label 'Traitement terminé avec succès!';
        Text009: Label 'Souhaitez vous annuler la ligne %1 - %2?';
        Text010: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text011: Label 'Cette opération (sur JIRAMA) ne peut être affectée à une cargaison JOVENNA disponible\N° Document %1, N° Ecriture %2, Date : %3\La qté déjà affectée pour JIRAMA est %4, La qté %5 ne peut plus être affectée.\Vérifiez les volumes alloués sur les cargo JOVENNA pour le mois encours';
        Text012: Label 'Cette opération (sur JIRAMA) ne peut être affectée à une cargaison disponible\N° Document %1, N° Ecriture %2, Date : %3';
        Text013: Label 'Cette opération ne peut être affectée à une cargaison FICTIVE disponible\N° Document %1, N° Ecriture %2, Date : %3';
        Text014: Label 'Cargo ''Ajustement'' introuvable';
        CargoEnlevement: Code[20];
        DimMgt: Codeunit DimensionManagement;
        Text015: Label 'Prévision non livrée %1';
        Text016: Label 'Souhaitez-vous créer des lignes de provisions pour le stock cargo ?';
        Text017: Label 'ECART_JIRAMA';
        CargoItems: array [20] of Code[20];
        CargoItemsLength: Integer;
        Text018: Label 'Ajust. Vente Cargo. %1 %2-%3 %4 ';
        GenPostingSetup: Record "General Posting Setup";
        Text019: Label 'Var. Stock vente anticipée %1 %2-%3 %4 ';
        Text020: Label 'Ajust. Neg Cargo %1 %2-%3 %4 ';
        TxtSuppr: Label 'Initialisation...';
        TxtCanal: Label 'Canal de vente %1  (%2)';
        TxtEntrees: Label 'Entrées';
        TxtSorties: Label 'Sorties';
        Text021: Label 'Cette opération (Vente anticipée) ne peut être affectée à une cargaison disponible\N° Document %1, N° Ecriture %2, Date : %3';
        Text022: Label 'Ajust. Pos Cargo %1 %2-%3 %4 ';
        Text023: Label 'Impossible de migrer car il existe déjà des écritures cargo.';
        TotalConsoJIRAMA: Decimal;
        Text024: Label 'Veuillez patienter SVP ...';
        DateFinTraitement: Date;
        Text025: Label 'La date de fin du traitement non spécifiée';

    procedure PeriodicProcess(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");

        if AddOnSetup."Desactivate Stock Value Mgt" then exit;

        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts


        BesoinNo :=0;
        Window.Open(Text010);


        //Purger les écritures
        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Cargo Adjusted",Reversed,"Posting Date");
        CargoEntry.SetFilter(CargoEntry.Source,'%1|%2',CargoEntry.Source::" ",CargoEntry.Source::EcartJIRAMA);
        CargoEntry.SetRange(CargoEntry."Cargo Adjusted",false);
        CargoEntry.SetRange(CargoEntry.Reversed,false);
        CargoEntry.SetRange(CargoEntry."Posting Date",DateDeb,DateFin);

        NbreTotalLignes := CargoEntry.Count;
        while CargoEntry.FindFirst do begin

          BesoinNo := BesoinNo + 1;
          Window.Update(1,Round(BesoinNo / NbreTotalLignes * 10000,1));
          Window.Update(2,TxtSuppr);

          //IF NOT CargoEntry."Cargo Adjusted" THEN
            CargoEntry.Delete;
        end;





        //Restaurer les valeurs pour les ventes anticipées et sorties OD
        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Cargo Adjusted",Reversed,"Posting Date");
        CargoEntry.SetFilter(CargoEntry.Source,'%1|%2',CargoEntry.Source::OD,CargoEntry.Source::Anticipated);
        CargoEntry.SetRange(CargoEntry."Cargo Adjusted",false);
        CargoEntry.SetRange(CargoEntry.Reversed,false);
        CargoEntry.SetRange(CargoEntry."Posting Date",DateDeb,DateFin);
        if CargoEntry.FindSet then repeat

          if CargoEntry.Source=CargoEntry.Source::Anticipated then
            if CargoEntry."Entry Type"=CargoEntry."Entry Type"::Sale then begin
              CargoEntry.Quantity := CargoEntry."Initial Qty";
              CargoEntry.Modify;
            end;

          if CargoEntry.Source=CargoEntry.Source::OD then
            if CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Negative Adjmt." then begin  //***
              CargoEntry.Quantity := CargoEntry."Initial Qty";
              CargoEntry.Modify;
            end;

        until CargoEntry.Next=0;




        if ContenuCargo.FindSet then
          repeat
            ContenuCargo."Cost Updated":=false;
            ContenuCargo.Modify;
          until ContenuCargo.Next=0;




        BesoinNo := 0;



        CargoItemsLength:=0;
        Item1.Reset;
        Item1.SetRange("Cargo Mgt",true);
        if Item1.FindSet then repeat

          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";

        until Item1.Next=0;



        //Traitement


        //ENTREES****************************
        //Autres Operations
        TraiterCanalVenteVide(DateDeb,DateFin,true);//Entrees

        //Op sur canal de vente
        SalesChannel.Reset;
        SalesChannel.SetCurrentKey("Cargo Priority");
        if SalesChannel.FindSet then repeat
          TraiterCanalVente(SalesChannel.Code,DateDeb,DateFin,true,SalesChannel.Description);//Entrees
        until SalesChannel.Next=0;
        //************************************


        //SORTIES*****************************
        SalesChannel.Reset;
        SalesChannel.SetCurrentKey("Cargo Priority");
        if SalesChannel.FindSet then repeat
          TraiterCanalVente(SalesChannel.Code,DateDeb,DateFin,false,SalesChannel.Description);//Sorties
          TraiterSortiesOD(DateDeb,DateFin,SalesChannel.Code);
        until SalesChannel.Next=0;

        //Traiter les sorties de stock sans canal de vente
        TraiterCanalVenteVide(DateDeb,DateFin,false);//Sorties

        //Traiter les sorties OD sans canal de vente
        TraiterSortiesOD(DateDeb,DateFin,'');
        //*************************************




        //Maj des cout des contenu cargo non a jour
        if ContenuCargo.FindSet then
          repeat
            getActualCost(ContenuCargo);
          until ContenuCargo.Next=0;


        Window.Close;
    end;

    local procedure TraiterCanalVente(CodeCanalDeVente: Code[10];DateDeb: Date;DateFin: Date;IsEntree: Boolean;NomCanalVente: Text[50])
    var
        CargoEntry: Record "Item Cargo Entry";
        Cargo: Record Cargo;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        Window: Dialog;
        NbreTotalLignes: Integer;
        BesoinNo: Integer;
        ItemCargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        
        //Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output
        
        BesoinNo :=0;
        Window.Open(Text010);
        
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey(Positive,"Sales Channel Code","Posting Date");
        ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive,IsEntree);
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Sales Channel Code",CodeCanalDeVente);
        ItemLedgerEntry.SetRange("Posting Date",DateDeb,DateFin);
        //ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item Category Code",AddOnSetup."PBL Category Code");
        if ItemLedgerEntry.FindSet then begin
          NbreTotalLignes := ItemLedgerEntry.Count;
        repeat
        
        
          BesoinNo := BesoinNo + 1;
          Window.Update(1,
          Round(BesoinNo / NbreTotalLignes * 10000,1));
          if IsEntree then
            Window.Update(2,StrSubstNo(TxtCanal,NomCanalVente,TxtEntrees))
          else
            Window.Update(2,StrSubstNo(TxtCanal,NomCanalVente,TxtSorties));
        
          if not ItemLedgerEntry."Cargo Adjusted" then
            ProcessLigneDifferee(ItemLedgerEntry);
        
        until ItemLedgerEntry.Next=0;
        end;
        
        /*
        IF ((IsEntree=FALSE) AND (CodeCanalDeVente=AddOnSetup."JIRAMA Sales Channel")) THEN
          ProcessQtyConfirmeeJIRAMA(DateDeb,DateFin);
        */

    end;

    local procedure TraiterCanalVenteVide(DateDeb: Date;DateFin: Date;IsEntree: Boolean)
    var
        CargoEntry: Record "Item Cargo Entry";
        Cargo: Record Cargo;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        Window: Dialog;
        NbreTotalLignes: Integer;
        BesoinNo: Integer;
        ItemCargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin

        //Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output

        BesoinNo :=0;
        Window.Open(Text010);

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey(Positive,"Sales Channel Code","Posting Date");
        ItemLedgerEntry.SetRange(ItemLedgerEntry.Positive,IsEntree);
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Sales Channel Code",'');
        ItemLedgerEntry.SetRange("Posting Date",DateDeb,DateFin);
        //ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item Category Code",AddOnSetup."PBL Category Code");

        if ItemLedgerEntry.FindSet then begin
          NbreTotalLignes := ItemLedgerEntry.Count;
        repeat


          BesoinNo := BesoinNo + 1;
          Window.Update(1,
          Round(BesoinNo / NbreTotalLignes * 10000,1));
          if IsEntree then
            Window.Update(2,StrSubstNo(TxtCanal,'',TxtEntrees))
          else
            Window.Update(2,StrSubstNo(TxtCanal,'',TxtSorties));

          if not ItemLedgerEntry."Cargo Adjusted" then
            ProcessLigneDifferee(ItemLedgerEntry);

        until ItemLedgerEntry.Next=0;
        end;
    end;

    local procedure TraiterSortiesOD(DateDeb: Date;DateFin: Date;CodeCanalVente: Code[20])
    var
        CargoEntry: Record "Item Cargo Entry";
    begin
        
        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Sales Channel Code","Posting Date");
        CargoEntry.SetFilter(CargoEntry.Source,'%1|%2',CargoEntry.Source::OD,CargoEntry.Source::Anticipated);
        CargoEntry.SetRange(CargoEntry."Sales Channel Code",CodeCanalVente);
        CargoEntry.SetRange(CargoEntry."Posting Date",DateDeb,DateFin);
        
        if CargoEntry.FindSet then
          //NbreTotalLignes := CargoEntry.COUNT;
          repeat
        
            /*UpdateUnitCost := TRUE;
            BesoinNo := BesoinNo + 1;
            Window.UPDATE(1,
            ROUND(BesoinNo / NbreTotalLignes * 10000,1));*/
        
          if ((CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Negative Adjmt.") or
              (CargoEntry."Entry Type"=CargoEntry."Entry Type"::Sale)) then
            if (not CargoEntry.Reversed) then
              if not CargoEntry."Cargo Adjusted" then
                ProcessSales_OD(CargoEntry);
        
        
            /*Cargo.GET(CargoEntry."Ref Cargo");
        
            //Mettre à jour le cout du cargo
            IF CargoEntry.Positive THEN
              IF UpdateUnitCost THEN
                UpdateUnitCostCargoEntry(CargoEntry);
        
            CargoEntry.MODIFY;*/
        
          until CargoEntry.Next=0;

    end;

    local procedure ProcessLigneDifferee(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        ItemCargoEntry: Record "Item Cargo Entry";
    begin

        if not IsCargoMgt(ItemLedgerEntry."Item No.") then exit;


        if ItemLedgerEntry."Entry Type"=ItemLedgerEntry."Entry Type"::Purchase then begin
          if ItemLedgerEntry."Ref Cargo"<>'' then
            ProcessPurchaseReceipt(ItemLedgerEntry)//Reception achat ou facture
          else begin
            if ItemLedgerEntry."Source No."=AddOnSetup."JOVENNA Vendor Code" then
              ProcessRetourAchatJOVENNA(ItemLedgerEntry)
            else
              ProcessNegAdj(ItemLedgerEntry);//Retour ou avoir
          end;
        end;


        //Mettre à jour la ref cargo, vente normale
        if ItemLedgerEntry."Entry Type"=ItemLedgerEntry."Entry Type"::Sale then begin
          if ItemLedgerEntry."Sales Channel Code" = AddOnSetup."JOVENNA Sales Channel" then//vente normale Jovenna (cargo JOVREGUL)
            ProcessSalesJOVENNA(ItemLedgerEntry)
          else
            ProcessSales(ItemLedgerEntry);
        end;


        if ItemLedgerEntry."Entry Type"=ItemLedgerEntry."Entry Type"::"Negative Adjmt." then begin
          if IsTransfertBE(ItemLedgerEntry."Adjustment Type") then begin
            ProcessConfrereTransfert(ItemLedgerEntry,CargoEnlevement,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
          end;

          if IsOpConfrere(ItemLedgerEntry."Adjustment Type") then begin
            ProcessConfrereTransfert(ItemLedgerEntry,CargoConfrere,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
          end;

          if not IsTransfertBE(ItemLedgerEntry."Adjustment Type") then
            if not IsOpConfrere(ItemLedgerEntry."Adjustment Type") then
              ProcessNegAdj(ItemLedgerEntry);
        end;



        if ItemLedgerEntry."Entry Type"=ItemLedgerEntry."Entry Type"::"Positive Adjmt." then begin
          if IsTransfertBE(ItemLedgerEntry."Adjustment Type") then begin
            ProcessConfrereTransfert(ItemLedgerEntry,CargoEnlevement,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
          end;

          if IsOpConfrere(ItemLedgerEntry."Adjustment Type") then begin
            ProcessConfrereTransfert(ItemLedgerEntry,CargoConfrere,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
          end;

          if not IsTransfertBE(ItemLedgerEntry."Adjustment Type") then
            if not IsOpConfrere(ItemLedgerEntry."Adjustment Type") then
              ProcessPositiveAdj(ItemLedgerEntry);
        end;


        if ItemLedgerEntry."Entry Type"=ItemLedgerEntry."Entry Type"::Transfer then begin
          ProcessConfrereTransfert(ItemLedgerEntry,CargoTransfert,ItemCargoEntry."Entry Type"::Transfer);
        end;
    end;

    procedure FillCargoEntries(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        Item1: Record Item;
    begin
        
        AddOnSetup.Get;
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        //CargoConfrere := GetCargoCONFRERE();
        AddOnSetup.TestField(AddOnSetup."PBL Category Code");
        
        Item1.Get(ItemLedgEntry."Item No.");
        
        
        if not Item1."Cargo Mgt" then exit;
        
        case ItemLedgEntry."Entry Type" of
        
          ItemLedgEntry."Entry Type"::Purchase:begin
            //ProcessPurchaseReceipt(ItemLedgEntry);
          end;
        
          //ItemLedgEntry."Entry Type"::Sale:BEGIN
          //  ProcessSales(ItemLedgEntry);
          //END;
        
          /*
          ItemLedgEntry."Entry Type"::"Positive Adjmt.":BEGIN
        
            IF ItemLedgEntry."Adjustment Type"=ItemLedgEntry."Adjustment Type"::" " THEN
              ProcessPositiveAdj(ItemLedgEntry);
        
            //Ajustements transferts
            IF ItemLedgEntry."Adjustment Type"=ItemLedgEntry."Adjustment Type"::Transfer THEN
              ProcessPositiveAdj(ItemLedgEntry);
        
            //Ajustements BE
            IF ItemLedgEntry."Adjustment Type"=ItemLedgEntry."Adjustment Type"::AdjBE THEN
              ProcessPositiveAdj(ItemLedgEntry);
          END;
        
          ItemLedgEntry."Entry Type"::"Negative Adjmt.":BEGIN
            IF ItemLedgEntry."Ref Cargo"<>'' THEN
              ProcessNegAdj(ItemLedgEntry);
          END;
          */
        
        end;

    end;

    procedure ProcessPurchaseReceipt(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        ItemCargoEntry: Record "Item Cargo Entry";
        ICE: Record "Item Cargo Entry";
        RefCargo: Code[20];
        Cargo: Record Cargo;
        TotalCost: Decimal;
        ContenuCargo: Record "Contenu Cargo";
    begin
        
        AddOnSetup.Get;
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        //Cas des retours achats non affectés ?
        if ItemLedgEntry."Ref Cargo"='' then begin
          if ((ItemLedgEntry."Document Type"=ItemLedgEntry."Document Type"::"Purchase Receipt")
            and (ItemLedgEntry."Document No."<>'')) then begin
            ICE.Reset;
            ICE.SetCurrentKey("Document Type","Document No.");
            ICE.SetRange("Document Type",ICE."Document Type"::"Purchase Receipt");
            ICE.SetRange("Document No.",ItemLedgEntry."Document No.");
            if ICE.FindFirst then
              RefCargo := ICE."Ref Cargo";
            if RefCargo='' then Error(Text003);
          end;
          //ItemLedgEntry.TESTFIELD("Ref Cargo");
          if RefCargo='' then RefCargo := ItemLedgEntry."Ref Cargo";
          if RefCargo='' then Error(Text003);
        end else begin
          RefCargo := ItemLedgEntry."Ref Cargo";
        end;
        
        //Achats reels JOV 070917
        if ItemLedgEntry."Source No."=AddOnSetup."JOVENNA Vendor Code" then
          RefCargo:=AddOnSetup."JOVENNA Regul Cargo";
        
        
        NextEntryNo := getNextCargoEntryNo();
        
        ItemCargoEntry.Init;
        ItemCargoEntry."Entry No." := NextEntryNo;
        ItemCargoEntry."Item No." := ItemLedgEntry."Item No.";
        ItemCargoEntry.Description := ItemLedgEntry.Description;
        ItemCargoEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemCargoEntry."Dimension Set ID" := ItemLedgEntry."Dimension Set ID";
        ItemCargoEntry."Posting Date" := ItemLedgEntry."Posting Date";
        ItemCargoEntry.Quantity := ItemLedgEntry.Quantity;
        ItemCargoEntry."Document No." := ItemLedgEntry."Document No.";
        ItemCargoEntry."Document Type" := ItemLedgEntry."Document Type";
        ItemCargoEntry."Customer No." := ItemLedgEntry."Source No.";
        /*
        ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)",ItemLedgEntry."Cost Amount (Expected)");
        TotalCost := ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
        ItemCargoEntry."Unit Cost" := ROUND(TotalCost/ItemCargoEntry.Quantity,0.00001);
        ItemCargoEntry."Cost Amount" := TotalCost;
        */
        ItemCargoEntry."Ref Cargo" := RefCargo;
        ItemCargoEntry.Description := ItemLedgEntry.Description;
        ItemCargoEntry."Entry Type" := ItemCargoEntry."Entry Type"::Purchase;
        ItemCargoEntry."Adjustment Type" := ItemLedgEntry."Adjustment Type";
        ItemCargoEntry.Positive := true;
        
        ItemCargoEntry."System Entry" := true;//****************************
        
        if Cargo.Get(RefCargo) then
          ItemCargoEntry."Cargo Type" := Cargo."Cargo Type";
        ItemCargoEntry.Positive := true;
        ItemCargoEntry."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry."User ID" := UserId;
        
        UpdateUnitCostCargoEntry(ItemCargoEntry);
        
        ItemCargoEntry.Insert;
        
        GetOrInsertContenuCargo(RefCargo,ItemLedgEntry."Item No.",ContenuCargo);

    end;

    procedure ProcessConfrereTransfert(var ItemLedgEntry: Record "Item Ledger Entry";RefCargo: Code[20];EntryType: Integer)
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
    begin
        AddOnSetup.Get;
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;


        NextEntryNo := getNextCargoEntryNo();
        InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo ,RefCargo,EntryType);
    end;

    procedure ProcessSales(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cust: Record Customer;
        IsJIRAMA: Boolean;
        AvailableCargo_JIR1: Code[20];
        AvailableCargo_JIR2: Code[20];
        QteArticleASortir_JIR1: Decimal;
        QteArticleASortir_JIR2: Decimal;
        PourcentCargoNormal: Decimal;
    begin
        
        AddOnSetup.Get;
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        QteArticleASortir := Abs(ItemLedgEntry.Quantity);
        
        
        NextEntryNo := getNextCargoEntryNo();
        
        
        
        
        
        
        
        //Vente FICTIVE
        /*
        IF (ItemLedgEntry."Type Ecr Cargo" = ItemLedgEntry."Type Ecr Cargo"::Fictive) THEN BEGIN
        
          AvailableCargo := getAvailableCargoWithQtyFictif(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
          IF AvailableCargo<>'' THEN BEGIN
            REPEAT
              InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo := getAvailableCargoWithQtyFictif(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
            UNTIL (AvailableCargo='') OR (QteArticleASortir<=0);
          END;
        
          IF QteArticleASortir>0 THEN
            ERROR(Text013,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date");
        
          EXIT;
        END;
        */
        
        
        
        
        
        
        
        //Vente JIRAMA
        IsJIRAMA := false;
        if (ItemLedgEntry."Source No."<>'') then
          if Cust.Get(ItemLedgEntry."Source No.") then
            IsJIRAMA := (Cust."Sales Channel Code"=AddOnSetup."JIRAMA Sales Channel");
        if(IsJIRAMA) then begin
        
          AddOnSetup.TestField("Jirama Affectation Cargo %");
          PourcentCargoNormal := AddOnSetup."Jirama Affectation Cargo %"/100;//061217
        
          //50% Normal ********
          QteArticleASortir_JIR1 := Abs(ItemLedgEntry.Quantity) * PourcentCargoNormal;//061217
        
          AvailableCargo_JIR1 := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
          if AvailableCargo_JIR1<>'' then begin
            repeat
              InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir_JIR1,AvailableCargo_JIR1,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo_JIR1 := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
            until (AvailableCargo_JIR1='') or (QteArticleASortir_JIR1<=0);
          end;
        
          if QteArticleASortir_JIR1>0 then begin
            AvailableCargo_JIR1 := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
            if AvailableCargo_JIR1<>'' then begin
              repeat
                InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir_JIR1,AvailableCargo_JIR1,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR1 := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
              until (AvailableCargo_JIR1='') or (QteArticleASortir_JIR1<=0);
            end;
          end;
        
          if QteArticleASortir_JIR1>0 then begin
            AvailableCargo_JIR1 := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
            if AvailableCargo_JIR1<>'' then begin
              repeat
                InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir_JIR1,AvailableCargo_JIR1,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR1 := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
              until (AvailableCargo_JIR1='') or (QteArticleASortir_JIR1<=0);
            end;
          end;
        
          if QteArticleASortir_JIR1>0 then
            Error(Text012,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date");
          //50% Normal ********
        
        
        
          //50% JOVENNA *******
          QteArticleASortir_JIR2 := Abs(ItemLedgEntry.Quantity) * (1-PourcentCargoNormal);//061217
        
          if QteArticleASortir_JIR2>0 then begin
            AvailableCargo_JIR2 := getAvailableCargoWithQtyJOVENNA(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
            if AvailableCargo_JIR2<>'' then begin
              repeat
                InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir_JIR2,AvailableCargo_JIR2,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR2 := getAvailableCargoWithQtyJOVENNA(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
              until (AvailableCargo_JIR2='') or (QteArticleASortir_JIR2<=0);
            end;
          end;
        
          if QteArticleASortir_JIR2>0 then begin
            AvailableCargo_JIR2 := getAvailableCargoWithQtyJOVENNA(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
            if AvailableCargo_JIR2<>'' then begin
              repeat
                InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir_JIR2,AvailableCargo_JIR2,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR2 := getAvailableCargoWithQtyJOVENNA(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
              until (AvailableCargo_JIR2='') or (QteArticleASortir_JIR2<=0);
            end;
          end;
        
        
          if QteArticleASortir_JIR2>0 then begin
            AvailableCargo_JIR2 := getAvailableCargoWithQtyJOVENNA(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
            if AvailableCargo_JIR2<>'' then begin
              repeat
                InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir_JIR2,AvailableCargo_JIR2,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR2 := getAvailableCargoWithQtyJOVENNA(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
              until (AvailableCargo_JIR2='') or (QteArticleASortir_JIR2<=0);
            end;
          end;
        
        
          if QteArticleASortir_JIR2>0 then
            Error(Text011,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date",TotalConsoJIRAMA,QteArticleASortir_JIR2);
          //50% JOVENNA *******
        
          exit;
        
        end;
        
        
        
        
        
        
        //Vente normale
        AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
        if AvailableCargo<>'' then begin
          repeat
            InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
            AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
          until (AvailableCargo='') or (QteArticleASortir<=0);
        end;
        
        
        if(QteArticleASortir>0) then begin
          AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
          if AvailableCargo<>'' then begin
            repeat
              InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
            until (AvailableCargo='') or (QteArticleASortir<=0);
          end;
        end;
        
        
        if(QteArticleASortir>0) then begin
          AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
          if AvailableCargo<>'' then begin
            repeat
              InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
            until (AvailableCargo='') or (QteArticleASortir<=0);
          end;
        end;
        
        
        if QteArticleASortir>0 then
          Error(Text002,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date");

    end;

    procedure ProcessSales_OD(var CargoEntrySource: Record "Item Cargo Entry")
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cust: Record Customer;
        IsJIRAMA: Boolean;
        AvailableCargo_JIR1: Code[20];
        AvailableCargo_JIR2: Code[20];
        QteArticleASortir_JIR1: Decimal;
        QteArticleASortir_JIR2: Decimal;
        PourcentCargoNormal: Decimal;
    begin

        AddOnSetup.Get;
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;


        QteArticleASortir := Abs(CargoEntrySource.Quantity);

        NextEntryNo := getNextCargoEntryNo();


        //Vente JIRAMA
        IsJIRAMA := false;
        IsJIRAMA := (ItemCargoEntry."Sales Channel Code"=AddOnSetup."JIRAMA Sales Channel");


        if(IsJIRAMA) then begin

          AddOnSetup.TestField("Jirama Affectation Cargo %");
          PourcentCargoNormal := AddOnSetup."Jirama Affectation Cargo %"/100;//061217

          //50% Normal ********
          QteArticleASortir_JIR1 := Abs(CargoEntrySource.Quantity) * PourcentCargoNormal;
          AvailableCargo_JIR1 := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
          if AvailableCargo_JIR1<>'' then begin
            repeat
              InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir_JIR1,AvailableCargo_JIR1,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo_JIR1 := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
            until (AvailableCargo_JIR1='') or (QteArticleASortir_JIR1<=0)  or (CargoEntrySource.Quantity=0);
          end;

          if QteArticleASortir_JIR1>0 then begin
            AvailableCargo_JIR1 := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
            if AvailableCargo_JIR1<>'' then begin
              repeat
                InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir_JIR1,AvailableCargo_JIR1,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR1 := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
              until (AvailableCargo_JIR1='') or (QteArticleASortir_JIR1<=0)  or (CargoEntrySource.Quantity=0);
            end;
          end;

          if QteArticleASortir_JIR1>0 then begin
            AvailableCargo_JIR1 := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
            if AvailableCargo_JIR1<>'' then begin
              repeat
                InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir_JIR1,AvailableCargo_JIR1,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR1 := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
              until (AvailableCargo_JIR1='') or (QteArticleASortir_JIR1<=0)  or (CargoEntrySource.Quantity=0);
            end;
          end;

          if QteArticleASortir_JIR1>0 then
            Error(Text012,ItemCargoEntry."Document No.",ItemCargoEntry."Entry No.",ItemCargoEntry."Posting Date");
          //50% Normal ********



          //50% JOVENNA *******
          QteArticleASortir_JIR2 := Abs(CargoEntrySource.Quantity) * (1-PourcentCargoNormal);
          if QteArticleASortir_JIR2>0 then begin
            AvailableCargo_JIR2 := getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
            if AvailableCargo_JIR2<>'' then begin
              repeat
                InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir_JIR2,AvailableCargo_JIR2,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR2 := getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
              until (AvailableCargo_JIR2='') or (QteArticleASortir_JIR2<=0)  or (CargoEntrySource.Quantity=0);
            end;
          end;

          if QteArticleASortir_JIR2>0 then begin
            AvailableCargo_JIR2 := getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
            if AvailableCargo_JIR2<>'' then begin
              repeat
                InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir_JIR2,AvailableCargo_JIR2,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR2 := getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
              until (AvailableCargo_JIR2='') or (QteArticleASortir_JIR2<=0)  or (CargoEntrySource.Quantity=0);
            end;
          end;


          if QteArticleASortir_JIR2>0 then begin
            AvailableCargo_JIR2 := getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
            if AvailableCargo_JIR2<>'' then begin
              repeat
                InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir_JIR2,AvailableCargo_JIR2,ItemCargoEntry."Entry Type"::Sale);
                AvailableCargo_JIR2 := getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
              until (AvailableCargo_JIR2='') or (QteArticleASortir_JIR2<=0)  or (CargoEntrySource.Quantity=0);
            end;
          end;


          if QteArticleASortir_JIR2>0 then
            Error(Text011,CargoEntrySource."Document No.",CargoEntrySource."Entry No.",CargoEntrySource."Posting Date",TotalConsoJIRAMA,QteArticleASortir_JIR2);
          //50% JOVENNA *******

          exit;

        end;


        AvailableCargo := CargoEntrySource."Ref Cargo";
        if AvailableCargo<>'' then begin
          UpdateUnitCostCargoEntry(CargoEntrySource);
          //Tester que la cargaison ne passe pas en négatif
          exit;
        end;


        //Vente normale
        AvailableCargo := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
        if AvailableCargo<>'' then begin
          repeat
            InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
            AvailableCargo := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,1,RemainingQty);
          until (AvailableCargo='') or (QteArticleASortir<=0)  or (CargoEntrySource.Quantity=0);
        end;


        if(QteArticleASortir>0) then begin
          AvailableCargo := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
          if AvailableCargo<>'' then begin
            repeat
              InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,2,RemainingQty);
            until (AvailableCargo='') or (QteArticleASortir<=0)  or (CargoEntrySource.Quantity=0);
          end;
        end;


        if(QteArticleASortir>0) then begin
          AvailableCargo := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
          if AvailableCargo<>'' then begin
            repeat
              InsertCargoEntrySales_OD(CargoEntrySource,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::Sale);
              AvailableCargo := getAvailableCargoWithQty_OD(CargoEntrySource,CargoAlloc."Operation Type"::Sale,3,RemainingQty);
            until (AvailableCargo='') or (QteArticleASortir<=0)  or (CargoEntrySource.Quantity=0);
          end;
        end;


        if QteArticleASortir>0 then
          Error(Text021,CargoEntrySource."Document No.",CargoEntrySource."Entry No.",CargoEntrySource."Posting Date");
    end;

    procedure ProcessSalesJOVENNA(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cust: Record Customer;
        IsJIRAMA: Boolean;
        AvailableCargo_JIR1: Code[20];
        AvailableCargo_JIR2: Code[20];
        QteArticleASortir_JIR1: Decimal;
        QteArticleASortir_JIR2: Decimal;
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");

        //Vente normale JOVENNA, utiliser le cargo REGUL
        QteArticleASortir := Abs(ItemLedgEntry.Quantity);

        NextEntryNo := getNextCargoEntryNo();

        InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,QteArticleASortir,
          QteArticleASortir,AddOnSetup."JOVENNA Regul Cargo",ItemCargoEntry."Entry Type"::Sale);
    end;

    procedure ProcessRetourAchatJOVENNA(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cust: Record Customer;
        IsJIRAMA: Boolean;
        AvailableCargo_JIR1: Code[20];
        AvailableCargo_JIR2: Code[20];
        QteArticleASortir_JIR1: Decimal;
        QteArticleASortir_JIR2: Decimal;
    begin
        //Achats reels JOV 070917

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");

        //Retour Achat normale JOVENNA
        QteArticleASortir := Abs(ItemLedgEntry.Quantity);

        NextEntryNo := getNextCargoEntryNo();

        InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,QteArticleASortir,
          QteArticleASortir,AddOnSetup."JOVENNA Regul Cargo",ItemCargoEntry."Entry Type"::Purchase);
    end;

    procedure ProcessPositiveAdj(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
    begin
        
        
        NextEntryNo := getNextCargoEntryNo();
        
        
        //Activités CONFRERE
        if IsOpConfrere(ItemLedgEntry."Adjustment Type")  then
          AvailableCargo := GetCargoCONFRERE();
        if AvailableCargo<>'' then begin
            InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo ,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
            exit;
        end;
        
        
        
        // IF ((ItemLedgEntry."Adjustment Type"=ItemLedgEntry."Adjustment Type"::AdjBE) OR
        //   (ItemLedgEntry."Adjustment Type"=ItemLedgEntry."Adjustment Type"::Transfer)) THEN
        //   AvailableCargo := GetCargoAjustement();
        // IF AvailableCargo<>'' THEN BEGIN
        //     InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo ,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
        //     EXIT;
        // END;
        
        /*
        IF ((ItemLedgEntry."Adjustment Type"=ItemLedgEntry."Adjustment Type"::Transfer)) THEN
          AvailableCargo := GetCargoAjustement();
        IF AvailableCargo<>'' THEN BEGIN
            InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo ,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
            EXIT;
        END;
        */
        
        
        
        //Ajout 20042016 ajustement sur feuille
        /*
        AvailableCargo := ItemLedgEntry."Ref Cargo";
        IF AvailableCargo<>'' THEN BEGIN
            InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo ,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
            EXIT;
        END;
        */
        
        
        
        
        
        AvailableCargo := getAvailableCargoAdjPos(ItemLedgEntry,CargoAlloc."Operation Type"::"Positive Adjmt.",1,RemainingQty);
        if AvailableCargo<>'' then begin
            InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo ,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
            exit;
        end;
        
        
        if AvailableCargo<>'' then begin
          AvailableCargo := getAvailableCargoAdjPos(ItemLedgEntry,CargoAlloc."Operation Type"::"Positive Adjmt.",2,RemainingQty);
          if AvailableCargo<>'' then begin
            InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
            exit;
          end;
        end;
        
        
        if AvailableCargo<>'' then begin
          AvailableCargo := getAvailableCargoAdjPos(ItemLedgEntry,CargoAlloc."Operation Type"::"Positive Adjmt.",3,RemainingQty);
          if AvailableCargo<>'' then begin
            InsertCargoEntryPosAdj(ItemLedgEntry,NextEntryNo,AvailableCargo,ItemCargoEntry."Entry Type"::"Positive Adjmt.");
            exit;
          end;
        end;
        
        
        if AvailableCargo='' then
          Error(Text002,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date");

    end;

    procedure ProcessNegAdj(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        NextEntryNo: Integer;
        AvailableCargo: Code[20];
        CargoAlloc: Record "Cargo Allocation Config";
        RemainingQty: Decimal;
        QteArticleASortir: Decimal;
        ItemCargoEntry: Record "Item Cargo Entry";
    begin
        
        
        QteArticleASortir := Abs(ItemLedgEntry.Quantity);
        
        
        NextEntryNo := getNextCargoEntryNo();
        
        
        
        //Activités CONFRERE
        if IsOpConfrere(ItemLedgEntry."Adjustment Type")  then
          AvailableCargo := GetCargoCONFRERE();
        if AvailableCargo<>'' then begin
          repeat
            InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,QteArticleASortir,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
            //AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",1,RemainingQty);
          until (AvailableCargo='') or (QteArticleASortir<=0);
        end;
        
        
        //Activités Ajustement
        /*
        IF IsOpConfrere(ItemLedgEntry."Adjustment Type")  THEN
          AvailableCargo := GetCargoAjustement();
        IF AvailableCargo<>'' THEN BEGIN
          REPEAT
            InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,QteArticleASortir,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
            //AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",1,RemainingQty);
          UNTIL (AvailableCargo='') OR (QteArticleASortir<=0);
        END;
        */
        
        
        
        
        AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",1,RemainingQty);
        if AvailableCargo<>'' then begin
          repeat
            InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
            AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",1,RemainingQty);
          until (AvailableCargo='') or (QteArticleASortir<=0);
        end;
        
        
        if(QteArticleASortir>0) then begin
          AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",2,RemainingQty);
          if AvailableCargo<>'' then begin
            repeat
              InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
              AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",2,RemainingQty);
            until (AvailableCargo='') or (QteArticleASortir<=0);
          end;
        end;
        
        
        if(QteArticleASortir>0) then begin
          AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",3,RemainingQty);
          if AvailableCargo<>'' then begin
            repeat
              InsertCargoEntrySales(ItemLedgEntry,NextEntryNo,RemainingQty,QteArticleASortir,AvailableCargo,ItemCargoEntry."Entry Type"::"Negative Adjmt.");
              AvailableCargo := getAvailableCargoWithQty(ItemLedgEntry,CargoAlloc."Operation Type"::"Negative Adjmt.",3,RemainingQty);
            until (AvailableCargo='') or (QteArticleASortir<=0);
          end;
        end;
        
        
        if QteArticleASortir>0 then
          Error(Text002,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date");

    end;

    local procedure ProcessQtyConfirmeeJIRAMA(DateDeb: Date;DateFin: Date)
    var
        JiramaForeCast: Record "Jirama Sales Forecast";
        JiramaForeCastLine: Record "Jirama Sales Forecast Line";
        ItemLedgEntry1: Record "Item Ledger Entry";
        JiramaProcess: Codeunit "JIRAMA Sales Mgt";
        ItemCargoEntry: Record "Item Cargo Entry";
    begin

        AddOnSetup.Get;





        JiramaForeCast.Reset;
        JiramaForeCast.SetRange(JiramaForeCast."Cargo Date",DateDeb,DateFin);
        JiramaForeCast.SetRange(JiramaForeCast.Status,JiramaForeCast.Status::Validated);
        if JiramaForeCast.FindSet then repeat

          JiramaForeCast.TestField(JiramaForeCast."Cargo Date");
          JiramaProcess.RefreshValuesForecast(JiramaForeCast);

          JiramaForeCastLine.Reset;
          JiramaForeCastLine.SetRange(JiramaForeCastLine."Document No.",JiramaForeCast."No.");
          if JiramaForeCastLine.FindSet then repeat
             if JiramaForeCastLine."Comfirmed Quantity" > JiramaForeCastLine."Total Enleve" then begin
               CreateItemEntryJIRMAForecast(JiramaForeCast,JiramaForeCastLine,ItemLedgEntry1);
               ProcessSales(ItemLedgEntry1);
            end;
          until JiramaForeCastLine.Next=0;

        until JiramaForeCast.Next=0;
    end;

    local procedure CreateItemEntryJIRMAForecast(JiramaForecast: Record "Jirama Sales Forecast";JiramaForecastLine: Record "Jirama Sales Forecast Line";var ItemLedgEntry1: Record "Item Ledger Entry")
    var
        Cust: Record Customer;
    begin

        ItemLedgEntry1.Init;
        ItemLedgEntry1."Entry No." := 0;
        ItemLedgEntry1."Entry Type" := ItemLedgEntry1."Entry Type"::Sale;
        ItemLedgEntry1.Quantity := -(JiramaForecastLine."Comfirmed Quantity" - JiramaForecastLine."Total Enleve");
        JiramaForecastLine.TestField("Sell-to Customer No.");
        ItemLedgEntry1."Source No." := JiramaForecastLine."Sell-to Customer No.";
        ItemLedgEntry1."Item No." := AddOnSetup."JIRAMA Item No.";
        Cust.Get(JiramaForecastLine."Sell-to Customer No.");
        ItemLedgEntry1.Description := StrSubstNo(Text015,Cust.Name);
        CreateDim(ItemLedgEntry1,
          DATABASE::Item,AddOnSetup."JIRAMA Item No.",
            DATABASE::Customer,Cust."No.",
            DATABASE::"Work Center",'');
        ItemLedgEntry1."Document No." := JiramaForecast."No.";
        ItemLedgEntry1."Posting Date" := FinMois(JiramaForecast."Cargo Date");
        ItemLedgEntry1."Document Date" := ItemLedgEntry1."Posting Date";
        ItemLedgEntry1."Document Type" := ItemLedgEntry1."Document Type"::" ";
        ItemLedgEntry1."External Document No." := Text017;
    end;

    local procedure getAllocationMethod(ItemLedgEntry: Record "Item Ledger Entry";typeOp: Integer;Priority: Integer): Integer
    var
        CargoAlloc: Record "Cargo Allocation Config";
        Cust: Record Customer;
        CanalDeVente: Code[20];
    begin


        if Cust.Get(ItemLedgEntry."Source No.") then begin
          Cust.TestField(Cust."Sales Channel Code");
          CanalDeVente := Cust."Sales Channel Code";
        end;


        CargoAlloc.Reset;
        CargoAlloc.SetRange(CargoAlloc."Operation Type",typeOp);
        CargoAlloc.SetRange(CargoAlloc."Sales Channel Code",CanalDeVente);
        CargoAlloc.SetRange(CargoAlloc."Item Code",ItemLedgEntry."Item No.");
        if CargoAlloc.FindFirst then begin
          if Priority=1 then exit (CargoAlloc."First Priority");
          if Priority=2 then exit (CargoAlloc."Second Priority");
          if Priority=3 then exit (CargoAlloc."Third Priority");
        end;


        CargoAlloc.Reset;
        CargoAlloc.SetRange(CargoAlloc."Operation Type",typeOp);
        CargoAlloc.SetRange(CargoAlloc."Sales Channel Code",'');
        CargoAlloc.SetRange(CargoAlloc."Item Code",ItemLedgEntry."Item No.");
        if CargoAlloc.FindFirst then begin
          if Priority=1 then exit (CargoAlloc."First Priority");
          if Priority=2 then exit (CargoAlloc."Second Priority");
          if Priority=3 then exit (CargoAlloc."Third Priority");
        end;



        CargoAlloc.Reset;
        CargoAlloc.SetRange(CargoAlloc."Operation Type",typeOp);
        CargoAlloc.SetRange(CargoAlloc."Sales Channel Code",CanalDeVente);
        CargoAlloc.SetRange(CargoAlloc."Item Code",'');
        if CargoAlloc.FindFirst then begin
          if Priority=1 then exit (CargoAlloc."First Priority");
          if Priority=2 then exit (CargoAlloc."Second Priority");
          if Priority=3 then exit (CargoAlloc."Third Priority");
        end;



        CargoAlloc.Reset;
        CargoAlloc.SetRange(CargoAlloc."Operation Type",typeOp);
        CargoAlloc.SetRange(CargoAlloc."Sales Channel Code",'');
        CargoAlloc.SetRange(CargoAlloc."Item Code",'');
        if CargoAlloc.FindFirst then begin
          if Priority=1 then exit (CargoAlloc."First Priority");
          if Priority=2 then exit (CargoAlloc."Second Priority");
          if Priority=3 then exit (CargoAlloc."Third Priority");
        end;


        Error(Text001,ItemLedgEntry."Document No.",ItemLedgEntry."Entry No.",ItemLedgEntry."Posting Date",CanalDeVente);
    end;

    local procedure getAllocationMethod_OD(ItemCargoEntry: Record "Item Cargo Entry";Priority: Integer): Integer
    var
        CargoAlloc: Record "Cargo Allocation Config";
        Cust: Record Customer;
        CanalDeVente: Code[20];
    begin


        CargoAlloc.Reset;
        CargoAlloc.SetRange(CargoAlloc."Operation Type",CargoAlloc."Operation Type"::Sale);
        CargoAlloc.SetRange(CargoAlloc."Sales Channel Code",ItemCargoEntry."Sales Channel Code");
        CargoAlloc.SetRange(CargoAlloc."Item Code",ItemCargoEntry."Item No.");
        if CargoAlloc.FindFirst then begin
          if Priority=1 then exit (CargoAlloc."First Priority");
          if Priority=2 then exit (CargoAlloc."Second Priority");
          if Priority=3 then exit (CargoAlloc."Third Priority");
        end else begin
          CargoAlloc.Reset;
          CargoAlloc.SetRange(CargoAlloc."Operation Type",CargoAlloc."Operation Type"::Sale);
          CargoAlloc.SetRange(CargoAlloc."Sales Channel Code",ItemCargoEntry."Sales Channel Code");
          CargoAlloc.SetRange(CargoAlloc."Item Code",'');
          if CargoAlloc.FindFirst then begin
            if Priority=1 then exit (CargoAlloc."First Priority");
            if Priority=2 then exit (CargoAlloc."Second Priority");
            if Priority=3 then exit (CargoAlloc."Third Priority");
          end else begin
            Error(Text001,ItemCargoEntry."Document No.",ItemCargoEntry."Entry No.",ItemCargoEntry."Posting Date",ItemCargoEntry."Sales Channel Code");
          end;
        end;
    end;

    local procedure getDatesFiltres(DateOperation: Date;AllocMethod: Integer;var DateDeb: Date;var DateFin: Date;Priority: Integer)
    var
        DateRef: Date;
        CargoAlloc: Record "Cargo Allocation Config";
    begin

        DateRef := DateOperation;

        if Priority=1 then begin
          if AllocMethod=CargoAlloc."First Priority"::M then begin
            DateRef := DateOperation;
          end;

          if AllocMethod=CargoAlloc."First Priority"::"M-1" then begin
            DateRef := CalcDate('<-1M>',DateOperation);
          end;

          if AllocMethod=CargoAlloc."First Priority"::"M-2" then begin
            DateRef := CalcDate('<-2M>',DateOperation);
          end;

          if AllocMethod=CargoAlloc."First Priority"::"M-3" then begin
            DateRef := CalcDate('<-3M>',DateOperation);
          end;

          DateDeb := DebutMois(DateRef);
          DateFin := FinMois(DateRef);

          if AllocMethod=CargoAlloc."First Priority"::None then begin
            DateDeb := 0D;
            DateFin := 0D;
          end;
        end;

        if Priority=2 then begin
          if AllocMethod=CargoAlloc."Second Priority"::M then begin
            DateRef := DateOperation;
          end;

          if AllocMethod=CargoAlloc."Second Priority"::"M-1" then begin
            DateRef := CalcDate('<-1M>',DateOperation);
          end;

          if AllocMethod=CargoAlloc."Second Priority"::"M-2" then begin
            DateRef := CalcDate('<-2M>',DateOperation);
          end;

          if AllocMethod=CargoAlloc."Second Priority"::"M-3" then begin
            DateRef := CalcDate('<-3M>',DateOperation);
          end;

          DateDeb := DebutMois(DateRef);
          DateFin := FinMois(DateRef);

          if AllocMethod=CargoAlloc."Second Priority"::None then begin
            DateDeb := 0D;
            DateFin := 0D;
          end;
        end;

        if Priority=3 then begin
          if AllocMethod=CargoAlloc."Third Priority"::M then begin
            DateRef := DateOperation;
          end;

          if AllocMethod=CargoAlloc."Third Priority"::"M-1" then begin
            DateRef := CalcDate('<-1M>',DateOperation);
          end;

          if AllocMethod=CargoAlloc."Third Priority"::"M-2" then begin
            DateRef := CalcDate('<-2M>',DateOperation);
          end;

          if AllocMethod=CargoAlloc."Third Priority"::"M-3" then begin
            DateRef := CalcDate('<-3M>',DateOperation);
          end;

          DateDeb := DebutMois(DateRef);
          DateFin := FinMois(DateRef);

          if AllocMethod=CargoAlloc."Third Priority"::None then begin
            DateDeb := 0D;
            DateFin := 0D;
          end;
        end;
    end;

    local procedure DebutMois(DateRef: Date): Date
    begin
        exit(DMY2Date(1,Date2DMY(DateRef,2),Date2DMY(DateRef,3)));
    end;

    local procedure FinMois(DateRef: Date): Date
    var
        Date1: Date;
    begin
        Date1 := DebutMois(DateRef);
        exit(CalcDate('<1M>',Date1)-1);
    end;

    local procedure getRemainingQtyCargo(RefCargo: Code[20];ItemNo: Code[20]): Decimal
    var
        Cargo: Record Cargo;
        ContenuCargo1: Record "Contenu Cargo";
        ContenuCargo2: Record "Contenu Cargo";
    begin
        /*Cargo.GET(RefCargo);
        Cargo.SETFILTER(Cargo."Item No. Filter",ItemNo);
        Cargo.CALCFIELDS(Cargo.Quantity);
        EXIT(Cargo.Quantity);*/
        
        if ContenuCargo1.Get(RefCargo,ItemNo) then begin
          ContenuCargo1.CalcFields(Quantity);
          exit(ContenuCargo1.Quantity);
        end else begin
          GetOrInsertContenuCargo(RefCargo,ItemNo,ContenuCargo2);//Ajouter si le contenu n'existe pas
          if ContenuCargo2.Get(RefCargo,ItemNo) then begin
            ContenuCargo2.CalcFields(Quantity);
            exit(ContenuCargo2.Quantity);
          end;
        end;

    end;

    local procedure getAvailableCargoWithQty(ItemLedgEntry: Record "Item Ledger Entry";OperationType: Integer;Priority: Integer;var RemainingQty: Decimal): Code[20]
    var
        QtyRestanteCargo: Decimal;
        QtyTotalArticle: Integer;
        MethodeAlloc1: Integer;
        CargoAlloc: Record "Cargo Allocation Config";
        DateDeb: Date;
        DateFin: Date;
        Cargo1: Record Cargo;
    begin
        
        MethodeAlloc1 := getAllocationMethod(ItemLedgEntry,OperationType,Priority);
        
        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          getDatesFiltres(ItemLedgEntry."Posting Date",MethodeAlloc1,DateDeb,DateFin,Priority);
        
        /*
        ItemCargoEntry.RESET;
        ItemCargoEntry.SETRANGE(ItemCargoEntry.Positive,TRUE);
        IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
          ItemCargoEntry.SETRANGE(ItemCargoEntry."Posting Date",DateDeb,DateFin);
        IF ItemCargoEntry.FINDSET THEN REPEAT
          IF Cargo1.GET(ItemCargoEntry."Ref Cargo") THEN BEGIN
            IF Cargo1."Cargo Type"=Cargo1."Cargo Type"::" " THEN BEGIN
              RemainingQty := getRemainingQtyCargo(ItemCargoEntry."Ref Cargo",ItemLedgEntry."Item No.");
              IF RemainingQty>0 THEN
                EXIT(ItemCargoEntry."Ref Cargo");
            END;
          END;
        UNTIL ItemCargoEntry.NEXT=0;
        */
        
        Cargo1.Reset;
        Cargo1.SetCurrentKey("Cargo Type","Cargo Date");
        Cargo1.SetRange("Cargo Type",Cargo1."Cargo Type"::" ");
        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          Cargo1.SetRange(Cargo1."Cargo Date",DateDeb,DateFin);
        if Cargo1.FindSet then repeat
        
          RemainingQty := getRemainingQtyCargo(Cargo1.Code,ItemLedgEntry."Item No.");
          if RemainingQty>0 then
            exit(Cargo1.Code);
        
        until Cargo1.Next=0;

    end;

    local procedure getAvailableCargoWithQty_OD(CargoEntrySource: Record "Item Cargo Entry";OperationType: Integer;Priority: Integer;var RemainingQty: Decimal): Code[20]
    var
        QtyRestanteCargo: Decimal;
        QtyTotalArticle: Integer;
        MethodeAlloc1: Integer;
        CargoAlloc: Record "Cargo Allocation Config";
        DateDeb: Date;
        DateFin: Date;
        Cargo1: Record Cargo;
    begin

        MethodeAlloc1 := getAllocationMethod_OD(CargoEntrySource,Priority);

        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          getDatesFiltres(CargoEntrySource."Posting Date",MethodeAlloc1,DateDeb,DateFin,Priority);

        Cargo1.Reset;
        Cargo1.SetCurrentKey("Cargo Type","Cargo Date");
        Cargo1.SetRange("Cargo Type",Cargo1."Cargo Type"::" ");
        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          Cargo1.SetRange(Cargo1."Cargo Date",DateDeb,DateFin);
        if Cargo1.FindSet then repeat

          RemainingQty := getRemainingQtyCargo(Cargo1.Code,CargoEntrySource."Item No.");
          if RemainingQty>0 then
            exit(Cargo1.Code);

        until Cargo1.Next=0;
    end;

    local procedure getAvailableCargoWithQty_OD_JOVENNA(CargoEntrySource: Record "Item Cargo Entry";OperationType: Integer;Priority: Integer;var RemainingQty: Decimal): Code[20]
    var
        QtyRestanteCargo: Decimal;
        QtyTotalArticle: Integer;
        MethodeAlloc1: Integer;
        CargoAlloc: Record "Cargo Allocation Config";
        DateDeb: Date;
        DateFin: Date;
        Cargo1: Record Cargo;
    begin

        MethodeAlloc1 := getAllocationMethod_OD(CargoEntrySource,Priority);

        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          getDatesFiltres(CargoEntrySource."Posting Date",MethodeAlloc1,DateDeb,DateFin,Priority);


        Cargo1.Reset;
        Cargo1.SetCurrentKey("Cargo Type","Cargo Date");
        Cargo1.SetRange("Cargo Type",Cargo1."Cargo Type"::JOVENNA);
        Cargo1.SetFilter(Cargo1.Code,'<>%1',AddOnSetup."JOVENNA Regul Cargo");
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
          Cargo1.SetRange(Cargo1."Cargo Date",DateDeb,DateFin);
        if Cargo1.FindSet then repeat

          RemainingQty := getRemainingQtyCargo(Cargo1.Code,CargoEntrySource."Item No.");
          if RemainingQty>0 then
            exit(Cargo1.Code);

        until Cargo1.Next=0;
    end;

    local procedure getAvailableCargoWithQtyFictif(ItemLedgEntry: Record "Item Ledger Entry";OperationType: Integer;Priority: Integer;var RemainingQty: Decimal): Code[20]
    var
        QtyRestanteCargo: Decimal;
        QtyTotalArticle: Integer;
        MethodeAlloc1: Integer;
        CargoAlloc: Record "Cargo Allocation Config";
        DateDeb: Date;
        DateFin: Date;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cargo1: Record Cargo;
    begin
        
        //MethodeAlloc1 := getAllocationMethod(ItemLedgEntry,OperationType,Priority);
        
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
        getDatesFiltres(ItemLedgEntry."Posting Date",CargoAlloc."First Priority"::M,DateDeb,DateFin,Priority);
        
        /*ItemCargoEntry.RESET;
        ItemCargoEntry.SETRANGE(ItemCargoEntry.Positive,TRUE);
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
        ItemCargoEntry.SETRANGE(ItemCargoEntry."Posting Date",DateDeb,DateFin);
        IF ItemCargoEntry.FINDSET THEN REPEAT
          IF Cargo1.GET(ItemCargoEntry."Ref Cargo") THEN BEGIN
            IF Cargo1."Cargo Type"=Cargo1."Cargo Type"::Fictif THEN BEGIN
              RemainingQty := getRemainingQtyCargo(ItemCargoEntry."Ref Cargo",ItemLedgEntry."Item No.");
              IF RemainingQty>0 THEN
                EXIT(ItemCargoEntry."Ref Cargo");
            END;
          END;
        
        UNTIL ItemCargoEntry.NEXT=0;*/
        
        Cargo1.Reset;
        Cargo1.SetCurrentKey("Cargo Type","Cargo Date");
        Cargo1.SetRange("Cargo Type",Cargo1."Cargo Type"::Fictif);
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
          Cargo1.SetRange(Cargo1."Cargo Date",DateDeb,DateFin);
        if Cargo1.FindSet then repeat
        
          RemainingQty := getRemainingQtyCargo(Cargo1.Code,ItemLedgEntry."Item No.");
          if RemainingQty>0 then
            exit(Cargo1.Code);
        
        until Cargo1.Next=0;

    end;

    local procedure getAvailableCargoWithQtyJOVENNA(ItemLedgEntry: Record "Item Ledger Entry";OperationType: Integer;Priority: Integer;var RemainingQty: Decimal): Code[20]
    var
        QtyRestanteCargo: Decimal;
        QtyTotalArticle: Integer;
        MethodeAlloc1: Integer;
        CargoAlloc: Record "Cargo Allocation Config";
        DateDeb: Date;
        DateFin: Date;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cargo1: Record Cargo;
    begin
        
        //MethodeAlloc1 := getAllocationMethod(ItemLedgEntry,OperationType,Priority);
        
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
        getDatesFiltres(ItemLedgEntry."Posting Date",CargoAlloc."First Priority"::M,DateDeb,DateFin,Priority);
        
        /*
        ItemCargoEntry.RESET;
        ItemCargoEntry.SETRANGE(ItemCargoEntry.Positive,TRUE);
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
        ItemCargoEntry.SETRANGE(ItemCargoEntry."Posting Date",DateDeb,DateFin);
        IF ItemCargoEntry.FINDSET THEN REPEAT
          IF Cargo1.GET(ItemCargoEntry."Ref Cargo") THEN BEGIN
            IF Cargo1."Cargo Type"=Cargo1."Cargo Type"::JOVENNA THEN BEGIN
              RemainingQty := getRemainingQtyCargo(ItemCargoEntry."Ref Cargo",ItemLedgEntry."Item No.");
              IF RemainingQty>0 THEN
                EXIT(ItemCargoEntry."Ref Cargo");
            END;
          END;
        UNTIL ItemCargoEntry.NEXT=0;
        */
        
        if AddOnSetup."JOVENNA Regul Cargo"='' then AddOnSetup.Get;
        
        Cargo1.Reset;
        Cargo1.SetCurrentKey("Cargo Type","Cargo Date");
        Cargo1.SetRange("Cargo Type",Cargo1."Cargo Type"::JOVENNA);
        Cargo1.SetFilter(Cargo1.Code,'<>%1',AddOnSetup."JOVENNA Regul Cargo");
        //IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN
          Cargo1.SetRange(Cargo1."Cargo Date",DateDeb,DateFin);
        if Cargo1.FindSet then repeat
        
          RemainingQty := getRemainingQtyCargo(Cargo1.Code,ItemLedgEntry."Item No.");
          if RemainingQty>0 then
            exit(Cargo1.Code);
        
        until Cargo1.Next=0;

    end;

    local procedure getAvailableCargoAdjPos(ItemLedgEntry: Record "Item Ledger Entry";OperationType: Integer;Priority: Integer;var RemainingQty: Decimal) Rep: Code[20]
    var
        QtyRestanteCargo: Decimal;
        QtyTotalArticle: Integer;
        MethodeAlloc1: Integer;
        CargoAlloc: Record "Cargo Allocation Config";
        DateDeb: Date;
        DateFin: Date;
        ItemCargoEntry: Record "Item Cargo Entry";
        Cargo1: Record Cargo;
        CargoEntry: Record "Item Cargo Entry";
        CodeArt: Code[20];
    begin
        //Prendre le cargo le plus ancien ayant un stock non nul
        
        
        MethodeAlloc1 := getAllocationMethod(ItemLedgEntry,OperationType,Priority);
        
        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          getDatesFiltres(ItemLedgEntry."Posting Date",MethodeAlloc1,DateDeb,DateFin,Priority);
        
        Cargo1.Reset;
        Cargo1.SetCurrentKey(Closed,"Cargo Type","Cargo Date");
        Cargo1.SetRange(Cargo1.Closed,false);
        Cargo1.SetRange("Cargo Type",Cargo1."Cargo Type"::" ");
        if MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO then
          Cargo1.SetRange(Cargo1."Cargo Date",DateDeb,DateFin);
        if Cargo1.FindSet then repeat
        
          RemainingQty := getRemainingQtyCargo(Cargo1.Code,ItemLedgEntry."Item No.");
          if RemainingQty>0 then begin
            Rep:=Cargo1.Code;
            exit(Cargo1.Code);
          end;
        
        until Cargo1.Next=0;
        
        
        if Rep='' then begin
          CargoEntry.Reset;
          CargoEntry.SetCurrentKey("Item No.",Reversed);
          CargoEntry.SetRange("Item No.",ItemLedgEntry."Item No.");
          CargoEntry.SetRange(CargoEntry.Reversed,false);
          if CargoEntry.FindLast then
            Rep := CargoEntry."Ref Cargo";
        end;
        
        
        /*
        IF MethodeAlloc1<>CargoAlloc."Third Priority"::FIFO THEN BEGIN
        
          getDatesFiltres(ItemLedgEntry."Posting Date",MethodeAlloc1,DateDeb,DateFin,Priority);
        
          Cargo1.RESET;
          Cargo1.SETCURRENTKEY("Cargo Type","Cargo Date");
          Cargo1.SETRANGE("Cargo Type",Cargo1."Cargo Type"::" ");
          Cargo1.SETRANGE("Cargo Date",DateDeb,DateFin);
          IF Cargo1.FINDFIRST THEN EXIT(Cargo1.Code);
        
        END ELSE BEGIN
        
          //Prendre le cargo le plus ancien ayant un stock non nul
          Cargo1.RESET;
          Cargo1.SETCURRENTKEY("Cargo Type","Cargo Date");
          Cargo1.SETRANGE("Cargo Type",Cargo1."Cargo Type"::" ");
          IF Cargo1.FINDLAST THEN EXIT(Cargo1.Code);
        
        END;
        */

    end;

    local procedure InsertCargoEntrySales(ItemLedgEntry: Record "Item Ledger Entry";var NextEntryNo: Integer;RemainingQtyCargo: Decimal;var QteASortir: Decimal;RefCargo: Code[20];EntryType: Integer)
    var
        ItemCargoEntry: Record "Item Cargo Entry";
        Cust: Record Customer;
        Cargo: Record Cargo;
        ShipInvoiced: Record "Shipment Invoiced";
    begin

        ItemCargoEntry.Init;
        ItemCargoEntry."Entry No." := NextEntryNo;
        ItemCargoEntry."Item No.":= ItemLedgEntry."Item No.";
        ItemCargoEntry.Description := ItemLedgEntry.Description;
        ItemCargoEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemCargoEntry."Dimension Set ID" := ItemLedgEntry."Dimension Set ID";
        ItemCargoEntry."Posting Date" := ItemLedgEntry."Posting Date";
        ItemCargoEntry."Document No." := ItemLedgEntry."Document No.";
        ItemCargoEntry."Document Type" := ItemLedgEntry."Document Type";
        ItemCargoEntry."Customer No." := ItemLedgEntry."Source No.";

        if (ItemLedgEntry.Quantity>0) then begin
          //Avoir et annulation livraisons
          ItemCargoEntry.Quantity := QteASortir;

        end else begin
          if QteASortir>RemainingQtyCargo then
            ItemCargoEntry.Quantity := -RemainingQtyCargo
          else
            ItemCargoEntry.Quantity := -QteASortir;
        end;



        //ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
        //ItemCargoEntry."Unit Cost" := GetUnitCostCargaison(RefCargo); //ROUND(ItemLedgEntry."Cost Amount (Actual)"/ItemLedgEntry.Quantity,0.00001);
        //ItemCargoEntry."Cost Amount" := ABS(ROUND(ItemCargoEntry.Quantity * ItemCargoEntry."Unit Cost"));
        ItemCargoEntry."Ref Cargo" := RefCargo;
        if Cargo.Get(RefCargo) then
          ItemCargoEntry."Cargo Type" := Cargo."Cargo Type";
        ItemCargoEntry."Entry Type" := EntryType;
        ItemCargoEntry."Adjustment Type" := ItemLedgEntry."Adjustment Type";
        ItemCargoEntry.Positive:=false;
        ItemCargoEntry."System Entry":=true;

        if (ItemLedgEntry."External Document No." = Text017) then
          ItemCargoEntry.Source := ItemCargoEntry.Source::EcartJIRAMA;

        ItemCargoEntry."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry."User ID" := UserId;

        if Cust.Get(ItemLedgEntry."Source No.") then begin

          ItemCargoEntry."Sales Channel Code" := Cust."Sales Channel Code";

          //Controle qte sortie pour JIRAMA 061017
          if (ItemLedgEntry.Quantity<0) then
            if (Cust."Sales Channel Code"=AddOnSetup."JIRAMA Sales Channel") then
              TotalConsoJIRAMA := TotalConsoJIRAMA + ItemCargoEntry.Quantity;

          if ItemCargoEntry."Document Type"=ItemCargoEntry."Document Type"::"Sales Shipment" then begin
            ShipInvoiced.Reset;
            ShipInvoiced.SetCurrentKey("Shipment No.","Shipment Line No.");
            ShipInvoiced.SetRange(ShipInvoiced."Shipment No.",ItemCargoEntry."Document No.");
            if ShipInvoiced.FindFirst then
              ItemCargoEntry."Invoice No" := ShipInvoiced."Invoice No.";
          end else begin
            ItemCargoEntry."Invoice No" := getNumAvoirVte(ItemCargoEntry."Document No.");
          end;

        end;

        UpdateUnitCostCargoEntry(ItemCargoEntry);

        ItemCargoEntry.Insert;



        NextEntryNo := NextEntryNo + 1;

        if (ItemLedgEntry.Quantity<0) then
          QteASortir := QteASortir - Abs(ItemCargoEntry.Quantity)
        else
          QteASortir:=0;
    end;

    local procedure InsertCargoEntrySales_OD(var CargoEntrySource: Record "Item Cargo Entry";var NextEntryNo: Integer;RemainingQtyCargo: Decimal;var QteASortir: Decimal;RefCargo: Code[20];EntryType: Integer)
    var
        ItemCargoEntry: Record "Item Cargo Entry";
        Cust: Record Customer;
        Cargo: Record Cargo;
    begin

        ItemCargoEntry.Init;
        ItemCargoEntry."Entry No." := NextEntryNo;
        ItemCargoEntry."Item No.":= CargoEntrySource."Item No.";
        ItemCargoEntry.Description := CargoEntrySource.Description;
        //ItemCargoEntry."Item Ledger Entry No." := CargoEntrySource."Entry No.";
        ItemCargoEntry."Dimension Set ID" := CargoEntrySource."Dimension Set ID";
        ItemCargoEntry."Posting Date" := CargoEntrySource."Posting Date";
        ItemCargoEntry."Document No." := CargoEntrySource."Document No.";
        ItemCargoEntry."Document Type" := CargoEntrySource."Document Type";
        ItemCargoEntry."Customer No." := CargoEntrySource."Customer No.";


        if (CargoEntrySource.Quantity>0) then begin
          //Avoir et annulation livraisons
          ItemCargoEntry.Quantity := QteASortir;

        end else begin
          if QteASortir>RemainingQtyCargo then
            ItemCargoEntry.Quantity := -RemainingQtyCargo
          else
            ItemCargoEntry.Quantity := -QteASortir;
        end;
        //ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
        //ItemCargoEntry."Unit Cost" := GetUnitCostCargaison(RefCargo); //ROUND(ItemLedgEntry."Cost Amount (Actual)"/ItemLedgEntry.Quantity,0.00001);
        //ItemCargoEntry."Cost Amount" := ABS(ROUND(ItemCargoEntry.Quantity * ItemCargoEntry."Unit Cost"));
        ItemCargoEntry."Ref Cargo" := RefCargo;
        ItemCargoEntry."Ref Dossier Cargo" := CargoEntrySource."Ref Dossier Cargo";
        if Cargo.Get(RefCargo) then
          ItemCargoEntry."Cargo Type" := Cargo."Cargo Type";
        ItemCargoEntry."Entry Type" := EntryType;
        ItemCargoEntry."Adjustment Type" := CargoEntrySource."Adjustment Type";
        ItemCargoEntry.Positive:=false;
        ItemCargoEntry."System Entry":=true;

        //IF (ItemCargoEntry."External Document No." = Text017) THEN
        //  ItemCargoEntry.Source := CargoEntrySource.Source::EcartJIRAMA;

        ItemCargoEntry.Source := ItemCargoEntry.Source::" ";

        ItemCargoEntry."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry."User ID" := UserId;

        if Cust.Get(CargoEntrySource."Customer No.") then
          ItemCargoEntry."Sales Channel Code" := Cust."Sales Channel Code";

        UpdateUnitCostCargoEntry(ItemCargoEntry);

        ItemCargoEntry.Insert;

        NextEntryNo := NextEntryNo + 1;


        if (CargoEntrySource.Quantity<0) then
          QteASortir := QteASortir - Abs(ItemCargoEntry.Quantity)
        else
          QteASortir:=0;


        //Diminution du montant prelevé sur le parent (ecriture source)
        if (CargoEntrySource.Quantity<0) then begin
          CargoEntrySource.Quantity := CargoEntrySource.Quantity - (ItemCargoEntry.Quantity);
          CargoEntrySource."Cost Amount" := CargoEntrySource.Quantity*CargoEntrySource."Unit Cost";
          CargoEntrySource.Modify;
        end;
    end;

    local procedure InsertCargoEntryPosAdj(ItemLedgEntry: Record "Item Ledger Entry";var NextEntryNo: Integer;RefCargo: Code[20];EntryType: Integer)
    var
        ItemCargoEntry: Record "Item Cargo Entry";
        Cargo: Record Cargo;
        ContenuCargo: Record "Contenu Cargo";
    begin

        ItemCargoEntry.Init;
        ItemCargoEntry."Entry No." := NextEntryNo;
        ItemCargoEntry."Item No." := ItemLedgEntry."Item No.";
        ItemCargoEntry.Description := ItemLedgEntry.Description;
        ItemCargoEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemCargoEntry."Dimension Set ID" := ItemLedgEntry."Dimension Set ID";
        ItemCargoEntry."Document No." := ItemLedgEntry."Document No.";
        ItemCargoEntry."Document Type" := ItemLedgEntry."Document Type";
        ItemCargoEntry."Posting Date" := ItemLedgEntry."Posting Date";

        ItemCargoEntry.Quantity := ItemLedgEntry.Quantity;

        //Prendre le cout du cargo
        //ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
        //ItemCargoEntry."Unit Cost" := ROUND(ItemLedgEntry."Cost Amount (Actual)"/ItemLedgEntry.Quantity,0.00001);
        //ItemCargoEntry."Cost Amount" := ItemLedgEntry."Cost Amount (Actual)";

        ItemCargoEntry."Ref Cargo" := RefCargo;
        ItemCargoEntry.Description := ItemLedgEntry.Description;
        ItemCargoEntry."Entry Type" := EntryType;
        ItemCargoEntry."Adjustment Type" := ItemLedgEntry."Adjustment Type";
        if Cargo.Get(RefCargo) then
          ItemCargoEntry."Cargo Type" := Cargo."Cargo Type";
        ItemCargoEntry.Positive := true;
        ItemCargoEntry."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry."User ID" := UserId;


        UpdateUnitCostCargoEntry(ItemCargoEntry);//Prendre le cout du cargo

        ItemCargoEntry.Insert;

        //GetOrInsertContenuCargo(RefCargo,ItemLedgEntry."Item No.",ContenuCargo);
    end;

    procedure GetUnitCostCargaison(RefCargo: Code[20];ItemNo: Code[20]): Decimal
    var
        ILE: Record "Item Ledger Entry";
        TotalQty: Decimal;
        TotalAmount: Decimal;
        CargoEntry: Record "Item Cargo Entry";
        CoutEcriture: Decimal;
    begin

        CheckDateFinTraitement;//081117

        ILE.Reset;
        ILE.SetCurrentKey("Entry Type","Ref Cargo","Item No.");
        //ILE.SETRANGE(ILE.Positive,TRUE);
        //ILE.SETFILTER(ILE."Entry Type",'%1|%2',ILE."Entry Type"::"Positive Adjmt.",ILE."Entry Type"::Purchase);
        ILE.SetRange(ILE."Entry Type",ILE."Entry Type"::Purchase);
        ILE.SetRange(ILE."Ref Cargo",RefCargo);
        ILE.SetRange(ILE."Item No.",ItemNo);
        if ILE.FindSet then repeat
          //ILE.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
          CoutEcriture := GetCoutFifoEcriture(ILE."Entry No.");
          //TotalAmount := TotalAmount + ILE."Cost Amount (Actual)"+ILE."Cost Amount (Expected)";
          TotalAmount := TotalAmount + CoutEcriture;
          TotalQty := TotalQty + ILE.Quantity;
        until ILE.Next=0;


        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Entry Type","Ref Cargo","Item No.");
        CargoEntry.SetRange(CargoEntry.Source,CargoEntry.Source::OD);
        CargoEntry.SetRange(CargoEntry."Entry Type",CargoEntry."Entry Type"::"Positive Adjmt.");
        CargoEntry.SetRange(CargoEntry."Ref Cargo",RefCargo);
        CargoEntry.SetRange(CargoEntry."Item No.",ItemNo);
        if CargoEntry.FindSet then repeat
          if ((not CargoEntry.Reversed) and (CargoEntry."Posting Date"<=DateFinTraitement)) then begin//081117
            TotalAmount := TotalAmount + CargoEntry."Cost Amount";
            TotalQty := TotalQty + CargoEntry.Quantity;
          end;
        until CargoEntry.Next=0;


        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Entry Type","Ref Cargo","Item No.");
        CargoEntry.SetRange(CargoEntry.Source,CargoEntry.Source::Anticipated);
        CargoEntry.SetRange(CargoEntry."Entry Type",CargoEntry."Entry Type"::Purchase);
        CargoEntry.SetRange(CargoEntry."Ref Cargo",RefCargo);
        CargoEntry.SetRange(CargoEntry."Item No.",ItemNo);
        if CargoEntry.FindSet then repeat
          if ((not CargoEntry.Reversed) and (CargoEntry."Posting Date"<=DateFinTraitement)) then begin//081117
            TotalAmount := TotalAmount + CargoEntry."Cost Amount";
            TotalQty := TotalQty + CargoEntry.Quantity;
          end;
        until CargoEntry.Next=0;


        //CargoEntry.SETFILTER(CargoEntry.Source,'%1|%2',CargoEntry.Source::" ",CargoEntry.Source::EcartJIRAMA);


        if TotalQty<>0 then
          exit(Round(TotalAmount/TotalQty,0.00001));
    end;

    local procedure GetCoutFifoEcriture(ILEntryNo: Integer): Decimal
    var
        ValueEntry: Record "Value Entry";
    begin
        //081117
        CheckDateFinTraitement;

        ValueEntry.Reset;
        ValueEntry.SetRange("Item Ledger Entry No.",ILEntryNo);
        ValueEntry.SetRange("Posting Date",0D,DateFinTraitement);//081117
        ValueEntry.CalcSums("Cost Amount (Actual)","Cost Amount (Expected)");
        exit(ValueEntry."Cost Amount (Actual)"+ValueEntry."Cost Amount (Expected)");
    end;

    local procedure ExcludeFromCargo(ILE: Record "Item Ledger Entry"): Boolean
    begin
        //IF ILE."Adjustment Type"=ILE."Adjustment Type"::
    end;

    procedure GetCargoCONFRERE(): Code[20]
    var
        Cargo1: Record Cargo;
    begin
        Cargo1.Reset;
        Cargo1.SetRange(Cargo1."Cargo Type",Cargo1."Cargo Type"::Confrere);
        if not Cargo1.FindFirst then Error(Text006);
        exit(Cargo1.Code);
    end;

    procedure GetCargoTransfer(): Code[20]
    var
        Cargo1: Record Cargo;
    begin
        Cargo1.Reset;
        Cargo1.SetRange(Cargo1."Cargo Type",Cargo1."Cargo Type"::Transfer);
        if not Cargo1.FindFirst then Error(Text014);
        exit(Cargo1.Code);
    end;

    procedure GetCargoEnlevement(): Code[20]
    var
        Cargo1: Record Cargo;
    begin
        Cargo1.Reset;
        Cargo1.SetRange(Cargo1."Cargo Type",Cargo1."Cargo Type"::Enlevement);
        if not Cargo1.FindFirst then Error(Text006);
        exit(Cargo1.Code);
    end;

    local procedure IsOpAdjustment(AdjType: Integer): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        // EXIT(AdjType IN [
        //   ItemLedgEntry."Adjustment Type"::AdjBE,ItemLedgEntry."Adjustment Type"::Transfer
        //   ]);

        exit(AdjType in [
          ItemLedgEntry."Adjustment Type"::Transfer
          ]);
    end;

    local procedure IsOpConfrere(AdjType: Integer): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        exit(AdjType in [
          ItemLedgEntry."Adjustment Type"::Borrow,ItemLedgEntry."Adjustment Type"::"Borrow Return"
          ,ItemLedgEntry."Adjustment Type"::Exchange,ItemLedgEntry."Adjustment Type"::Loan
          ,ItemLedgEntry."Adjustment Type"::"Loan Return"
          ]);
    end;

    local procedure IsTransfertBE(AdjType: Integer): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        exit(AdjType in [
          ItemLedgEntry."Adjustment Type"::BE
          ]);
    end;

    local procedure getActualCost(var ContenuCargo: Record "Contenu Cargo"): Decimal
    begin
        if ContenuCargo."Cost Updated" then
          exit(ContenuCargo."Unit Cost");

        if ContenuCargo."Last Updated Date"<>WorkDate then
          ContenuCargo."Last Unit Cost" := ContenuCargo."Unit Cost";
        ContenuCargo."Unit Cost" := GetUnitCostCargaison(ContenuCargo."Ref Cargo",ContenuCargo."Item No.");
        ContenuCargo."Cost Updated" := true;
        ContenuCargo."Last Updated Date" := WorkDate;
        ContenuCargo.Modify;

        exit(ContenuCargo."Unit Cost");
    end;

    local procedure UpdateUnitCostCargoEntry(var CargoEntry: Record "Item Cargo Entry")
    var
        ContenuCargo: Record "Contenu Cargo";
    begin

        GetOrInsertContenuCargo(CargoEntry."Ref Cargo",CargoEntry."Item No.",ContenuCargo);
        //ContenuCargo.GET(CargoEntry."Ref Cargo",CargoEntry."Item No.");
        if((CargoEntry."Ref Cargo"<>CargoConfrere) and (CargoEntry."Ref Cargo"<>CargoEnlevement)and (CargoEntry."Ref Cargo"<>CargoTransfert)) then begin
          CargoEntry."Unit Cost" := getActualCost(ContenuCargo);
          CargoEntry."Cost Amount" := CargoEntry."Unit Cost"*CargoEntry.Quantity;
          //CargoEntry.MODIFY;
        end;
    end;

    local procedure UpdateUnitCostCargoEntry_OD(var CargoEntry: Record "Item Cargo Entry";RefCargo: Code[20])
    var
        Cargo: Record Cargo;
        ContenuCargo: Record "Contenu Cargo";
    begin
        //ContenuCargo.GET(RefCargo,CargoEntry."Item No.");
        GetOrInsertContenuCargo(RefCargo,CargoEntry."Item No.",ContenuCargo);

        CargoEntry."Ref Cargo" := RefCargo;
        CargoEntry."Cargo Type" := Cargo."Cargo Type";

        if((CargoEntry."Ref Cargo"<>CargoConfrere) and (CargoEntry."Ref Cargo"<>CargoEnlevement)
          and (CargoEntry."Ref Cargo"<>CargoTransfert)) then begin
          CargoEntry."Unit Cost" := getActualCost(ContenuCargo);
          CargoEntry."Cost Amount" := CargoEntry."Unit Cost"*CargoEntry.Quantity;
        end;

        CargoEntry.Modify;
    end;

    procedure PostAjustement()
    var
        CargoJournalLine: Record "Cargo Journal Line";
        ItemCargoEntry: Record "Item Cargo Entry";
        NextEntryNo: Integer;
    begin

        if not Confirm(Text007) then exit;

        NextEntryNo := getNextCargoEntryNo();

        CargoJournalLine.Reset;
        if CargoJournalLine.FindSet then
        repeat


          CargoJournalLine.TestField(CargoJournalLine."Item No.");
          //CargoJournalLine.TESTFIELD(CargoJournalLine."Document No.");
          CargoJournalLine.TestField(CargoJournalLine."Line No.");
          CargoJournalLine.TestField(CargoJournalLine.Quantity);


          //IF (CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Negative Adjmt.") THEN
          //  CargoJournalLine.TESTFIELD(CargoJournalLine."Sales Channel Code");


          if (CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt.") then begin
            CargoJournalLine.TestField(CargoJournalLine."Ref Cargo");
            CargoJournalLine.TestField(CargoJournalLine."Unit Cost");
          end;

          InsertCargoEntryJournal(CargoJournalLine,NextEntryNo);

        until CargoJournalLine.Next=0;


        CargoJournalLine.Reset;
        CargoJournalLine.DeleteAll;
        Message(Text008);
    end;

    local procedure InsertCargoEntryJournal(CargoJournalLine: Record "Cargo Journal Line";var NextEntryNo: Integer)
    var
        ItemCargoEntry: Record "Item Cargo Entry";
        Cargo: Record Cargo;
    begin

        ItemCargoEntry.Init;
        ItemCargoEntry."Entry No." := NextEntryNo;
        ItemCargoEntry."Item No." := CargoJournalLine."Item No.";
        ItemCargoEntry.Description := CargoJournalLine.Description;
        //ItemCargoEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemCargoEntry."Document No." := CargoJournalLine."Document No.";
        //ItemCargoEntry."Document Type" := ItemLedgEntry."Document Type";
        ItemCargoEntry."Posting Date" := CargoJournalLine."Posting Date";

        if CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt." then
          ItemCargoEntry.Quantity := CargoJournalLine.Quantity
        else
          ItemCargoEntry.Quantity := -CargoJournalLine.Quantity;

        ItemCargoEntry."Initial Qty" := ItemCargoEntry.Quantity;

        ItemCargoEntry."Unit Cost" := CargoJournalLine."Unit Cost";
        ItemCargoEntry."Cost Amount" := CargoJournalLine."Unit Cost" * CargoJournalLine.Quantity;
        //ItemCargoEntry."Cost Amount" := CargoJournalLine."Unit Cost" * CargoJournalLine.Quantity

        ItemCargoEntry."Ref Cargo" := CargoJournalLine."Ref Cargo";
        ItemCargoEntry."Ref Dossier Cargo" := CargoJournalLine."Ref Dossier Cargo";
        //ItemCargoEntry.Description := CargoJournalLine.Description;

        if CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Negative Adjmt." then
          ItemCargoEntry."Entry Type" := ItemCargoEntry."Entry Type"::"Negative Adjmt.";

        if CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt." then
          ItemCargoEntry."Entry Type" := ItemCargoEntry."Entry Type"::"Positive Adjmt.";

        //ItemCargoEntry."Entry Type" := EntryType;
        //ItemCargoEntry."Adjustment Type" := ItemLedgEntry."Adjustment Type";

        if Cargo.Get(CargoJournalLine."Ref Cargo") then
          ItemCargoEntry."Cargo Type" := Cargo."Cargo Type";

        ItemCargoEntry.Positive := (CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt.");
        ItemCargoEntry."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry."User ID" := UserId;
        ItemCargoEntry.Journal := true;
        ItemCargoEntry.Source := ItemCargoEntry.Source::OD;
        ItemCargoEntry."Sales Channel Code" := CargoJournalLine."Sales Channel Code";

        ItemCargoEntry."Dimension Set ID" := CargoJournalLine."Dimension Set ID";

        ItemCargoEntry.Insert;

        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure InsertCargoEntryAnticipated(CargoJournalLine: Record "Cargo Journal Line";var NextEntryNo: Integer)
    var
        ItemCargoEntry: Record "Item Cargo Entry";
        Cargo: Record Cargo;
        ContenuCargo: Record "Contenu Cargo";
    begin

        ItemCargoEntry.Init;
        ItemCargoEntry."Entry No." := NextEntryNo;
        ItemCargoEntry."Item No." := CargoJournalLine."Item No.";
        ItemCargoEntry.Description := CargoJournalLine.Description;
        //ItemCargoEntry."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemCargoEntry."Document No." := CargoJournalLine."Document No.";
        //ItemCargoEntry."Document Type" := ItemLedgEntry."Document Type";
        ItemCargoEntry."Posting Date" := CargoJournalLine."Posting Date";

        if CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt." then
          ItemCargoEntry.Quantity := CargoJournalLine.Quantity
        else
          ItemCargoEntry.Quantity := -CargoJournalLine.Quantity;

        ItemCargoEntry."Initial Qty" := ItemCargoEntry.Quantity;

        ItemCargoEntry."Unit Cost" := CargoJournalLine."Unit Cost";
        ItemCargoEntry."Cost Amount" := CargoJournalLine."Unit Cost" * CargoJournalLine.Quantity;

        ItemCargoEntry."Ref Cargo" := CargoJournalLine."Ref Cargo";
        ItemCargoEntry."Ref Dossier Cargo" := CargoJournalLine."Ref Dossier Cargo";

        if CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Negative Adjmt." then
          ItemCargoEntry."Entry Type" := ItemCargoEntry."Entry Type"::Sale;

        if CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt." then
          ItemCargoEntry."Entry Type" := ItemCargoEntry."Entry Type"::Purchase;

        ItemCargoEntry.Source := ItemCargoEntry.Source::Anticipated;
        //ItemCargoEntry."Entry Type" := EntryType;
        //ItemCargoEntry."Adjustment Type" := ItemLedgEntry."Adjustment Type";

        if Cargo.Get(CargoJournalLine."Ref Cargo") then
          ItemCargoEntry."Cargo Type" := Cargo."Cargo Type";

        ItemCargoEntry.Positive := (CargoJournalLine."Entry Type"=CargoJournalLine."Entry Type"::"Positive Adjmt.");
        ItemCargoEntry."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry."User ID" := UserId;
        //ItemCargoEntry.Journal := TRUE;
        ItemCargoEntry."Sales Channel Code" := CargoJournalLine."Sales Channel Code";
        ItemCargoEntry."Customer No." := CargoJournalLine."Customer No.";

        ItemCargoEntry.Insert;

        GetOrInsertContenuCargo(CargoJournalLine."Ref Cargo",CargoJournalLine."Item No.",ContenuCargo);//061017

        NextEntryNo := NextEntryNo + 1;
    end;

    procedure ProcessSalesOrderAnticipated(SalesH: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Item1: Record Item;
        CargoJournalLine: Record "Cargo Journal Line";
        NextEntryNo: Integer;
        ItemCargoEntry1: Record "Item Cargo Entry";
    begin
        if not Confirm(Text016) then exit;


        ItemCargoEntry1.Reset;
        ItemCargoEntry1.SetCurrentKey(Source,"Document No.");
        ItemCargoEntry1.SetRange(Source,ItemCargoEntry1.Source::Anticipated);
        ItemCargoEntry1.SetRange("Document No.",SalesH."No.");
        ItemCargoEntry1.DeleteAll;


        NextEntryNo := getNextCargoEntryNo();

        SalesLine.Reset;
        SalesLine.SetRange(SalesLine."Document No.",SalesH."No.");
        if SalesLine.FindSet then repeat

          if SalesLine.Type=SalesLine.Type::Item then
            if Item1.Get(SalesLine."No.") then
              if Item1."Cargo Mgt" then begin
                CreateCargoJournalLineFromSales(SalesH,SalesLine,CargoJournalLine);
                InsertCargoEntryAnticipated(CargoJournalLine,NextEntryNo);
              end;

        until SalesLine.Next=0;

        Message(TxtTraitementTerminé);
    end;

    procedure ProcessPurchOrderAnticipated(PurchH: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        Item1: Record Item;
        CargoJournalLine: Record "Cargo Journal Line";
        NextEntryNo: Integer;
        ItemCargoEntry1: Record "Item Cargo Entry";
    begin
        if not Confirm(Text016) then exit;

        //MESSAGE('%1',1/0);

        ItemCargoEntry1.Reset;
        ItemCargoEntry1.SetCurrentKey(Source,"Document No.");
        ItemCargoEntry1.SetRange(Source,ItemCargoEntry1.Source::Anticipated);
        ItemCargoEntry1.SetRange("Document No.",PurchH."No.");
        ItemCargoEntry1.DeleteAll;


        NextEntryNo := getNextCargoEntryNo();

        PurchLine.Reset;
        PurchLine.SetRange("Document No.",PurchH."No.");
        if PurchLine.FindSet then repeat

          if PurchLine.Type=PurchLine.Type::Item then
            if Item1.Get(PurchLine."No.") then
              if Item1."Cargo Mgt" then begin
                CreateCargoJournalLineFromPurchase(PurchH,PurchLine,CargoJournalLine);
                InsertCargoEntryAnticipated(CargoJournalLine,NextEntryNo);
              end;

        until PurchLine.Next=0;

        Message(TxtTraitementTerminé);
    end;

    procedure CancelCargoEntry(NewPostingDate: Date;var ItemCargoEntry: Record "Item Cargo Entry")
    var
        Cargo: Record Cargo;
        ItemCargoEntry1: Record "Item Cargo Entry";
        NextEntryNo: Integer;
    begin

        ItemCargoEntry.TestField(ItemCargoEntry.Journal);

        if not Confirm(StrSubstNo( Text009,ItemCargoEntry."Document No.",ItemCargoEntry."Entry No.")) then exit;


        ItemCargoEntry1.LockTable;
        if ItemCargoEntry1.FindLast then
          NextEntryNo := ItemCargoEntry1."Entry No." + 1
        else
          NextEntryNo := 1;

        ItemCargoEntry1.Init;
        ItemCargoEntry1.TransferFields(ItemCargoEntry);
        ItemCargoEntry1."Entry No." := NextEntryNo;
        ItemCargoEntry1."Posting Date" := NewPostingDate;

        ItemCargoEntry1.Positive:=not ItemCargoEntry.Positive;
        ItemCargoEntry1.Quantity := -ItemCargoEntry.Quantity;
        ItemCargoEntry1."Cost Amount" := ItemCargoEntry1."Unit Cost" * ItemCargoEntry1.Quantity;
        ItemCargoEntry1.Reversed := true;

        ItemCargoEntry1."Entry Date" := CreateDateTime(Today,Time);
        ItemCargoEntry1."User ID" := UserId;
        ItemCargoEntry1.Insert;




        ItemCargoEntry.Reversed := true;
        ItemCargoEntry.Modify;
    end;

    local procedure GetOrInsertContenuCargo(RefCargo: Code[20];ItemNo: Code[20];var ContenuCargo: Record "Contenu Cargo")
    begin
        if ContenuCargo.Get(RefCargo,ItemNo) then
          exit;
        ContenuCargo.Init;
        ContenuCargo."Ref Cargo" := RefCargo;
        ContenuCargo."Item No." := ItemNo;
        if ContenuCargo.Insert then;
    end;

    local procedure CreateDim(var ItemLedgEntry2: Record "Item Ledger Entry";Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20])
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        GlobalCode1: Code[20];
        GlobalCode2: Code[20];
        SourceCode: Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;

        GlobalCode1 := '';
        GlobalCode2 := '';
        SourceCode := '';

        ItemLedgEntry2."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCode,
            GlobalCode1,GlobalCode2,0,0);
    end;

    local procedure getNextCargoEntryNo() NextEntryNo: Integer
    var
        ItemCargoEntry: Record "Item Cargo Entry";
    begin
        Clear(ItemCargoEntry);
        ItemCargoEntry.LockTable;
        if ItemCargoEntry.FindLast then
          NextEntryNo := ItemCargoEntry."Entry No." + 1
        else
          NextEntryNo := 1;
    end;

    local procedure CreateCargoJournalLineFromPurchase(PurchaseH: Record "Purchase Header";PurchaseLine: Record "Purchase Line";var CargoJournalLine: Record "Cargo Journal Line")
    begin
        CargoJournalLine.Init;
        CargoJournalLine.Validate("Item No.",PurchaseLine."No.");
        CargoJournalLine.Description := PurchaseLine.Description;
        CargoJournalLine."Document No." := PurchaseH."No.";
        CargoJournalLine."Entry Type" := CargoJournalLine."Entry Type"::"Positive Adjmt.";
        CargoJournalLine."Line No." := 1000;
        PurchaseH.TestField("Order Date");
        CargoJournalLine."Posting Date" := PurchaseH."Order Date";
        CargoJournalLine.Quantity := PurchaseLine."Quantity (Base)";
        PurchaseH.TestField("Ref Cargo");
        CargoJournalLine."Ref Cargo" := PurchaseH."Ref Cargo";
        CargoJournalLine."Unit Cost" := PurchaseLine."Direct Unit Cost";
        CargoJournalLine."Dimension Set ID" := PurchaseLine."Dimension Set ID";

        PurchaseH.TestField("Ref Dossier Cargo");
        CargoJournalLine."Ref Dossier Cargo" := PurchaseH."Ref Dossier Cargo";
    end;

    local procedure CreateCargoJournalLineFromSales(SalesH: Record "Sales Header";SalesLine: Record "Sales Line";var CargoJournalLine: Record "Cargo Journal Line")
    var
        Cust: Record Customer;
    begin
        CargoJournalLine.Init;
        CargoJournalLine.Validate("Item No.",SalesLine."No.");
        CargoJournalLine.Description := SalesLine.Description;
        CargoJournalLine."Document No." := SalesH."No.";
        CargoJournalLine."Entry Type" := CargoJournalLine."Entry Type"::"Negative Adjmt.";
        CargoJournalLine."Line No." := 1000;
        SalesH.TestField("Order Date");
        CargoJournalLine."Posting Date" := SalesH."Order Date";
        CargoJournalLine.Quantity := SalesLine."Quantity (Base)";
        CargoJournalLine."Customer No." := SalesH."Sell-to Customer No.";
        SalesH.TestField("Ref Dossier Cargo");
        CargoJournalLine."Ref Dossier Cargo" := SalesH."Ref Dossier Cargo";

        //CargoJournalLine."Ref Cargo" := PurchaseH."Ref Cargo";
        //CargoJournalLine."Unit Cost" := SalesLine."Direct Unit Cost";
        Cust.Get(SalesH."Sell-to Customer No.");
        CargoJournalLine."Sales Channel Code" := Cust."Sales Channel Code";
    end;

    local procedure IsCargoMgt(ItemNo: Code[20]): Boolean
    var
        I: Integer;
    begin

        for I := 1 to CargoItemsLength do begin
          if (ItemNo=CargoItems[I]) then
            exit(true);
        end;
        exit(false);
    end;

    procedure TraiterComptaStockCargo(CargoEntry: Record "Item Cargo Entry";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];DateDeb: Date;DateFin: Date;var LineNo: Integer): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
        LigneEcr: Record "Gen. Journal Line";
    begin


        DateFinTraitement:=DateFin;

        //180817 Exclure cargo jovregul
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        if CargoEntry."Ref Cargo"=AddOnSetup."JOVENNA Regul Cargo" then exit;

        //180817 Transactions de vente et ajustements
        if ((CargoEntry."Entry Type" <> CargoEntry."Entry Type"::Sale)
          and (CargoEntry."Entry Type" <> CargoEntry."Entry Type"::"Negative Adjmt.")
          and (CargoEntry."Entry Type" <> CargoEntry."Entry Type"::"Positive Adjmt.")) then exit;

        //180817 Transactions normales + JOVENNA
        if ((CargoEntry."Cargo Type"<>CargoEntry."Cargo Type"::" ") and (CargoEntry."Cargo Type"<>CargoEntry."Cargo Type"::JOVENNA)) then exit;

        if CargoEntry."Cargo Adjusted" then exit;

        if CargoEntry."Entry Type"=CargoEntry."Entry Type"::Sale then
          AddLineComptaStockVente(CargoEntry,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,DateDeb,DateFin,LineNo,LigneEcr);

        if CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Negative Adjmt." then
          AddLineComptaStockAdjNeg(CargoEntry,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,DateDeb,DateFin,LineNo,LigneEcr);

        if CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Positive Adjmt." then
          AddLineComptaStockAdjPos(CargoEntry,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,DateDeb,DateFin,LineNo,LigneEcr);


        Clear(GenJrnLine);
        GenJrnLine.SetRange("Journal Template Name",ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", CodeFeuille);
        GenJrnLine.SetRange(GenJrnLine."External Document No.",LigneEcr."External Document No.");//Client
        GenJrnLine.SetRange(GenJrnLine.CodeArticleProvisions,LigneEcr.CodeArticleProvisions);//Article
        GenJrnLine.SetRange(GenJrnLine."Cargo Entry Type",LigneEcr."Cargo Entry Type");


        if GenJrnLine.FindFirst then begin

          LineAmount := LigneEcr.Amount;
          GenJrnLine.Validate(GenJrnLine.Amount , GenJrnLine.Amount + LineAmount);
          GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions + LigneEcr.VolumeProvisions;
          GenJrnLine.Modify;

        end else begin

          if LigneEcr.Amount<>0 then begin
            LigneEcr.Insert(true);
            exit(true);
          end;

        end;
    end;

    procedure TraiterComptaStockCargo_TEST(CargoEntry: Record "Item Cargo Entry";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];DateDeb: Date;DateFin: Date;var LineNo: Integer): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        GenJrnLine: Record "Gen. Journal Line";
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        CodeFsseur: Code[20];
        Vend: Record Vendor;
        LigneEcr: Record "Gen. Journal Line";
    begin
        
        DateFinTraitement:=DateFin;
        
        //180817 Exclure cargo jovregul
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        if CargoEntry."Ref Cargo"=AddOnSetup."JOVENNA Regul Cargo" then exit;
        
        //180817 Transactions de vente et ajustements
        if ((CargoEntry."Entry Type" <> CargoEntry."Entry Type"::Sale)
          and (CargoEntry."Entry Type" <> CargoEntry."Entry Type"::"Negative Adjmt.")
          and (CargoEntry."Entry Type" <> CargoEntry."Entry Type"::"Positive Adjmt.")) then exit;
        
        //180817 Transactions normales + JOVENNA
        if ((CargoEntry."Cargo Type"<>CargoEntry."Cargo Type"::" ") and (CargoEntry."Cargo Type"<>CargoEntry."Cargo Type"::JOVENNA)) then exit;
        
        if CargoEntry."Cargo Adjusted" then exit;
        
        if CargoEntry."Entry Type"=CargoEntry."Entry Type"::Sale then
          AddLineComptaStockVente(CargoEntry,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,DateDeb,DateFin,LineNo,LigneEcr);
        
        if CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Negative Adjmt." then
          AddLineComptaStockAdjNeg(CargoEntry,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,DateDeb,DateFin,LineNo,LigneEcr);
        
        if CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Positive Adjmt." then
          AddLineComptaStockAdjPos(CargoEntry,ModeleFeuille,CodeFeuille,PostingDate,DocumentNo,DateDeb,DateFin,LineNo,LigneEcr);
        
        
        LigneEcr.Destinataire := CargoEntry."Document No.";
        
        /*CLEAR(GenJrnLine);
        GenJrnLine.SETRANGE("Journal Template Name",ModeleFeuille);
        GenJrnLine.SETRANGE("Journal Batch Name", CodeFeuille);
        GenJrnLine.SETRANGE(GenJrnLine."External Document No.",LigneEcr."External Document No.");//Client
        GenJrnLine.SETRANGE(GenJrnLine.CodeArticleProvisions,LigneEcr.CodeArticleProvisions);//Article
        GenJrnLine.SETRANGE(GenJrnLine."Cargo Entry Type",LigneEcr."Cargo Entry Type");
        
        
        IF GenJrnLine.FINDFIRST THEN BEGIN
        
          LineAmount := LigneEcr.Amount;
          GenJrnLine.VALIDATE(GenJrnLine.Amount , GenJrnLine.Amount + LineAmount);
          GenJrnLine.VolumeProvisions := GenJrnLine.VolumeProvisions + LigneEcr.VolumeProvisions;
          GenJrnLine.MODIFY;
        
        END ELSE BEGIN*/
        
          if LigneEcr.Amount<>0 then begin
            LigneEcr.Insert(true);
            exit(true);
          end;
        
        //END;

    end;

    procedure AddLineComptaStockVente(CargoEntry: Record "Item Cargo Entry";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];DateDeb: Date;DateFin: Date;var LineNo: Integer;var GenJrnLine: Record "Gen. Journal Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        EnteteBL: Record pro_enteteBL;
        Vend: Record Vendor;
        Camion: Record pro_moyentransport;
        Item1: Record Item;
        ILE: Record "Item Ledger Entry";
        CoutCargo: Decimal;
        CoutFIFO: Decimal;
    begin
        
        DateFinTraitement:=DateFin;
        
        AddOnSetup.Get;
        
        Item1.Get(CargoEntry."Item No.");
        if Cust2.Get(CargoEntry."Customer No.") then;
        
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;
        
        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);
        
        GenJrnLine."Document No." := DocumentNo;
        
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := getCOGSAcc(Item1);
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Gen. Posting Type" := GenJrnLine."Gen. Posting Type"::Purchase;
        
        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);Text019
        if CargoEntry.Source=CargoEntry.Source::Anticipated then
          GenJrnLine.Description := CopyStr(StrSubstNo(Text019,Item1.Description,Cust2.Name,DateDeb,DateFin),1,49)
        else
          GenJrnLine.Description := CopyStr(StrSubstNo(Text018,Item1.Description,Cust2.Name,DateDeb,DateFin),1,49);
        
        GenJrnLine."Cargo Entry Type" := CargoEntry."Entry Type";
        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Cargo;
        
        if CargoEntry.Source=CargoEntry.Source::Anticipated then
          GenJrnLine."External Document No." := CargoEntry."Document No."//Non traité
        else
          GenJrnLine."External Document No." := Cust2."No.";
        
        
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        
        GenJrnLine.VolumeProvisions := CargoEntry.Quantity;
        GenJrnLine.CodeArticleProvisions := CargoEntry."Item No.";
        GenJrnLine.NumDocProvisions := Format(CargoEntry."Sales Channel Code");
        
        if ILE.Get(CargoEntry."Item Ledger Entry No.") then begin
          //ILE.CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
          //LineAmount := CargoEntry."Cost Amount"-(ILE."Cost Amount (Actual)"+ILE."Cost Amount (Expected)");
        
          UpdateMontantAjustementCargo(GenJrnLine,CargoEntry,ILE);
          /*CoutCargo := ABS(CargoEntry."Cost Amount");
          CoutFIFO  := ABS(ILE."Cost Amount (Actual)"+ILE."Cost Amount (Expected)");
        
          IF CargoEntry.Quantity<0 THEN BEGIN //Vente, Ajustement négatif
        
            IF CoutCargo>CoutFIFO THEN
              GenJrnLine.VALIDATE(GenJrnLine.Amount, CoutCargo-CoutFIFO)//Ajouter le debit du 603
            ELSE
              GenJrnLine.VALIDATE(GenJrnLine.Amount, -(CoutCargo-CoutFIFO))//Ajouter le crédit du 603
        
          END ELSE BEGIN //Retour vente, Ajustement positif
        
            IF CoutCargo>CoutFIFO THEN
              GenJrnLine.VALIDATE(GenJrnLine.Amount, -(CoutCargo-CoutFIFO))//Ajouter le crédit  du 603
            ELSE
              GenJrnLine.VALIDATE(GenJrnLine.Amount, CoutCargo-CoutFIFO)//Ajouter le debit du 603
        
          END;*/
        
          /*IF NOT CargoEntry.Positive THEN
            GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount)
          ELSE
            GenJrnLine.VALIDATE(GenJrnLine.Amount, -LineAmount);*/
        
        end;
        GenJrnLine.Validate("Currency Code",'');
        
        
        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := getItemAcc(Item1);
        GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;
        
        
        
        GenJrnLine.CreateDim(
          DATABASE::Campaign,GenJrnLine."Campaign No.",
          DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
          DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
          DATABASE::Job,GenJrnLine."Job No.",
          DATABASE::Customer,Cust2."No.");
        
        
        if GenJrnLine.Amount<>0 then
          exit(true);
        exit(false);

    end;

    procedure AddLineComptaStockAdjNeg(CargoEntry: Record "Item Cargo Entry";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];DateDeb: Date;DateFin: Date;var LineNo: Integer;var GenJrnLine: Record "Gen. Journal Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        EnteteBL: Record pro_enteteBL;
        Vend: Record Vendor;
        Camion: Record pro_moyentransport;
        Item1: Record Item;
        ILE: Record "Item Ledger Entry";
    begin
        
        DateFinTraitement:=DateFin;
        
        AddOnSetup.Get;
        
        Item1.Get(CargoEntry."Item No.");
        if Cust2.Get(CargoEntry."Customer No.") then;
        
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;
        
        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);
        
        GenJrnLine."Document No." := DocumentNo;
        
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := getCOGSAcc(Item1);
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Gen. Posting Type" := GenJrnLine."Gen. Posting Type"::Purchase;
        
        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);Text019
        GenJrnLine.Description := CopyStr(StrSubstNo(Text020,Item1.Description,Cust2.Name,DateDeb,DateFin),1,49);
        
        GenJrnLine."Cargo Entry Type" := CargoEntry."Entry Type";
        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Cargo;
        
        //GenJrnLine."External Document No." := Item1."No.";
        GenJrnLine.CodeArticleProvisions := Item1."No.";
        
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        
        
        GenJrnLine.NumDocProvisions := Format(CargoEntry."Sales Channel Code");
        
        if ILE.Get(CargoEntry."Item Ledger Entry No.") then begin
          //ILE.CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
          //LineAmount := CargoEntry."Cost Amount"-(ILE."Cost Amount (Actual)"+ILE."Cost Amount (Expected)");
          //IF CargoEntry.Positive THEN
          //  GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount)
          //ELSE
          //  GenJrnLine.VALIDATE(GenJrnLine.Amount, -LineAmount);
        
          UpdateMontantAjustementCargo(GenJrnLine,CargoEntry,ILE);
        
          /*IF NOT CargoEntry.Positive THEN
            GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount)
          ELSE
            GenJrnLine.VALIDATE(GenJrnLine.Amount, -LineAmount);*/
        
          GenJrnLine.VolumeProvisions := CargoEntry.Quantity;
        end;
        
        GenJrnLine.Validate("Currency Code",'');
        
        
        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := getItemAcc(Item1);
        GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;
        
        
        
        GenJrnLine.CreateDim(
          DATABASE::Campaign,GenJrnLine."Campaign No.",
          DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
          DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
          DATABASE::Job,GenJrnLine."Job No.",
          DATABASE::Item,Item1."No.");
        
        
        if GenJrnLine.Amount<>0 then
          exit(true);
        exit(false);

    end;

    procedure AddLineComptaStockAdjPos(CargoEntry: Record "Item Cargo Entry";ModeleFeuille: Code[20];CodeFeuille: Code[20];PostingDate: Date;DocumentNo: Code[20];DateDeb: Date;DateFin: Date;var LineNo: Integer;var GenJrnLine: Record "Gen. Journal Line"): Boolean
    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        SalesByCardLine: Record "MoneyTech Import Line";
        isNoteDebit: Boolean;
        LastDocNo: Code[20];
        LastDocNoDebit: Code[20];
        GenerateNewDocNo: Boolean;
        GLAccNo: Code[20];
        MontantTotalCde: Decimal;
        JrnTmplName: Record "Gen. Journal Template";
        LineAmount: Decimal;
        Cust2: Record Customer;
        QteToInvoice: Decimal;
        EnteteBL: Record pro_enteteBL;
        Vend: Record Vendor;
        Camion: Record pro_moyentransport;
        Item1: Record Item;
        ILE: Record "Item Ledger Entry";
    begin
        
        DateFinTraitement:=DateFin;
        
        AddOnSetup.Get;
        
        Item1.Get(CargoEntry."Item No.");
        if Cust2.Get(CargoEntry."Customer No.") then;
        
        Clear(GenJrnLine);
        GenJrnLine."Journal Template Name":= ModeleFeuille;
        GenJrnLine."Journal Batch Name" := CodeFeuille;
        
        LineNo := LineNo + 10;
        GenJrnLine."Line No." := LineNo;
        JrnTmplName.Get(GenJrnLine."Journal Template Name");
        JrnTmplName.TestField("Source Code");
        GenJrnLine."Source Code" := JrnTmplName."Source Code";
        GenJrnLine.Validate("Posting Date",PostingDate);
        
        GenJrnLine."Document No." := DocumentNo;
        
        
        GenJrnLine."Account Type" := GenJrnLine."Account Type"::"G/L Account";
        GLAccNo := getCOGSAcc(Item1);
        GenJrnLine.Validate("Account No.",GLAccNo);
        GenJrnLine.Validate("VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Gen. Posting Type" := GenJrnLine."Gen. Posting Type"::Purchase;
        GenJrnLine.Validate("Gen. Prod. Posting Group",'');//180817
        
        //GenJrnLine.Description := COPYSTR(STRSUBSTNO(Text005,SalesH."No."),1,49);Text019
        GenJrnLine.Description := CopyStr(StrSubstNo(Text022,Item1.Description,Cust2.Name,DateDeb,DateFin),1,49);
        
        GenJrnLine."Cargo Entry Type" := CargoEntry."Entry Type";
        GenJrnLine.TypeProvision := GenJrnLine.TypeProvision::Cargo;
        
        //GenJrnLine."External Document No." := Item1."No.";
        GenJrnLine.CodeArticleProvisions := Item1."No.";
        
        GenJrnLine."DateDeb Provisions" := DateDeb;
        GenJrnLine."DateFin Provisions" := DateFin;
        
        
        GenJrnLine.NumDocProvisions := Format(CargoEntry."Sales Channel Code");
        
        if ILE.Get(CargoEntry."Item Ledger Entry No.") then begin
          //ILE.CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
          //LineAmount := CargoEntry."Cost Amount"-(ILE."Cost Amount (Actual)"+ILE."Cost Amount (Expected)");
          //IF CargoEntry.Positive THEN
          //  GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount)
          //ELSE
          //  GenJrnLine.VALIDATE(GenJrnLine.Amount, -LineAmount);
          /*IF NOT CargoEntry.Positive THEN
            GenJrnLine.VALIDATE(GenJrnLine.Amount, LineAmount)
          ELSE
            GenJrnLine.VALIDATE(GenJrnLine.Amount, -LineAmount);*/
        
          UpdateMontantAjustementCargo(GenJrnLine,CargoEntry,ILE);
        
          GenJrnLine.VolumeProvisions := CargoEntry.Quantity;
        end;
        
        GenJrnLine.Validate("Currency Code",'');
        
        
        //Contrepartie
        GenJrnLine."Bal. Account Type" := GenJrnLine."Bal. Account Type"::"G/L Account";
        GLAccNo := getItemAcc(Item1);
        GenJrnLine.Validate(GenJrnLine."Bal. Account No.",GLAccNo);
        GenJrnLine.Validate(GenJrnLine."Bal. VAT Prod. Posting Group",AddOnSetup."NoVAT Prod. Posting Group");
        GenJrnLine."Bal. Gen. Posting Type" := GenJrnLine."Bal. Gen. Posting Type"::Purchase;
        GenJrnLine.Validate(GenJrnLine."Bal. Gen. Prod. Posting Group",'');//180817
        
        
        GenJrnLine.CreateDim(
          DATABASE::Campaign,GenJrnLine."Campaign No.",
          DimMgt.TypeToTableID1(GenJrnLine."Account Type"),GenJrnLine."Account No.",
          DimMgt.TypeToTableID1(GenJrnLine."Bal. Account Type"),GenJrnLine."Bal. Account No.",
          DATABASE::Job,GenJrnLine."Job No.",
          DATABASE::Item,Item1."No.");
        
        
        if GenJrnLine.Amount<>0 then
          exit(true);
        exit(false);

    end;

    local procedure getCOGSAcc(Item: Record Item): Code[20]
    begin
        GenPostingSetup.Get('',Item."Gen. Prod. Posting Group");
        GenPostingSetup.TestField("COGS Account");
        exit(GenPostingSetup."COGS Account");
    end;

    local procedure getItemAcc(Item: Record Item): Code[20]
    var
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        if AddOnSetup."GRT Location Code"='' then AddOnSetup.Get;
        Item.TestField("Inventory Posting Group");
        InventoryPostingSetup.Get(AddOnSetup."GRT Location Code",Item."Inventory Posting Group");
        InventoryPostingSetup.TestField("Inventory Account");
        exit(InventoryPostingSetup."Inventory Account");
    end;

    procedure ConfirmerAjustementCargo(GenJrnLine: Record "Gen. Journal Line")
    var
        CargoEntry1: Record "Item Cargo Entry";
        ILE: Record "Item Ledger Entry";
    begin

        if GenJrnLine.TypeProvision<>GenJrnLine.TypeProvision::Cargo then
          exit;

        if (GenJrnLine."Cargo Entry Type"=GenJrnLine."Cargo Entry Type"::Sale) then begin
          CargoEntry1.Reset;
          CargoEntry1.SetCurrentKey("Entry Type","Item No.","Customer No.","Posting Date");
          CargoEntry1.SetRange("Entry Type",CargoEntry1."Entry Type"::Sale);
          CargoEntry1.SetRange("Item No.",GenJrnLine.CodeArticleProvisions);
          CargoEntry1.SetRange("Customer No.",GenJrnLine."External Document No.");
          CargoEntry1.SetRange("Posting Date",GenJrnLine."DateDeb Provisions",GenJrnLine."DateFin Provisions");
          if CargoEntry1.FindSet then repeat
            if ((CargoEntry1."Cargo Type"=CargoEntry1."Cargo Type"::" ")
                or (CargoEntry1."Cargo Type"=CargoEntry1."Cargo Type"::JOVENNA)) then begin

              if CargoEntry1."Item Ledger Entry No.">0 then begin
                ILE.Get(CargoEntry1."Item Ledger Entry No.");
                ILE."Cargo Adjusted":=true;
                ILE.Modify;
              end;

              CargoEntry1."Cargo Adjusted" := true;
              CargoEntry1.Modify;

            end;

          until CargoEntry1.Next=0;
        end;

        if (GenJrnLine."Cargo Entry Type"=GenJrnLine."Cargo Entry Type"::"Negative Adjmt.") then begin
          CargoEntry1.Reset;
          CargoEntry1.SetCurrentKey(Source,"Entry Type","Item No.","Customer No.","Posting Date");
          CargoEntry1.SetRange(Source,CargoEntry1.Source::" ");
          CargoEntry1.SetRange("Entry Type",CargoEntry1."Entry Type"::"Negative Adjmt.");
          CargoEntry1.SetRange("Item No.",GenJrnLine.CodeArticleProvisions);
          CargoEntry1.SetRange("Customer No.",GenJrnLine."External Document No.");
          CargoEntry1.SetRange("Posting Date",GenJrnLine."DateDeb Provisions",GenJrnLine."DateFin Provisions");
          if CargoEntry1.FindSet then repeat
            if ((CargoEntry1."Cargo Type"=CargoEntry1."Cargo Type"::" ")
                 or (CargoEntry1."Cargo Type"=CargoEntry1."Cargo Type"::JOVENNA)) then begin

              if CargoEntry1."Item Ledger Entry No.">0 then begin
                ILE.Get(CargoEntry1."Item Ledger Entry No.");
                ILE."Cargo Adjusted":=true;
                ILE.Modify;
              end;

              CargoEntry1."Cargo Adjusted" := true;
              CargoEntry1.Modify;

            end;
          until CargoEntry1.Next=0;
        end;


        if (GenJrnLine."Cargo Entry Type"=GenJrnLine."Cargo Entry Type"::"Positive Adjmt.") then begin
          CargoEntry1.Reset;
          CargoEntry1.SetCurrentKey(Source,"Entry Type","Item No.","Customer No.","Posting Date");
          CargoEntry1.SetRange(Source,CargoEntry1.Source::" ");
          CargoEntry1.SetRange("Entry Type",CargoEntry1."Entry Type"::"Positive Adjmt.");
          CargoEntry1.SetRange("Item No.",GenJrnLine.CodeArticleProvisions);
          CargoEntry1.SetRange("Customer No.",GenJrnLine."External Document No.");
          CargoEntry1.SetRange("Posting Date",GenJrnLine."DateDeb Provisions",GenJrnLine."DateFin Provisions");
          if CargoEntry1.FindSet then repeat
            if ((CargoEntry1."Cargo Type"=CargoEntry1."Cargo Type"::" ")
                 or (CargoEntry1."Cargo Type"=CargoEntry1."Cargo Type"::JOVENNA)) then begin

              if CargoEntry1."Item Ledger Entry No.">0 then begin
                ILE.Get(CargoEntry1."Item Ledger Entry No.");
                ILE."Cargo Adjusted":=true;
                ILE.Modify;
              end;

              CargoEntry1."Cargo Adjusted" := true;
              CargoEntry1.Modify;

            end;
          until CargoEntry1.Next=0;
        end;
    end;

    local procedure getNumAvoirVte(CodeReception: Code[20]): Code[20]
    var
        ValEntry: Record "Value Entry";
        LigneReceptionEnreg: Record "Return Receipt Line";
    begin
        LigneReceptionEnreg.Reset;
        LigneReceptionEnreg.SetRange(LigneReceptionEnreg."Document No.",CodeReception);
        LigneReceptionEnreg.SetRange(LigneReceptionEnreg.Type,LigneReceptionEnreg.Type::Item);
        if LigneReceptionEnreg.FindFirst then
          exit(LigneReceptionEnreg.AFK_GetCrNum());
    end;

    local procedure UpdateMontantAjustementCargo(var GenJrnLine: Record "Gen. Journal Line";CargoEntry: Record "Item Cargo Entry";ILE: Record "Item Ledger Entry")
    var
        CoutCargo: Decimal;
        CoutFIFO: Decimal;
        Diff: Decimal;
    begin
        
        //ILE.CALCFIELDS("Cost Amount (Actual)","Cost Amount (Expected)");
        
        CoutCargo := (CargoEntry."Cost Amount");
        //CoutFIFO  := (ILE."Cost Amount (Actual)"+ILE."Cost Amount (Expected)");
        CoutFIFO := GetCoutFifoEcriture(ILE."Entry No.");
        
        
        if ILE.Quantity<>0 then
          CoutFIFO := CoutFIFO*(CargoEntry.Quantity/ILE.Quantity);//Prorata du cout si lecriture a été affectée a plusieurs écritures cargo
        
        Diff := CoutCargo-CoutFIFO;
        
        /*
        IF NOT CargoEntry.Positive THEN BEGIN //Vente, Ajustement négatif
        
          IF Diff<0 THEN (
            GenJrnLine.VALIDATE(GenJrnLine.Amount, ABS(Diff))//Ajouter le debit du 603
          ELSE
            GenJrnLine.VALIDATE(GenJrnLine.Amount, -ABS(Diff))//Ajouter le crédit du 603
        
        END ELSE BEGIN //Retour vente, Ajustement positif
        
          IF Diff>0 THEN
            GenJrnLine.VALIDATE(GenJrnLine.Amount, -ABS(Diff))//Ajouter le crédit  du 603
          ELSE
            GenJrnLine.VALIDATE(GenJrnLine.Amount, ABS(Diff))//Ajouter le debit du 603
        END;
        */
        //Diff sur compte de stock et -Diff sur le compte de variation
        GenJrnLine.Validate(GenJrnLine.Amount,-Diff);

    end;

    procedure ProcessMigration(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts
        //Traiter les entrées
        
        BesoinNo :=0;
        Window.Open(Text010);
        
        //Purger les écritures
        CargoEntry.Reset;
        if CargoEntry.FindFirst then begin
          Error(Text023);
        end;
        //CargoEntry.DELETEALL;
        
        
        
        if ContenuCargo.FindSet then
          repeat
            ContenuCargo."Cost Updated":=false;
            ContenuCargo.Modify;
          until ContenuCargo.Next=0;
        
        
        BesoinNo := 0;
        
        CargoItemsLength:=0;
        Item1.Reset;
        Item1.SetRange("Cargo Mgt",true);
        if Item1.FindSet then repeat
        
          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";
        
        until Item1.Next=0;
        
        
        //Traitement
        
        
        //ENTREES****************************
        //Autres Operations
        //TraiterCanalVenteVide(DateDeb,DateFin,TRUE);//Entrees
        
        //Op sur canal de vente
        /*
        SalesChannel.RESET;
        SalesChannel.SETCURRENTKEY("Cargo Priority");
        IF SalesChannel.FINDSET THEN REPEAT
          TraiterCanalVente(SalesChannel.Code,DateDeb,DateFin,TRUE,SalesChannel.Description);//Entrees
        UNTIL SalesChannel.NEXT=0;
        */
        //************************************
        
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type",ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange("Posting Date",DateDeb,DateFin);
        //ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Item Category Code",AddOnSetup."PBL Category Code");
        //ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Sales Channel Code",'');
        if ItemLedgerEntry.FindSet then begin
          NbreTotalLignes := ItemLedgerEntry.Count;
        repeat
        
        
          BesoinNo := BesoinNo + 1;
          Window.Update(1,
          Round(BesoinNo / NbreTotalLignes * 10000,1));
          //IF IsEntree THEN
            Window.Update(2,StrSubstNo(TxtCanal,'',TxtEntrees));
          //ELSE
          //  Window.UPDATE(2,STRSUBSTNO(TxtCanal,'',TxtSorties));
        
          //IF NOT ItemLedgerEntry."Cargo Adjusted" THEN
            ProcessLigneDifferee(ItemLedgerEntry);
        
        until ItemLedgerEntry.Next=0;
        end;
        
        
        
        
        //Maj des cout des contenu cargo non a jour
        if ContenuCargo.FindSet then
          repeat
            getActualCost(ContenuCargo);
          until ContenuCargo.Next=0;
        
        Window.Close;

    end;

    procedure CargoIsEmpty(CodeCargo: Code[20]): Boolean
    var
        ContenuCargo: Record "Contenu Cargo";
    begin

        ContenuCargo.Reset;
        ContenuCargo.SetRange(ContenuCargo."Ref Cargo",CodeCargo);
        if ContenuCargo.FindSet then
          repeat
            ContenuCargo.CalcFields(ContenuCargo.Quantity);
            if ContenuCargo.Quantity<>0 then exit(false);

          until ContenuCargo.Next=0;

        exit(true);
    end;

    procedure PeriodicProcess_Intro(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin
        
        DateFinTraitement := DateFin;
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts
        
        
        BesoinNo :=0;
        Window.Open(Text010);
        
        
        //Purger les écritures
        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Cargo Adjusted",Reversed,"Posting Date");
        CargoEntry.SetFilter(CargoEntry.Source,'%1|%2',CargoEntry.Source::" ",CargoEntry.Source::EcartJIRAMA);
        CargoEntry.SetRange(CargoEntry."Cargo Adjusted",false);
        CargoEntry.SetRange(CargoEntry.Reversed,false);
        CargoEntry.SetRange(CargoEntry."Posting Date",DateDeb,DateFin);
        
        NbreTotalLignes := CargoEntry.Count;
        while CargoEntry.FindFirst do begin
        
          BesoinNo := BesoinNo + 1;
          Window.Update(1,Round(BesoinNo / NbreTotalLignes * 10000,1));
          Window.Update(2,TxtSuppr);
        
          //IF NOT CargoEntry."Cargo Adjusted" THEN
            CargoEntry.Delete;
        end;
        
        
        
        
        
        //Restaurer les valeurs pour les ventes anticipées et sorties OD
        CargoEntry.Reset;
        CargoEntry.SetCurrentKey(Source,"Cargo Adjusted",Reversed,"Posting Date");
        CargoEntry.SetFilter(CargoEntry.Source,'%1|%2',CargoEntry.Source::OD,CargoEntry.Source::Anticipated);
        CargoEntry.SetRange(CargoEntry."Cargo Adjusted",false);
        CargoEntry.SetRange(CargoEntry.Reversed,false);
        CargoEntry.SetRange(CargoEntry."Posting Date",DateDeb,DateFin);
        if CargoEntry.FindSet then repeat
        
          if CargoEntry.Source=CargoEntry.Source::Anticipated then
            if CargoEntry."Entry Type"=CargoEntry."Entry Type"::Sale then begin
              CargoEntry.Quantity := CargoEntry."Initial Qty";
              CargoEntry.Modify;
            end;
        
          if CargoEntry.Source=CargoEntry.Source::OD then
            if CargoEntry."Entry Type"=CargoEntry."Entry Type"::"Negative Adjmt." then begin  //***
              CargoEntry.Quantity := CargoEntry."Initial Qty";
              CargoEntry.Modify;
            end;
        
        until CargoEntry.Next=0;
        
        
        if ContenuCargo.FindSet then
          repeat
            ContenuCargo."Cost Updated":=false;
            ContenuCargo.Modify;
          until ContenuCargo.Next=0;
        
        BesoinNo := 0;
        
        
        
        /*CargoItemsLength:=0;
        Item1.RESET;
        Item1.SETRANGE("Cargo Mgt",TRUE);
        IF Item1.FINDSET THEN REPEAT
        
          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";
        
        UNTIL Item1.NEXT=0;*/
        
        
        
        Window.Close;

    end;

    procedure PeriodicProcess_Trait01(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin
        
        DateFinTraitement := DateFin;
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts
        
        
        /*IF ContenuCargo.FINDSET THEN
          REPEAT
            ContenuCargo."Cost Updated":=FALSE;
            ContenuCargo.MODIFY;
          UNTIL ContenuCargo.NEXT=0;*/
        
        
        
        CargoItemsLength:=0;
        Item1.Reset;
        Item1.SetRange("Cargo Mgt",true);
        if Item1.FindSet then repeat
        
          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";
        
        until Item1.Next=0;
        
        
        //ENTREES****************************
        //Autres Operations
        TraiterCanalVenteVide(DateDeb,DateFin,true);//Entrees
        
        
        //Maj des cout des contenu cargo non a jour
        /*IF ContenuCargo.FINDSET THEN
          REPEAT
            getActualCost(ContenuCargo);
          UNTIL ContenuCargo.NEXT=0;*/

    end;

    procedure PeriodicProcess_Trait02(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin
        
        DateFinTraitement := DateFin;
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts
        
        
        CargoItemsLength:=0;
        Item1.Reset;
        Item1.SetRange("Cargo Mgt",true);
        if Item1.FindSet then repeat
        
          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";
        
        until Item1.Next=0;
        
        
        
        //Traitement
        
        
        //ENTREES****************************
        
        //Op sur canal de vente
        SalesChannel.Reset;
        SalesChannel.SetCurrentKey("Cargo Priority");
        if SalesChannel.FindSet then repeat
          TraiterCanalVente(SalesChannel.Code,DateDeb,DateFin,true,SalesChannel.Description);//Entrees
        until SalesChannel.Next=0;
        //************************************
        
        
        //Maj des cout des contenu cargo non a jour
        /*IF ContenuCargo.FINDSET THEN
          REPEAT
            getActualCost(ContenuCargo);
          UNTIL ContenuCargo.NEXT=0;*/

    end;

    procedure PeriodicProcess_Trait03(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin
        
        DateFinTraitement := DateFin;
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts
        
        
        /*IF ContenuCargo.FINDSET THEN
          REPEAT
            ContenuCargo."Cost Updated":=FALSE;
            ContenuCargo.MODIFY;
          UNTIL ContenuCargo.NEXT=0;*/
        
        
        
        CargoItemsLength:=0;
        Item1.Reset;
        Item1.SetRange("Cargo Mgt",true);
        if Item1.FindSet then repeat
        
          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";
        
        until Item1.Next=0;
        
        
        
        //Traitement
        
        
        //SORTIES*****************************
        SalesChannel.Reset;
        SalesChannel.SetCurrentKey("Cargo Priority");
        if SalesChannel.FindSet then repeat
          TraiterCanalVente(SalesChannel.Code,DateDeb,DateFin,false,SalesChannel.Description);//Sorties
          TraiterSortiesOD(DateDeb,DateFin,SalesChannel.Code);
        until SalesChannel.Next=0;
        
        
        //Maj des cout des contenu cargo non a jour
        /*IF ContenuCargo.FINDSET THEN
          REPEAT
            getActualCost(ContenuCargo);
          UNTIL ContenuCargo.NEXT=0;*/

    end;

    procedure PeriodicProcess_Trait04(DateDeb: Date;DateFin: Date)
    var
        CargoEntry: Record "Item Cargo Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Cargo: Record Cargo;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        ContenuCargo: Record "Contenu Cargo";
        UpdateUnitCost: Boolean;
        SalesChannel: Record "Sales Channel";
        Item1: Record Item;
    begin
        
        DateFinTraitement := DateFin;
        
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."JOVENNA Regul Cargo");
        
        if AddOnSetup."Desactivate Stock Value Mgt" then exit;
        
        CargoConfrere := GetCargoCONFRERE();//Confreres
        CargoEnlevement := GetCargoEnlevement();//Enlevements
        CargoTransfert := GetCargoTransfer();//Transferts
        
        
        /*IF ContenuCargo.FINDSET THEN
          REPEAT
            ContenuCargo."Cost Updated":=FALSE;
            ContenuCargo.MODIFY;
          UNTIL ContenuCargo.NEXT=0;*/
        
        
        BesoinNo := 0;
        
        CargoItemsLength:=0;
        Item1.Reset;
        Item1.SetRange("Cargo Mgt",true);
        if Item1.FindSet then repeat
        
          CargoItemsLength:=CargoItemsLength+1;
          CargoItems[CargoItemsLength] := Item1."No.";
        
        until Item1.Next=0;
        
        
        //Traitement
        
        //Traiter les sorties de stock sans canal de vente
        TraiterCanalVenteVide(DateDeb,DateFin,false);//Sorties
        
        //Traiter les sorties OD sans canal de vente
        TraiterSortiesOD(DateDeb,DateFin,'');
        //*************************************
        
        
        Window.Open(Text010);
        Window.Update(1,Round(1 / 2 * 10000,1));
        Window.Update(2,Text024);
        
        //Maj des cout des contenu cargo non a jour
        if ContenuCargo.FindSet then
          repeat
            getActualCost(ContenuCargo);
          until ContenuCargo.Next=0;
        
        Window.Close;

    end;

    local procedure CheckDateFinTraitement()
    begin
        if DateFinTraitement=0D then
          DateFinTraitement:=Today;
          //ERROR(Text025);
    end;
}

