report 50188 "Maj BLs"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(pro_enteteBL;pro_enteteBL)
        {
            DataItemTableView = WHERE(IsBon=CONST(true));

            trigger OnAfterGetRecord()
            begin
                BesoinNo := BesoinNo + 1;
                Window.Update(1,
                Round(BesoinNo / NbreTotalLignes * 10000,1));

                if "Posted Shipment No" = '' then begin
                  if pro_enteteBL.isconfirme then
                    NbreVides:=NbreVides+1;

                  if PostedSalesShip.Get(NumBU) then begin
                    "Posted Shipment No" := NumBU;
                    Modify;
                    NbreMod:=NbreMod+1;
                  end;

                end;
            end;

            trigger OnPostDataItem()
            begin

                Window.Close;
                Message(StrSubstNo('Traitement termine %1/%2',NbreMod,NbreVides));
            end;

            trigger OnPreDataItem()
            begin
                BesoinNo :=0;

                Window.Open(Text008);
                NbreTotalLignes := pro_enteteBL.Count;
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

    var
        PostedSalesShip: Record "Sales Shipment Header";
        AddOnSetup: Record "AddOn Setup";
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        NbreMod: Integer;
        NbreVides: Integer;
}

