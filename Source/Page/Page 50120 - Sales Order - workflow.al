page 50120 "Sales Order - workflow"
{
    Caption = 'Commande vente';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = HeaderIsEditable;
                    Importance = Promoted;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = HeaderIsEditable;
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        SelltoCustomerNoOnAfterValidat;
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = HeaderIsEditable;
                    QuickEntry = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    Editable = HeaderIsEditable;
                    Importance = Additional;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    Editable = HeaderIsEditable;
                    Importance = Additional;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Editable = HeaderIsEditable;
                    Importance = Additional;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    Editable = HeaderIsEditable;
                    QuickEntry = false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    Editable = HeaderIsEditable;
                    Importance = Additional;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = HeaderIsEditable;
                    QuickEntry = false;
                }
                field("Order Date"; Rec."Order Date")
                {
                    Editable = HeaderIsEditable;
                    Importance = Promoted;
                    QuickEntry = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = HeaderIsEditable;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    Editable = HeaderIsEditable;
                    Visible = true;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    Editable = HeaderIsEditable;
                    Importance = Additional;
                    Visible = false;
                }
                field("Quote No."; Rec."Quote No.")
                {
                    Importance = Additional;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                    Importance = Promoted;
                    ShowMandatory = ExternalDocNoMandatory;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Editable = HeaderIsEditable;
                    QuickEntry = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field(Status; Rec.Status)
                {
                    Importance = Promoted;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Delivery Status"; Rec."Delivery Status")
                {
                    Importance = Promoted;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = HeaderIsEditable;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                        SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    Importance = Promoted;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    Editable = HeaderIsEditable;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    Editable = HeaderIsEditable;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Importance = Promoted;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Editable = HeaderIsEditable;
                    Importance = Promoted;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Importance = Promoted;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Editable = HeaderIsEditable;
                }
                field("Return Reason"; Rec."Return Reason")
                {
                }
                field("Posting Description"; Rec."Posting Description")
                {
                }
                field("Prices Status"; Rec."Prices Status")
                {
                }
                field(Anticipated; Rec.Anticipated)
                {
                }
                field("GD1 Credit Notes Amount"; Rec."GD1 Credit Notes Amount")
                {
                }
                field(Observations; Rec.Observations)
                {
                    MultiLine = true;
                }
            }
            part(SalesLines; "Sales Order Subform")
            {
                Editable = DynamicEditable;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part(Control35; "Pending Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = true;
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                SubPageLink = "No." = FIELD("Sell-to Customer No.");
                Visible = false;
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
                Visible = true;
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1906354007; "Approval FactBox")
            {
                SubPageLink = "Table ID" = CONST(36),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = false;
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ShowFilter = false;
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                Provider = SalesLines;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
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
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        Rec.OpenSalesOrderStatistics;
                        //SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                        CurrPage.SalesLines.Page.ForceTotalsCalculation();
                    end;
                }
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Enabled = IsCustomerOrContactNotEmpty;
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = field("Sell-to Customer No."),
                                  "Date Filter" = field("Date Filter");
                    ShortCutKey = 'Shift+F7';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(DocAttach)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGoToSalesOrder)
                {
                    Caption = 'Sales Order';
                    Enabled = CRMIntegrationEnabled AND CRMIsCoupledToRecord;
                    Image = CoupledOrder;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM sales order.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipments';
                    Image = Shipment;
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = field("No.");
                    RunPageView = sorting("Order No.");
                    ToolTip = 'View related posted sales shipments.';
                }
                action(Invoices)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoices';
                    Image = Invoice;
                    ToolTip = 'View a list of ongoing sales invoices for the order.';

                    trigger OnAction()
                    var
                        TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
                        SalesGetShipment: Codeunit "Sales-Get Shipment";
                    begin
                        SalesGetShipment.GetSalesOrderInvoices(TempSalesInvoiceHeader, Rec."No.");
                        Page.Run(Page::"Posted Sales Invoices", TempSalesInvoiceHeader);
                    end;
                }
            }
            action(ListeBonsNonValides)
            {
                Caption = 'Bons List';
                Image = Sales;
                RunObject = Page "Bon Dispaching List";
                RunPageLink = NavOrderNo = FIELD("No."),
                              IsBon = CONST(true);
            }
            action(ListeBENonValides)
            {
                Caption = 'Removal Orders List';
                Image = SalesShipment;
                RunObject = Page "Removal Order List";
                RunPageLink = CreatedFromDocNo = FIELD("No."),
                              IsBon = CONST(false);
            }
            action(ListeBLNonValides)
            {
                Caption = 'Delivery Orders List';
                Image = Sales;
                RunObject = Page "Delivery Order List";
                RunPageLink = CreatedFromDocNo = FIELD("No."),
                              IsBon = CONST(false);
            }
            action(SuiviEtapesValidation)
            {
                Caption = 'Validation Step Lines';
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Document Step Lines";
                RunPageLink = "Document Type" = CONST("Sales Order"),
                              "Document No." = FIELD("No.");
            }
        }
        area(processing)
        {
            group(ActionGroup21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                        PrepaymentMgt: Codeunit "Prepayment Mgt.";
                    begin
                        if PrepaymentMgt.TestSalesPrepayment(Rec) then
                            Error(StrSubstNo(Text10800, Rec."Document Type", Rec."No."));

                        if PrepaymentMgt.TestSalesPayment(Rec) then begin
                            if not Confirm(StrSubstNo(Text10801, Rec."Document Type", Rec."No.")) then
                                exit;
                            Rec.Status := Rec.Status::"Pending Prepayment";
                            Rec.Modify;
                            CurrPage.Update;
                        end else
                            ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
                action(DebloquerCde)
                {
                    Caption = 'Release Order';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        //***********************************************************
                        if not SecMgt.CanUnlockOrders then Error(Text003);
                        Rec.TestField(Rec."Delivery Status", Rec."Delivery Status"::Bloquee);//*******
                        SOProcess.ValidationDeblocage(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'Functions';
                Image = "Action";
                action(CalculateInvoiceDiscount)
                {
                    Caption = 'Calculate Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action("Get St&d. Cust. Sales Codes")
                {
                    Caption = 'Get Std. Cust. Sales Codes';
                    Ellipsis = false;
                    Image = CustomerCode;

                    trigger OnAction()
                    var
                        StdCustSalesCode: Record "Standard Customer Sales Code";
                    begin
                        StdCustSalesCode.InsertSalesLines(Rec);
                    end;
                }
                action(MajPrixVente)
                {
                    Caption = 'Update prices';
                    Ellipsis = true;
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //TODO
                        //Rec.AFK_RefreshSalesLinePrices();
                    end;
                }
                action(CopyDocument)
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;

                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RunModal;
                        Clear(CopySalesDoc);
                    end;
                }
                action("Move Negative Lines")
                {
                    Caption = 'Move Negative Lines';
                    Ellipsis = true;
                    Image = MoveNegativeLines;

                    trigger OnAction()
                    begin
                        Clear(MoveNegSalesLines);
                        MoveNegSalesLines.SetSalesHeader(Rec);
                        MoveNegSalesLines.RunModal;
                        MoveNegSalesLines.ShowDocument;
                    end;
                }
                action(TraiterCommande)
                {
                    Caption = 'Process';
                    Ellipsis = true;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SOProcess.TraiterCommande(Rec);
                        CurrPage.Close;
                    end;
                }
                action(AnnulerCommande)
                {
                    Caption = 'Cancel order';
                    Ellipsis = true;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        SOProcess.AnnulerCde(Rec);
                    end;
                }
                action(CreerPreparation)
                {
                    Caption = 'Create preparation document';
                    Enabled = ShowCreerPreparation;
                    Image = SalesShipment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = ShowCreerPreparation;

                    trigger OnAction()
                    begin
                        AFK_ShipMgt.CreatePreparationFromSalesOrder(Rec);
                    end;
                }
                action(CreateBE)
                {
                    Caption = 'Create removal order';
                    Enabled = ShowCreerBE;
                    Image = Shipment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = ShowCreerBE;

                    trigger OnAction()
                    begin
                        LogistiqueMgt.CreateBLBEJIRAMA_FromOrder(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'Posting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    AboutTitle = 'Posting the order';
                    AboutText = 'Posting will ship or invoice the quantities on the order, or both. **Post** and **Send** can save the order as a file, print it, or attach it to an email, all in one go.';

                    trigger OnAction()
                    begin
                        PostSalesOrder(CODEUNIT::"Sales-Post (Yes/No)", Enum::"Navigate After Posting"::"Posted Document");
                    end;
                }
                action(PostAndSend)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and Send';
                    Ellipsis = true;
                    Image = PostMail;
                    ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                    trigger OnAction()
                    begin
                        PostSalesOrder(CODEUNIT::"Sales-Post and Send", Enum::"Navigate After Posting"::"Do Nothing");
                    end;
                }
                action(PreviewPosting)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    ShortCutKey = 'Ctrl+Alt+F9';
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    begin
                        ShowPreview();
                    end;
                }
                // action("Post and &Print")
                // {
                //     Caption = 'Post and Print';
                //     Ellipsis = true;
                //     Image = PostPrint;
                //     Promoted = true;
                //     PromotedCategory = Process;
                //     PromotedIsBig = true;
                //     ShortCutKey = 'Shift+F9';

                //     trigger OnAction()
                //     begin
                //         Post2(CODEUNIT::"Sales-Post + Print");
                //     end;
                // }
                // action("Post and Email")
                // {
                //     Caption = 'Post and Email';
                //     Ellipsis = true;
                //     Image = PostMail;

                //     trigger OnAction()
                //     var
                //         SalesPostPrint: Codeunit "Sales-Post + Print";
                //     begin
                //         SalesPostPrint.PostAndEmail(Rec);
                //     end;
                // }
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                // action("Post &Batch")
                // {
                //     Caption = 'Post Batch';
                //     Ellipsis = true;
                //     Image = PostBatch;

                //     trigger OnAction()
                //     begin
                //         REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, Rec);
                //         CurrPage.Update(false);
                //     end;
                // }
            }
            group("&Order Confirmation")
            {
                Caption = 'Order Confirmation';
                Image = Email;
                action("Email Confirmation")
                {
                    Caption = 'Email Confirmation';
                    Ellipsis = true;
                    Image = Email;

                    trigger OnAction()
                    begin
                        DocPrint.EmailSalesHeader(Rec);
                    end;
                }
                action("Print Confirmation")
                {
                    Caption = 'Print Confirmation';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesOrder(Rec, Usage::"Order Confirmation");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        DynamicEditable := CurrPage.Editable;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);


        //*********************************************
        //*********************************************
        //ShowCreerBE := SOProcess.IsCdePBL(SalesHeader);
        ShowCreerPreparation := SOProcess.IsCdeLUBS(Rec) or SOProcess.IsCdeGPL(Rec);
        ShowCreerBE := not (ShowCreerPreparation or (Rec."Shipment Method Code" = 'TRP'));
        HeaderIsEditable := SOProcess.CanUpdateOrderHeaderAfterValidation(Rec);
        //*********************************************
        //*********************************************
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlVisibility;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CheckCreditMaxBeforeInsert;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Responsibility Center" := UserMgt.GetSalesFilter;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        /*
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
          FILTERGROUP(0);
        END;
        */

        SetFiltreCentreGestion;

        Rec.SetRange("Date Filter", 0D, WorkDate - 1);
        Rec.SetRange(Rec."No.");

        SetDocNoVisible;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

    end;

    var
        CopySalesDoc: Report "Copy Sales Document";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ReportPrint: Codeunit "Test Report-Print";
        DocPrint: Codeunit "Document-Print";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        ChangeExchangeRate: Page "Change Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        [InDataSet]
        JobQueueVisible: Boolean;
        Text10800: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text10801: Label 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.';
        Text001: Label 'Do you want to change %1 in all related records in the warehouse?';
        Text002: Label 'The update has been interrupted to respect the warning.';
        DynamicEditable: Boolean;
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        ShowWorkflowStatus: Boolean;
        SOProcess: Codeunit "Sales Order Process";
        LogistiqueMgt: Codeunit "Logistique Mgt";
        AFK_ShipMgt: Codeunit "Item Shipment Mgt";
        ShowCreerPreparation: Boolean;
        ShowCreerBE: Boolean;
        SecMgt: Codeunit "Security Mgt";
        Text003: Label 'Fonction non autorisée';
        HeaderIsEditable: Boolean;
        DocumentIsScheduledForPosting: Boolean;
        DocumentIsPosted: Boolean;
        IsCustomerOrContactNotEmpty: Boolean;
        OpenPostedSalesOrderQst: Label 'The order is posted as number %1 and moved to the Posted Sales Invoices window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';

    local procedure Post2(PostingCodeunitID: Integer)
    begin
        Rec.SendToPosting(PostingCodeunitID);
        if Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting" then
            CurrPage.Close;
        CurrPage.Update(false);
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.SalesLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        if Rec.GetFilter("Sell-to Customer No.") = xRec."Sell-to Customer No." then
            if Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." then
                Rec.SetRange("Sell-to Customer No.");
        CurrPage.Update;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure Prepayment37OnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order, Rec."No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        IsCustomerOrContactNotEmpty := (Rec."Sell-to Customer No." <> '') or (Rec."Sell-to Contact No." <> '');
    end;

    local procedure SetFiltreCentreGestion()
    var
        FiltreCG: Text[100];
        SecMgt: Codeunit "Security Mgt";
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            /*FILTERGROUP(2);
            SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
            FILTERGROUP(0);*/

            FiltreCG := SecMgt.GetFiltresCentresGestion;
            if FiltreCG <> '' then begin
                Rec.FilterGroup(2);
                Rec.SetFilter("Responsibility Center", FiltreCG);
                Rec.FilterGroup(0);
            end;
        end;

    end;

    protected procedure PostSalesOrder(PostingCodeunitID: Integer; Navigate: Enum "Navigate After Posting")
    var
        SalesHeader: Record "Sales Header";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        InstructionMgt: Codeunit "Instruction Mgt.";
        IsHandled: Boolean;
    begin
        //OnBeforePostSalesOrder(Rec, PostingCodeunitID, Navigate);
        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);

        Rec.SendToPosting(PostingCodeunitID);

        DocumentIsScheduledForPosting := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not SalesHeader.Get(Rec."Document Type", Rec."No.")) or DocumentIsScheduledForPosting;
        //OnPostOnAfterSetDocumentIsPosted(SalesHeader, DocumentIsScheduledForPosting, DocumentIsPosted);

        CurrPage.Update(false);

        //IsHandled := false;
        //OnPostDocumentBeforeNavigateAfterPosting(Rec, PostingCodeunitID, Navigate, DocumentIsPosted, IsHandled);
        // if IsHandled then
        //     exit;

        if PostingCodeunitID <> CODEUNIT::"Sales-Post (Yes/No)" then
            exit;

        case Navigate of
            Enum::"Navigate After Posting"::"Posted Document":
                begin
                    if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode()) then
                        ShowPostedConfirmationMessage();

                    if DocumentIsScheduledForPosting or DocumentIsPosted then
                        CurrPage.Close();
                end;
            Enum::"Navigate After Posting"::"New Document":
                if DocumentIsPosted then begin
                    Clear(SalesHeader);
                    SalesHeader.Init();
                    SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
                    //OnPostOnBeforeSalesHeaderInsert(SalesHeader);
                    SalesHeader.Insert(true);
                    PAGE.Run(PAGE::"Sales Order", SalesHeader);
                end;
        end;
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderSalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        ICFeedback: Codeunit "IC Feedback";
    begin
        if not OrderSalesHeader.Get(Rec."Document Type", Rec."No.") then begin
            SalesInvoiceHeader.SetRange("No.", Rec."Last Posting No.");
            if SalesInvoiceHeader.FindFirst() then begin
                ICFeedback.ShowIntercompanyMessage(Rec, Enum::"IC Transaction Document Type"::Order);
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedSalesOrderQst, SalesInvoiceHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode())
                then
                    InstructionMgt.ShowPostedDocument(SalesInvoiceHeader, Page::"Sales Order");
            end;
        end;
    end;
}

