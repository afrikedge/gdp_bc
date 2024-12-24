page 50075 "Complex Transfer Order Archive"
{
    Caption = 'Complex Transfer Order Archive';
    Editable = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Transfer Header Archive";
    SourceTableView = WHERE("Transfer Type" = CONST(Hypothetical));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        //IF AssistEdit(xRec) THEN
                        //  CurrPage.UPDATE;
                    end;
                }
                field("Transfer Type"; Rec."Transfer Type")
                {
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    Importance = Promoted;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Importance = Promoted;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                }
                field("Receive-to Code"; Rec."Receive-to Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                }
            }
            part(TransferLines; "Complex Transfer Subform Arch")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Derived From Line No." = CONST(0);
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                }
                field("Transfer-from Name 2"; Rec."Transfer-from Name 2")
                {
                }
                field("Transfer-from Address"; Rec."Transfer-from Address")
                {
                }
                field("Transfer-from Address 2"; Rec."Transfer-from Address 2")
                {
                }
                field("Transfer-from Post Code"; Rec."Transfer-from Post Code")
                {
                }
                field("Transfer-from City"; Rec."Transfer-from City")
                {
                }
                field("Transfer-from Contact"; Rec."Transfer-from Contact")
                {
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Outbound Whse. Handling Time"; Rec."Outbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        OutboundWhseHandlingTimeOnAfte;
                    end;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ShippingAgentCodeOnAfterValida;
                    end;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {

                    trigger OnValidate()
                    begin
                        ShippingAgentServiceCodeOnAfte;
                    end;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {

                    trigger OnValidate()
                    begin
                        ShippingTimeOnAfterValidate;
                    end;
                }
                field("Shipping Advice"; Rec."Shipping Advice")
                {
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        if Rec."Shipping Advice" <> xRec."Shipping Advice" then
                            if not Confirm(Text000, false, Rec.FieldCaption("Shipping Advice")) then
                                Error('');
                    end;
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                }
                field("Transfer-to Name 2"; Rec."Transfer-to Name 2")
                {
                }
                field("Transfer-to Address"; Rec."Transfer-to Address")
                {
                }
                field("Transfer-to Address 2"; Rec."Transfer-to Address 2")
                {
                }
                field("Transfer-to Post Code"; Rec."Transfer-to Post Code")
                {
                }
                field("Transfer-to City"; Rec."Transfer-to City")
                {
                }
                field("Transfer-to Contact"; Rec."Transfer-to Contact")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {

                    trigger OnValidate()
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {

                    trigger OnValidate()
                    begin
                        InboundWhseHandlingTimeOnAfter;
                    end;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Importance = Promoted;
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    Importance = Promoted;
                }
                field("Area"; Rec.Area)
                {
                }
                field("Entry/Exit Point"; Rec."Entry/Exit Point")
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'Order';
                Image = "Order";
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Transfer Order"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    Caption = 'Shipments';
                    Image = Shipment;
                    RunObject = Page "Posted Transfer Shipments";
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
                action("Re&ceipts")
                {
                    Caption = 'Receipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transfer Receipts";
                    RunPageLink = "Transfer Order No." = FIELD("No.");
                }
            }
            group(ActionGroup1000000004)
            {
                Caption = 'Documents';
                Image = Documents;
                action(Action1000000003)
                {
                    Caption = 'Shipments';
                    Image = Shipment;
                    RunObject = Page "Posted Transfer Shipments";
                    RunPageLink = "Original Transfer No" = FIELD("No.");
                }
                action(Action1000000002)
                {
                    Caption = 'Receipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transfer Receipts";
                    RunPageLink = "Original Transfer No" = FIELD("No.");
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = 'Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    //DocPrint.PrintTransferHeader(Rec);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField(Status, Rec.Status::Open);
    end;

    var
        Text000: Label 'Do you want to change %1 in all related records in the warehouse?';

    local procedure PostingDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShippingAgentServiceCodeOnAfte()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShippingAgentCodeOnAfterValida()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ShippingTimeOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure OutboundWhseHandlingTimeOnAfte()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure ReceiptDateOnAfterValidate()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;

    local procedure InboundWhseHandlingTimeOnAfter()
    begin
        CurrPage.TransferLines.PAGE.UpdateForm(true);
    end;
}

