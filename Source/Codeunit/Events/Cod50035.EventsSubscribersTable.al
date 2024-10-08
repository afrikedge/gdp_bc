codeunit 50035 "EventsSubscribers Table"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', true, true)]
    local procedure OnAfterInitRecord_SalesHeader(var SalesHeader: Record "Sales Header")
    var
        SOProcess: codeunit "A01 Sales Order Processing";
    begin
        SalesHeader."A01 User Id" := CopyStr(USERID, 1, 50);
        SOProcess.InsertNewStep(SalesHeader."No.", "A01 ActionStepHistory"::Creation, FORMAT(SalesHeader."A01 Processing Status"), '');
    end;
}
