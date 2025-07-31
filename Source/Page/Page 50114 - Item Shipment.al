page 50114 "Item Shipment"
{
    Caption = 'Item Shipment';
    Editable = true;
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Shipment));
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
                    Visible = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Shipment Status"; Rec."Shipment Status")
                {
                }
            }
            part(Lines; "Item Shipment Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
            }
            group(Transport)
            {
                Caption = 'Transport';
                field("Truck Code"; Rec."Truck Code")
                {
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
                field(nomchauffeur; Rec.nomchauffeur)
                {
                }
                field(prenomchauffeur; Rec.prenomchauffeur)
                {
                }
                field(permis; Rec.permis)
                {
                }
                field(CarteGrise; Rec.CarteGrise)
                {
                }
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
        }
        area(processing)
        {
            action(TraiterDocument)
            {
                Caption = 'Process document';
                Ellipsis = true;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemShipmentMgt.TraiterLivraison(Rec);
                end;
            }
            action(ArchiverDocument)
            {
                Caption = 'Archive document';
                Ellipsis = true;
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowArchiveBtn;

                trigger OnAction()
                begin
                    ItemShipmentMgt.PostArchiveDoc(Rec);
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
            action(ImprimerBL)
            {
                Caption = 'Imprimer BL';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EnteteBL: Record "Adjustment Header";
                begin
                    EnteteBL.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(REPORT::"PreparationOrder Lub", TRUE, FALSE, EnteteBL);
                    // CRReports.PrintBL_Lubs(Rec."No.");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Editable := Rec.Status <> Rec."Shipment Status"::Shipped;
        ShowArchiveBtn := Rec."Shipment Status" = Rec."Shipment Status"::Prepared;
    end;

    var
        ItemShipmentMgt: Codeunit "Item Shipment Mgt";
        IsNotShipped: Boolean;
        CRReports: Codeunit CRReports;
        ShowArchiveBtn: Boolean;
}

