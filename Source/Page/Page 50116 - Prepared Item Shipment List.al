page 50116 "Prepared Item Shipment List"
{
    Caption = 'Prepared Item Shipment List';
    CardPageID = "Item Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Shipment),
                            "Shipment Status" = CONST(Prepared));

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
                field(BLub_Preparation; Rec.BLub_Preparation)
                {
                }
                field(BLub_Expedition; Rec.BLub_Expedition)
                {
                }
                field(BLub_Confirmation; Rec.BLub_Confirmation)
                {
                }
                field("Customer Search Name"; Rec."Customer Search Name")
                {
                }
            }
        }
    }

    actions
    {
    }

    local procedure ApplyFiltresMagasin()
    var
        SecMgt: Codeunit "Security Mgt";
        UserMgt: Codeunit "User Setup Management";
        FiltreMag: Text[500];
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FiltreMag := SecMgt.GetFiltresMagasinsDispaching(UserMgt.GetSalesFilter);
            if FiltreMag <> '' then begin
                Rec.FilterGroup(2);
                Rec.SetFilter(Rec."Location Code", FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;
    end;
}

