report 50085 "Blocking dormant suppliers"
{
    Caption = 'Bloquer les fournisseurs dormants';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                VendorCreateDate: date;
            begin
                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000, 1));

                VendLedgEntry.Reset();
                VendLedgEntry.SetRange("Vendor No.", Vendor."No.");
                if (VendLedgEntry.FindLast) then begin
                    NbreMois := NbreOfMonthsInPeriod(VendLedgEntry."Posting Date", Today);
                    if NbreMois >= AddOnSetup."Supplier blocking period Month" then begin
                        if (Vendor.Blocked <> Vendor.Blocked::All) then begin
                            Vendor.Blocked := Vendor.Blocked::All;
                            Vendor.Modify;
                        end;
                    end;
                end else begin
                    //Aucune transaction
                    VendorCreateDate := DT2Date(Vendor.SystemCreatedAt);
                    if (VendorCreateDate = 0D) then
                        VendorCreateDate := Vendor."Created By Date";
                    if (VendorCreateDate = 0D) then begin
                        Vendor.Blocked := Vendor.Blocked::All;
                        Vendor.Modify;
                    end else begin
                        NbreMois := NbreOfMonthsInPeriod(VendorCreateDate, Today);
                        if NbreMois >= AddOnSetup."Supplier blocking period Month" then begin
                            if (Vendor.Blocked <> Vendor.Blocked::All) then begin
                                Vendor.Blocked := Vendor.Blocked::All;
                                Vendor.Modify;
                            end;
                        end;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(TxtTraitementTerminé);
            end;

            trigger OnPreDataItem()
            begin

                BesoinNo := 0;
                Window.Open(Text008);
                NbreTotalLignes := Vendor.Count;

                AddOnSetup.Get;
                AddOnSetup.TestField("Supplier blocking period Month");
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

    trigger OnPreReport()
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField("Supplier blocking period Month");
    end;

    local procedure NbreOfMonthsInPeriod(Day1: Date; Day2: Date) NoOfMonthsInPeriod: Integer
    var
        Wdate: Date;
        FirstDayinCrntMonth: Date;
        LastDayinCrntMonth: Date;
    begin
        NoOfMonthsInPeriod := 0;

        if Day1 > Day2 then
            exit(0);
        if Day1 = 0D then
            exit(0);
        if Day2 = 0D then
            exit(0);

        /*
        Wdate := Day1;
        REPEAT
          FirstDayinCrntMonth := CALCDATE('<-CM>',Wdate);
          LastDayinCrntMonth := CALCDATE('<CM>',Wdate);
          IF (Wdate = FirstDayinCrntMonth) AND (LastDayinCrntMonth <= Day2) THEN BEGIN
            NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
            Wdate := LastDayinCrntMonth + 1;
          END ELSE BEGIN
            Wdate := Wdate + 1;
          END;
        UNTIL Wdate > Day2;
        */


        Wdate := Day1;
        repeat
            Wdate := CalcDate('<1M>', Wdate);
            if Wdate <= Day2 then
                NoOfMonthsInPeriod := NoOfMonthsInPeriod + 1;
        until Wdate > Day2;

    end;

    var
        //CalculCte: Codeunit CalculCte;
        AddOnSetup: Record "AddOn Setup2";
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        VendLedgEntry: Record "Vendor Ledger Entry";
        NbreMois: Integer;
}

