codeunit 50018 "AMSA Sales mgt"
{
    // MANGO RIVER
    // SS AMBATOVY
    // CENTRALE ELECTRIQUE
    // //JN020518 Prendre le dernier prix saisi pour AMSA


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Prix de vente AMSA non définis pour l''article %1 pour la date du %2';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement terminé !';
        Text006: Label 'Traitement terminé.\%1 facture(s) créée(s)';
        Text007: Label 'Il n''ya rien à facturer';
        Text002: Label 'Voulez-vous créer les factures pour ce document ?';
        Text003: Label 'Voulez-vous archiver ce document ?';
        Text009: Label 'Traitement terminé.Une facture créée';

    procedure CreateInvoices(var FSHeader: Record "Fuel Statement Header")
    var
        FSLine: Record "Fuel Statement Line";
        ImportedLine: Record "Posted Moneytech Import Line";
        LineNum: Integer;
        NbreLignes: Integer;
        CurrentDate: Date;
        CurrentCostCode: Code[20];
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        EquipType: Option Mobile,Fixe;
        BackCharge: Option " ",Yes,No;
        CostCode: Code[20];
        Process: Option " ",Yes,No;
        CompanyCode: Code[30];
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
    begin

        //Création des factures SS AMBATOVY à partir du Fuel Statement

        FSHeader.TestField(FSHeader."Item No.");
        FSHeader.TestField(FSHeader."Location Code");
        FSHeader.TestField(FSHeader."Customer No");
        FSHeader.CheckInvoices;

        if not Confirm(Text002) then exit;

        FillInvBuffer(FSHeader,InvPostBuffer);


        //LineNo := 0;
        BesoinNo :=0;
        Window.Open(Text008);


        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,FSHeader."No.");
        if InvPostBuffer.FindSet then begin
          NbreTotalLignes:=FSLine.Count;
          repeat

              BesoinNo := BesoinNo + 1;
              Window.Update(1,
              Round(BesoinNo / NbreTotalLignes * 10000,1));

            if (
                (CurrentDate<>InvPostBuffer."Posting Date") or (CurrentCostCode<>InvPostBuffer."Cost Code")
                or (EquipType<>InvPostBuffer."Equipment Type") or (BackCharge<>InvPostBuffer.Backcharge)
                or (Process<>InvPostBuffer.Process) or (CompanyCode<>InvPostBuffer."Company Code")
              )then begin
                AddNewInvoice(FSHeader,InvPostBuffer."Posting Date",InvPostBuffer."Equipment Type",InvPostBuffer.Backcharge,
                  InvPostBuffer."Cost Code",InvPostBuffer.Process,InvPostBuffer."Company Code");

              NbreLignes := NbreLignes + 1;
              CurrentDate := InvPostBuffer."Posting Date";
              CurrentCostCode := InvPostBuffer."Cost Code";
              EquipType:=InvPostBuffer."Equipment Type";
              BackCharge:=InvPostBuffer.Backcharge;
              Process:=InvPostBuffer.Process;
              CompanyCode:=InvPostBuffer."Company Code";

            end;

          until InvPostBuffer.Next=0;
        end;
        if NbreLignes=0 then Error(Text007);

        //PostFSHeader(FSHeader);


        Window.Close;
        Message(Text006,NbreLignes);
    end;

    local procedure FillInvBuffer(var FSHeader: Record "Fuel Statement Header";var InvPostBuffer: Record "AMSA Inv. Post Buffer")
    var
        FSLine: Record "Fuel Statement Line";
        EquipType: Option Mobile,Fixe;
        BackCharge: Option " ",Yes,No;
        CostCode: Code[20];
        Process: Option " ",Yes,No;
        CompanyCode: Code[30];
        SourceAppro: Option Station,Tanker;
        Qty: Decimal;
        InvoiceNo: Integer;
    begin

        //CLEAR(InvPostBuffer);
        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,FSHeader."No.");
        InvPostBuffer.DeleteAll;



        FSLine.Reset;
        FSLine.SetRange("Document Type",FSHeader."Document Type"::FS);
        FSLine.SetRange("Document No.",FSHeader."No.");
        if FSLine.FindSet then repeat

          GetParametersLine(FSLine,EquipType,BackCharge,CostCode,Process,CompanyCode,SourceAppro,Qty);
          InsertInvBuffer( FSHeader."No.",FSLine.DateRefuel,EquipType,BackCharge,CostCode,Process,CompanyCode,SourceAppro,Qty,InvoiceNo);

        until FSLine.Next=0;
    end;

    local procedure InsertInvBuffer(FSNumber: Code[20];PostDate: Date;EquipType: Option Mobile,Fixe;BackCharge: Option " ",Yes,No;CostCode: Code[20];Process: Option " ",Yes,No;CompanyCode: Code[30];SourceAppro: Option Station,Tanker;Qty: Decimal;var InvNo: Integer)
    var
        FSLine: Record "Fuel Statement Line";
        MaxInvId: Integer;
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
    begin

        //Posting Date,Equipment Type,Backcharge,Cost Code,Company Code,Process,Invoice Id,Source Appro


        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,FSNumber);
        InvPostBuffer.SetRange(InvPostBuffer."Posting Date",PostDate);
        InvPostBuffer.SetRange(InvPostBuffer."Equipment Type",EquipType);
        InvPostBuffer.SetRange(InvPostBuffer.Backcharge,BackCharge);
        InvPostBuffer.SetRange(InvPostBuffer."Cost Code",CostCode);
        InvPostBuffer.SetRange(InvPostBuffer."Company Code",CompanyCode);
        InvPostBuffer.SetRange(InvPostBuffer.Process,Process);
        InvPostBuffer.SetRange(InvPostBuffer."Source Appro",SourceAppro);
        if InvPostBuffer.FindFirst then begin

          InvPostBuffer."Invoice Qty" := InvPostBuffer."Invoice Qty" + Qty;
          InvPostBuffer.Modify;

        end else begin

            InvPostBuffer.Init;
            InvPostBuffer.FSNumber := FSNumber;
            InvPostBuffer."Equipment Type" := EquipType;
            InvPostBuffer.Backcharge := BackCharge;
            InvPostBuffer."Company Code" := CompanyCode;
            InvPostBuffer."Cost Code" := CostCode;
            InvPostBuffer.Process := Process;
            InvPostBuffer."Invoice Qty" := Qty;
            InvPostBuffer."Posting Date" := PostDate;
            InvPostBuffer."Source Appro" := SourceAppro;
            InvPostBuffer.Insert;

        end;
    end;

    local procedure GetParametersLine(var FSLine: Record "Fuel Statement Line";var EquipType: Option Mobile,Fixe;var BackCharge: Option " ",Yes,No;var CostCode: Code[20];var Process: Option " ",Yes,No;var CompanyCode: Code[30];var SourceAppro: Option Station,Tanker;var Qty: Decimal)
    var
        AMSAConfig: Record "AMSA Invoicing Configuration";
        AMSACong2: Record "AMSA Invoicing Configuration";
    begin

        Qty := FSLine."Total Counter";
        SourceAppro := FSLine."Source Appro";


        AMSAConfig.Reset;
        AMSAConfig.SetRange(AMSAConfig."Equipment Type",FSLine."Equipment Type");
        if FSLine.BackCharge then
          AMSAConfig.SetRange(AMSAConfig.Backcharge,AMSAConfig.Backcharge::Yes)
        else
          AMSAConfig.SetRange(AMSAConfig.Backcharge,AMSAConfig.Backcharge::No);
        AMSAConfig.SetRange(AMSAConfig."Cost Code",FSLine."Cost Code");
        if AMSAConfig.FindFirst then begin
          EquipType := FSLine."Equipment Type";
          if FSLine.BackCharge then
            BackCharge := BackCharge::Yes
          else
            BackCharge := BackCharge::No;
          CostCode := FSLine."Cost Code";
          GetAddParamsLine2(FSLine,AMSAConfig,Process,CompanyCode);
          exit;
        end;



        AMSAConfig.Reset;
        AMSAConfig.SetRange(AMSAConfig."Equipment Type",FSLine."Equipment Type");
        if FSLine.BackCharge then
          AMSAConfig.SetRange(AMSAConfig.Backcharge,AMSAConfig.Backcharge::Yes)
        else
          AMSAConfig.SetRange(AMSAConfig.Backcharge,AMSAConfig.Backcharge::No);
        AMSAConfig.SetRange(AMSAConfig."Cost Code",'');
        if AMSAConfig.FindFirst then begin
          EquipType := FSLine."Equipment Type";
          if FSLine.BackCharge then
            BackCharge := BackCharge::Yes
          else
            BackCharge := BackCharge::No;
          GetAddParamsLine(FSLine,AMSAConfig,CostCode,Process,CompanyCode);
          exit;
        end;



        AMSAConfig.Reset;
        AMSAConfig.SetRange(AMSAConfig."Equipment Type",FSLine."Equipment Type");
        AMSAConfig.SetRange(AMSAConfig.Backcharge,AMSAConfig.Backcharge::" ");
        AMSAConfig.SetRange(AMSAConfig."Cost Code",FSLine."Cost Code");
        if AMSAConfig.FindFirst then begin
          EquipType := FSLine."Equipment Type";
          BackCharge := BackCharge::" ";
          CostCode := FSLine."Cost Code";
          GetAddParamsLine2(FSLine,AMSAConfig,Process,CompanyCode);
          exit;
        end;


        AMSAConfig.Reset;
        AMSAConfig.SetRange(AMSAConfig."Equipment Type",FSLine."Equipment Type");
        AMSAConfig.SetRange(AMSAConfig.Backcharge,AMSAConfig.Backcharge::" ");
        AMSAConfig.SetRange(AMSAConfig."Cost Code",'');
        if AMSAConfig.FindFirst then begin
          EquipType := FSLine."Equipment Type";
          BackCharge := BackCharge::" ";
          GetAddParamsLine(FSLine,AMSAConfig,CostCode,Process,CompanyCode);
          exit;
        end;
    end;

    local procedure GetAddParamsLine(FSLine: Record "Fuel Statement Line";var AMSAConfig: Record "AMSA Invoicing Configuration";var CostCode: Code[20];var Process: Option " ",Yes,No;var CompanyCode: Code[30])
    begin

        if AMSAConfig."Per Company" then
          CompanyCode := FSLine.Company
        else
          CompanyCode := '';

        if AMSAConfig."Per Cost Code" then
          CostCode := FSLine."Cost Code"
        else
          CostCode := '';

        if AMSAConfig."Per Process" then begin
          if FSLine.Process then
            Process := Process::Yes
          else
            Process := Process::No
        end else begin
          Process := Process::" ";
        end;
    end;

    local procedure GetAddParamsLine2(FSLine: Record "Fuel Statement Line";var AMSAConfig: Record "AMSA Invoicing Configuration";var Process: Option " ",Yes,No;var CompanyCode: Code[30])
    begin

        if AMSAConfig."Per Company" then
          CompanyCode := FSLine.Company
        else
          CompanyCode := '';



        if AMSAConfig."Per Process" then begin
          if FSLine.Process then
            Process := Process::Yes
          else
            Process := Process::No
        end else begin
          Process := Process::" ";
        end;
    end;

    local procedure AddNewInvoice(var FSHeader: Record "Fuel Statement Header";PostDate: Date;EquipType: Option Mobile,Fixe;BackCharge: Option " ",Yes,No;CostCode: Code[20];Process: Option " ",Yes,No;CompanyCode: Code[30])
    var
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        LineNum: Integer;
        FSLine: Record "Fuel Statement Line";
        UnitPrice: Decimal;
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
    begin

        SalesOrderHeader.Init;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Invoice;
        SalesOrderHeader."No." := '';

        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        //SalesOrderHeader.VALIDATE(SalesOrderHeader."Sell-to Customer No.",FSHeader."Customer No");
        //SalesOrderHeader."Delivery Status" := SalesOrderHeader."Delivery Status"::AttenteLivraison;

        SalesOrderHeader.Validate("Sell-to Customer No.",FSHeader."Customer No");

        SalesOrderHeader."External Document No." := FSHeader."No.";
        //SalesOrderHeader."AMSA Cost Code" := CostCode;
        SalesOrderHeader."Document Date" := WorkDate;
        SalesOrderHeader."Created By Doc No." := FSHeader."No.";
        SalesOrderHeader."Created By Doc Type" := SalesOrderHeader."Created By Doc Type"::AMSA;
        SalesOrderHeader."Location Code" := FSHeader."Location Code";
        SalesOrderHeader.Validate("Posting Date" , PostDate);
        //SalesOrderHeader."Posting Date" := InvPostBuffer."Posting Date";

        SalesOrderHeader.Modify;

        //AddOnSetup.GET;
        //AddOnSetup.TESTFIELD(AddOnSetup."Postpaid Cards Account");



        //Ligne
        LineNum:=0;
        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,FSHeader."No.");
        InvPostBuffer.SetRange(InvPostBuffer."Posting Date",PostDate);
        InvPostBuffer.SetRange(InvPostBuffer."Equipment Type",EquipType);
        InvPostBuffer.SetRange(InvPostBuffer.Backcharge,BackCharge);
        InvPostBuffer.SetRange(InvPostBuffer."Cost Code",CostCode);
        InvPostBuffer.SetRange(InvPostBuffer."Company Code",CompanyCode);
        InvPostBuffer.SetRange(InvPostBuffer.Process,Process);
        //InvPostBuffer.SETRANGE(InvPostBuffer."Source Appro",SourceAppro);
        if InvPostBuffer.FindSet then repeat

          SalesOrderLine.Init;
          SalesOrderLine."Document Type" := SalesOrderLine."Document Type"::Invoice;
          SalesOrderLine."Document No." := SalesOrderHeader."No.";
          LineNum := LineNum + 10;
          SalesOrderLine."Line No.":=LineNum;
          SalesOrderLine.Insert(true);

          SalesOrderLine.Type := SalesOrderLine.Type::Item;

          SalesOrderLine.Validate(SalesOrderLine."No.",FSHeader."Item No.");
          SalesOrderLine.Validate(SalesOrderLine."Location Code",FSHeader."Location Code");
          SalesOrderLine.Validate(SalesOrderLine.Quantity,InvPostBuffer."Invoice Qty");
          UnitPrice := GetSalesPrice(FSHeader,InvPostBuffer."Posting Date",InvPostBuffer."Source Appro");
          SalesOrderLine.Validate(SalesOrderLine."Unit Price",UnitPrice);
          SalesOrderLine."AMSA Source Type" := InvPostBuffer."Source Appro";
          SalesOrderLine."AMSA BackCharge" := InvPostBuffer.Backcharge;
          SalesOrderLine."AMSA Company Code" := InvPostBuffer."Company Code";
          SalesOrderLine."AMSA Cost Code" := InvPostBuffer."Cost Code";
          SalesOrderLine."AMSA Equipment Type" := InvPostBuffer."Equipment Type";
          SalesOrderLine."AMSA Process" := InvPostBuffer.Process;
          SalesOrderLine.IsAMSA := true;

          SalesOrderLine.Modify;

        until InvPostBuffer.Next=0;
    end;

    procedure ArchiveFuelStatement(var FSHeader: Record "Fuel Statement Header")
    var
        PostedFS: Record "Posted Fuel Statement";
        PostedFSLine: Record "Posted Fuel Statement Line";
        FSLine: Record "Fuel Statement Line";
    begin

        //IF NOT BillingHeader.GET(CodeImport) THEN EXIT;

        if not Confirm(Text003) then exit;

        //Transferer le document
        PostedFSLine.LockTable();
        PostedFS.Init();
        PostedFS.TransferFields(FSHeader);
        PostedFS.Status:= PostedFS.Status::Validated;
        PostedFS.Insert;



        //Lignes Fuel Statement
        FSLine.Reset();
        FSLine.SetRange(FSLine."Document Type",FSLine."Document Type"::FS);
        FSLine.SetRange("Document No.",FSHeader."No.");
        if FSLine.FindSet then repeat

            PostedFSLine.Init();
            PostedFSLine.TransferFields(FSLine);
            PostedFSLine.Insert;

         until FSLine.Next=0;

        FSHeader.SetIsAuto(true);
        FSHeader.Delete(true);
    end;

    local procedure GetSalesPrice(FSHeader: Record "Fuel Statement Header";PostingDate: Date;SourceAppro: Option Station,Tanker): Decimal
    var
        SalesPrice: Record "AMSA Sales Price";
    begin
        FSHeader.TestField(FSHeader."Item No.");
        //FSHeader.TESTFIELD(FSHeader."Posting Date");

        //JN020518
        SalesPrice.Reset;
        SalesPrice.SetRange(SalesPrice."Source Type",SourceAppro);
        SalesPrice.SetRange(SalesPrice."Item No.",FSHeader."Item No.");
        //SalesPrice.SETFILTER(SalesPrice."Starting Date",'<=%1',FSLine.DateRefuel);
        SalesPrice.SetFilter(SalesPrice."Starting Date",'<=%1',PostingDate);
        if not SalesPrice.FindLast then
          Error(Text001,FSHeader."Item No.",PostingDate);

        exit(SalesPrice."Unit Price");
    end;

    procedure CreateAMSAInvoices(var AMSAMainInvoice: Record "Fuel Statement Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
        LineNum: Integer;
        NbreLignes: Integer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        CurrentDate: Date;
        CurrentCostCode: Code[20];
        EquipType: Option Mobile,Fixe;
        BackCharge: Option " ",Yes,No;
        CostCode: Code[20];
        Process: Option " ",Yes,No;
        CompanyCode: Code[30];
        InvoiceAMSA: Record "Fuel Statement Header";
        LigneFactureAMSA: Record "AMSA Invoice Line";
        SalesInvH: Record "Sales Invoice Header";
        num: Integer;
        CustFilter: Text[1024];
        AMSAInvHeader: Record "Fuel Statement Header";
        AMSAInvLine: Record "AMSA Invoice Line";
        Item1: Record Item;
    begin

        //Création des sous factures pour Mango RIVER et Centrale electrique
        //Regroupement simple de factures NAV
        //260117 Une seule facture à créer, regroupement effectuée lors de l'impression


        //LineNo := 0;
        BesoinNo := 0;
        Window.Open(Text008);


        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,AMSAMainInvoice."No.");
        InvPostBuffer.DeleteAll;


        DeleteRelateDocsMainInvoice(AMSAMainInvoice);


        //Création de la facture unique
        AMSAInvHeader.Init;
        AMSAInvHeader."Document Type" := AMSAInvHeader."Document Type"::Invoice;
        AMSAInvHeader."No." := '';

        AMSAInvLine.LockTable;
        AMSAInvHeader.Insert(true);


        AMSAInvHeader."Customer No" := AMSAMainInvoice."Customer No";
        AMSAInvHeader."Customer Name" := AMSAMainInvoice."Customer Name";
        AMSAInvHeader."Grouping Type" := AMSAMainInvoice."Grouping Type";
        AMSAInvHeader."Grouping Customer" := AMSAMainInvoice."Grouping Customer";
        AMSAInvHeader."Item No." := AMSAMainInvoice."Item No.";
        AMSAInvHeader."Parent Invoice No." := AMSAMainInvoice."No.";

        AMSAInvHeader."Starting Date" := AMSAMainInvoice."Starting Date";
        AMSAInvHeader."Ending Date" := AMSAMainInvoice."Ending Date";
        AMSAInvHeader.Backcharge := BackCharge;
        AMSAInvHeader."Company Code" := CompanyCode;
        AMSAInvHeader."Cost Code" := CostCode;
        AMSAInvHeader."Equipment Type" := EquipType;
        AMSAInvHeader.Process := Process;
        AMSAInvHeader."Posting Date" := WorkDate;

        AMSAInvHeader.Modify;




        num := 0;LineNum:=0;

        AMSAMainInvoice.TestField("Grouping Customer");
        CustFilter := GetAMSACustFilter(AMSAMainInvoice);

        SalesInvLine.Reset;
        //SalesInvLine.SETCURRENTKEY(IsAMSA,"Posting Date");
        //SalesInvLine.SETRANGE(SalesInvLine.IsAMSA,TRUE);
        //Sell-to Customer No.,Type,No.,Posting Date
        SalesInvLine.SetCurrentKey("Sell-to Customer No.",Type,"No.","Posting Date");
        //SalesInvLine.SETRANGE("Sell-to Customer No.",AMSAMainInvoice."Customer No");
        SalesInvLine.SetFilter("Sell-to Customer No.",CustFilter);
        SalesInvLine.SetRange(Type,SalesInvLine.Type::Item);
        SalesInvLine.SetRange("No.",AMSAMainInvoice."Item No.");
        SalesInvLine.SetRange("Posting Date",AMSAMainInvoice."Starting Date",AMSAMainInvoice."Ending Date");
        if SalesInvLine.FindSet then
        repeat


          AMSAInvLine.Init;
          AMSAInvLine."Document Type" := AMSAInvLine."Document Type"::Invoice;
          AMSAInvLine."Document No." := AMSAInvHeader."No.";
          LineNum := LineNum + 10;
          AMSAInvLine."Line No." := LineNum;
          //AMSAInvLine.INSERT(TRUE);

          AMSAInvLine.Amount := SalesInvLine.Amount;;
          AMSAInvLine."Item No" := AMSAInvHeader."Item No.";
          Item1.Get(AMSAInvHeader."Item No.");
          AMSAInvLine."Item Name" := Item1.Description;
          AMSAInvLine."VAT Amount" := SalesInvLine."Amount Including VAT"-SalesInvLine.Amount;
          AMSAInvLine."Unit Price" := SalesInvLine."Unit Price";
          AMSAInvLine."Invoice Qty" := SalesInvLine.Quantity;
          AMSAInvLine."Invoice Ref" := SalesInvLine."Document No.";

          if SalesInvH.Get(SalesInvLine."Document No.") then begin
            if SalesInvH."Order No."<>'' then
              AMSAInvLine."Order Ref" := SalesInvH."Order No."
            else
              AMSAInvLine."Order Ref" := CopyStr( SalesInvH."Your Reference",1,20);
          end;

          //AMSAInvLine."Order Ref" := InvPostBuffer."Order No";
          AMSAInvLine."Amount Incl. VAT" := SalesInvLine."Amount Including VAT";
          AMSAInvLine."Posting Date" := SalesInvLine."Posting Date";
          AMSAInvLine.Process := SalesInvLine."AMSA Process";
          AMSAInvLine."Customer No" := SalesInvH."Sell-to Customer No.";

          SalesInvH.CalcFields(Closed,SalesInvH.Cancelled);
          if ((not SalesInvH.Closed) and (not SalesInvH.Cancelled)) then begin
            AMSAInvLine.Insert;NbreLignes:=NbreLignes+1;
          end;
          //AMSAInvLine.MODIFY;

        until SalesInvLine.Next=0;


        if NbreLignes=0 then Error(Text007);



        Window.Close;
        Message(Text009);
    end;

    procedure CreateInvoices_CentraleMangoRiver(var AMSAMainInvoice: Record "Fuel Statement Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
        LineNum: Integer;
        NbreLignes: Integer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        CurrentDate: Date;
        CurrentCostCode: Code[20];
        EquipType: Option Mobile,Fixe;
        BackCharge: Option " ",Yes,No;
        CostCode: Code[20];
        Process: Option " ",Yes,No;
        CompanyCode: Code[30];
        InvoiceAMSA: Record "Fuel Statement Header";
        LigneFactureAMSA: Record "AMSA Invoice Line";
        SalesInvH: Record "Sales Invoice Header";
        AMSAInvHeader: Record "Fuel Statement Header";
        AMSAInvLine: Record "AMSA Invoice Line";
        Item1: Record Item;
        CustFilter: Text[1024];
    begin

        //Création des sous Factures pour AMBATOVY

        //IsAMSA,Posting Date,AMSA Equipment Type,AMSA BackCharge,AMSA Cost Code,AMSA Company Code,AMSA Process


        //LineNo := 0;
        BesoinNo :=0;
        Window.Open(Text008);

        AMSAMainInvoice.TestField(AMSAMainInvoice."Grouping Customer");
        AMSAMainInvoice.TestField(AMSAMainInvoice."Customer No");
        AMSAMainInvoice.TestField(AMSAMainInvoice."Item No.");

        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,AMSAMainInvoice."No.");
        InvPostBuffer.DeleteAll;


        DeleteRelateDocsMainInvoice(AMSAMainInvoice);





        //Sous facture pour la période

        AMSAInvHeader.Init;
        AMSAInvHeader."Document Type" := AMSAInvHeader."Document Type"::Invoice;
        AMSAInvHeader."No." := '';
        AMSAInvLine.LockTable;
        AMSAInvHeader.Insert(true);

        AMSAInvHeader."Customer No" := AMSAMainInvoice."Customer No";
        AMSAInvHeader."Customer Name" := AMSAMainInvoice."Customer Name";
        AMSAInvHeader."Grouping Type" := AMSAMainInvoice."Grouping Type";
        AMSAInvHeader."Grouping Customer" := AMSAMainInvoice."Grouping Customer";
        AMSAInvHeader."Item No." := AMSAMainInvoice."Item No.";
        AMSAInvHeader."Parent Invoice No." := AMSAMainInvoice."No.";

        AMSAInvHeader."Starting Date" := AMSAMainInvoice."Starting Date";
        AMSAInvHeader."Ending Date" := AMSAMainInvoice."Ending Date";
        // AMSAInvHeader.Backcharge := BackCharge;
        // AMSAInvHeader."Company Code" := CompanyCode;
        // AMSAInvHeader."Cost Code" := CostCode;
        // AMSAInvHeader."Equipment Type" := EquipType;
        // AMSAInvHeader.Process := Process;
        AMSAInvHeader."Posting Date" := WorkDate;

        AMSAInvHeader.Modify;



        CustFilter := GetAMSACustFilter(AMSAMainInvoice);

        //Ligne
        LineNum:=0;
        SalesInvLine.Reset;
        //SalesInvLine.SETCURRENTKEY(IsAMSA,"Posting Date");
        //SalesInvLine.SETRANGE(SalesInvLine.IsAMSA,TRUE);
        //Sell-to Customer No.,Type,No.,Posting Date
        SalesInvLine.SetCurrentKey("Sell-to Customer No.",Type,"No.","Posting Date");
        //SalesInvLine.SETRANGE("Sell-to Customer No.",AMSAMainInvoice."Customer No");
        SalesInvLine.SetFilter("Sell-to Customer No.",CustFilter);
        SalesInvLine.SetRange(Type,SalesInvLine.Type::Item);
        SalesInvLine.SetRange("No.",AMSAMainInvoice."Item No.");
        SalesInvLine.SetRange("Posting Date",AMSAMainInvoice."Starting Date",AMSAMainInvoice."Ending Date");
        if SalesInvLine.FindSet then
        repeat

          AMSAInvLine.Init;
          AMSAInvLine."Document Type" := AMSAInvLine."Document Type"::Invoice;
          AMSAInvLine."Document No." := AMSAInvHeader."No.";
          LineNum := LineNum + 10;
          AMSAInvLine."Line No." := LineNum;
          AMSAInvLine.Insert(true);

          AMSAInvLine.Amount := SalesInvLine.Amount;
          AMSAInvLine."Item No" := AMSAInvHeader."Item No.";
          Item1.Get(AMSAInvHeader."Item No.");
          AMSAInvLine."Item Name" := Item1.Description;
          AMSAInvLine."VAT Amount" := SalesInvLine."Amount Including VAT" - SalesInvLine.Amount;
          AMSAInvLine."Unit Price" := SalesInvLine."Unit Price";
          AMSAInvLine."Invoice Qty" := SalesInvLine.Quantity;
          AMSAInvLine."Invoice Ref" := SalesInvLine."Document No.";

          if SalesInvH.Get(SalesInvLine."Document No.") then begin
            AMSAInvLine."Order Ref" := SalesInvH."Order No.";
            AMSAInvLine."Customer No" := SalesInvH."Sell-to Customer No.";
          end;

          AMSAInvLine."Amount Incl. VAT" := SalesInvLine."Amount Including VAT";
          AMSAInvLine."Posting Date" := SalesInvLine."Posting Date";

          AMSAInvLine.Modify;
          NbreLignes:=NbreLignes+1;

        until SalesInvLine.Next=0;


        if NbreLignes=0 then Error(Text007);

        //PostFSHeader(FSHeader);


        Window.Close;
        Message(Text006,NbreLignes);
    end;

    local procedure AddNewAMSAInvoice(var AMSAMainInvoice: Record "Fuel Statement Header";EquipType: Option Mobile,Fixe;BackCharge: Option " ",Yes,No;CostCode: Code[20];Process: Option " ",Yes,No;CompanyCode: Code[30])
    var
        AMSAInvHeader: Record "Fuel Statement Header";
        AMSAInvLine: Record "AMSA Invoice Line";
        LineNum: Integer;
        FSLine: Record "Fuel Statement Line";
        UnitPrice: Decimal;
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
        Item1: Record Item;
    begin

        AMSAInvHeader.Init;
        AMSAInvHeader."Document Type" := AMSAInvHeader."Document Type"::Invoice;
        AMSAInvHeader."No." := '';

        AMSAInvLine.LockTable;
        AMSAInvHeader.Insert(true);


        AMSAInvHeader."Customer No" := AMSAMainInvoice."Customer No";
        AMSAInvHeader."Customer Name" := AMSAMainInvoice."Customer Name";
        AMSAInvHeader."Grouping Type" := AMSAMainInvoice."Grouping Type";
        AMSAInvHeader."Grouping Customer" := AMSAMainInvoice."Grouping Customer";
        AMSAInvHeader."Item No." := AMSAMainInvoice."Item No.";
        AMSAInvHeader."Parent Invoice No." := AMSAMainInvoice."No.";

        AMSAInvHeader."Starting Date" := AMSAMainInvoice."Starting Date";
        AMSAInvHeader."Ending Date" := AMSAMainInvoice."Ending Date";
        AMSAInvHeader.Backcharge := BackCharge;
        AMSAInvHeader."Company Code" := CompanyCode;
        AMSAInvHeader."Cost Code" := CostCode;
        AMSAInvHeader."Equipment Type" := EquipType;
        AMSAInvHeader.Process := Process;
        AMSAInvHeader."Posting Date" := WorkDate;

        AMSAInvHeader.Modify;



        //Ligne
        LineNum:=0;
        InvPostBuffer.Reset;
        InvPostBuffer.SetCurrentKey(FSNumber,"Equipment Type",Backcharge,"Cost Code","Company Code",Process);
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,AMSAMainInvoice."No.");
        //InvPostBuffer.SETRANGE(InvPostBuffer."Posting Date",PostDate);
        InvPostBuffer.SetRange(InvPostBuffer."Equipment Type",EquipType);
        InvPostBuffer.SetRange(InvPostBuffer.Backcharge,BackCharge);
        InvPostBuffer.SetRange(InvPostBuffer."Cost Code",CostCode);
        InvPostBuffer.SetRange(InvPostBuffer."Company Code",CompanyCode);
        InvPostBuffer.SetRange(InvPostBuffer.Process,Process);
        //InvPostBuffer.SETRANGE(InvPostBuffer."Source Appro",SourceAppro);
        if InvPostBuffer.FindSet then repeat

          AMSAInvLine.Init;
          AMSAInvLine."Document Type" := AMSAInvLine."Document Type"::Invoice;
          AMSAInvLine."Document No." := AMSAInvHeader."No.";
          LineNum := LineNum + 10;
          AMSAInvLine."Line No." := LineNum;
          AMSAInvLine.Insert(true);

          AMSAInvLine.Amount := InvPostBuffer.Amount;
          AMSAInvLine."Item No" := AMSAInvHeader."Item No.";
          Item1.Get(AMSAInvHeader."Item No.");
          AMSAInvLine."Item Name" := Item1.Description;
          AMSAInvLine."VAT Amount" := InvPostBuffer."VAT Amount";
          AMSAInvLine."Unit Price" := InvPostBuffer."Unit Price";
          AMSAInvLine."Invoice Qty" := InvPostBuffer."Invoice Qty";
          AMSAInvLine."Invoice Ref" := InvPostBuffer."Invoice No";
          AMSAInvLine."Order Ref" := InvPostBuffer."Order No";
          AMSAInvLine."Amount Incl. VAT" := InvPostBuffer."Amount Incl. VAT";
          AMSAInvLine."Posting Date" := InvPostBuffer."Posting Date";

          AMSAInvLine.Modify;

        until InvPostBuffer.Next=0;
    end;

    procedure ArchiveAMSAMainInvoice(var FSHeader: Record "Fuel Statement Header")
    var
        PostedFS: Record "Posted Fuel Statement";
        PostedFSLine: Record "Posted Fuel Statement Line";
        FSLine: Record "Fuel Statement Line";
        InvoiceAMSA: Record "Fuel Statement Header";
        PostedInvoiceAMSA: Record "Posted Fuel Statement";
        LigneFacture: Record "AMSA Invoice Line";
        PostedLigneFacture: Record "Posted AMSA Invoice Line";
    begin

        //IF NOT BillingHeader.GET(CodeImport) THEN EXIT;

        if not Confirm(Text003) then exit;

        //Transferer le document
        //Facturation globale
        PostedFS.Init();
        PostedFS.TransferFields(FSHeader);
        PostedFS.Status:= PostedFS.Status::Validated;
        PostedFS.Insert;

        //Factures
        InvoiceAMSA.Reset();
        InvoiceAMSA.SetRange(InvoiceAMSA."Document Type",InvoiceAMSA."Document Type"::Invoice);
        InvoiceAMSA.SetRange(InvoiceAMSA."Parent Invoice No.",FSHeader."No.");
        if InvoiceAMSA.FindSet then repeat

           //SousFacture
           PostedInvoiceAMSA.Init();
           PostedInvoiceAMSA.TransferFields(InvoiceAMSA);
           PostedInvoiceAMSA.Insert;

           //Ligne SousFacture
           LigneFacture.Reset;
           LigneFacture.SetRange(LigneFacture."Document Type",LigneFacture."Document Type"::Invoice);
           LigneFacture.SetRange(LigneFacture."Document No.",InvoiceAMSA."No.");
           if LigneFacture.FindSet then repeat
             PostedLigneFacture.Init();
             PostedLigneFacture.TransferFields(LigneFacture);
             PostedLigneFacture.Insert;
           until LigneFacture.Next=0;

         until InvoiceAMSA.Next=0;


        DeleteRelateDocsMainInvoice(FSHeader);
        FSHeader.Delete(true);
    end;

    local procedure DeleteRelateDocsMainInvoice(var AMSAMainInvoice: Record "Fuel Statement Header")
    var
        InvoiceAMSA: Record "Fuel Statement Header";
        LigneFactureAMSA: Record "AMSA Invoice Line";
    begin

        InvoiceAMSA.Reset;
        InvoiceAMSA.SetRange(InvoiceAMSA."Document Type",InvoiceAMSA."Document Type"::Invoice);
        InvoiceAMSA.SetRange(InvoiceAMSA."Parent Invoice No.",AMSAMainInvoice."No.");
        if InvoiceAMSA.FindSet then repeat

          LigneFactureAMSA.Reset;
          LigneFactureAMSA.SetRange(LigneFactureAMSA."Document Type",LigneFactureAMSA."Document Type"::Invoice);
          LigneFactureAMSA.SetRange(LigneFactureAMSA."Document No.",InvoiceAMSA."No.");
          LigneFactureAMSA.DeleteAll;

        until InvoiceAMSA.Next=0;

        InvoiceAMSA.Reset;
        InvoiceAMSA.SetRange(InvoiceAMSA."Document Type",InvoiceAMSA."Document Type"::Invoice);
        InvoiceAMSA.SetRange(InvoiceAMSA."Parent Invoice No.",AMSAMainInvoice."No.");
        InvoiceAMSA.DeleteAll;
    end;

    local procedure GetAMSACustFilter(AMSAMainInvoice: Record "Fuel Statement Header") Rep: Text[1024]
    var
        Cust: Record Customer;
    begin

        if AMSAMainInvoice."Grouping Type"=AMSAMainInvoice."Grouping Type"::Client then
          exit(AMSAMainInvoice."Grouping Customer")
        else begin
          Cust.Reset;
          Cust.SetRange(Cust."Company Code",AMSAMainInvoice."Grouping Customer");
          if Cust.FindSet then repeat
            if Rep='' then
              Rep := Cust."No."
            else
              Rep := Rep + '|' + Cust."No.";
          until Cust.Next=0;
        end;
    end;

    procedure CreateAMSAInvoices_OLD(var AMSAMainInvoice: Record "Fuel Statement Header")
    var
        SalesInvLine: Record "Sales Invoice Line";
        InvPostBuffer: Record "AMSA Inv. Post Buffer";
        LineNum: Integer;
        NbreLignes: Integer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        CurrentDate: Date;
        CurrentCostCode: Code[20];
        EquipType: Option Mobile,Fixe;
        BackCharge: Option " ",Yes,No;
        CostCode: Code[20];
        Process: Option " ",Yes,No;
        CompanyCode: Code[30];
        InvoiceAMSA: Record "Fuel Statement Header";
        LigneFactureAMSA: Record "AMSA Invoice Line";
        SalesInvH: Record "Sales Invoice Header";
        num: Integer;
        CustFilter: Text[1024];
    begin

        //Création des sous factures pour Mango RIVER et Centrale electrique
        //Regroupement simple de factures NAV


        //LineNo := 0;
        BesoinNo := 0;
        Window.Open(Text008);



        InvPostBuffer.Reset;
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,AMSAMainInvoice."No.");
        InvPostBuffer.DeleteAll;



        DeleteRelateDocsMainInvoice(AMSAMainInvoice);



        //SalesInvLine.RESET;
        //SalesInvLine.SETCURRENTKEY(IsAMSA,"Posting Date");
        //SalesInvLine.SETRANGE(SalesInvLine.IsAMSA,TRUE);
        //SalesInvLine.SETRANGE(SalesInvLine."Posting Date",AMSAMainInvoice."Starting Date",AMSAMainInvoice."Ending Date");
        num := 0;

        AMSAMainInvoice.TestField("Grouping Customer");
        CustFilter := GetAMSACustFilter(AMSAMainInvoice);

        SalesInvLine.Reset;
        //SalesInvLine.SETCURRENTKEY(IsAMSA,"Posting Date");
        //SalesInvLine.SETRANGE(SalesInvLine.IsAMSA,TRUE);
        //Sell-to Customer No.,Type,No.,Posting Date
        SalesInvLine.SetCurrentKey("Sell-to Customer No.",Type,"No.","Posting Date");
        //SalesInvLine.SETRANGE("Sell-to Customer No.",AMSAMainInvoice."Customer No");
        SalesInvLine.SetFilter("Sell-to Customer No.",CustFilter);
        SalesInvLine.SetRange(Type,SalesInvLine.Type::Item);
        SalesInvLine.SetRange("No.",AMSAMainInvoice."Item No.");
        SalesInvLine.SetRange("Posting Date",AMSAMainInvoice."Starting Date",AMSAMainInvoice."Ending Date");
        if SalesInvLine.FindSet then
        repeat
          InvPostBuffer.Init;
          InvPostBuffer.FSNumber := AMSAMainInvoice."No.";
          InvPostBuffer."Posting Date" := SalesInvLine."Posting Date";
          num := num+1;
          InvPostBuffer.LineNum := num;
          //InvPostBuffer.i
          InvPostBuffer.Backcharge := SalesInvLine."AMSA BackCharge";
          InvPostBuffer."Equipment Type" := SalesInvLine."AMSA Equipment Type";
          InvPostBuffer."Company Code" := SalesInvLine."AMSA Company Code";
          InvPostBuffer."Cost Code" := SalesInvLine."AMSA Cost Code";
          InvPostBuffer.Process := SalesInvLine."AMSA Process";
          InvPostBuffer."Source Appro" := SalesInvLine."AMSA Source Type";
          InvPostBuffer."Invoice Qty" := SalesInvLine.Quantity;
          InvPostBuffer."Invoice No" := SalesInvLine."Document No.";

          if SalesInvH.Get(SalesInvLine."Document No.") then begin
            if SalesInvH."Order No."<>'' then
              InvPostBuffer."Order No" := SalesInvH."Order No."
            else
              InvPostBuffer."Order No" := CopyStr( SalesInvH."Your Reference",1,20);
          end;
          InvPostBuffer."Unit Price" := SalesInvLine."Unit Price";
          InvPostBuffer.Amount := SalesInvLine.Amount;
          InvPostBuffer."VAT Amount" := SalesInvLine."Amount Including VAT"-SalesInvLine.Amount;
          InvPostBuffer."Amount Incl. VAT" := SalesInvLine."Amount Including VAT";

          SalesInvH.CalcFields(Closed,SalesInvH.Cancelled);
          if ((not SalesInvH.Closed) and (not SalesInvH.Cancelled)) then
            InvPostBuffer.Insert;

        until SalesInvLine.Next=0;


        //FSNumber,Equipment Type,Backcharge,Cost Code,Company Code,Process

        InvPostBuffer.Reset;
        InvPostBuffer.SetCurrentKey(FSNumber,"Equipment Type",Backcharge,"Cost Code","Company Code",Process);
        InvPostBuffer.SetRange(InvPostBuffer.FSNumber,AMSAMainInvoice."No.");
        if InvPostBuffer.FindSet then begin
          NbreTotalLignes:=InvPostBuffer.Count;
          repeat

              BesoinNo := BesoinNo + 1;
              Window.Update(1,
              Round(BesoinNo / NbreTotalLignes * 10000,1));

            if (
                (CurrentCostCode<>InvPostBuffer."Cost Code")
                or (EquipType<>InvPostBuffer."Equipment Type") or (BackCharge<>InvPostBuffer.Backcharge)
                or (Process<>InvPostBuffer.Process) or (CompanyCode<>InvPostBuffer."Company Code")
              )then begin
                AddNewAMSAInvoice(AMSAMainInvoice,InvPostBuffer."Equipment Type",InvPostBuffer.Backcharge,
                  InvPostBuffer."Cost Code",InvPostBuffer.Process,InvPostBuffer."Company Code");

              NbreLignes := NbreLignes + 1;
              CurrentDate := InvPostBuffer."Posting Date";
              CurrentCostCode := InvPostBuffer."Cost Code";
              EquipType:=InvPostBuffer."Equipment Type";
              BackCharge:=InvPostBuffer.Backcharge;
              Process:=InvPostBuffer.Process;
              CompanyCode:=InvPostBuffer."Company Code";

            end;

          until InvPostBuffer.Next=0;
        end;
        if NbreLignes=0 then Error(Text007);

        //PostFSHeader(FSHeader);


        Window.Close;
        Message(Text006,NbreLignes);
    end;
}

