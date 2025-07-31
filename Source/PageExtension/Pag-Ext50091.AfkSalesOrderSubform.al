pageextension 50091 "Afk Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            Editable = AFK_CanUpdateLineAfterValidated;
            trigger OnAfterValidate()
            var
            begin
                IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
                    IF SalesHeader."Created By Doc No." <> '' THEN
                        IF AFKSOMgt.IsCdeJIRAMA(SalesHeader) THEN
                            IF NOT AFK_SecMgt.CanUpdateQtyJIRAMA_SO THEN
                                ERROR(AFK_Text002, SalesHeader."Created By Doc No.");
            end;
        }
        modify(Type)
        {
            Editable = AFK_CanUpdateLineAfterValidated;
        }
        modify("No.")
        {
            Editable = AFK_CanUpdateLineAfterValidated;
        }
        modify(Description)
        {
            Editable = AFK_CanUpdateLineAfterValidated;
        }
        modify("Location Code")
        {
            Editable = AFK_CanUpdateLineAfterValidated;
        }
        modify("Unit Price")
        {
            Editable = AFK_CanUpdatePrice;
            BlankZero = true;
            ShowMandatory = Rec.Type <> Rec.Type::" ";
        }
        modify("Line Amount")
        {
            Editable = AFK_CanUpdatePrice;
        }
        addafter("Qty. to Ship")
        {
            field("Qty to prepare"; Rec."Qty to prepare")
            {
                Visible = ShowQteAPreparer;
                ApplicationArea = All;
            }
            field("Qty to remove"; Rec."Qty to remove")
            {
                Visible = ShowQteAEnlever;
                ApplicationArea = All;
            }
        }
        addafter("Attached Lines Count")
        {
            field("Initial Qty"; Rec."Initial Qty")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
            field("Provision Qty"; Rec."Provision Qty")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
            field("Real Location"; Rec."Real Location")
            {
                Visible = false;
                Editable = false;
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        GetHeader();
        ShowQteAEnlever := AFKSOMgt.IsCdePBL(SalesHeader) AND (SalesHeader."Shipment Method Code" <> 'TRP');
        ShowQteAPreparer := AFKSOMgt.IsCdeLUBS(SalesHeader) OR AFKSOMgt.IsCdeGPL(SalesHeader);
        //ShowQteAExpedier := NOT(ShowQteAEnlever OR ShowQteAPreparer)
        //ShowQteAExpedier := TRUE;
        AFK_CanUpdatePrice := ((SalesHeader."Delivery Status" = SalesHeader."Delivery Status"::ValidationTarifs)
              OR (AFK_SecMgt.CanUpdatePrices));

        AFK_CanUpdateLineAfterValidated := AFKSOMgt.CanUpdateOrderLineAfterValidation(SalesHeader);
    end;

    trigger OnOpenPage()
    var
    //myInt: Integer;
    begin
        AFK_CanUpdateLineAfterValidated := true;
    end;

    local procedure GetHeader()
    var
    begin
        if (SalesHeader."No." <> Rec."Document No.") then
            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
    end;


    var
        SalesHeader: record "Sales Header";
        AFKSOMgt: Codeunit "Sales Order Process";
        AFK_SecMgt: Codeunit "Security Mgt";
        ShowQteAEnlever: Boolean;
        ShowQteAPreparer: Boolean;
        AFK_CanUpdatePrice: Boolean;
        AFK_CanUpdateLineAfterValidated: Boolean;
        AFK_Text002: label 'Vous ne pouvez pas modifier cette quantité car la commande provient d''un document de prévision %1';
}
