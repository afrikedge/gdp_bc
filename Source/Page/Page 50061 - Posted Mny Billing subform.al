page 50061 "Posted Mny Billing subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
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
                field("Invoice No"; Rec."Invoice No")
                {
                }
            }
        }
    }

    actions
    {
    }
}

