page 50082 "Item Exchange List"
{
    Caption = 'Item Exchange List';
    CardPageID = "Item Exchange";
    PageType = List;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Exchange));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Cession Date"; Rec."Cession Date")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

