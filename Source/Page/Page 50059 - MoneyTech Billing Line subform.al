page 50059 "MoneyTech Billing Line subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "MoneyTech Billing Line";

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
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Card Number"; Rec."Card Number")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

