tableextension 50071 "A02 Return Receipt Line" extends "Return Receipt Line"
{
    // //ShowItemSalesCrMemoLines est globale

    procedure AFK_GetCrNum(): Code[20]
    var
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
    begin
        GetSalesCrMemoLines(TempSalesCrMemoLine);
        IF TempSalesCrMemoLine.FINDFIRST THEN EXIT(TempSalesCrMemoLine."Document No.");
    end;
}

