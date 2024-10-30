page 50025 "Sales Order List - Closed"
{
    Caption = 'Sales Order List - Closed';
    CardPageID = "Sales Order Archive";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Header Archive";
    SourceTableView = WHERE("Document Type" = CONST(Order),
                            "Delivery Status" = CONST(Soldee));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Date Archived"; Rec."Date Archived")
                {
                }
                field("Time Archived"; Rec."Time Archived")
                {
                }
                field("Archived By"; Rec."Archived By")
                {
                }
                field("Interaction Exist"; Rec."Interaction Exist")
                {
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Visible = false;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    Visible = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Visible = false;
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
                Caption = 'Ver&sion';
                Image = Versions;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Archive Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0),
                                  "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence"),
                                  "Version No." = FIELD("Version No.");
                }
            }
        }
    }
}

