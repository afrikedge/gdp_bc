page 50105 "Item Borrow"
{
    Caption = 'Item Loan';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Borrow));

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
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
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
            part(Lines; "Item Borrow Subform")
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
        area(processing)
        {
            action(ValiderOctroi)
            {
                Caption = 'Post document';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemLoanMgt.PostOctroiEmprunt(Rec);
                end;
            }
            action(CreateReturn)
            {
                Caption = 'Create new return';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ItemLoanMgt.PostRembEmprunt(Rec);
                end;
            }
        }
    }

    var
        ItemLoanMgt: Codeunit "Item Borrow Mgt";
}

