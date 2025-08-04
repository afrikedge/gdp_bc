page 50178 "AMSA Main Invoice"
{
    Caption = 'AMSA Main Invoice';
    PageType = Document;
    SourceTable = "Fuel Statement Header";
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
                field("Grouping Type"; Rec."Grouping Type")
                {
                }
                field("Grouping Customer"; Rec."Grouping Customer")
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                    Caption = 'Adresse';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'Contract Number';
                }
                field("Total Counter"; Rec."Total Counter")
                {
                    Visible = false;
                }
                field("AMSA Invoice Type"; Rec."AMSA Invoice Type")
                {
                }
            }
            part(Lines; "AMSA Main Invoice Subform")
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
            action(CreateInvoices)
            {
                Caption = 'Create invoices';
                Ellipsis = true;
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Cust: Record Customer;
                begin

                    if Cust.Get(Rec."Customer No") then begin

                        if Cust."AMSA Invoice Type" = Cust."AMSA Invoice Type"::Group then
                            AMSAMgt.CreateInvoices_CentraleMangoRiver(Rec);

                        if Cust."AMSA Invoice Type" = Cust."AMSA Invoice Type"::FS then
                            AMSAMgt.CreateAMSAInvoices(Rec);

                    end;
                end;
            }
            action(Archiver)
            {
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    AMSAMgt.ArchiveAMSAMainInvoice(Rec);
                end;
            }
        }
    }

    var
        AMSAMgt: Codeunit "AMSA Sales mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

