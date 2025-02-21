page 50350 "Vendor Emails To Send"
{
    Caption = 'Emails fournisseurs à envoyer';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Tampon Payment Vendor Email";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryID; Rec.EntryID)
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Vendor Email"; Rec."Vendor Email")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(Attachment; Rec.Attachment)
                {
                    Visible = false;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(EmailSent; Rec.EmailSent)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Refresh emails")
            {
                Caption = 'Update emails address';
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Vend: Record Vendor;
                begin
                    if (Vend.Get(Rec."Vendor No.")) then begin
                        rec.SendTo := Vend."E-Mail";
                        rec.Modify();
                    end;
                end;
            }
            action("Send emails")
            {
                Caption = 'Envoyer tous les mails';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TresoMgt.SendEmailVendorTransferAll();
                end;
            }
            action("Envoyer le mail pour la ligne")
            {
                Caption = 'Envoyer le mail pour la ligne';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TresoMgt.SendEmailVendorTransferOne(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("User ID", UserId);
        // Rec.SetRange(EmailSent, false);
        // Rec.SetRange(Rec.EmailType, Rec.EmailType::VendorTransfer);
        Rec.FilterGroup(0);
    end;

    var
        TresoMgt: Codeunit "Treso Mgt";
}

