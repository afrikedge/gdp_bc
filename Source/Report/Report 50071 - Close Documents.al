report 50071 "Close Documents"
{
    Caption = 'Clôture commandes vente/achat';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                if Type = Type::"Commande d'achat" then begin
                    if (PurchaseOrderNo = '') then Error(Text003);
                    if Confirm(StrSubstNo(Text001, PurchaseOrderNo)) then
                        ClosePurchOrder(PurchaseOrderNo);

                end;
                if Type = Type::"Commande de vente" then begin
                    if (SalesOrderNo = '') then Error(Text003);
                    if Confirm(StrSubstNo(Text002, SalesOrderNo)) then
                        CloseSalesOrder(SalesOrderNo);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(OrderType; Type)
                {
                    Caption = 'Type commande';

                    trigger OnValidate()
                    begin

                        IsCdeAchat := Type = Type::"Commande d'achat";
                        IsCdeVente := Type = Type::"Commande de vente";
                    end;
                }
                group(Control1000000004)
                {
                    ShowCaption = false;
                    field("Commande de vente"; SalesOrderNo)
                    {
                        TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
                    }
                }
                group(Control1000000005)
                {
                    ShowCaption = false;
                    field("Commande d'achat"; PurchaseOrderNo)
                    {
                        TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            IsCdeAchat := Type = Type::"Commande d'achat";
            IsCdeVente := Type = Type::"Commande de vente";
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Type := Type::"Commande d'achat";
    end;

    var
        Type: Option "Commande d'achat","Commande de vente";
        SalesOrderNo: Code[20];
        PurchaseOrderNo: Code[20];
        IsCdeAchat: Boolean;
        IsCdeVente: Boolean;
        ArchiveMgt: Codeunit ArchiveManagement;
        Text001: Label 'Voulez-vous clôturer la commande d''achat %1';
        Text002: Label 'Voulez-vous clôturer la commande de vente %1';
        Text003: Label 'Numéro de commande erroné';
        Text004: Label 'Le traitement est terminé';

    local procedure ClosePurchOrder(OrderNo: Code[20])
    var
        PurchH: Record "Purchase Header";
    begin
        if PurchH.Get(PurchH."Document Type"::Order, OrderNo) then begin
            //PurchHArchive.INIT;
            //PurchHArchive.TRANSFERFIELDS(PurchH);
            //PurchHArchive.INSERT;

            PurchH."Processing Status" := PurchH."Processing Status"::Soldee;
            PurchH."GDP Deletion" := true;
            PurchH.Modify;
            ArchiveMgt.ArchPurchDocumentNoConfirm(PurchH);
            PurchH.Delete;

            Message(Text004);
        end;
    end;

    local procedure CloseSalesOrder(SalesNo: Code[20])
    var
        SalesH: Record "Sales Header";
    begin
        if SalesH.Get(SalesH."Document Type"::Order, SalesNo) then begin

            //SalesH."Processing Status":=SalesH."Processing Status"::Soldee;
            SalesH."GDP Deletion" := true;
            SalesH.Modify;
            ArchiveMgt.ArchSalesDocumentNoConfirm(SalesH);
            SalesH.Delete;

            Message(Text004);
        end;
    end;
}

