page 50160 "Item Invoiced Conso"
{
    Caption = 'Item Consumption to invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST("Invoiced Consumption"));
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
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Station Code';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Station Name';
                }
            }
            part(Lines; "Item Invoiced Conso Subform")
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
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
        }
        area(processing)
        {
            action(ValiderSortie)
            {
                Caption = 'Post document';
                Ellipsis = true;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsOpen;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ItemConsoMgt.PostSortie(Rec);
                end;
            }
            action(GenerateND)
            {
                Caption = 'Create Invoice';
                Ellipsis = true;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsNotOpen;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ItemConsoMgt.PostNoteDebit(Rec);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(PrintSortieStock)
            {
                Caption = 'Print Item Adjustment';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdjH: Record "Adjustment Header";
                begin
                    AdjH.Reset;
                    AdjH.SetRange(AdjH."Document Type", AdjH."Document Type"::"Invoiced Consumption");
                    AdjH.SetRange(AdjH."No.", Rec."No.");
                    REPORT.Run(50037, true, false, AdjH);
                end;
            }
            action("Mettre à jour les pourcentages")
            {
                Caption = 'Mettre à jour les pourcentages';
                Image = Recalculate;

                trigger OnAction()
                begin
                    ItemConsoMgt.RefreshOutputPercentage(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsOpen := (Rec.Status = Rec.Status::Open);
        IsNotOpen := (Rec.Status = Rec.Status::Released);
        CurrPage.Editable := IsOpen;
    end;

    var
        ItemConsoMgt: Codeunit "Item Invoiced Conso Mgt";
        IsOpen: Boolean;
        IsNotOpen: Boolean;
}

