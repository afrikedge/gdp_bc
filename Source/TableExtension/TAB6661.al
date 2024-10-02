tableextension 70000157 tableextension70000157 extends "Return Receipt Line" 
{
    // //ShowItemSalesCrMemoLines est globale

    procedure AFK_GetCrNum(): Code[20]
    var
        TempSalesCrMemoLine: Record "115" temporary;
    begin
        GetSalesCrMemoLines(TempSalesCrMemoLine);
        IF TempSalesCrMemoLine.FINDFIRST THEN EXIT(TempSalesCrMemoLine."Document No.");
    end;
}

