xmlport 50085 "Archive SO With Control"
{
    Caption = 'Suppression commandes d''achat';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement("Import Data";"Import Data")
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                SourceTableView = SORTING(EntryNo) ORDER(Ascending);
                fieldattribute(SONumber;"Import Data".DocumentNo)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    SHeader: Record "Sales Header";
                    SLine: Record "Sales Line";
                    SHeaderArchive: Record "Sales Header Archive";
                begin
                    
                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));
                    
                    /*
                    IF PHeader.GET(PHeader."Document Type"::Order, "Import Data".DocumentNo) THEN BEGIN
                      PHeader."GDP Deletion" := TRUE;
                      PHeader.MODIFY;
                    
                      Nbre:=Nbre+1;
                    
                      ArchiveMgt.ArchPurchDocumentNoConfirm(PHeader);
                      PHeader.DELETE;
                    
                      PurchLine.RESET;
                      PurchLine.SETRANGE("Document Type",PHeader."Document Type");
                      PurchLine.SETRANGE("Document No.",PHeader."No.");
                      IF PurchLine.FINDSET THEN BEGIN
                        REPEAT
                          PurchLine.DELETE;
                        UNTIL PurchLine.NEXT = 0;
                      END;
                    END;
                    */
                    if SHeader.Get(SHeader."Document Type"::Order, "Import Data".DocumentNo) then begin
                    
                      if(CanArchivePO(SHeader)) then begin
                        if ArchivePO(SHeader) then
                          Nbre:=Nbre+1;
                      end else begin
                          if SHeader.Get(SHeader."Document Type"::Order,"Import Data".DocumentNo) then begin
                    
                            //SHeader."Processing Status":=PurchH."Processing Status"::Soldee;
                            SHeader."GDP Deletion":=true;
                            SHeader.Modify;
                            ArchiveMgt.ArchSalesDocumentNoConfirm(SHeader);
                            SHeader.Delete;
                            Nbre:=Nbre+1;
                          end;
                      end;
                    end;

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(GenJrnTemplate;GenJrnTemplate)
                {
                    Caption = 'General journal template';
                    TableRelation = "Gen. Journal Template";
                    Visible = false;
                }
                field(GenJrnBatch;GenJrnBatch)
                {
                    Caption = 'Posting journal Batch';
                    TableRelation = "Gen. Journal Batch";
                    Visible = false;
                }
                field("N° Document";DocNum)
                {
                    Visible = false;
                }
                field("Nbre de lignes";NbreTotalLignes)
                {
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin

        GLSetup.Get;
        AddOnSetup.Get;
        //AddOnSetup.TESTFIELD(AddOnSetup."Payroll Tmpl Journal");

        //GenJrnTemplate:=AddOnSetup."Payroll Tmpl Journal";
    end;

    trigger OnPostXmlPort()
    begin

        Window.Close;
        Message(TextFin,Nbre);
        //MESSAGE(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin



        LineNo := 0;

        BesoinNo :=0;
        Window.Open(Text008);
        Nbre:=0;
        //NbreTotalLignes := 517;
    end;

    var
        GenJrnTemplate: Code[20];
        GenJrnBatch: Code[20];
        PostingDate: Date;
        GenJrnTable: Record "Gen. Journal Batch";
        GenJrnLine: Record "Gen. Journal Line";
        LineNo: Integer;
        Cust2: Record Customer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        AddOnSetup: Record "AddOn Setup";
        JrnTmplName: Record "Gen. Journal Template";
        GLAcc2: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        Vend2: Record Vendor;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LastDocNo: Code[20];
        LastAmountTotal: Decimal;
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text002: Label 'This account %1 does not exists !';
        Text003: Label 'The journal template model is required';
        Text004: Label 'The journal code is required';
        DocNum: Code[20];
        Text005: Label 'Vous devez selectionner un code document';
        ArchiveMgt: Codeunit ArchiveManagement;
        Nbre: Integer;
        TextFin: Label '%1 commandes traitées';
        ArchiveManagement: Codeunit ArchiveManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

    procedure SetFeuille(Modele: Code[10];NomFeuille: Code[10])
    begin
        GenJrnBatch := NomFeuille;
        GenJrnTemplate := Modele;
    end;

    local procedure ArchivePO(var SalesHeader: Record "Sales Header"): Boolean
    var
        ReleaseMgt: Codeunit "Release Sales Document";
        SLine1: Record "Sales Line";
    begin

        //ApprovalsMgmt.OnCancelPurchaseApprovalRequest(PurchH);
        //PurchH.MODIFY;

        ReleaseMgt.Reopen(SalesHeader);



        SLine1.Reset;
        SLine1.SetRange("Document Type",SLine1."Document Type"::Order);
        SLine1.SetRange("Document No.",SalesHeader."No.");
        SLine1.SetFilter(Type,'<>%1',SLine1.Type::" ");
        SLine1.SetFilter("No.",'<>%1','');
        if SLine1.FindSet then repeat

          if SLine1."Quantity Invoiced"<>SLine1."Quantity Shipped" then
            exit(false);
            //ERROR(Text013,PurchLine1."No.");

          if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (SLine1.Quantity <> SLine1."Quantity Invoiced") then
            if SLine1."Prepmt. Amt. Inv."<>SLine1."Prepmt Amt Deducted" then
              exit(false);
          //TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

          SLine1.Validate(SLine1.Quantity,SLine1."Quantity Shipped");
          SLine1.Modify;

        until SLine1.Next=0;


        //SalesHeader."Processing Status":=PurchH."Processing Status"::Soldee;
        SalesHeader."GDP Deletion" := true;
        SalesHeader.Modify;
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);

        SalesHeader.AFK_AllowDeletion(true);
        SalesHeader.Delete(true);
        exit(true);
    end;

    local procedure CanArchivePO(SHeader: Record "Sales Header"): Boolean
    var
        ReleaseMgt: Codeunit "Release Purchase Document";
        SLine1: Record "Sales Line";
    begin


        SLine1.Reset;
        SLine1.SetRange("Document Type",SLine1."Document Type"::Order);
        SLine1.SetRange("Document No.",SHeader."No.");
        if SLine1.FindSet then repeat

          if SLine1."Quantity Invoiced"<>SLine1."Quantity Shipped" then
            exit(false);
            //ERROR(Text013,PurchLine1."No.");

          if (SHeader."Document Type" = SHeader."Document Type"::Order) and (SLine1.Quantity <> SLine1."Quantity Invoiced") then
            if SLine1."Prepmt. Amt. Inv."<>SLine1."Prepmt Amt Deducted" then
              exit(false);
          //TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

        until SLine1.Next=0;


        exit(true);
    end;
}

