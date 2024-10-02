tableextension 50035 "A02 Reversal Entry" extends "Reversal Entry"
{
    // //Annulation des paiements clients liée aux documents de paiement encours
    // 181017 Contre passation reservée aux RADV


    //Unsupported feature: Code Modification on "ReverseEntries(PROCEDURE 32)".

    //procedure ReverseEntries();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := FALSE;
    OnBeforeReverseEntries(Number,RevType,IsHandled);
    IF IsHandled THEN
    #4..12
      ReversalPost.RUN(TempReversalEntry);
    END;
    TempReversalEntry.DELETEALL;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //181017
    //**************************************
    AFK_SecMgt.CheckCanReverseTransaction;
    //**************************************


    #1..15
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: PayDoc) (VariableCollection) on "CheckCust(PROCEDURE 16)".


    //Unsupported feature: Variable Insertion (Variable: PayStatus) (VariableCollection) on "CheckCust(PROCEDURE 16)".



    //Unsupported feature: Code Modification on "CheckCust(PROCEDURE 16)".

    //procedure CheckCust();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Cust.GET(CustLedgEntry."Customer No.");
    CheckPostingDate(
      CustLedgEntry."Posting Date",CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
    Cust.CheckBlockedCustOnJnls(Cust,CustLedgEntry."Document Type",FALSE);
    IF CustLedgEntry.Reversed THEN
      AlreadyReversedEntry(CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.");
    CheckDtldCustLedgEntry(CustLedgEntry);

    OnAfterCheckCust(Cust,CustLedgEntry);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8


    //***************************************************************************************
    PayDoc.RESET;
    PayDoc.SETCURRENTKEY("Customer No.","Origin Document N°");
    PayDoc.SETRANGE("Customer No.",CustLedgEntry."Customer No.");
    PayDoc.SETRANGE("Origin Document N°",CustLedgEntry."Document No.");
    IF PayDoc.FINDFIRST THEN
      IF PayStatus.GET(PayDoc."Payment Class", PayDoc."Status No.") THEN
        IF NOT PayStatus.Cancellable THEN
          ERROR(AFK_Err001,CustLedgEntry.TABLECAPTION,CustLedgEntry."Entry No.",PayDoc."No.");

    //***************************************************************************************


    OnAfterCheckCust(Cust,CustLedgEntry);
    */
    //end;


    //Unsupported feature: Code Modification on "TestFieldError(PROCEDURE 4)".

    //procedure TestFieldError();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ERROR(Text004);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF NOT IsDocSpecif THEN  //**************************************************************************
      ERROR(Text004);
    */
    //end;


    //Unsupported feature: Code Modification on "InsertFromGLEntry(PROCEDURE 40)".

    //procedure InsertFromGLEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TempRevertTransactionNo.FINDSET;
    REPEAT
      IF RevType = RevType::Transaction THEN
    #4..17
          NextLineNo := NextLineNo + 1;
          TempReversalEntry.INSERT;
          IF GLEntry.Letter <> '' THEN
            ERROR(Text000,RevType,Number)
        UNTIL GLEntry.NEXT = 0;
    UNTIL TempRevertTransactionNo.NEXT = 0;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..20
            ERROR(Text000,RevType,Number);



        UNTIL GLEntry.NEXT = 0;
    UNTIL TempRevertTransactionNo.NEXT = 0;
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromGLEntry(PROCEDURE 42)".

    //procedure CopyFromGLEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Entry No." := GLEntry."Entry No.";
    "Posting Date" := GLEntry."Posting Date";
    "Source Code" := GLEntry."Source Code";
    #4..14
    "Bal. Account Type" := GLEntry."Bal. Account Type";
    "Bal. Account No." := GLEntry."Bal. Account No.";

    OnAfterCopyFromGLEntry(Rec,GLEntry);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17
    //**************************************
    AFK_SecMgt.CheckReverseAmount("Amount (LCY)");
    //**************************************

    OnAfterCopyFromGLEntry(Rec,GLEntry);
    */
    //end;

    procedure SetIsDocSpecif(isSpec: Boolean)
    begin
        IsDocSpecif := isSpec;
    end;

    var
        IsDocSpecif: Boolean;
        AFK_Err001: Label 'Vous ne pouvez pas contrepasser %1 n° %2 car l''écriture est associée à un document de paiement %3 qui n''est pas dans un statut annulable';
    //AFK_SecMgt: Codeunit "50016";
}

