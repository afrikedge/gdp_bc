page 50080 "Item Exchange Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Adjustment Line";
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
                field("GRT Storage Fee"; Rec."GRT Storage Fee")
                {
                }
                field("LPSA Storage Fee"; Rec."LPSA Storage Fee")
                {
                }
                field("Exchange Transit Location"; Rec."Exchange Transit Location")
                {
                }
                field("Exch Transit Transfer Fee"; Rec."Exch Transit Transfer Fee")
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
                field("USD Unit Price 2"; Rec."USD Unit Price 2")
                {
                }
                field("USD Rate"; Rec."USD Rate")
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

