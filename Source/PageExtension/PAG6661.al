pageextension 50064 pageextension70000129 extends "Posted Return Receipt Subform"
{
    actions
    {

        //Unsupported feature: Code Modification on "ItemCreditMemoLines(Action 1901652104).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        PageShowItemSalesCrMemoLines;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        // {>>>>>>>} ORIGINAL
        // ShowItemSalesCrMemoLines;
        // {=======} MODIFIED
        // ShowItemSalesCrMemoLinesPage;
        // {=======} TARGET
        PageShowItemSalesCrMemoLines;
        */
        //end;
    }


    //Unsupported feature: Code Modification on "PageShowItemSalesCrMemoLines(PROCEDURE 2)".

    //procedure PageShowItemSalesCrMemoLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD(Type,Type::Item);
    ShowItemSalesCrMemoLines;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TESTFIELD(Type,Type::Item);
    Rec.ShowItemSalesCrMemoLines;
    */
    //end;
}

