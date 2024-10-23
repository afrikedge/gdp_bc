page 50251 "Posted Reception Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Item Return Line";
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
                field("Exchange Type"; Rec."Exchange Type")
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
                field("Qty to receive Adj"; Rec."Qty to receive Adj")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
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
                RunObject = Page "Posted Transfer Reason Codes";
                RunPageLink = "Document Type" = CONST(Transfer),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
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

