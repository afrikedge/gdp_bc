page 50090 "Posted Item Exchange"
{
    Caption = 'Posted Item Exchange';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Exchange));
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
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Posting Description"; Rec."Posting Description")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
            }
            part(Lines; "Posted Item Exchange Subform")
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
                ApplicationArea = All;
            }
            systempart(Control1000000011; Notes)
            {
                Visible = true;
                ApplicationArea = All;
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
            action(FactureVente)
            {
                Caption = 'Sales invoice';
                Image = SalesShipment;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction()
                var
                    SalesH: Record "Sales Header";
                    SalesInvPage: Page "Sales Invoice";
                    PostedSalesH: Record "Sales Invoice Header";
                    PostedSalesInvPage: Page "Posted Sales Invoice";
                begin
                    SalesH.Reset;
                    SalesH.SetRange(SalesH."Created By Doc Type", SalesH."Created By Doc Type"::Exchange);
                    SalesH.SetRange("Document Type", SalesH."Document Type"::Invoice);
                    SalesH.SetRange("Created By Doc No.", Rec."No.");
                    if SalesH.FindFirst then begin
                        SalesInvPage.SetRecord(SalesH);
                        SalesInvPage.Run();
                    end else begin
                        PostedSalesH.Reset;
                        PostedSalesH.SetRange(PostedSalesH."Created By Doc Type", PostedSalesH."Created By Doc Type"::Exchange);
                        PostedSalesH.SetRange("Created By Doc No.", Rec."No.");
                        if PostedSalesH.FindFirst then begin
                            PostedSalesInvPage.SetRecord(PostedSalesH);
                            PostedSalesInvPage.Run();
                        end;
                    end;
                end;
            }
            action(FactureAchat)
            {
                Caption = 'Purchase invoice';
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction()
                var
                    PurchH: Record "Purchase Header";
                    PurchInvPage: Page "Purchase Invoice";
                    PostedPurchH: Record "Purch. Inv. Header";
                    PostedPurchInvPage: Page "Posted Purchase Invoice";
                begin
                    PurchH.Reset;
                    PurchH.SetRange("Document Type", PurchH."Document Type"::Invoice);
                    PurchH.SetRange("Created By Doc No.", Rec."No.");
                    if PurchH.FindFirst then begin
                        PurchInvPage.SetRecord(PurchH);
                        PurchInvPage.Run();
                    end else begin
                        PostedPurchH.Reset;
                        PostedPurchH.SetRange("Created By Doc Type", PostedPurchH."Created By Doc Type"::Exchange);
                        PostedPurchH.SetRange("Created By Doc No.", Rec."No.");
                        if PostedPurchH.FindFirst then begin
                            PostedPurchInvPage.SetRecord(PostedPurchH);
                            PostedPurchInvPage.Run();
                        end;
                    end;
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
            action(GLEntries)
            {
                Caption = 'Exchange fees';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "General Ledger Entries";
                RunPageLink = "External Document No." = FIELD("No.");
            }
        }
    }

    var
        ItemExchMgt: Codeunit "Item Exchange Mgt";
}

