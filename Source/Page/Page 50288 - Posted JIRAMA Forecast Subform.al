page 50288 "Posted JIRAMA Forecast Subform"
{
    AutoSplitKey = false;
    Caption = 'JIRAMA Sales Forecast Subform';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Jirama Sales Forecast Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;

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
                    Editable = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field(Volume; Rec.Volume)
                {
                    Editable = false;
                }
                field("Added Volume"; Rec."Added Volume")
                {
                    Editable = false;
                }
                field("Removed Volume"; Rec."Removed Volume")
                {
                    Editable = false;
                }
                field("Actual Volume"; Rec."Actual Volume")
                {
                    Editable = false;
                }
                field("Total Enleve"; Rec."Total Enleve")
                {
                    Editable = false;
                }
                field("Remaining Volume"; Rec."Remaining Volume")
                {
                    Editable = false;
                }
                field("Allowed Quantity"; Rec."Allowed Quantity")
                {
                }
                field("Comfirmed Quantity"; Rec."Comfirmed Quantity")
                {
                }
                field("Total Facture"; Rec."Total Facture")
                {
                    Editable = false;
                }
                field("Sales Order No"; Rec."Sales Order No")
                {
                    Editable = false;
                }
                field("Purchase Order No"; Rec."Purchase Order No")
                {
                    Editable = false;
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

