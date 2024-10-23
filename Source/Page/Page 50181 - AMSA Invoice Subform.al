page 50181 "AMSA Invoice Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "AMSA Invoice Line";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Item No"; Rec."Item No")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Invoice Qty"; Rec."Invoice Qty")
                {
                }
                field("Order Ref"; Rec."Order Ref")
                {
                }
                field("Invoice Ref"; Rec."Invoice Ref")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                }
                field("Amount Incl. VAT"; Rec."Amount Incl. VAT")
                {
                }
                field(Process; Rec.Process)
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                }
            }
        }
    }

    actions
    {
    }
}

