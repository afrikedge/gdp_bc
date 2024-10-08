codeunit 50009 "Item Adjustment Mgt"
{

    trigger OnRun()
    begin
    end;

    procedure ArchiveDoc(var ItemAdj: Record "Adjustment Header")
    var
        PostedRec: Record "Posted Adjustment Header";
        PostedLine: Record "Posted Adjustment Line";
        AdjustLine: Record "Adjustment Line";
    begin

        PostedRec.Init;
        PostedRec.TransferFields(ItemAdj);
        PostedRec.Insert;

        AdjustLine.Reset;
        AdjustLine.SetRange("Document Type",ItemAdj."Document Type");
        AdjustLine.SetRange("Document No.",ItemAdj."No.");
        if AdjustLine.FindSet then repeat
          PostedLine.Init;
          PostedLine.TransferFields(AdjustLine);
          PostedLine.Insert;
        until AdjustLine.Next=0;
    end;
}

