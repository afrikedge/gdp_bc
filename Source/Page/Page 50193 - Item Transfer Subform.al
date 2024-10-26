page 50193 "Item Transfer Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Adjustment Line";
    SourceTableView = WHERE("Document Type" = CONST(Transfer));

    layout
    {
        area(content)
        {
            repeater(Control1000000008)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Qty to return"; Rec."Qty to return")
                {
                    Caption = 'Qty to receipt';
                }
                field("Qty to receive Adj"; Rec."Qty to receive Adj")
                {
                }
                field("Returned Qty"; Rec."Returned Qty")
                {
                    Caption = 'Receipt Quantity';
                }
                field("Ambiant Volume"; Rec."Ambiant Volume")
                {
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    Visible = false;
                }
                field("Qty. in Transit (Base)"; Rec."Qty. in Transit (Base)")
                {
                    Visible = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    Visible = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Visible = false;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                }
                field("Batch Number"; Rec."Batch Number")
                {
                    Visible = false;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Visible = false;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MotifsAjustements)
            {
                Caption = 'Adjustment Lines';
                Ellipsis = true;
                Image = AdjustEntries;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Transfer Reason Codes";
                RunPageLink = "Document Type" = CONST(Transfer),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
            action(CalculerQteAjustee)
            {
                Caption = 'Calc. Adjust Qty';
                Ellipsis = true;
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.AFK_RefreshAdjustQty;
                end;
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
            }
        }
    }
}

