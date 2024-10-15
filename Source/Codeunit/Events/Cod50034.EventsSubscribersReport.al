codeunit 50034 "EventsSubscribers Report"
{
    [EventSubscriber(ObjectType::Report, Report::"Adjust Cost - Item Entries", 'OnBeforeRunCostAdjustment', '', true, true)]
    local procedure AdjustCostItemEntries_OnBeforeRunCostAdjustment()
    var
        SingleInstanceCu: Codeunit SingleInstance;
    begin
        SingleInstanceCu.Set_AFK_EscapeCheck_MultiLevelAdjmt(true);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Adjust Cost - Item Entries", 'OnAfterRunCostAdjustment', '', true, true)]
    local procedure AdjustCostItemEntries_OnAfterRunCostAdjustment()
    var
        SingleInstanceCu: Codeunit SingleInstance;
    begin
        SingleInstanceCu.Clear_AFK_EscapeCheck_MultiLevelAdjmt();
    end;


}
