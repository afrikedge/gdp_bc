report 50085 "Blocking dormant suppliers"
{
    Caption = 'Bloquer les fournisseurs dormants';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000, 1));

                VendLedgEntry.Reset();
                VendLedgEntry.SetRange("Vendor No.", Vendor."No.");
                if (VendLedgEntry.FindLast) then begin
                    NbreMois := CalculCte.NbreOfMonthsInPeriod(VendLedgEntry."Posting Date", Today);
                    if NbreMois > AddOnSetup."Supplier blocking period Month" then begin
                        if (Vendor.Blocked <> Vendor.Blocked::All) then begin
                            Vendor.Blocked := Vendor.Blocked::All;
                            Vendor.Modify;
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

