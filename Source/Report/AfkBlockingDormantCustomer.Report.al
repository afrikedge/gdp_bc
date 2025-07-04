

report 50064 "Afk Blocking Dormant Customer"
{
    Caption = 'Bloquer les clients dormants';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;


    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000, 1));

                CustLedgEntry.Reset();
                CustLedgEntry.SetRange("Customer No.", Customer."No.");
                if (CustLedgEntry.FindLast) then begin
                    NbreMois := NbreOfMonthsInPeriod(CustLedgEntry."Posting Date", Today);
                    if NbreMois >= AddOnSetup."Customer blocking period Month" then begin
                        if (Customer.Blocked <> Customer.Blocked::All) then begin
                            Customer.Blocked := Customer.Blocked::All;
                            Customer.Modify;
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
                NbreTotalLignes := Customer.Count;

                AddOnSetup.Get;
                AddOnSetup.TestField("Customer blocking period Month");
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
        AddOnSetup.TestField("Customer blocking period Month");
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
        CustLedgEntry: Record "Cust. Ledger Entry";
        NbreMois: Integer;
}

