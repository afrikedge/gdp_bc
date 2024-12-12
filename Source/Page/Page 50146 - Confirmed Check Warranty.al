page 50146 "Confirmed Check Warranty"
{
    Caption = 'Confirmed Check Warranty';
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Check Warranty";
    SourceTableView = WHERE(Status = CONST(Confirmed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Check No."; Rec."Check No.")
                {
                }
                field("Check Date"; Rec."Check Date")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Confirmed Date"; Rec."Confirmed Date")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
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

