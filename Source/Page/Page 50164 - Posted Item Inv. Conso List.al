page 50164 "Posted Item Inv. Conso List"
{
    Caption = 'Posted Item invoiced conso List';
    CardPageID = "Posted Item Invoiced Conso";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST("Invoiced Consumption"));

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
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Station Code';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field("Posted Doc No"; Rec."Posted Doc No")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

