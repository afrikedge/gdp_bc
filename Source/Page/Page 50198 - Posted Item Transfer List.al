page 50198 "Posted Item Transfer List"
{
    Caption = 'Posted Item Transfer List';
    CardPageID = "Posted Item Transfer";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Transfer));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Shipment Date';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Origin Location Code';
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Caption = 'Transfer-to Code';
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("BEX Number"; Rec."BEX Number")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

