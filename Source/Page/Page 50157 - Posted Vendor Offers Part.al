page 50157 "Posted Vendor Offers Part"
{
    Caption = 'Offers';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Purchase Header Archive";
    SourceTableView = WHERE("Document Type" = CONST(Quote));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                    Visible = false;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field(DelaiDeLivraison; Rec.DelaiDeLivraison)
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Open the Offer")
            {
                Caption = 'Open the Offer';
                RunObject = Page "Purchase Quote Archive";
                RunPageLink = "No." = FIELD("No."),
                              "Version No." = FIELD("Version No.");
                RunPageMode = View;
            }
        }
    }
}

