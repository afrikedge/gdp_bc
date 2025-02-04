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
}
