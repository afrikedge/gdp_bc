codeunit 50033 "EventsSubscribers Page"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    local procedure DocumentAttachmentFactbox_OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        VendInvoice: record "Vendor Invoice Doc";
    begin
        if (DocumentAttachment."Table ID" = Database::"Vendor Invoice Doc") then begin
            RecRef.Open(Database::"Vendor Invoice Doc");
            VendInvoice.SetRange("Reference Number", DocumentAttachment."No.");
            if (VendInvoice.FindFirst()) then
                RecRef.GetTable(VendInvoice);
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Report Selection - Reminder", 'OnSetUsageFilterOnAfterSetFiltersByReportUsage', '', true, true)]
    local procedure P524_OnSetUsageFilterOnAfterSetFiltersByReportUsage(var Rec: Record "Report Selections"; ReportUsage2: Enum "Report Selection Usage Reminder")
    begin
        case ReportUsage2 of
            Enum::"Report Selection Usage Reminder"::Reminder1:
                Rec.SetRange(Usage, Enum::"Report Selection Usage"::Reminder1);
            Enum::"Report Selection Usage Reminder"::"Reminder2":
                Rec.SetRange(Usage, Enum::"Report Selection Usage"::Reminder2);
            Enum::"Report Selection Usage Reminder"::"Reminder3":
                Rec.SetRange(Usage, Enum::"Report Selection Usage"::Reminder3);
        end;
    end;
}
