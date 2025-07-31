page 50081 "Item Exchange"
{
    Caption = 'Item Exchange';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Adjustment Header";
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
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Cession Date"; Rec."Cession Date")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
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
                    Caption = 'External Doc. Date';
                }
                field("Credit Notes Import Jrnal"; Rec."Credit Notes Import Jrnal")
                {
                    Visible = false;
                }
                field("Debit Notes Import Jrnal"; Rec."Debit Notes Import Jrnal")
                {
                }
            }
            part(Lines; "Item Exchange Subform")
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
            action(FactureVente)
            {
                Caption = 'Sales invoice';
                Image = SalesShipment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = false;
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
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "General Ledger Entries";
                RunPageLink = "External Document No." = FIELD("No.");
            }
        }
        area(processing)
        {
            action(ValiderCession)
            {
                Caption = 'Post cession';
                Ellipsis = true;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemExchMgt.PostAjustementEchange(Rec, true);
                end;
            }
            action(ValiderReception)
            {
                Caption = 'Post reception';
                Ellipsis = true;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemExchMgt.PostAjustementEchange(Rec, false);
                end;
            }
            action(CalculateFees)
            {
                Caption = 'Calculate fees';
                Image = CalculateBalanceAccount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemExchMgt.CalculateExchangeFees(Rec);
                end;
            }
            action(TraiterFraisEchange)
            {
                Caption = 'Process Transfer Fees';
                Ellipsis = true;
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemExchMgt.CreateExchangeInvoices(Rec);
                end;
            }
            action(CloturerEchange)
            {
                Caption = 'Close exchange';
                Ellipsis = true;
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemExchMgt.ArchiveDoc(Rec);
                end;
            }
            action("Sales Journal")
            {
                Caption = 'Sales Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Sales Journal";
            }
        }
    }

    var
        ItemExchMgt: Codeunit "Item Exchange Mgt";
        Cust: Record Customer;
        Vend: Record Vendor;
}

