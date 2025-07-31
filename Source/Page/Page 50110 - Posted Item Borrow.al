page 50110 "Posted Item Borrow"
{
    Caption = 'Posted Item Borrow';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Borrow));
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
            part(Lines; "Posted Item Borrow Subform")
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
            action(ListeRemb)
            {
                Caption = 'Refund List';
                Image = ReturnOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RembPret: Record "Item Return Header";
                    RembListPage: Page "Posted Return Borrow List";
                begin
                    RembPret.Reset;
                    RembPret.SetRange("Document Type", RembPret."Document Type"::Borrow);
                    RembPret.SetRange("Original Doc No", Rec."No.");
                    //IF RembPret.FINDFIRST THEN BEGIN
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

    var
        ItemLoanMgt: Codeunit "Item Loan Mgt";
}

