page 50185 "Posted AMSA Main Invoice"
{
    Caption = 'Posted AMSA Main Invoice';
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Fuel Statement";
    SourceTableView = WHERE("Document Type" = CONST("Main invoice"));
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
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Total Counter"; Rec."Total Counter")
                {
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
            }
            part(Lines; "Posted AMSA Main Inv. Subform")
            {
                SubPageLink = "Parent Invoice No." = FIELD("No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    var
        AMSAMgt: Codeunit "AMSA Sales mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

