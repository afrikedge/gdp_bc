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

    [EventSubscriber(ObjectType::Report, Report::"Calculate Depreciation", 'OnBeforeFAJnlLineInsert', '', true, true)]
    local procedure CalculateDepreciation_OnBeforeFAJnlLineInsert(var TempFAJournalLine: Record "FA Journal Line" temporary; var FAJournalLine: Record "FA Journal Line")
    var
        FA: record "Fixed Asset";
    begin
        AddOnSetup.GetRecordOnce();
        IF AddOnSetup."Activer libelles Immos" THEN
            if (FA.Get(FAJournalLine."FA No.")) then
                FAJournalLine.Description := COPYSTR(FA.Description, 1, 75) + '-' + FA."No.";
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calculate Depreciation", 'OnBeforeGenJnlLineInsert', '', true, true)]
    local procedure CalculateDepreciation_OnBeforeGenJnlLineInsert(var TempGenJournalLine: Record "Gen. Journal Line" temporary; var GenJournalLine: Record "Gen. Journal Line")
    var
        FA: record "Fixed Asset";
    begin
        AddOnSetup.GetRecordOnce();
        IF AddOnSetup."Activer libelles Immos" THEN
            if (FA.Get(GenJournalLine."Account No.")) then
                GenJournalLine.Description := COPYSTR(FA.Description, 1, 75) + '-' + FA."No.";
    end;

    var
        AddOnSetup: record "AddOn Setup";

}
