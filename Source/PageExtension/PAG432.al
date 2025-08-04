pageextension 50038 pageextension70000084 extends "Reminder Levels"
{
    layout
    {
        addafter("Calculate Interest")
        {
            field("Reminder Report ID"; Rec."Reminder Report ID")
            {
                ApplicationArea = All;
            }
            field("Reminder Report Name"; Rec."Reminder Report Name")
            {
                ApplicationArea = All;
            }
            field("AG1 Report Usage"; Rec."AG1 Report Usage")
            {
                ApplicationArea = All;
            }
        }
    }
}

