page 50191 "Item Invoiced Conso Released"
{
    Caption = 'Item Consumption to invoice';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST("Invoiced Consumption"),
                            Status = CONST(Released));
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
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Station Code';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Station Name';
                    Editable = false;
                }
                field("ItemInvoiceSourcePrice"; Rec.ItemInvoiceSourcePrice)
                {
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

