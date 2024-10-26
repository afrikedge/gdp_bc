xmlport 50009 "Archive PO"
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
                fieldattribute(PONumber;"Import Data".DocumentNo)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    PHeader: Record "Purchase Header";
                    PurchLine: Record "Purchase Line";
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
                    if PHeader.Get(PHeader."Document Type"::Order, "Import Data".DocumentNo) then begin
                    
                      if(CanArchivePO(PHeader)) then
                        if ArchivePO(PHeader) then
                          Nbre:=Nbre+1;
                    
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
        NbreTotalLignes := 517;
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

    local procedure ArchivePO(var PurchH: Record "Purchase Header"): Boolean
    var
        ReleaseMgt: Codeunit "Release Purchase Document";
        PurchLine1: Record "Purchase Line";
    begin

        //ApprovalsMgmt.OnCancelPurchaseApprovalRequest(PurchH);
        //PurchH.MODIFY;

        ReleaseMgt.Reopen(PurchH);



        PurchLine1.Reset;
        PurchLine1.SetRange("Document Type",PurchLine1."Document Type"::Order);
        PurchLine1.SetRange("Document No.",PurchH."No.");
        PurchLine1.SetFilter(Type,'<>%1',PurchLine1.Type::" ");
        PurchLine1.SetFilter("No.",'<>%1','');
        if PurchLine1.FindSet then repeat

          if PurchLine1."Quantity Invoiced"<>PurchLine1."Quantity Received" then
            exit(false);
            //ERROR(Text013,PurchLine1."No.");

          if (PurchH."Document Type" = PurchH."Document Type"::Order) and (PurchLine1.Quantity <> PurchLine1."Quantity Invoiced") then
            if PurchLine1."Prepmt. Amt. Inv."<>PurchLine1."Prepmt Amt Deducted" then
              exit(false);
          //TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

          PurchLine1.Validate(PurchLine1.Quantity,PurchLine1."Quantity Received");
          PurchLine1.Modify;

        until PurchLine1.Next=0;


        PurchH."Processing Status":=PurchH."Processing Status"::Soldee;
        PurchH."GDP Deletion" := true;
        PurchH.Modify;
        //ArchiveManagement.ArchPurchDocumentNoConfirm(PurchH);

        //PurchH.AFK_AllowDeletion(TRUE);
        PurchH.Delete(true);
        exit(true);
    end;

    local procedure CanArchivePO(PurchH: Record "Purchase Header"): Boolean
    var
        ReleaseMgt: Codeunit "Release Purchase Document";
        PurchLine1: Record "Purchase Line";
    begin


        PurchLine1.Reset;
        PurchLine1.SetRange("Document Type",PurchLine1."Document Type"::Order);
        PurchLine1.SetRange("Document No.",PurchH."No.");
        if PurchLine1.FindSet then repeat

          if PurchLine1."Quantity Invoiced"<>PurchLine1."Quantity Received" then
            exit(false);
            //ERROR(Text013,PurchLine1."No.");

          if (PurchH."Document Type" = PurchH."Document Type"::Order) and (PurchLine1.Quantity <> PurchLine1."Quantity Invoiced") then
            if PurchLine1."Prepmt. Amt. Inv."<>PurchLine1."Prepmt Amt Deducted" then
              exit(false);
          //TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

        until PurchLine1.Next=0;


        exit(true);
    end;
}

