page 50145 "Payment Config CCL"
{
    Caption = 'Payment document config';
    PageType = List;
    SourceTable = "Payment CC Config";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field("CC Document Type"; Rec."CC Document Type")
                {
                }
                field("Payment Class"; Rec."Payment Class")
                {
                }
            }
        }
    }

    actions
    {
    }
}

