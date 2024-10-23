page 50089 "Posted Item Exchange Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Posted Adjustment Line";
    SourceTableView = WHERE("Document Type" = CONST(Exchange));

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
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Location Code"; Rec."Location Code")
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
                field("Transfer Fees"; Rec."Transfer Fees")
                {
                }
                field("USD Unit Price"; Rec."USD Unit Price")
                {
                }
                field("USD Rate"; Rec."USD Rate")
                {
                }
                field("GRT Storage Fee"; Rec."GRT Storage Fee")
                {
                }
                field("LPSA Storage Fee"; Rec."LPSA Storage Fee")
                {
                }
                field("Exchange Transit Location"; Rec."Exchange Transit Location")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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

