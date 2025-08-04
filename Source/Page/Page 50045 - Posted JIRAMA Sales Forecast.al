page 50045 "Posted JIRAMA Sales Forecast"
{
    Caption = 'Commande JIRAMA Enregistrée';
    PageType = Document;
    SourceTable = "Jirama Sales Forecast";
    SourceTableView = WHERE(Status = CONST(Archived));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Editable = false;
                }
                field("Partner No."; Rec."Partner No.")
                {
                    Editable = false;
                }
                field("Partner Name"; Rec."Partner Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
            }
            part(PurchLines; "Posted JIRAMA Forecast Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(CommandesList)
            {
                Caption = 'Sales orders';
                Image = Sales;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Sales Order List - To Ship";
                RunPageLink = "Created By Doc No." = FIELD("No.");
            }
            action(PurchOrder)
            {
                Caption = 'Purchase order';
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "PBL Purchase Order List";
                RunPageLink = "Created By Doc No." = FIELD("No.");
            }
        }
    }

    var
        JiramaProcess: Codeunit "JIRAMA Sales Mgt";
}

