tableextension 50077 "A02 Payment Line" extends "Payment Line"
{

    //Unsupported feature: Code Modification on "SetUpNewLine(PROCEDURE 1120007)".

    //procedure SetUpNewLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Account Type" := LastGenJnlLine."Account Type";
    IF "No." <> '' THEN BEGIN
      Statement.GET("No.");
      PaymentClass.GET(Statement."Payment Class");
    #5..11
            "Document No." := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series","Posting Date",FALSE);
    END;
    "Due Date" := Statement."Posting Date";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Account Type" := LastGenJnlLine."Account Type";

    //*************************
    //*************************
    VALIDATE("Account No.",LastGenJnlLine."Account No.");
    //*************************
    //*************************

    #2..14
    */
    //end;
}

