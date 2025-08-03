report 50070 "Corr Num Doc Liaison"
{
    Permissions = TableData "Item Ledger Entry" = rm;
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            DataItemTableView = WHERE("Item Category Code" = CONST('PBL'));
            RequestFilterFields = "Posting Date";

            trigger OnAfterGetRecord()
            begin

                if "Item Ledger Entry"."Transaction Date" > 20201123D then begin
                    if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::Sale then
                        FindLivraison("Item Ledger Entry");
                end;

                if "Item Ledger Entry"."Adjustment Type" = "Item Ledger Entry"."Adjustment Type"::AdjBL then
                    FindEcartPompe("Item Ledger Entry");

                if "Item Ledger Entry"."Num Doc Liaison PBL" = '' then
                    "Item Ledger Entry"."Num Doc Liaison PBL" := "Item Ledger Entry"."Document No.";

                "Item Ledger Entry".Modify;
            end;

            trigger OnPostDataItem()
            begin
                Message('TERMINE');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    local procedure FindEcartPompe(var ILE: Record "Item Ledger Entry")
    var
        EnteteBL: Record pro_enteteBL;
        FoundLivraison: Boolean;
        FoundEcart15: Boolean;
        FoundEcartPompe: Boolean;
        NumBL1: Integer;
    begin

        if not Evaluate(NumBL1, CopyStr(ILE."Document No.", 3)) then exit;

        EnteteBL.Reset;
        EnteteBL.SetRange(EnteteBL.numBL, NumBL1);
        EnteteBL.SetRange(EnteteBL.isconfirme, true);
        EnteteBL.SetRange(EnteteBL.isAnnule, false);
        if EnteteBL.FindFirst then begin
            if EnteteBL.NumBU <> '' then
                ILE."Num Doc Liaison PBL" := EnteteBL.NumBU
            else
                ILE."Num Doc Liaison PBL" := 'BE' + Format(EnteteBL.numBE);
        end;
        ILE.Modify;
    end;

    local procedure FindEcart15()
    begin
    end;

    local procedure FindLivraison(var ILE: Record "Item Ledger Entry")
    var
        EnteteBL: Record pro_enteteBL;
        FoundLivraison: Boolean;
        FoundEcart15: Boolean;
        FoundEcartPompe: Boolean;
    begin
        FoundLivraison := false;

        EnteteBL.Reset;
        EnteteBL.SetRange(EnteteBL."Posted Shipment No", ILE."Document No.");
        EnteteBL.SetRange(EnteteBL.isconfirme, true);
        EnteteBL.SetRange(EnteteBL.isAnnule, false);
        if EnteteBL.FindFirst then begin
            FoundLivraison := true;
            if EnteteBL.NumBU <> '' then
                ILE."Num Doc Liaison PBL" := EnteteBL.NumBU
            else
                ILE."Num Doc Liaison PBL" := 'BE' + Format(EnteteBL.numBE);
        end;

        if FoundLivraison = false then begin
            if ILE."Shipment Method Code" = 'TRP' then begin
                EnteteBL.Reset;
                EnteteBL.SetRange(EnteteBL.datelivraison, ILE."Posting Date");
                EnteteBL.SetRange(EnteteBL.NavOrderNo, ILE."Order No.");
                EnteteBL.SetRange(EnteteBL.isconfirme, true);
                EnteteBL.SetRange(EnteteBL.isAnnule, false);
                if EnteteBL.Count = 1 then begin
                    if EnteteBL.FindFirst then begin
                        FoundLivraison := true;
                        if EnteteBL.NumBU <> '' then
                            ILE."Num Doc Liaison PBL" := EnteteBL.NumBU
                        else
                            ILE."Num Doc Liaison PBL" := 'BE' + Format(EnteteBL.numBE);
                    end;
                end;
            end;
        end;
        ILE.Modify;
    end;
}

