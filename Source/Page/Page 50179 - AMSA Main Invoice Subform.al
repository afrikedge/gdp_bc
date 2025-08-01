page 50179 "AMSA Main Invoice Subform"
{
    Caption = 'Invoices';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Fuel Statement Header";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field("Grouping Customer"; Rec."Grouping Customer")
                {
                    Editable = false;
                }
                field("Customer No"; Rec."Customer No")
                {
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Order No."; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'Invoice N°';
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field(Backcharge; Rec.Backcharge)
                {
                }
                field("Cost Code"; Rec."Cost Code")
                {
                }
                field("Company Code"; Rec."Company Code")
                {
                }
                field(Process; Rec.Process)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenInvoice)
            {
                Caption = 'Open Invoice';
                Image = DocumentEdit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "AMSA Invoice";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                              "No." = FIELD("No.");
                ShortCutKey = 'Return';
            }
        }
    }
}

