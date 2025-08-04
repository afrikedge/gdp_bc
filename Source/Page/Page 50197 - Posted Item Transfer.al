page 50197 "Posted Item Transfer"
{
    Caption = 'Posted Item Transfer';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Adjustment Header";
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
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
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
                field("BEX Number"; Rec."BEX Number")
                {
                }
                field("External Document No."; Rec."External Document No.")
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
                field("Cancelled By"; Rec."Cancelled By")
                {
                }
                field("Cancellation Date"; Rec."Cancellation Date")
                {
                }
            }
            part(Lines; "Posted Item Transfer Subform")
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
                Caption = 'Receptions List';
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
                    Rec.Navigate;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ApplyFiltresMagasin;
    end;

    var
        ItemLoanMgt: Codeunit "Item Loan Mgt";

    local procedure ApplyFiltresMagasin()
    var
        SecMgt: Codeunit "Security Mgt";
        UserMgt: Codeunit "User Setup Management";
        FiltreMag: Text[500];
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FiltreMag := SecMgt.GetFiltresMagasinsDispaching(UserMgt.GetSalesFilter);
            if FiltreMag <> '' then begin
                Rec.FilterGroup(2);
                Rec.SetFilter(Rec."Location Code", FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;
    end;
}

