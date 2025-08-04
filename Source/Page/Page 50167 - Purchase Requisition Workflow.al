page 50167 "Purchase Requisition Workflow"
{
    Caption = 'Purchase Requisition';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Purchase Requisition";
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

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    MultiLine = true;
                }
                field("Purchase Type"; Rec."Purchase Type")
                {
                    Visible = false;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        //CurrPage.Lines.PAGE.UpdatePage(TRUE);
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        //CurrPage.Lines.PAGE.UpdateForm(TRUE);
                    end;
                }
                field("External Doc No"; Rec."External Doc No")
                {
                }
                field("Return Reason"; Rec."Return Reason")
                {
                }
                field("Direction Code"; Rec."Direction Code")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field("Service Code"; Rec."Service Code")
                {
                }
                field("Type Achat"; Rec."Type Achat")
                {
                }
                field("Type article"; Rec."Type article")
                {
                }
                field("Order Type"; Rec."Order Type")
                {
                }
                field("Under Contract"; Rec."Under Contract")
                {
                }
                field("Contract Ref"; Rec."Contract Ref")
                {
                }
                field(Project; Rec.Project)
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field("PO Type"; Rec."PO Type")
                {
                    ShowMandatory = true;
                }
            }
            part(Lines; "Purch Requisition Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Document No" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Offers List"; "Vendor Offers Part")
            {
                Caption = 'Offers List';
                SubPageLink = "Code Demande" = FIELD("No.");
                ApplicationArea = All;
            }
            part("Budget Summary"; "Budget Document Lines")
            {
                Caption = 'Budget Summary';
                SubPageLink = "Document Type" = CONST(Requisition),
                              "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            systempart(Control1000000001; Links)
            {
                Visible = false;
            }
            systempart(Control1000000000; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Traiter)
            {
                Caption = 'Validate document';
                Ellipsis = true;
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PurchReqMgt.TraiterDoc(Rec);
                end;
            }
            action(CreateOffer)
            {
                Caption = 'Ajouter une offre fournisseur';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PurchReqMgt.CreateOpenNewOffer(Rec);
                end;
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            action(CalculateBudget)
            {
                Caption = 'Calculate budget';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PurchReqMgt.CreatePurchaseBudgetLinesFromReq(Rec);
                end;
            }
            action(CalculateQty)
            {
                Caption = 'Update Quantities';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PurchReqMgt.RefreshRemainingQtyReq(Rec);
                end;
            }
            separator(Separator1000000023)
            {
            }
            action(CloseDossier)
            {
                Caption = 'Close Purch. Requisition';
                Image = Close;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PurchReqMgt.CloturerDemande(Rec, 0, '', '');
                end;
            }
            action(PrintCompare)
            {
                Caption = 'Imprimer comparaison offres';
                Image = CompareCost;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurchRequis: Record "Purchase Requisition";
                begin
                    PurchRequis.SetFilter("No.", Rec."No.");
                    REPORT.Run(REPORT::"Comparaison Offres", true, false, PurchRequis);
                end;
            }
            action(PrintDDA)
            {
                Caption = 'Imprimer DDA';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurchRequis: Record "Purchase Requisition";
                begin
                    PurchRequis.SetFilter("No.", Rec."No.");
                    REPORT.Run(REPORT::"Demande d'achat ", true, false, PurchRequis);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        PurchReqMgt: Codeunit "Purchase Requisition Mgt";
        ShortcutDimCode: array[8] of Code[20];
}

