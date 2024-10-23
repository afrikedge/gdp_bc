page 50115 "Item Shipment List"
{
    Caption = 'Item Shipment List';
    CardPageID = "Item Shipment";
    Editable = false;
    PageType = List;
    SourceTable = "Adjustment Header";
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
                field("Shipment Status"; Rec."Shipment Status")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("User ID"; Rec."User ID")
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
                Rec.FilterGroup(2);
                Rec.SetFilter(Rec."Location Code", FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;
    end;
}

