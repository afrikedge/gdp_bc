codeunit 50026 ImportInfosBE
{

    trigger OnRun()
    begin
    end;

    var
        FileMgt: Codeunit "File Management";
        Text001: Label 'Selectionnez le fichier à importer';
        FileFilterTxt: Label 'Text Files(*.txt;*.csv)|*.txt;*.csv';
        FileFilterExtensionTxt: Label 'txt,csv', Locked = true;
        // [RunOnClient]
        // dotNetFile: DotNet BCFile;
        // dotNetArray: DotNet BCArray;
        Text002: Label 'Le compte n''a pas été configuré pour l''import des relevés bancaires';
        Text003: Label 'Date BSL invalide sur la ligne %1';
        Text004: Label 'Volume ambiant invalide sur la ligne %1';
        Text005: Label 'Volume à 15 invalide sur la ligne %1';
        Text006: Label 'Température invalide sur la ligne %1';
        Text007: Label 'Densité invalide sur la ligne %1';
        AddOnSetup: Record "AddOn Setup";
        Text008: Label 'Les volumes à livrer ne correspondent pas pour l''article %1 et le Bon %2. Le volume importé est %3, celui de Nav est %4';
        Text009: Label 'Traitement terminé';
        Text010: Label 'Traitement...        @2@@@@@@@@@@@@@\';
        NbreTotalLignes: Integer;
        Window: Dialog;

    procedure SelectAndImportBEData()
    var
    // DataExchDef: Record "Data Exch. Def";
    // TempBlob: Record TempBlob;
    // FileName: Text;
    // FileFilterTxt: Label 'Text Files(*.txt;*.csv)|*.txt;*.csv';
    // FileFilterExtensionTxt: Label 'txt,csv', Locked=true;
    // i: Integer;
    // dotNetArray: DotNet BCArray;
    // BankAcc: Record "Bank Account";
    begin
        // AddOnSetup.Get;

        // FileName := FileMgt.BLOBImportWithFilter(TempBlob,Text001,'',FileFilterTxt,FileFilterExtensionTxt);
        // if FileName <> '' then begin
        //   dotNetArray := dotNetFile.ReadAllLines(FileName);
        //   NbreTotalLignes:=dotNetArray.Length;
        //   Window.Open(Text010);

        //   ImportDataInfosBE(dotNetArray);
        //   Message(Text009);
        // end;
    end;

    // local procedure ImportDataInfosBE(dotNetArray: DotNet BCArray)
    // var
    //     BesoinNo: Integer;
    //     i: Integer;
    // begin
    //     for i:=0 to (dotNetArray.Length-1) do begin

    //       BesoinNo := i + 1;
    //       Window.Update(1,Round(BesoinNo / NbreTotalLignes * 10000,1));

    //       if (i >= 2) then
    //         ProcessLineInfosBE(dotNetArray.GetValue(i),i);
    //     end;

    //     Window.Close();
    // end;

    local procedure ProcessLineInfosBE(LineSource: Text; iLine: Integer)
    var
    // dotNetString: DotNet BCString;
    // dotNetTab: DotNet BCArray;
    // dotNetChar: DotNet BCString;
    // DepotChargeur: Text;
    // CodeProd: Text;
    // NumeroBon: Text;
    // NumBSL: Text;
    // DateBSL: Date;
    // VolumeAmbiant: Decimal;
    // Volume15: Decimal;
    // Temperature: Decimal;
    // Densite: Decimal;
    // EnteteBE: Record pro_enteteBE;
    // LigneBE: Record pro_detailBE;
    // VolumeALivrerM3: Decimal;
    // VolumeA15M3: Decimal;
    begin
        // dotNetChar:=';';
        // dotNetString:=LineSource;
        // dotNetTab := dotNetString.Split(dotNetChar.ToCharArray());



        // DepotChargeur := dotNetTab.GetValue(0);
        // if DepotChargeur='' then exit;

        // CodeProd := dotNetTab.GetValue(2);
        // NumeroBon := dotNetTab.GetValue(3);
        // NumBSL := dotNetTab.GetValue(4);

        // if not Evaluate(DateBSL , dotNetTab.GetValue(5)) then
        //   Error(Text003,iLine);
        // if not Evaluate(VolumeAmbiant , dotNetTab.GetValue(9)) then
        //   Error(Text004,iLine);
        // if not Evaluate(Volume15 , dotNetTab.GetValue(10)) then
        //   Error(Text005,iLine);
        // if not Evaluate(Temperature , dotNetTab.GetValue(11)) then
        //   Error(Text006,iLine);
        // if not Evaluate(Densite , dotNetTab.GetValue(12)) then
        //   Error(Text007,iLine);

        // if EnteteBE.Get(NumeroBon) then begin
        //   EnteteBE.Validate(numBSL,NumBSL);
        //   LigneBE.Reset;
        //   LigneBE.SetRange(LigneBE.numBE,EnteteBE.numBE);
        //   if LigneBE.FindSet then repeat
        //     if (LigneBE.NavItemCode = GetCorrespondanceArticle(CodeProd)) then begin

        //       VolumeALivrerM3 := GetQtyInDispachingUnit(VolumeAmbiant,LigneBE.NavItemCode,AddOnSetup."Dispaching Unit Code");
        //       VolumeA15M3 := GetQtyInDispachingUnit(Volume15,LigneBE.NavItemCode,AddOnSetup."Dispaching Unit Code");

        //       if(VolumeALivrerM3<>LigneBE.volumeaenlever) then
        //         Error(Text008,CodeProd,NumeroBon,VolumeALivrerM3,LigneBE.volumeaenlever);

        //       LigneBE.Validate(LigneBE.volumea15,VolumeA15M3);
        //       LigneBE.temperature := Temperature;
        //       LigneBE.densite := Densite;
        //       LigneBE.Modify;
        //     end;
        //   until LigneBE.Next = 0;
        //   EnteteBE.Modify;
        // end;
    end;

    local procedure GetCorrespondanceArticle(codeArticleLPSA: Code[20]): Code[10]
    begin
        if codeArticleLPSA = 'SP95' then exit('31000-0000');
        if codeArticleLPSA = 'GO' then exit('34000-0000');
        if codeArticleLPSA = 'PL' then exit('33000-0000');
    end;

    local procedure GetQtyInDispachingUnit(QtyInBaseUnit: Decimal; ItemCode: Code[20]; DispachingBaseUnit: Code[10]): Decimal
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        if ItemCode = '' then exit(0);
        ItemUOM.Get(ItemCode, DispachingBaseUnit);
        exit(Round(QtyInBaseUnit / ItemUOM."Qty. per Unit of Measure", 0.00001));
    end;
}

