page 50194 "Item Transfer"
{
    Caption = 'Item Transfer';
    PageType = Document;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Transfer));
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
                    Caption = 'Shipment Date';
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Caption = 'Last Reception Date';
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("BEX Number"; Rec."BEX Number")
                {
                }
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
                field(permis; Rec.permis)
                {
                }
                field(CarteGrise; Rec.CarteGrise)
                {
                }
            }
            part(Lines; "Item Transfer Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                ApplicationArea = All;
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
            action(ListeRemb)
            {
                Caption = 'Reception List';
                Ellipsis = true;
                Image = ReturnOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RembPret: Record "Item Return Header";
                    RembListPage: Page "Posted Reception List";
                begin
                    RembPret.Reset;
                    RembPret.SetRange("Document Type", RembPret."Document Type"::Transfer);
                    RembPret.SetRange(RembPret."Original Doc No", Rec."No.");
                    //IF RembPret.SETTABLEVIEW THEN BEGIN
                    RembListPage.SetTableView(RembPret);
                    RembListPage.Run();
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
                    Rec.navigate;
                end;
            }
        }
        area(processing)
        {
            action(ValiderOctroi)
            {
                Caption = 'Post shipment';
                Ellipsis = true;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = CanSeeExpedier;

                trigger OnAction()
                begin
                    ItemtransferMgt.PostExpedition(Rec);
                end;
            }
            action(CreateReturn)
            {
                Caption = 'Create new receipt';
                Ellipsis = true;
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = CanSeeReceive;

                trigger OnAction()
                begin
                    ItemtransferMgt.PostReception(Rec);
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
                    AdjH.SetRange(AdjH."Document Type", AdjH."Document Type"::Transfer);
                    AdjH.SetRange(AdjH."No.", Rec."No.");
                    REPORT.RunModal(50038, true, false, AdjH);
                end;
            }
            action(CancelExp)
            {
                Caption = 'Cancel expedition';
                Ellipsis = true;
                Image = Cancel;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = false;
                Visible = CanSeeReceive;

                trigger OnAction()
                begin
                    ItemtransferMgt.CancelExpedition(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        CanSeeExpedier := Rec.Status = Rec.Status::Open;
        CanSeeReceive := not CanSeeExpedier;
    end;

    var
        ItemtransferMgt: Codeunit "Item Transfer Mgt";
        CanSeeExpedier: Boolean;
        CanSeeReceive: Boolean;
        AdjH: Record "Adjustment Header";
}

