page 50085 "Item Loan List"
{
    Caption = 'Item Loan List';
    CardPageID = "Item Loan";
    PageType = List;
    SourceTable = "Adjustment Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTableView = WHERE("Document Type" = CONST(Loan));

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
                    Caption = 'Posting Date';
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Document Date"; Rec."Document Date")
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
            }
        }
    }

    actions
    {
    }
}

