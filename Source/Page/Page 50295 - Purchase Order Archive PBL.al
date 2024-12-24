page 50295 "Purchase Order Archive PBL"
{
    Caption = 'Purchase Order Archive';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Purchase Header Archive";
    SourceTableView = WHERE("Document Type" = CONST(Order),
                            "Purchase Type" = CONST(AchatMarchandise));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No."; Rec."No.")
                {
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Buy-from Contact No."; Rec."Buy-from Contact No.")
                {
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                }
                field("Buy-from Address"; Rec."Buy-from Address")
                {
                }
                field("Buy-from Address 2"; Rec."Buy-from Address 2")
                {
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                }
                field("Buy-from City"; Rec."Buy-from City")
                {
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Order Date"; Rec."Order Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Vendor Order No."; Rec."Vendor Order No.")
                {
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
            part(PurchLinesArchive; "Purchase Order Archive Subform")
            {
                Editable = false;
                SubPageLink = "Document No." = FIELD("No."),
                              "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence"),
                              "Version No." = FIELD("Version No.");
            }
            part(TrackingLines; "PO Tracking Subform")
            {
                Caption = 'Tracking Lines';
                SubPageLink = "Document No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
                UpdatePropagation = Both;
            }
            part(FALines; "PO FA Subform")
            {
                Caption = 'FA Lines';
                Editable = false;
                Enabled = false;
                SubPageLink = "Document No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
                UpdatePropagation = Both;
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                Editable = false;
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                }
                field("Pay-to Contact No."; Rec."Pay-to Contact No.")
                {
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                }
                field("Pay-to Address"; Rec."Pay-to Address")
                {
                }
                field("Pay-to Address 2"; Rec."Pay-to Address 2")
                {
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                }
                field("Pay-to City"; Rec."Pay-to City")
                {
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                field("On Hold"; Rec."On Hold")
                {
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                Editable = false;
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                Editable = false;
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                }
                field("Entry Point"; Rec."Entry Point")
                {
                }
                field("Area"; Rec.Area)
                {
                }
            }
            group(Version)
            {
                Caption = 'Version';
                Editable = false;
                field("Version No."; Rec."Version No.")
                {
                }
                field("Archived By"; Rec."Archived By")
                {
                }
                field("Date Archived"; Rec."Date Archived")
                {
                }
                field("Time Archived"; Rec."Time Archived")
                {
                }
                field("Interaction Exist"; Rec."Interaction Exist")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ver&sion")
            {
                Caption = 'Version';
                Image = Versions;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Archive Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0),
                                  "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence"),
                                  "Version No." = FIELD("Version No.");
                }
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintPurchHeaderArch(Rec);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        // ApprovalEntries.Setfilters(DATABASE::"Purchase Header","Document Type","No.");
                        // ApprovalEntries.SetDisableDelegate;
                        // ApprovalEntries.Run;
                    end;
                }
            }
        }
    }

    var
        DocPrint: Codeunit "Document-Print";
}

