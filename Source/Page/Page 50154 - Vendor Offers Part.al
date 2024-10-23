page 50154 "Vendor Offers Part"
{
    Caption = 'Vendor Offers';
    DeleteAllowed = false;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Purchase Header";
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
                    Visible = false;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    Visible = false;
                }
                field("Validity Offer"; Rec."Validity Offer")
                {
                }
                field("Offer Prepayment %"; Rec."Offer Prepayment %")
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
                RunObject = Page "Purchase Quote";
                RunPageLink = "No." = FIELD("No.");
                RunPageMode = Edit;
            }
        }
    }
}

