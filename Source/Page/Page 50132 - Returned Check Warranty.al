page 50132 "Returned Check Warranty"
{
    Caption = 'Returned Check Warranty';
    Editable = false;
    PageType = List;
    SourceTable = "Check Warranty";
    SourceTableView = WHERE(Status = CONST(Returned));

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
                field("Return Date"; Rec."Return Date")
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

