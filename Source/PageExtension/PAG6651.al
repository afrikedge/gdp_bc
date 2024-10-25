pageextension 50063 pageextension70000128 extends "Posted Return Shipment Subform"
{
    actions
    {

        //Unsupported feature: Code Modification on "ItemCreditMemoLines(Action 1903100004).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        PageShowItemPurchCrMemoLines;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        // {>>>>>>>} ORIGINAL
        // ShowItemPurchCrMemoLines;
        // {=======} MODIFIED
        // ShowItemPurchCrMemoLinesPage;
        // {=======} TARGET
        PageShowItemPurchCrMemoLines;
        */
        //end;
    }


    //Unsupported feature: Code Modification on "PageShowItemPurchCrMemoLines(PROCEDURE 2)".

    //procedure PageShowItemPurchCrMemoLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD(Type,Type::Item);
    ShowItemPurchCrMemoLines;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TESTFIELD(Type,Type::Item);
    ShowItemPurchCrMemoLinesPage;
    */
    //end;

    // local procedure ShowItemPurchCrMemoLinesPage()
    // begin
    //     TESTFIELD(Type,Type::Item);
    //     ShowItemPurchCrMemoLinesPage;
    // end;
}

