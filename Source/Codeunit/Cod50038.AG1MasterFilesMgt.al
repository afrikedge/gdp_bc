codeunit 50038 "AG1 Master Files Mgt"
{
    procedure ResetVendorValidation(var Vend: record Vendor)
    var
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';
    begin
        if Vend."Validation Status" <> Vend."Validation Status"::Created then
            if not Confirm(ErrAfk001) then Error('');
        Vend."Validation Status" := Vend."Validation Status"::Created;
        Vend.Modify();
    end;

    procedure AFK_TestMFilesInvoice(PurchaseHeader: record "Purchase Header")
    var
        AddOnSetup: record "AddOn Setup";
        AFK_Text0001: Label 'Cette facture ne peut pas être modifiée car elle provient d''un document MFiles';
    begin
        //*******************************121017
        AddOnSetup.Get;
        if not AddOnSetup."MFiles Mgt" then exit;

        if PurchaseHeader."MFiles Invoice" then
            Error(AFK_Text0001);
    end;

    procedure AFKGetLongAccountNum(Rec: record "Vendor Bank Account"): Text
    begin
        EXIT(Rec."Bank Branch No." + Rec."Agency Code" + Rec."Bank Account No." + CONVERTSTR(FORMAT(Rec."RIB Key", 2), ' ', '0'));
    end;

    procedure CollectIBAN(Rec: record "Vendor Bank Account"): Code[50]
    begin
        EXIT(Rec."Bank Branch No." + Rec."Agency Code" + Rec."Bank Account No." + CONVERTSTR(FORMAT(Rec."RIB Key", 2), ' ', '0'));
    end;

    procedure ResetVendorValidation(Rec: record "Vendor Bank Account")
    var
        Vend1: Record "Vendor";
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur %1 au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';

    begin
        IF Vend1.GET(Rec."Vendor No.") THEN BEGIN
            IF Vend1."Validation Status" <> Vend1."Validation Status"::Created THEN
                IF NOT CONFIRM(STRSUBSTNO(ErrAfk001, Vend1.Name)) THEN ERROR('');
            Vend1."Validation Status" := Vend1."Validation Status"::Created;
            Vend1.MODIFY;
        END;
    end;
}
