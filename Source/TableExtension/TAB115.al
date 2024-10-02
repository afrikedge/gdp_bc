tableextension 50029 "A02 Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    // //MAJ la fonction ShowItemReturnRcptLines est Globale et non locale
    // //JN 310718 Sauvegarde PU utilises pour redevance OMH dans les lignes factures
    fields
    {
        field(50010; "OMH Fees Price"; Decimal)
        {
        }
        field(50011; "FER Fees Price"; Decimal)
        {
        }
        field(50012; "ENV Fees Price"; Decimal)
        {
        }
        field(50014; "RDS Fees Price"; Decimal)
        {
        }
        field(50080; VAT20Amount; Decimal)
        {
        }
        field(50081; VAT15Amount; Decimal)
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: AFKItem1) (VariableCollection) on "InitFromSalesLine(PROCEDURE 8)".



    //Unsupported feature: Code Modification on "InitFromSalesLine(PROCEDURE 8)".

    //procedure InitFromSalesLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    INIT;
    TRANSFERFIELDS(SalesLine);
    IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
    #4..6
    Quantity := SalesLine."Qty. to Invoice";
    "Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";

    OnAfterInitFromSalesLine(Rec,SalesCrMemoHeader,SalesLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9

    //310718**************************************************
    IF (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
      AFKItem1.GET(SalesLine."No.");
      "OMH Fees Price" := AFKItem1."OMH Fees Price";
      "FER Fees Price" := AFKItem1."FER Fees Price";
      "ENV Fees Price" := AFKItem1."ENV Fees Price";
      "RDS Fees Price" := AFKItem1."RDS Fees Price";
    END;
    //END*****************************************************

    OnAfterInitFromSalesLine(Rec,SalesCrMemoHeader,SalesLine);
    */
    //end;
}

