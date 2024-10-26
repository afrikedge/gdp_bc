page 50052 "MoneyTech Import Line subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MoneyTech Import Line";

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
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
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

