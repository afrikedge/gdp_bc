page 50087 "Item Consignation"
{
    Caption = 'Item Consignation';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Consignation));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ShowMandatory = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Partner Code (Customer)';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Caption = 'Receipt Date';
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
            }
            part(Lines; "Item Consignation Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1000000012; Links)
            {
                Visible = false;
            }
            systempart(Control1000000011; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            action(FacturesVente)
            {
                Caption = 'Sales invoices';
                Ellipsis = true;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesH: Record "Sales Header";
                    SalesInvPage: Page "Sales Invoice List";
                    PostedSalesH: Record "Sales Invoice Header";
                    PostedSalesInvPage: Page "Posted Sales Invoices";
                begin
                    SalesH.Reset;
                    SalesH.SetRange(SalesH."Created By Doc Type", SalesH."Created By Doc Type"::Consignation);
                    SalesH.SetRange("Document Type", SalesH."Document Type"::Invoice);
                    SalesH.SetRange("Created By Doc No.", Rec."No.");
                    if SalesH.FindFirst then begin
                        SalesInvPage.SetTableView(SalesH);
                        SalesInvPage.Run();
                    end else begin
                        PostedSalesH.Reset;
                        PostedSalesH.SetRange(PostedSalesH."Created By Doc Type", PostedSalesH."Created By Doc Type"::Consignation);
                        PostedSalesH.SetRange("Created By Doc No.", Rec."No.");
                        if PostedSalesH.FindFirst then begin
                            PostedSalesInvPage.SetTableView(PostedSalesH);
                            PostedSalesInvPage.Run();
                        end;
                    end;
                end;
            }
            action(RetourConsignation)
            {
                Caption = 'Consignation Returns';
                Ellipsis = true;
                Image = ReturnOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ReturnH: Record "Item Return Header";
                    ReturnPageList: Page "Posted Return Consignat List";
                begin
                    ReturnH.Reset;
                    ReturnH.SetRange("Document Type", ReturnH."Document Type"::Consignation);
                    //ReturnH.SETRANGE("Created By Doc Type",SalesH."Created By Doc Type"::Consignation);
                    ReturnH.SetRange(ReturnH."Original Doc No", Rec."No.");
                    //IF SalesH.FINDFIRST THEN BEGIN
                    ReturnPageList.SetTableView(ReturnH);
                    ReturnPageList.Run();
                    //END;
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
        area(processing)
        {
            action(ValiderConsignation)
            {
                Caption = 'Post consignation';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemConsMgt.PostConsignation(Rec);
                end;
            }
            action(CreerRetourProduits)
            {
                Caption = 'Post Item Return';
                Ellipsis = true;
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemConsMgt.PostRetourConsignation(Rec);
                end;
            }
            action(CreerFactureVente)
            {
                Caption = 'Create sales invoice';
                Ellipsis = true;
                Image = SalesShipment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemConsMgt.AddNewSalesConsignationInvoice(Rec);
                end;
            }
            action(Cloturer)
            {
                Visible = false;

                trigger OnAction()
                begin
                    ItemConsMgt.ArchiveDoc(Rec);
                end;
            }
            action(PrintTransferOrder)
            {
                Caption = 'Print Transfer Order';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //*******************************
                    AdjH.SetRange(AdjH."Document Type", AdjH."Document Type"::Consignation);
                    AdjH.SetRange(AdjH."No.", Rec."No.");
                    REPORT.RunModal(50063, true, false, AdjH);
                end;
            }
        }
    }

    var
        ItemConsMgt: Codeunit "Item Consignation Mgt";
        AdjH: Record "Adjustment Header";
}

