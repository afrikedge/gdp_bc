page 50183 "AMSA Invoice"
{
    Caption = 'AMSA Invoice';
    DataCaptionFields = "No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Fuel Statement Header";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    Visible = false;
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
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'Invoice N°';
                }
                field("Total Counter"; Rec."Total Counter")
                {
                    Visible = false;
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
                field("Order No."; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
            }
            part(Lines; "AMSA Invoice Subform")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PrintInvoice)
            {
                Caption = 'Print Invoice';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    AdjH: Record "Fuel Statement Header";
                    Cust: Record Customer;
                begin
                    //*******************************
                    AdjH.SetRange(AdjH."Document Type", AdjH."Document Type"::Invoice);
                    AdjH.SetRange(AdjH."No.", Rec."No.");

                    Cust.Get(Rec."Customer No");
                    if Cust."AMSA Invoice Model" = Cust."AMSA Invoice Model"::Mobile then
                        REPORT.RunModal(50059, true, false, AdjH)
                    else
                        REPORT.RunModal(50060, true, false, AdjH);
                end;
            }
        }
    }

    var
        AMSAMgt: Codeunit "AMSA Sales mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

