page 50190 "Item Invoiced Conso List Relea"
{
    Caption = 'Invoiced consumption List (To be invoice)';
    CardPageID = "Item Invoiced Conso Released";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST("Invoiced Consumption"),
                            Status = CONST(Released));

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
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Station Code';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }
            }
        }
    }

    actions
    {
    }
}

