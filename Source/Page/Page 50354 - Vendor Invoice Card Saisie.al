page 50354 "Vendor Invoice Card Saisie"
{
    Caption = 'Vendor invoice doc card';
    DataCaptionFields = "Vendor Invoice No.";
    PageType = Document;
    SourceTable = "Vendor Invoice Doc";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("Reference Number"; Rec."Reference Number")
                {
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ShowMandatory = true;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ShowMandatory = true;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                    ShowMandatory = true;
                }
                field("Order No"; Rec."Order No")
                {
                    Visible = IsNotSaisie;
                }
                field(MontantHTVA; Rec.MontantHTVA)
                {
                    Visible = IsNotSaisie;
                }
                field(MontantTTC; Rec.MontantTTC)
                {
                    Visible = IsNotSaisie;
                }
                field(Devise; Rec.Devise)
                {
                    Visible = IsNotSaisie;
                }
            }
            group(Infos)
            {
                Caption = 'Infos';
                Visible = IsNotSaisie;
                field(Status; Rec.Status)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Vendor Invoice Doc"),
                              "No." = field("Reference Number");
            }
            systempart(Control15; Links)
            {
            }
            systempart(Control16; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Receipts)
                {
                    Caption = 'Receipts';
                    Image = Receipt;
                    RunObject = Page "Posted Purchase Receipts";
                    RunPageLink = "Order No." = FIELD("Order No");
                    RunPageView = SORTING("Order No.");
                }
            }
        }
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(TraiterFacture)
                {
                    Caption = 'Process';
                    Ellipsis = true;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        VendInvMgt.TraiterFacture(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsNotSaisie := Rec.Status <> Rec.Status::EnSaisie;
    end;

    var
        VendInvMgt: Codeunit VendorInvoiceMgt;
        IsNotSaisie: Boolean;
}

