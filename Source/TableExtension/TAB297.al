tableextension 70000124 tableextension70000124 extends "Issued Reminder Header" 
{

    //Unsupported feature: Variable Insertion (Variable: ReminderLevel) (VariableCollection) on "PrintRecords(PROCEDURE 1)".


    //Unsupported feature: Variable Insertion (Variable: PostReminder) (VariableCollection) on "PrintRecords(PROCEDURE 1)".


    //Unsupported feature: Code Modification on "PrintRecords(PROCEDURE 1)".

    //procedure PrintRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IsHandled := FALSE;
        OnBeforePrintRecords(Rec,ShowRequestForm,SendAsEmail,HideDialog,IsHandled);
        IF IsHandled THEN
        #4..19
          DocumentSendingProfile.TrySendToPrinter(
            DummyReportSelections.Usage::Reminder,Rec,
            IssuedReminderHeaderToSend.FIELDNO("Customer No."),ShowRequestForm);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        // {>>>>>>>} ORIGINAL
        // WITH IssuedReminderHeader DO BEGIN
        //  COPY(Rec);
        //  ReportSelection.SETRANGE(Usage,ReportSelection.Usage::Reminder);
        //  ReportSelection.SETFILTER("Report ID",'<>0');
        //  ReportSelection.FIND('-');
        //  REPEAT
        //    IF NOT SendAsEmail THEN
        //      REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,IssuedReminderHeader)
        //    ELSE
        //      SendReport(ReportSelection."Report ID");
        //  UNTIL ReportSelection.NEXT = 0;
        // END;
        // {=======} MODIFIED
        // WITH IssuedReminderHeader DO BEGIN
        //  COPY(Rec);
        //  {ReportSelection.SETRANGE(Usage,ReportSelection.Usage::Reminder);
        //  ReportSelection.SETFILTER("Report ID",'<>0');
        //  ReportSelection.FIND('-');
        //  REPEAT
        //    IF NOT SendAsEmail THEN
        //      REPORT.RUNMODAL(ReportSelection."Report ID",ShowRequestForm,FALSE,IssuedReminderHeader)
        //    ELSE
        //      SendReport(ReportSelection."Report ID");
        //  UNTIL ReportSelection.NEXT = 0;}
        //  PostReminder.GET(IssuedReminderHeader.GETFILTER("No."));
        //  ReminderLevel.GET(PostReminder."Reminder Terms Code",PostReminder."Reminder Level");
        //  ReminderLevel.TESTFIELD(ReminderLevel."Reminder Report ID");
        //  IF NOT SendAsEmail THEN
        //      REPORT.RUNMODAL(ReminderLevel."Reminder Report ID",ShowRequestForm,FALSE,IssuedReminderHeader)
        //    ELSE
        //      SendReport(ReminderLevel."Reminder Report ID");
        // END;
        // {=======} TARGET
        #1..22
        */
    //end;
}

