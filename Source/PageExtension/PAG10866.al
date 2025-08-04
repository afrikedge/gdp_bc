pageextension 50080 pageextension70000005 extends "Payment Steps"
{
    layout
    {
        addafter("Name")
        {
            field("Previous Status"; Rec."Previous Status")
            {
                ApplicationArea = All;
            }
            field("Previous Status Name"; Rec."Previous Status Name")
            {
                ApplicationArea = All;
            }
            field("Next Status"; Rec."Next Status")
            {
                ApplicationArea = All;
            }
            field("Next Status Name"; Rec."Next Status Name")
            {
                ApplicationArea = All;
            }
            field("Action Type"; Rec."Action Type")
            {
                ApplicationArea = All;
            }
            field("Report No."; Rec."Report No.")
            {
                ApplicationArea = All;
            }
            field("Export Type"; Rec."Export Type")
            {
                ApplicationArea = All;
            }
            field("Export No."; Rec."Export No.")
            {
                ApplicationArea = All;
            }
            field("Verify Lines RIB"; Rec."Verify Lines RIB")
            {
                ApplicationArea = All;
            }
            field("Verify Due Date"; Rec."Verify Due Date")
            {
                ApplicationArea = All;
            }
            field("Source Code"; Rec."Source Code")
            {
                ApplicationArea = All;
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
            field("Header Nos. Series"; Rec."Header Nos. Series")
            {
                ApplicationArea = All;
            }
            field(Correction; Rec.Correction)
            {
                ApplicationArea = All;
            }
            field("Realize VAT"; Rec."Realize VAT")
            {
                ApplicationArea = All;
            }
            field("Verify Header RIB"; Rec."Verify Header RIB")
            {
                ApplicationArea = All;
            }
            field("Acceptation Code<>No"; Rec."Acceptation Code<>No")
            {
                ApplicationArea = All;
            }
        }
    }
}

