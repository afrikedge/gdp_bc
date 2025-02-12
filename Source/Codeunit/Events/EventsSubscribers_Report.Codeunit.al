/// <summary>
/// Codeunit ReportEventsSubr (ID 50042).
/// </summary>
codeunit 50042 "EventsSubscribers_Report"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnAfterSubstitute_Reports(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Bank Acc. - Detail Trial Bal." then
            NewReportId := Report::"AfkCpteBancaireGrdLivre";

        if ReportId = Report::"Detail Trial Balance" then
            NewReportId := Report::"Afk Grand Livre";
    end;
}