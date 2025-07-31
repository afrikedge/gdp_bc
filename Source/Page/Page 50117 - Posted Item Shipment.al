page 50117 "Posted Item Shipment"
{
    Caption = 'Posted Item Shipment';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Adjustment Header";
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
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Shipment Status"; Rec."Shipment Status")
                {
                }
            }
            part(Lines; "Posted Item Shipment Subform")
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
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navigate2;
                end;
            }
            action(ImprimerBL)
            {
                Caption = 'Imprimer BL';
                Image = "report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EnteteBL: Record "Posted Adjustment Header";
                begin
                    //EnteteBL.SETRANGE("No.",Rec."No.");
                    //REPORT.RUN(REPORT::"Bon livraison LUB Before Val",TRUE, FALSE,EnteteBL);
                    CRReports.PrintBL_Lubs_Enreg(Rec."No.");
                end;
            }
        }
    }

    var
        ItemExchMgt: Codeunit "Item Exchange Mgt";
        CRReports: Codeunit CRReports;

    procedure Navigate2()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc(Rec."Posting Date", Rec."Posted Doc No");
        NavigateForm.Run;
    end;
}

