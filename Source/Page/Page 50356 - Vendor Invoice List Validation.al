page 50356 "Vendor Invoice List Validation"
{
    Caption = 'Documents facture fournisseur en validation';
    CardPageID = "Vendor Invoice Card Encours";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Vendor Invoice Doc";
    SourceTableView = WHERE(Status = FILTER(AttenteValResp1 | AttenteValResp2 | AttenteValResp3 | Litigieuse | Validee | Comptabilise | AttentePaiement | Payee));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reference Number"; Rec."Reference Number")
                {
                }
                field("Vendor No"; Rec."Vendor No")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Order No"; Rec."Order No")
                {
                }
                field(MontantTTC; Rec.MontantTTC)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Validator Name"; Rec."Validator Name")
                {
                }
                field("Entry No"; Rec."Entry No")
                {
                    Visible = false;
                }
                field("Send Email for rejection"; Rec."Send Email for rejection")
                {
                }
                field("Reason for rejection"; Rec."Reason for rejection")
                {
                }
                field("Reason for refusal"; Rec."Reason for refusal")
                {
                }
                field("Payment Date"; Rec."Payment Date")
                {
                }
                field("Payment Method Code"; Rec."Payment Method Code")
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
            systempart(Control16; Links)
            {
            }
            systempart(Control15; Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        Rec.FilterGroup(2);
        Rec.SetCurrentKey("Workflow Code");
        Rec.SetFilter("Workflow Code", WkfwMgt.GetServicesUserFilter);
        Rec.FilterGroup(0);
    end;

    var
        WkfwMgt: Codeunit VendorInvoiceMgt;
}

