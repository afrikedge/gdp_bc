page 50138 "Open Letters of credit"
{
    Caption = 'Letters of credit (Open)';
    CardPageID = "Letter of Credit";
    PageType = List;
    SourceTable = "Letter of credit";
    SourceTableView = WHERE(Status = CONST(Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Letter of Credit Ref"; Rec."Letter of Credit Ref")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("CIF Amount"; Rec."CIF Amount")
                {
                }
                field("BL Date"; Rec."BL Date")
                {
                }
                field(Status; Status)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                }
                field("Purchase Quote Amount"; Rec."Purchase Quote Amount")
                {
                }
                field("Vendor Invoice Number"; Rec."Vendor Invoice Number")
                {
                }
                field("Purchase rate"; Rec."Purchase rate")
                {
                }
                field("Structure rate"; Rec."Structure rate")
                {
                }
                field("Total Purchased (LCY)"; Rec."Total Purchased (LCY)")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

