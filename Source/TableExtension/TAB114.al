tableextension 50028 "A02 Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50012; Observations; Text[250])
        {
        }
    }


    //Unsupported feature: Code Modification on "PrintRecords(PROCEDURE 1)".

    //procedure PrintRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := FALSE;
    OnBeforePrintRecords(DummyReportSelections,Rec,ShowRequestPage,IsHandled);
    IF IsHandled THEN
      EXIT;

    DocumentSendingProfile.TrySendToPrinter(
      DummyReportSelections.Usage::"S.Cr.Memo",Rec,FIELDNO("Bill-to Customer No."),ShowRequestPage);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    CRReports.PrintNoteCredit_Avoir(Rec."No.");//ADDED JN200217
    {**************************************************************************
    DocumentSendingProfile.TrySendToPrinter(
      DummyReportSelections.Usage::"S.Cr.Memo",Rec,FIELDNO("Bill-to Customer No."),ShowRequestPage);
      }
    */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 5)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF UserSetupMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5



    //**********************************************
    SETRANGE("User ID",USERID);
    //**********************************************
    */
    //end;

    var
    //CRReports: Codeunit "50027";
}

