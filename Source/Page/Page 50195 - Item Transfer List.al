page 50195 "Item Transfer List"
{
    Caption = 'Item Transfer List';
    CardPageID = "Item Transfer";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Adjustment Header";
    SourceTableView = WHERE("Document Type" = CONST(Transfer));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Shipment Date';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                    Caption = 'Origin Location Code';
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Caption = 'Transfer-to Code';
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field("BEX Number"; Rec."BEX Number")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportTransfers)
            {
                Caption = 'Import LPSA Transfers';
                Image = TransferToGeneralJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = XMLport "Import LPSA Transfers";
            }
            action(ImportReceptions)
            {
                Caption = 'Import LPSA Transfers Receipts';
                Image = ReceiptLines;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = XMLport "Import LPSA Receptions";
            }
            action("Post &Batch")
            {
                Caption = 'Post &Batch';
                Ellipsis = true;
                Image = PostBatch;

                trigger OnAction()
                begin
                    REPORT.RunModal(REPORT::"Batch Post item Transfers", true, true, Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ApplyFiltresMagasin;
    end;

    local procedure ApplyFiltresMagasin()
    var
        SecMgt: Codeunit "Security Mgt";
        UserMgt: Codeunit "User Setup Management";
        FiltreMag: Text[500];
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FiltreMag := SecMgt.GetFiltresMagasinsDispaching(UserMgt.GetSalesFilter);
            if FiltreMag <> '' then begin
                Rec.FilterGroup(2);
                Rec.SetFilter(Rec."Location Code", FiltreMag);
                Rec.FilterGroup(0);
            end;
        end;
    end;
}

