pageextension 50011 pageextension70000090 extends "Sales Invoice Subform"
{
    layout
    {

        modify("Unit Price")
        {
            Editable = AFK_CanUpdatePrice;
        }
        modify("Line Amount")
        {
            Editable = false;
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        AddOnSetup.GET;
        AFK_IsAMSA := AFK_SalesProcess.IsCdeAMSA(SalesHeader);
        CanEditPrices := TRUE;
        IF ((NOT AFK_SalesProcess.IsCdeJIRAMA(SalesHeader)
          AND (Rec.GetParentCategory() = AddOnSetup."PBL Category Code"))) THEN
            CanEditPrices := FALSE;

        AFK_CanUpdatePrice := AFK_SecMgt.CanUpdatePrices;
    end;

    var
        SalesHeader: Record "36";

        AFK_IsAMSA: Boolean;
        AFK_SalesProcess: Codeunit "50001";
        CanEditPrices: Boolean;
        AddOnSetup: Record "50000";
        AFK_CanUpdatePrice: Boolean;
        AFK_SecMgt: Codeunit "50016";
}

