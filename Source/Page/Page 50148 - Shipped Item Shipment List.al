page 50148 "Shipped Item Shipment List"
{
    Caption = 'Shipped Item Shipment List';
    CardPageID = "Item Shipment";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Shipment),
                            "Shipment Status" = CONST(Shipped));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Shipment Status"; Rec."Shipment Status")
                {
                }
            }
        }
    }

    actions
    {
    }
}

