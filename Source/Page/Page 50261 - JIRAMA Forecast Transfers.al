page 50261 "JIRAMA Forecast Transfers"
{
    Caption = 'Quota Transfers';
    Editable = false;
    PageType = List;
    SourceTable = "JIRAMA Forecast Transfer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("From Sell-to Customer No."; Rec."From Sell-to Customer No.")
                {
                }
                field("From Ship-to Code"; Rec."From Ship-to Code")
                {
                }
                field("To Sell-to Customer No."; Rec."To Sell-to Customer No.")
                {
                }
                field(Volume; Rec.Volume)
                {
                }
                field("From Customer Name"; Rec."From Customer Name")
                {
                }
                field("To Customer Name"; Rec."To Customer Name")
                {
                }
                field("To Ship-to Code"; Rec."To Ship-to Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

