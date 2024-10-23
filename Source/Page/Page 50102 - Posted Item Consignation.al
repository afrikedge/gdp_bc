page 50102 "Posted Item Consignation"
{
    Caption = 'Posted Item Consignation';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Consignation));

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
            part(Lines; "Posted Item Consignat Subform")
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
    }

    var
        ItemConsMgt: Codeunit "Item Consignation Mgt";
}

