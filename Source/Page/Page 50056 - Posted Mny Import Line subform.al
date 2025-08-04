page 50056 "Posted Mny Import Line subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Posted Moneytech Import Line";

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
                field("Station Code"; Rec."Station Code")
                {
                }
                field("Debitor No."; Rec."Debitor No.")
                {
                }
                field("Card Type"; Rec."Card Type")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Card Number"; Rec."Card Number")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Visible = false;
                }
                field(TransmissionNo; Rec.TransmissionNo)
                {
                }
                field(TransmissionDate; Rec.TransmissionDate)
                {
                }
            }
        }
    }

    actions
    {
    }
}

