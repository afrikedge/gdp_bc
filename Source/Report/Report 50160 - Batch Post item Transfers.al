report 50160 "Batch Post item Transfers"
{
    Caption = 'Batch Post Sales Orders';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Adjustment Header"; "Adjustment Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Transfer));
            RequestFilterFields = "No.", Status, "Posting Date", "External Document No.", "Receipt Date";
            RequestFilterHeading = 'Transfer Order';

            trigger OnAfterGetRecord()
            var
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
            begin
                //IF ApprovalsMgmt.IsSalesApprovalsWorkflowEnabled("Sales Header") OR (Status = Status::"Pending Approval") THEN
                //  CurrReport.SKIP;
                Clear(ItemTransferPost);

                if ShipReceipt = ShipReceipt::Livrer then
                    if not ItemTransferPost.CanPostExpedition("Adjustment Header") then
                        CurrReport.Skip;

                if ShipReceipt = ShipReceipt::Recevoir then
                    if not ItemTransferPost.CanPostReception("Adjustment Header") then
                        CurrReport.Skip;


                //IF CalcInvDisc THEN
                //  CalculateInvoiceDiscount;

                Counter := Counter + 1;
                Window.Update(1, "No.");
                Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
                //Ship := ShipReq;
                //Invoice := InvReq;

                ItemTransferPost.SetIsBatch(true);
                //SalesPost.SetPostingDate(ReplacePostingDate,ReplaceDocumentDate,PostingDateReq);
                if ShipReceipt = ShipReceipt::Livrer then begin
                    ItemTransferPost.PostExpedition("Adjustment Header");
                    CounterOK := CounterOK + 1;
                    if MarkedOnly then
                        Mark(false);
                    //END;
                end;

                if ShipReceipt = ShipReceipt::Recevoir then begin
                    ItemTransferPost.PostReception("Adjustment Header");
                    CounterOK := CounterOK + 1;
                    if MarkedOnly then
                        Mark(false);
                    //END;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002, CounterOK, CounterTotal);
            end;

            trigger OnPreDataItem()
            begin
                if ReplacePostingDate and (PostingDateReq = 0D) then
                    Error(Text000);

                CounterTotal := Count;
                Window.Open(Text001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Ship; ShipReceipt)
                    {
                        Caption = 'Action';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            SalesSetup.Get;
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
            ReplacePostingDate := false;
            ReplaceDocumentDate := false;
        end;
    }

    labels
    {
    }

    var
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Posting orders  #1########## @2@@@@@@@@@@@@@';
        Text002: Label '%1 orders out of a total of %2 have now been posted.';
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        ShipReq: Boolean;
        InvReq: Boolean;
        PostingDateReq: Date;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        CalcInvDisc: Boolean;
        Text003: Label '%1 orders out of a total of %2 have now been posted.';
        ShipReceipt: Option Livrer,Recevoir;
        ItemTransferPost: Codeunit "Item Transfer Mgt";
}

