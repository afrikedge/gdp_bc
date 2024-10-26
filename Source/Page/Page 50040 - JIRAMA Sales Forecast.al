page 50040 "JIRAMA Sales Forecast"
{
    Caption = 'JIRAMA Sales Forecast';
    PageType = Document;
    SourceTable = "Jirama Sales Forecast";
    SourceTableView = WHERE(Status = FILTER(Created | Validated));

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
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Partner No."; Rec."Partner No.")
                {
                    Editable = IsNotValidated;
                }
                field("Partner Name"; Rec."Partner Name")
                {
                }
                field("JIRAMA Order Ref"; Rec."JIRAMA Order Ref")
                {
                }
                field("Cargo Date"; Rec."Cargo Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
            part(PurchLines; "JIRAMA Sales Forecast Subform")
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
            action(TraiterPrevision)
            {
                Caption = 'Create orders';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    JiramaProcess.CreateOrders(Rec);
                end;
            }
            action(AddTransfer)
            {
                Caption = 'Ajouter un transfert de quota';
                Image = TransferOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    report1: Report "Create JIRAMA Forecast Transfe";
                begin
                    Rec.TestField(Status, Rec.Status::Validated);
                    Clear(report1);
                    report1.SetForeCastNo(Rec."No.");
                    report1.RunModal;
                end;
            }
            action(ArchiverPrevision)
            {
                Caption = 'Archive Forecast';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    JiramaProcess.ArchiveForecast(Rec);
                end;
            }
            action(TransferList)
            {
                Caption = 'Transfers list';
                Image = TransferToLines;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "JIRAMA Forecast Transfers";
                RunPageLink = "Document No." = FIELD("No.");
            }
            action(UpdateQty)
            {
                Caption = 'Update quantities';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    JiramaProcess.RefreshValuesForecast(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsNotValidated := Rec.Status = Rec.Status::Created;
    end;

    var
        JiramaProcess: Codeunit "JIRAMA Sales Mgt";
        IsNotValidated: Boolean;
}

