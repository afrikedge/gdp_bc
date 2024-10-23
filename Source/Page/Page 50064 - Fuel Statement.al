page 50064 "Fuel Statement"
{
    PageType = Document;
    SourceTable = "Fuel Statement Header";
    SourceTableView = WHERE("Document Type" = CONST(FS));

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
                }
            }
            part(Lines; "Fuel Statement Line subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportFS)
            {
                Caption = 'Import Lines';
                Ellipsis = true;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLImportFS: XMLport "Import Fuel Statement";
                begin
                    //MoneyTechMgt.ProcessBilling(Rec);
                    XMLImportFS.SetFSNumber(Rec."No.");
                    XMLImportFS.Run;
                end;
            }
            action(CreateInvoices)
            {
                Caption = 'Create invoices';
                Ellipsis = true;
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AMSAMgt.CreateInvoices(Rec);
                end;
            }
            action(FacturesVente)
            {
                Caption = 'Sales invoices';
                Ellipsis = true;
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesH: Record "Sales Header";
                    SalesInvPage: Page "Sales Invoice List";
                    PostedSalesH: Record "Sales Invoice Header";
                    PostedSalesInvPage: Page "Posted Sales Invoices";
                begin
                    SalesH.Reset;
                    SalesH.SetRange(SalesH."Created By Doc Type", SalesH."Created By Doc Type"::AMSA);
                    SalesH.SetRange("Document Type", SalesH."Document Type"::Invoice);
                    SalesH.SetRange("Created By Doc No.", Rec."No.");
                    if SalesH.FindFirst then begin
                        SalesInvPage.SetTableView(SalesH);
                        SalesInvPage.Run();
                    end else begin
                        PostedSalesH.Reset;
                        PostedSalesH.SetRange(PostedSalesH."Created By Doc Type", PostedSalesH."Created By Doc Type"::AMSA);
                        PostedSalesH.SetRange("Created By Doc No.", Rec."No.");
                        if PostedSalesH.FindFirst then begin
                            PostedSalesInvPage.SetTableView(PostedSalesH);
                            PostedSalesInvPage.Run();
                        end;
                    end;
                end;
            }
            action(Archiver)
            {
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AMSAMgt.ArchiveFuelStatement(Rec);
                end;
            }
        }
    }

    var
        AMSAMgt: Codeunit "AMSA Sales mgt";
        SQLMgt: Codeunit "SQL Mgt";
}

