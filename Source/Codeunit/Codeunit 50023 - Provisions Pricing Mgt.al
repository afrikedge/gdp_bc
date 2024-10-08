codeunit 50023 "Provisions Pricing Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Taux de change LPSA inexistant pour la période du %1 au %2\Devise : %3';
        Text002: Label 'Aucune valeur définie pour le dépôt %1 pour les frais de passage/stockage';
        Text003: Label 'Aucune valeur définie pour les frais de transport\Dépôts %1 - %2';
        UOMMgt: Codeunit "Unit of Measure Management";
        Item: Record Item;
        AddOnSetup: Record "AddOn Setup";

    procedure GetProvisionsPassage(EnteteBE: Record pro_enteteBE;LigneBL: Record pro_detailBL): Decimal
    var
        ReturnAmt: Decimal;
        QteM3: Decimal;
    begin

        QteM3 := CalcQtyM3(LigneBL.NavItemCode,LigneBL.volumelivre,LigneBL."Unit of Measure Code");
        ReturnAmt := ReturnAmt+ (QteM3 * GetProvisionsPassageUnitPrice(LigneBL.NavItemCode,EnteteBE.depot,EnteteBE.dateBE));

        exit(Round(ReturnAmt,0.01));
    end;

    procedure GetProvisionsPassageTransfert(EnteteTr: Record "Posted Adjustment Header";LigneTr: Record "Posted Adjustment Line";TransferToCode: Code[20]): Decimal
    var
        ReturnAmt: Decimal;
        QteM3: Decimal;
        UnitPrice: Decimal;
    begin

        QteM3 := CalcQtyM3(LigneTr."Item No.",LigneTr.Quantity,LigneTr."Unit of Measure Code");
        UnitPrice := GetProvisionsPassageUnitPrice(LigneTr."Item No.",EnteteTr."Location Code",EnteteTr."Posting Date");
        ReturnAmt := ReturnAmt + (QteM3 * UnitPrice);

        exit(Round(ReturnAmt,0.01));
    end;

    procedure GetProvisionsTransfert(EnteteTr: Record "Posted Adjustment Header";LigneTr: Record "Posted Adjustment Line";TransferToCode: Code[20]): Decimal
    var
        ReturnAmt: Decimal;
        QteM3: Decimal;
        UnitPrice: Decimal;
    begin

        QteM3 := CalcQtyM3(LigneTr."Item No.",LigneTr.Quantity,LigneTr."Unit of Measure Code");
        UnitPrice := GetProvisionsTransfertUnitPrice(EnteteTr."Location Code",
            TransferToCode,EnteteTr."Receipt Date",LigneTr."USD Unit Price",LigneTr."USD Rate");
        ReturnAmt := ReturnAmt + (QteM3 * UnitPrice);

        exit(Round(ReturnAmt,0.01));
    end;

    procedure GetProvisionsTransfertToAmbatovy(EnteteTr: Record "Posted Adjustment Header";LigneTr: Record "Posted Adjustment Line";TransferToCode: Code[20]): Decimal
    var
        ReturnAmt: Decimal;
        QteM3: Decimal;
        UnitPrice: Decimal;
    begin


        QteM3 := CalcQtyM3(LigneTr."Item No.",LigneTr.Quantity,LigneTr."Unit of Measure Code");
        UnitPrice := GetProvisionsTransfertToAmbatovyUnitPrice(EnteteTr."Location Code",
            TransferToCode,EnteteTr."Receipt Date",LigneTr."USD Unit Price",LigneTr."USD Rate",EnteteTr."Transporter Code");
        ReturnAmt := ReturnAmt + (QteM3 * UnitPrice);

        exit(Round(ReturnAmt,0.01));
    end;

    procedure GetProvisionsEchange(ItemAdj: Record "Adjustment Header";LigneAdj: Record "Adjustment Line";var USDPrice: Decimal;var USDRate: Decimal;var USDPrice2: Decimal): Decimal
    var
        ReturnAmt: Decimal;
        QteM3: Decimal;
        UnitPrice: Decimal;
        UnitPrice2: Decimal;
        GRTStorageFees: Decimal;
        LPSAStorageFees: Decimal;
    begin

        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."GRT Location Code");

        QteM3 := CalcQtyM3(LigneAdj."Item No.",LigneAdj.Quantity,LigneAdj."Unit of Measure Code");

        if LigneAdj."Exchange Type"=LigneAdj."Exchange Type"::Ship then begin
          //ItemAdj.TESTFIELD(ItemAdj."Cession Date");
          if ((LigneAdj."Exchange Transit Location"='') or (not LigneAdj."Exch Transit Transfer Fee")) then begin
            if ItemAdj."Cession Date"<>0D then
              UnitPrice:=GetProvisionsTransfertUnitPrice(AddOnSetup."GRT Location Code",
                LigneAdj."Location Code",ItemAdj."Cession Date",USDPrice,USDRate);
              UnitPrice2:=0;
              USDPrice2:=0;
           end else begin
              UnitPrice:=GetProvisionsTransfertUnitPrice(AddOnSetup."GRT Location Code",
                LigneAdj."Exchange Transit Location",ItemAdj."Cession Date",USDPrice,USDRate);

              UnitPrice2:=GetProvisionsTransfertUnitPrice(LigneAdj."Exchange Transit Location",
                LigneAdj."Location Code",ItemAdj."Cession Date",USDPrice2,USDRate);
          end;
          if ItemAdj."Cession Date"<>0D then begin
            if LigneAdj."GRT Storage Fee" then
              GRTStorageFees := GetProvisionsPassageUnitPrice(LigneAdj."Item No.",AddOnSetup."GRT Location Code",ItemAdj."Cession Date");
            if LigneAdj."LPSA Storage Fee" then
              LPSAStorageFees:= GetProvisionsPassageUnitPrice(LigneAdj."Item No.",LigneAdj."Location Code",ItemAdj."Cession Date");
          end;
        end;


        if LigneAdj."Exchange Type"=LigneAdj."Exchange Type"::Receive then begin
          //ItemAdj.TESTFIELD(ItemAdj."Receipt Date");
          if ((LigneAdj."Exchange Transit Location"='') or (not LigneAdj."Exch Transit Transfer Fee")) then begin
            if ItemAdj."Receipt Date"<>0D then
              UnitPrice:=GetProvisionsTransfertUnitPrice(AddOnSetup."GRT Location Code",
                LigneAdj."Location Code",ItemAdj."Receipt Date",USDPrice,USDRate);
              UnitPrice2:=0;
              USDPrice2:=0;
          end else begin
              UnitPrice:=GetProvisionsTransfertUnitPrice(AddOnSetup."GRT Location Code",
                LigneAdj."Exchange Transit Location",ItemAdj."Receipt Date",USDPrice,USDRate);

              UnitPrice2:=GetProvisionsTransfertUnitPrice(LigneAdj."Exchange Transit Location",
                LigneAdj."Location Code",ItemAdj."Receipt Date",USDPrice2,USDRate);
          end;
          if ItemAdj."Receipt Date"<>0D then begin
            if LigneAdj."GRT Storage Fee" then
              GRTStorageFees := GetProvisionsPassageUnitPrice(LigneAdj."Item No.",AddOnSetup."GRT Location Code",ItemAdj."Receipt Date");
            if LigneAdj."LPSA Storage Fee" then
              LPSAStorageFees:= GetProvisionsPassageUnitPrice(LigneAdj."Item No.",LigneAdj."Location Code",ItemAdj."Receipt Date");
          end;
        end;


        if not LigneAdj."GRT Storage Fee" then GRTStorageFees := 0;
        if not LigneAdj."LPSA Storage Fee" then LPSAStorageFees := 0;


        ReturnAmt := (QteM3*UnitPrice)+(QteM3*UnitPrice2)+(QteM3*GRTStorageFees)+(QteM3*LPSAStorageFees);


        exit(Round(ReturnAmt,0.01));
    end;

    procedure GetProvisionsPassageUnitPrice(ItemCode: Code[20];CodeDepot: Code[20];PostDate: Date): Decimal
    var
        LignePrix: Record "Item Charge Pricing";
        USDPrice: Decimal;
        USDRate: Decimal;
    begin
        //Date,Service Type,Item No.,Origin Location,Arrival Location
        LignePrix.Reset;
        LignePrix.SetFilter(LignePrix.Date,'..%1',PostDate);
        LignePrix.SetRange(LignePrix."Service Type",LignePrix."Service Type"::Storage);
        LignePrix.SetRange(LignePrix."Item No.",ItemCode);
        LignePrix.SetRange(LignePrix."Origin Location",CodeDepot);
        if LignePrix.FindLast then
          exit(GetLinePrice(LignePrix,PostDate,USDPrice,USDRate));



        LignePrix.Reset;
        LignePrix.SetFilter(LignePrix.Date,'..%1',PostDate);
        LignePrix.SetRange(LignePrix."Service Type",LignePrix."Service Type"::Storage);
        LignePrix.SetRange(LignePrix."Item No.",'');
        LignePrix.SetRange(LignePrix."Origin Location",CodeDepot);
        if LignePrix.FindLast then
          exit(GetLinePrice(LignePrix,PostDate,USDPrice,USDRate));


        Error(Text002,CodeDepot);
    end;

    procedure GetProvisionsTransfertUnitPrice(DepotOrigin: Code[10];DepotDestination: Code[10];PostingDate: Date;var USDPrice: Decimal;var USDRate: Decimal): Decimal
    var
        LignePrix: Record "Item Charge Pricing";
    begin
        //Date,Service Type,Item No.,Origin Location,Arrival Location

        if PostingDate=0D then exit(0);
        if DepotDestination=DepotOrigin then exit(0);

        //EnteteTr.TESTFIELD(EnteteTr."Location Code");
        //EnteteTr.TESTFIELD(EnteteTr."Transfer-to Code");

        LignePrix.Reset;
        LignePrix.SetFilter(LignePrix.Date,'..%1',PostingDate);
        LignePrix.SetRange(LignePrix."Service Type",LignePrix."Service Type"::Transport);
        //LignePrix.SETRANGE(LignePrix."Item No.",LigneBe.NavItemCode);
        LignePrix.SetRange(LignePrix."Origin Location",DepotOrigin);
        LignePrix.SetRange(LignePrix."Arrival Location",DepotDestination);
        if LignePrix.FindLast then
          exit(GetLinePrice(LignePrix,PostingDate,USDPrice,USDRate));


        Error(Text003,DepotOrigin,DepotDestination);
    end;

    procedure GetProvisionsTransfertToAmbatovyUnitPrice(DepotOrigin: Code[10];DepotDestination: Code[10];PostingDate: Date;var USDPrice: Decimal;var USDRate: Decimal;VendorCode: Code[20]): Decimal
    var
        LignePrix: Record "Item Charge Pricing";
    begin
        //Date,Service Type,Item No.,Origin Location,Arrival Location

        if PostingDate=0D then exit(0);
        if DepotDestination=DepotOrigin then exit(0);

        LignePrix.Reset;
        LignePrix.SetFilter(LignePrix.Date,'..%1',PostingDate);
        LignePrix.SetRange(LignePrix."Service Type",LignePrix."Service Type"::TransportAmbatovy);
        LignePrix.SetRange(LignePrix."Vendor Code",VendorCode);
        LignePrix.SetRange(LignePrix."Origin Location",DepotOrigin);
        LignePrix.SetRange(LignePrix."Arrival Location",DepotDestination);
        if LignePrix.FindLast then
          exit(GetLinePrice(LignePrix,PostingDate,USDPrice,USDRate));


        //ERROR(Text003,DepotOrigin,DepotDestination);
    end;

    local procedure GetLinePrice(LineP: Record "Item Charge Pricing";PostingDate: Date;var USDPrice: Decimal;var USDRate: Decimal): Decimal
    var
        LPSARate: Record "LPSA Exchange Rate";
        DebutMois: Date;
        FinMoisPrec: Date;
        FiltreDeb: Date;
        FiltreFin: Date;
    begin

        DebutMois :=  GetDebutMois(PostingDate);
        FinMoisPrec := CalcDate('<-1D>',DebutMois);
        FiltreDeb := GetDebutMois(FinMoisPrec);
        FiltreFin := FinMoisPrec;

        LPSARate.Reset;
        LPSARate.SetRange(LPSARate."Currency Code",LineP."Currency Code");
        LPSARate.SetRange(LPSARate.Date,FiltreDeb,FiltreFin);
        if not LPSARate.FindFirst then Error(Text001,FiltreDeb,FiltreFin,LineP."Currency Code");

        USDRate := LPSARate."Exchange Rate";
        USDPrice := LineP.Price;

        exit(Round((LineP.Price*LPSARate."Exchange Rate")-LineP.Discount,0.01));
    end;

    procedure GetDebutMois(DateRef: Date): Date
    begin
        if DateRef<>0D then
           exit(DMY2Date(1,Date2DMY(DateRef,2),Date2DMY(DateRef,3)));   //Debut de l'année de DateRef - AnneeRef
    end;

    procedure GetFinMois(DateRef: Date): Date
    begin
        //IF DateRef<>0D THEN
        //   EXIT(CALCDATE('<1M>',DateRef)-1);
        exit(CalcDate('<1M>',GetDebutMois(DateRef)));         //Fin de l'année de paie
    end;

    procedure CalcQtyM3(ItemCode: Code[20];Qty: Decimal;CodeUnite: Code[10]): Decimal
    var
        QtyPerUnit: Decimal;
    begin
        Item.Get(ItemCode);
        QtyPerUnit := UOMMgt.GetQtyPerUnitOfMeasure(Item,CodeUnite);
        exit(Round((Qty * QtyPerUnit)/1000,0.00001));
    end;

    procedure GetProvisionsPassage_270818(EnteteBE: Record pro_enteteBE;LigneBE: Record pro_detailBE): Decimal
    var
        ReturnAmt: Decimal;
        QteM3: Decimal;
    begin
        
        /*LigneBE.RESET;
        LigneBE.SETRANGE(LigneBE.numBE,EnteteBE.numBE);
        IF LigneBE.FINDSET THEN REPEAT
        
          QteM3 := CalcQtyM3(LigneBE.NavItemCode,LigneBE.volumeenleve,LigneBE."Unit of Measure Code");
          ReturnAmt := ReturnAmt+ (QteM3 * GetProvisionsPassageUnitPrice(LigneBE.NavItemCode,EnteteBE.depot,EnteteBE.dateBE));
        
        UNTIL LigneBE.NEXT=0;*/
        
        QteM3 := CalcQtyM3(LigneBE.NavItemCode,LigneBE.volumeenleve,LigneBE."Unit of Measure Code");
        ReturnAmt := ReturnAmt+ (QteM3 * GetProvisionsPassageUnitPrice(LigneBE.NavItemCode,EnteteBE.depot,EnteteBE.dateBE));
        
        exit(Round(ReturnAmt,0.01));

    end;

    procedure GetJiramaSiteUnitPrice(CustomerNo: Code[20];ShipToCode: Code[10];PostingDate: Date;"Item No": Code[20]): Decimal
    var
        LignePrix: Record "Item Charge Pricing";
    begin

        if PostingDate=0D then exit(0);

        LignePrix.Reset;
        LignePrix.SetFilter(Date,'..%1',PostingDate);
        LignePrix.SetRange("Service Type",LignePrix."Service Type"::JiramaSite);
        LignePrix.SetRange("Item No.","Item No");
        LignePrix.SetRange("Customer No",CustomerNo);
        LignePrix.SetRange("Ship-to Code",ShipToCode);
        if LignePrix.FindLast then
          exit(LignePrix.Price);
    end;
}

