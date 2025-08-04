page 50041 "JIRAMA Sales Forecast Subform"
{
    AutoSplitKey = false;
    Caption = 'JIRAMA Sales Forecast Subform';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Jirama Sales Forecast Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        AddOnSetup.Get;
                        Cust.SetRange(Cust."Sales Channel Code", AddOnSetup."JIRAMA Sales Channel");
                        if PAGE.RunModal(PAGE::"Customer List", Cust) = ACTION::LookupOK then begin
                            Rec.Validate("Sell-to Customer No.", Cust."No.");
                        end;
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field(Volume; Rec.Volume)
                {
                }
                field("Added Volume"; Rec."Added Volume")
                {
                }
                field("Removed Volume"; Rec."Removed Volume")
                {
                }
                field("Actual Volume"; Rec."Actual Volume")
                {
                }
                field("Total Enleve"; Rec."Total Enleve")
                {
                }
                field("Remaining Volume"; Rec."Remaining Volume")
                {
                }
                field("Allowed Quantity"; Rec."Allowed Quantity")
                {
                }
                field("Comfirmed Quantity"; Rec."Comfirmed Quantity")
                {
                }
                field("Total Facture"; Rec."Total Facture")
                {
                }
                field("Sales Order No"; Rec."Sales Order No")
                {
                }
                field("Purchase Order No"; Rec."Purchase Order No")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenSalesOrder)
            {
                Caption = 'Sales Order';
                RunObject = Page "Sales Order - workflow";
                RunPageLink = "Document Type" = CONST(Order),
                              "No." = FIELD("Sales Order No");
            }
            action(OpenPurchOrder)
            {
                Caption = 'Purchase order';
                RunObject = Page "PBL Purchase Order";
                RunPageLink = "Document Type" = CONST(Order),
                              "No." = FIELD("Purchase Order No");
            }
        }
    }

    var
        AddOnSetup: Record "AddOn Setup";
        Cust: Record Customer;
}

