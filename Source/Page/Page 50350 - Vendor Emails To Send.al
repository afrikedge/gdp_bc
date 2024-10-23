page 50350 "Vendor Emails To Send"
{
    Caption = 'Emails fournisseurs à envoyer';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Tampon Payment Vendor Email";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send emails")
            {
                Caption = 'Send emails';
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
        Rec.FilterGroup(0);
    end;

    var
        TresoMgt: Codeunit "Treso Mgt";
}

