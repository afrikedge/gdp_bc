codeunit 50035 "EventsSubscribers Table"
{
    [EventSubscriber(ObjectType::Table, Database::"Currency", 'OnBeforeGetGainLossAccount', '', true, true)]
    local procedure Currency_OnBeforeGetGainLossAccount(var Currency: Record Currency; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
    // AddOnSetup: record "AddOn Setup";
    // TresoMgt: codeunit "Treso Mgt";
    begin
        // AddOnSetup.GET;
        // AddOnSetup.TESTFIELD(AddOnSetup."PROGAL Vendor Code");
        //IF (AddOnSetup."PROGAL Vendor Code" = DtldCVLedgEntryBuffer."CV No.") THEN
        //EXIT(TresoMgt.GetGainLossAccount_PROGAL(DtldCVLedgEntryBuffer));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", 'OnBeforeCheckBlockedVend', '', true, true)]
    local procedure Vendor_OnBeforeCheckBlockedVend(Vendor: Record Vendor; Source: Option Journal,Document; DocType: Option; Transaction: Boolean; var IsHandled: Boolean)
    var
    begin
        Vendor.TESTFIELD(Vendor."Validation Status", Vendor."Validation Status"::Validated);
    end;








}
