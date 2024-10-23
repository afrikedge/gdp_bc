page 50119 "Posted Item Shipment List"
{
    Caption = 'Posted Item Shimpent List';
    CardPageID = "Posted Item Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Shipment));

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
                field("Document Date"; Rec."Document Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ApplyFiltresMagasin;
    end;

    local procedure ApplyFiltresMagasin()
    var
        SecMgt: Codeunit "Security Mgt";
        UserMgt: Codeunit "User Setup Management";
        FiltreMag: Text[500];
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FiltreMag := SecMgt.GetFiltresMagasinsDispaching(UserMgt.GetSalesFilter);
            if FiltreMag <> '' then begin
                FilterGroup(2);
                SetFilter(Rec."Location Code", FiltreMag);
                FilterGroup(0);
            end;
        end;
    end;
}

