pageextension 50062 pageextension70000124 extends "Posted Purchase Document Lines"
{
    var
        AFKToPurchHeader: Record "38";


    //Unsupported feature: Code Modification on "CopyLineToDoc(PROCEDURE 5)".

    //procedure CopyLineToDoc();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OnBeforeCopyLineToDoc(CopyDocMgt);
    ToPurchHeader.TESTFIELD(Status,ToPurchHeader.Status::Open);
    LinesNotCopied := 0;
    #4..13
        BEGIN
          CurrPage.PostedInvoices.PAGE.GetSelectedLine(FromPurchInvLine);
          CopyDocMgt.SetProperties(FALSE,FALSE,FALSE,FALSE,TRUE,TRUE,OriginalQuantity);
          CopyDocMgt.CopyPurchaseLinesToDoc(
            PurchDocType::"Posted Invoice",ToPurchHeader,
            FromPurchRcptLine,FromPurchInvLine,FromReturnShptLine,FromPurchCrMemoLine,LinesNotCopied,MissingExCostRevLink);
        END;
      2:
        BEGIN
    #23..39

    IF LinesNotCopied <> 0 THEN
      MESSAGE(Text000);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..16
    // {>>>>>>>} ORIGINAL
    //      CopyDocMgt.CopyPurchInvLinesToDoc(
    //        ToPurchHeader,FromPurchInvLine,LinesNotCopied,MissingExCostRevLink);
    // {=======} MODIFIED
    //      //CopyDocMgt.AFKSetToPurchHeader(AFKToPurchHeader);//***************************
    //      CopyDocMgt.CopyPurchInvLinesToDoc(
    //        ToPurchHeader,FromPurchInvLine,LinesNotCopied,MissingExCostRevLink);
    // {=======} TARGET
    #17..19

    #20..42
    */
    //end;
}

