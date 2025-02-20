tableextension 50042 "A02 Vendor Bank Account" extends "Vendor Bank Account"
{
    fields
    {
        modify(Name)
        {
            Caption = 'Name';
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify("Name 2")
        {
            Caption = 'Name 2';
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify(Code)
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify(IBAN)
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify("SWIFT Code")
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify("Agency Code")
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify("RIB Key")
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }
        modify("RIB Checked")
        {
            trigger OnAfterValidate()
            var
            begin
                ResetVendorValidation;
            end;
        }

        modify("Bank Branch No.")
        {
            trigger OnAfterValidate()
            var
                SwiftCorrespondence: record "BA Swift Correspondence";
            begin

                IBAN := CollectIBAN();

                IF SwiftCorrespondence.GET("Bank Branch No.") THEN
                    "SWIFT Code" := SwiftCorrespondence."SWIFT Code";
                ResetVendorValidation;
            end;
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            var
            begin
                IBAN := CollectIBAN();
                ResetVendorValidation;
            end;
        }
        field(50000; "RIB Key Text"; Text[2])
        {
            Caption = 'RIB Key Text';

            trigger OnValidate()
            begin
                EVALUATE("RIB Key", "RIB Key Text");
                ResetVendorValidation;
            end;
        }

    }

    procedure AFKGetLongAccountNum(): Text
    begin
        EXIT("Bank Branch No." + "Agency Code" + "Bank Account No." + CONVERTSTR(FORMAT("RIB Key", 2), ' ', '0'));
    end;

    procedure CollectIBAN(): Code[50]
    begin
        EXIT("Bank Branch No." + "Agency Code" + "Bank Account No." + CONVERTSTR(FORMAT("RIB Key", 2), ' ', '0'));
    end;

    local procedure ResetVendorValidation()
    var
        Vend1: Record "Vendor";
    begin
        IF Vend1.GET("Vendor No.") THEN BEGIN
            IF Vend1."Validation Status" <> Vend1."Validation Status"::Created THEN
                IF NOT CONFIRM(STRSUBSTNO(ErrAfk001, Vend1.Name)) THEN ERROR('');
            Vend1."Validation Status" := Vend1."Validation Status"::Created;
            Vend1.MODIFY;
        END;
    end;

    var
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur %1 au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';
}

