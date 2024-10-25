report 50170 "Update Cargo Entries1"
{
    Permissions = TableData "Item Ledger Entry"=rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Item Ledger Entry";"Item Ledger Entry")
        {
            DataItemTableView = WHERE("Item Category Code"=CONST('PBL'));

            trigger OnAfterGetRecord()
            var
                CargoEnlevement: Code[20];
                Cust2: Record Customer;
                CargoAjustement: Code[20];
            begin
                BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));


                //Correction type Ajustement BE
                if (("Item Ledger Entry"."Adjustment Type"="Item Ledger Entry"."Adjustment Type"::BE)
                and ("Item Ledger Entry"."External Document No."='')) then begin
                  "Item Ledger Entry"."Adjustment Type" := "Item Ledger Entry"."Adjustment Type"::AdjBE;
                  "Item Ledger Entry".Modify;
                end;



                CargoAjustement  := GetCargoAjustement();


                //Ajout Ajustement positif BE dans écritures cargo
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::"Positive Adjmt." then
                  if "Item Ledger Entry"."Adjustment Type" = "Item Ledger Entry"."Adjustment Type"::AdjBE then begin
                    "Item Ledger Entry"."Ref Cargo" := CargoAjustement;
                    "Item Ledger Entry".Modify;

                    CargoMgt.FillCargoEntries("Item Ledger Entry");
                  end;

                //Ajout Ajustement transferts dans écritures cargo
                if "Item Ledger Entry"."Entry Type" = "Item Ledger Entry"."Entry Type"::"Positive Adjmt." then
                  if "Item Ledger Entry"."Adjustment Type" = "Item Ledger Entry"."Adjustment Type"::Transfer then begin
                    "Item Ledger Entry"."Ref Cargo" := CargoAjustement;
                    "Item Ledger Entry".Modify;

                    CargoMgt.FillCargoEntries("Item Ledger Entry");
                  end;







                //Nouveau champ crée "Canal de vente"
                if "Item Ledger Entry"."Source Type"="Item Ledger Entry"."Source Type"::Customer then
                  if Cust2.Get("Item Ledger Entry"."Source No.") then begin
                    "Item Ledger Entry"."Sales Channel Code" := Cust2."Sales Channel Code";
                    "Item Ledger Entry".Modify;
                  end;


                //Creation ds écritures cargo
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(TxtTraitementTerminé);
            end;

            trigger OnPreDataItem()
            begin
                NbreTotalLignes := "Item Ledger Entry".Count;
                BesoinNo :=0;

                Window.Open(Text008);
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
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        Text014: Label 'Cargo ''Ajustement'' introuvable';
        CargoMgt: Codeunit "Item Value Cargo Mgt";

    local procedure IsOpAdjustment(AdjType: Integer): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        exit(AdjType in [
          ItemLedgEntry."Adjustment Type"::AdjBE,ItemLedgEntry."Adjustment Type"::Transfer
          ]);
    end;

    procedure GetCargoAjustement(): Code[20]
    var
        Cargo1: Record Cargo;
    begin
        Cargo1.Reset;
        Cargo1.SetRange(Cargo1."Cargo Type",Cargo1."Cargo Type"::Transfer);
        if not Cargo1.FindFirst then Error(Text014);
        exit(Cargo1.Code);
    end;
}

